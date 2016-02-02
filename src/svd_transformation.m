function [ transformation, error ] = svd_transformation(X, Y, correspondences, weights)
% Returns the transformation from Y to X with minimal error

            mean_X = mean(X.pc.Location);
            normalized_X = bsxfun(@minus, X.pc.Location, mean_X);

            P = Y.pc.Location(correspondences, :);
            mean_P = mean(P);
            normalized_P = bsxfun(@minus, P, mean_P);

            W = zeros(3,3);
            for j=1:size(normalized_X, 1)
                W = W + weights(j) * normalized_X(j, :)' * normalized_P(j, :);
            end
            [U, S, V] = svd(W);
            
            R = U * V';
            t = mean_X - (R * mean_P')';
            
            rotated_pc = (R * normalized_P')';
            error = error_icp(normalized_X, rotated_pc, S) / sum(weights);
            
            transformation = affine3d([[R t']; [0 0 0 1]]');

end

