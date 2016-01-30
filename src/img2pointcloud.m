function pc = img2pointcloud(image, calib)

[x,y,z] = find(image);
points = [y, z, 480 - x];

pc = (calib * double(points'));

end