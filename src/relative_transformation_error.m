function [trans, rot] = relative_transformation_error(estimated, ground_truth)
% Returns the relative transformation error
% estimated: Estimated relative transformation
% ground_truth: Actual relative transformation
% trans: Error based on distance
% rot: Error based on angleomi

error = ominus(estimated, ground_truth);

trans = norm(error.T(4,1:3));
rot = acos(min(1,max(-1, (trace(error.T(1:3,1:3)) - 1)/2)));

end