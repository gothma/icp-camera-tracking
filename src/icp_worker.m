function icp_worker(varargin)

p = inputParser;

p.addParameter('frame', 1);
p.addParameter('convergence', '10steps');
p.addParameter('closest_points', 'delaunayn');
p.addParameter('icp_error_func', 'svd_error');

p.parse(varargin{:});
range = eval(p.Results.frame);

switch p.Results.convergence
    case '1step'
        convergence_func = @(~,error,steps) steps > 1;
    case '10steps'
        convergence_func = @(~,error,steps) steps > 10;
    case '25steps'
        convergence_func = @(~,error,steps) steps > 25;
end

switch p.Results.closest_points
    case 'delaunayn'
        closest_points_func = @closest_points_delaunayn;
end

switch p.Results.icp_error_func
    case 'svd_error'
        icp_error_func = @error_icp;
end
    

addpath('misc', 'utils');

calibration_matrix = load('../train/camera_calibration_matrix.txt');

camera_images = dir('../train/depth_*.png');
color_images = dir('../train/color_*.png');

ground_truth = load_ground_truth('../test/ICP_quasi_ground_truth_poses.txt');
    
last_i = -1;
results = struct([]);

for i=range
    camera_img_name = camera_images(i).name;
    if ~isempty(regexpi(camera_img_name, '[0-9]_'))
      continue 
    end
    depth_img = imread(fullfile('../train', camera_img_name));
    color_img = imread(fullfile('../train', color_images(i).name));

    current = loadColorPC(depth_img, color_img, calibration_matrix);

    % do the icp
    if i > 1
        tstart = tic;
        % Copy arguments
        arg_names = fieldnames(p.Results);
        for i_arg = 1:size(arg_names);
            arg_name = arg_names{i_arg};
            results(i).(arg_name) = p.Results.(arg_name);
        end
        
        git_info = getGitInfo('..');
        results(i).git_hash = git_info.hash;
        
        % Insert framecount
        results(i).from_i = last_i;
        results(i).to_i = i;
        
        % Call icp
        [estimated_transformation, errors, ~] = icp_plain(last, current, ...
        'criterion', convergence_func, 'verbose', false, ...
        'closest_points', closest_points_func, ...
        'icp_error_func', icp_error_func);

        results(i).icp_error = errors;

        % Compare to ground truth
        gt_transformation = ominus(ground_truth{i - 1}, ground_truth{i});
        [trans, rot] = relative_transformation_error(estimated_transformation, gt_transformation);
        results(i).rel_trans_error = trans;
        results(i).rel_rot_error = rot;
        
        % Save transformation
        results(i).transformation = estimated_transformation;
        results(i).duration = toc(tstart);
    end

    last = current;
    last_i = i;
end

result_table = struct2table(results); %#ok

filename = sprintf('%s-%05.0f.mat', datestr(now,'yyyy-mm-dd-HH-MM-SS-FFF'), rand * 100000);
save(filename, 'result_table');
end


    