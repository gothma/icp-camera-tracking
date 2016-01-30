function [pc, c] = loadColorPC(image, color, calib)

% Find indices of depth values
[v,u,d] = find(image);
[Nv, Nu] = size(image);

% Slice color pixels for each depth ray
pixels = reshape(color, [Nu*Nv 3]);
indices = sub2ind([Nv, Nu], v, u);
c = pixels(indices, :);

v = double(Nv - v);
u = double(u);
d = double(d);

% Read internal camera values
fx = calib(1,1);
fy = calib(2,2);
cx = calib(1,3);
cy = calib(2,3);

% Convert to 3D points
x = (u - cx) .* inv(fx) .* d;
y = (v - cy) .* inv(fy) .* d;
z = -d;

pc = [x, y, z];
end