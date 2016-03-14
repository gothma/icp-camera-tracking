function [ transformation, error ] = svd_transformation(X, Y, correspondences, weights, error_func)
% Returns the transformation from X to Y with minimal error

            normalized_weights = weights ./ sum(weights);
            mean_X = X.pc' * normalized_weights;
            normalized_X = X.pc - repmat(mean_X', size(X.pc,1), 1);
            

            P = Y.pc(correspondences, :);
            mean_P = P' * normalized_weights;
            normalized_P = (P - repmat(mean_P', size(P,1), 1)) .* repmat(weights, 1, 3);

            W = normalized_X' * normalized_P;
            [U, S, V] = svd(W);
            
            R = U * V';
            t = mean_X' - (R * mean_P)';
            
            rotated_pc = (R * normalized_P')';
            error = error_func(normalized_X, rotated_pc, S, weights);
            
            transformation = affine3d([[R t']; [0 0 0 1]]').invert;

end

