function [ error ] = squared_error( X, Y )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

error = immse(X, Y) * 3;
end

