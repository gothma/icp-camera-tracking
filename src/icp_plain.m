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
        rotation_translation = cell(steps, 3);
        
        for i=1:steps
            if opt.verbose
                display(sprintf('ICP step %i', i));
            end
            
            closest_points = opt.closest_points(X, Y);

            mean_X = mean(X.pc.Location);
            normalized_X = bsxfun(@minus, X.pc.Location, mean_X);

            P = Y.pc.Location(closest_points, :);
            mean_P = mean(P);
            normalized_P = bsxfun(@minus, P, mean_P);
            
            if opt.verbose
               display(sprintf('ICP step %i: Calculate W matrix', i)); 
            end
            
            weight_correspondance = ones(size(normalized_P,1), 3);

            W = zeros(3,3);
            for j=1:size(normalized_X, 1)
                W = W + normalized_X(j, :)' * (diag(weight_correspondance(j, :)) *  normalized_P(j, :)')';
            end
            [U, S, V] = svd(W);

            R = U * V';
            t = mean_X - (R * mean_P')';

            rotated_pc = bsxfun(@plus, (R * normalized_P')', t);
            error = error_icp(normalized_X, rotated_pc, S);
            
            transform = affine3d([[R t']; [0 0 0 1]]');
            Y.pc = pctransform(Y.pc, transform);

            errors(i) = error;
            rotation_translation{i, 1} = R;
            rotation_translation{i, 2} = t;
            if opt.save_rotated_pc
                rotation_translation{i, 3} = Y;
            end
        end
end

function y = isPointCloud(x)
    y = isa(x.pc, 'pointCloud');
end
