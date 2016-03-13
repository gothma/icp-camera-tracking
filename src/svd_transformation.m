function [ transformation, error ] = svd_transformation(X, Y, correspondences, weights, error_func)
% Returns the transformation from X to Y with minimal error

            mean_X = mean(X.pc);
            normalized_X = bsxfun(@minus, X.pc, mean_X);

            P = Y.pc(correspondences, :);
            mean_P = mean(P);
            normalized_P = bsxfun(@minus, P, mean_P);

            W = normalized_X' * normalized_P;
            [U, S, V] = svd(W);
            
            R = U * V';
            t = mean_X - (R * mean_P')';
            
            rotated_pc = (R * normalized_P')';
            error = error_func(normalized_X, rotated_pc, S, weights);
            
            transformation = affine3d([[R t']; [0 0 0 1]]').invert;

end

