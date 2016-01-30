function [ out ] = closest_points_delaunayn( X, Y )
%CLOSEST_POINTS Summary of this function goes here
%   Detailed explanation goes here
    misc_checkType(X, 'DOUBLE');
    misc_checkType(Y, 'DOUBLE');
    out = dsearchn(Y, delaunayn(Y), X);
end

