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
        [errors, rt] = icp_plain(pc, last_pc, 10);
   end
   
   % visualize
   figure,
       pcshow(pc);
    
   last_pc = pc;
end