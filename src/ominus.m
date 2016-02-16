function x = ominus(a,b)
% Compute the relative 3D transformation from a to b.
% a: first pose (affine3d)
% b: second pose (affine3d)
% Returns: Relative 3D transformation from a to b.
t = a.T \ b.T;
if max(t(:,4) - [0;0;0;1]) > 10^-13
    error(message('images:geotrans:invalidAffineMatrix'));
end
x = affine3d([t(:,1:3) [0;0;0;1]]);
end