function [ errors, transformations ] = icp_plain( X, Y, varargin)
%ICP_PLAIN Summary of this function goes here
%   X - 
%   Y - 
    p = inputParser;
    addRequired(p, 'X', @isPointCloud);
    addRequired(p, 'Y', @isPointCloud);
    addParameter(p, 'criterion', @(x, y, z) false);
    addParameter(p, 'closest_points', @closest_points_delaunayn);
    addParameter(p, 'save_rotated_pc', false);
    addParameter(p, 'verbose', true);
    
    parse(p, X, Y, varargin{:});
    opt = p.Results;
    
    errors = [];
    transform = affine3d(eye(4));
    error = inf;
    transformations = {};
    i = 1;

    while ~opt.criterion(transform, error, i)
        if opt.verbose
            display(sprintf('ICP step %i', i));
        end

        correspondences = opt.closest_points(X, Y);

        [transform, error] = svd_transformation(X, Y, correspondences, ones(size(correspondences,1), 1));

        Y.pc = pctransform(Y.pc, transform);

        errors = [errors; error];
        transformations{i} = transform;
        i = i + 1;
    end
end

function y = isPointCloud(x)
    y = isa(x.pc, 'pointCloud');
end
