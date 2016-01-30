calibration_matrix = load('../train/camera_calibration_matrix.txt');

camera_images = dir('../train/depth_*.png');

first_image_filename = camera_images(1).name;
first_image = imread(strcat('../train/', first_image_filename));

camera_rotation = eye(3);
camera_transpose = zeros(3,1);

pc = img2pointcloud(first_image, calibration_matrix, camera_rotation);
pc = pc';

figure,
    pcshow(pc);
    
last_pc = [];
for i=1:10
   camera_img_name = camera_images(i).name;
   if ~isempty(regexpi(camera_img_name, '[0-9]_'))
      continue 
   end
   camera_img = imread(fullfile('../train', camera_img_name));
   
   camera_rotation = eye(3);
   camera_transpose = zeros(3, 1);
   
   pc = img2pointcloud(camera_img, calibration_matrix, camera_rotation);
   pc = pc';

   
   % do the icp
   if i > 1
        % returns the closest point in last_pc for each point in pc
        closest_points = dsearchn(last_pc, delaunayn(last_pc), pc);
        
        mean_frame = mean(pc);
        pc_minus_mean = bsxfun(@minus, pc, mean_frame);
        
        corresponding_points_from_last_frame = last_pc(closest_points, :);
        mean_last_frame = mean(corresponding_points_from_last_frame);
        last_pc_minus_mean = bsxfun(@minus, corresponding_points_from_last_frame, mean_last_frame);
        
        W = zeros(3,3);
        
        for j=1:size(pc_minus_mean, 1)
            W = W + pc_minus_mean(j, :)' * last_pc_minus_mean(j, :);
        end
        [U, S, V] = svd(W);
        
        R = U * V';
        t = mean_frame - (R * mean_last_frame')';
        
        rotate_last_pc = bsxfun(@plus, (R * last_pc_minus_mean')', t);
        error = error_icp(pc_minus_mean, rotate_last_pc, S);
   end
   
   % visualize
   figure,
       pcshow(pc);
    
   last_pc = pc;
end