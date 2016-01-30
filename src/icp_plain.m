function [ errors, rotation_translation ] = icp_plain( X, Y, steps, varargin)
%ICP_PLAIN Summary of this function goes here
%   X - 
%   Y - 
    misc_checkType(X, 'DOUBLE[- 3]');
    misc_checkType(Y, 'DOUBLE[- 3]');
    misc_checkType(steps, 'INT');
    
    props = {'closest_point' @closest_point_delaunayn 'FUNC',
             'save_rotated_pc' 0 'BOOL'};    
    opt= opt_proplistToStruct(varargin{:});
    [opt, ~]= opt_setDefaults(opt, props);
    
    
        errors = zeros(steps, 1);
        rotation_translation = cell(steps, 3);
        for i=1:steps
            
            closest_points = opt.closest_points(X, Y);

            mean_X = mean(X);
            normalized_X = bsxfun(@minus, X, mean_X);

            P = Y(closest_points, :);
            mean_P = mean(P);
            normalized_P = bsxfun(@minus, P, mean_P);
            
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
            
            Y = bsxfun(@plus, (R * Y')', t);

            errors(i) = error;
            rotation_translation{i, 1} = R;
            rotation_translation{i, 2} = t;
            if opt.save_rotated_pc
                rotation_translation{i, 3} = Y;
            end
        end
end

