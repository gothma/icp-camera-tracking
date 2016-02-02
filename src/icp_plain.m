function [ errors, rotation_translation ] = icp_plain( X, Y, steps, varargin)
%ICP_PLAIN Summary of this function goes here
%   X - 
%   Y - 
    p = inputParser;
    addRequired(p, 'X', @isPointCloud);
    addRequired(p, 'Y', @isPointCloud);
    addRequired(p, 'steps', @isnumeric);
    addParameter(p, 'closest_points', @closest_points_delaunayn);
    addParameter(p, 'save_rotated_pc', false);
    addParameter(p, 'verbose', true);
    
    parse(p, X, Y, steps, varargin{:});
    opt = p.Results;
    
    
        errors = zeros(steps, 1);
        transformations = cell(steps, 1);
        
        for i=1:steps
            if opt.verbose
                display(sprintf('ICP step %i', i));
            end
            
            correspondences = opt.closest_points(X, Y);

            [transform, error] = svd_transformation(X, Y, correspondences, ones(size(correspondences,1), 1));
            
            Y.pc = pctransform(Y.pc, transform);

            errors(i) = error;
            transformations{i} = transform;
        end
end

function y = isPointCloud(x)
    y = isa(x.pc, 'pointCloud');
end
