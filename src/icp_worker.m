function icp_worker(varargin)

p = inputParser;

p.addParameter('frame', 1);

p.parse(varargin{:});
range = eval(p.Results.frame);

addpath('misc', 'utils');

calibration_matrix = load('../train/camera_calibration_matrix.txt');

camera_images = dir('../train/depth_*.png');
color_images = dir('../train/color_*.png');

ground_truth = load_ground_truth('../test/ICP_quasi_ground_truth_poses.txt');
    
last_pc = [];
last_i = -1;
results = struct([]);

for i=range
   camera_img_name = camera_images(i).name;
   if ~isempty(regexpi(camera_img_name, '[0-9]_'))
      continue 
   end
   depth_img = imread(fullfile('../train', camera_img_name));
   color_img = imread(fullfile('../train', color_images(i).name));
   
   camera_rotation = eye(3);
   camera_transpose = zeros(3, 1);
   
   current = loadColorPC(depth_img, color_img, calibration_matrix);

   % do the icp
   if i > 1
        results(i).to_i = i;
        results(i).from_i = last_i;
        
        [estimated_transformation, errors, rt] = icp_plain(last, current, ...
        'criterion', @(~,error,steps) steps > 10, 'verbose', false);

        results(i).est_trans = estimated_transformation;
        results(i).icp_error = errors;
    
        gt_transformation = ominus(ground_truth{i - 1}, ground_truth{i});
        [trans, rot] = relative_transformation_error(estimated_transformation, gt_transformation);
        results(i).rel_trans_error = trans;
        results(i).rel_rot_error = rot;
   end
    
   last = current;
   last_i = i;
end

result_table = struct2table(results);
writetable(result_table, 'test.csv');
end


    