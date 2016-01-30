function [ out ] = closest_points_delaunayn( X, Y )
%CLOSEST_POINTS Summary of this function goes here
%   Detailed explanation goes here
    misc_checkType(X, 'STRUCT(pc)');
    misc_checkType(Y, 'STRUCT(pc)');
    out = dsearchn(Y.pc, delaunayn(Y.pc), X.pc);
end

