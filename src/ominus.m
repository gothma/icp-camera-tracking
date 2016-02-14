function x = ominus(a,b)
% Compute the relative 3D transformation from a to b.
% a: first pose (affine3d)
% b: second pose (affine3d)
% Returns: Relative 3D transformation from a to b.
x = affine3d(a.T \ b.T);
end