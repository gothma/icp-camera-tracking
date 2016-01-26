function [x, y, z] = img2pointcloud(image)

sizeX = size(image, 2);
sizeY = size(image, 1);

x = reshape(repmat(1:640, 480, 1), 1, sizeX*sizeY);
y = reshape(repmat(1:sizeY, 1, sizeX), 1, sizeX*sizeY);
z = reshape(image, 1, sizeX*sizeY);

end