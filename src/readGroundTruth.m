function [ cell_R_t ] = readGroundTruth( filename )
%READGROUNDTRUTH Summary of this function goes here
%   Detailed explanation goes here
    M = textread(filename);

    rowind_rot = repmat((1:3)', size(M, 1)/6, 1) + kron(0:6:size(M,1)-1, ones(1,3))';

    R = M(rowind_rot, 1:3);

    rowind_trans = repmat((4:6)', size(M, 1)/6, 1) + kron(0:6:size(M,1)-1, ones(1,3))';
    t = M(rowind_trans, 1);

    cell_R_t = cell(size(R, 1)/3, 2);
    for i=1:3:size(R, 1)
       cell_R_t{floor((i-1)/3)+1, 1} = R(i:i+2, :);
       cell_R_t{floor((i-1)/3)+1, 2} = t(i:i+2, :);
    end
end

