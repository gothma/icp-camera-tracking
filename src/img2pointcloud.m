function pc = img2pointcloud(image, calib)

[y,x,z] = find(image);
pc = [x, z, 480 - y];

end