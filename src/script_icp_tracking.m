addpath('misc', 'utils');

calibration_matrix = load('../train/camera_calibration_matrix.txt');

camera_images = dir('../train/depth_*.png');
color_images = dir('../train/color_*.png');

ground_truth = load_ground_truth('../test/ICP_quasi_ground_truth_poses.txt');
    
last_pc = [];
for i=1:10
   camera_img_name = camera_images(i).name;
   if ~isempty(regexpi(camera_img_name, '[0-9]_'))
      continue 
   end
   depth_img = imread(fullfile('../train', camera_img_name));
   color_img = imread(fullfile('../train', color_images(i).name));
   
   camera_rotation = eye(3);
   camera_transpose = zeros(3, 1);
   
   current = PointCloudContainer();
   current.pc = loadColorPC(depth_img, color_img, calibration_matrix);

   % do the icp
   if i > 1
        [estimated_transformation, errors, rt] = icp_plain(last, current, ...
        'criterion', @(~,error,steps) steps > 10, 'verbose', false);

        gt_transformation = ominus(ground_truth{i - 1}, ground_truth{i});
        display(relative_transformation_error(estimated_transformation, gt_transformation));

       % visualize
       figure,
           subplot(1,2,1),
           plot(errors),
           subplot(1,2,2),
           pcshow(current.pc),
           drawnow
   end
    
   last = current;
end
    