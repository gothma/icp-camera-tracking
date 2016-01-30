function pc = img2pointcloud(image, calib, camera_rotation)

fx = calib(1,1);
fy = calib(1,1);
fx_inv = 1/fx;
fy_inv = 1/fy;
cx = calib(1,3);
cy = calib(2,3);

[x,y,depth] = find(image);
%points = [x, y, ones(size(x))];

% pc = (calib * camera_rotation * double(points)');
pc = [];
pc(1, :) = (x-cx) * fx_inv .* double(depth);
pc(2, :) = -(y-cy) * fy_inv .* double(depth);
pc(3, :) = depth;

end