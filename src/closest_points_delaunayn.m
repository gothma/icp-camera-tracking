function [ out, weights ] = closest_points_delaunayn( X, Y )
% For each point in X this returns the index of the closest point in Y
    p = inputParser();
    addRequired(p, 'X', @(x) isa(x, 'PointCloudContainer'));
    addRequired(p, 'Y', @(x) isa(x, 'PointCloudContainer'));
    parse(p, X, Y);
    
    if (~Y.hasDelaunayn())
        try
            Y.delaunayn = delaunayn(Y.pc);
        catch
            out = dsearchn(Y.pc, X.pc);
            weights = ones(size(X.pc,1), 1);
            return
        end
    end
    
    out = dsearchn(Y.pc, Y.delaunayn, X.pc);
    weights = ones(size(X.pc,1), 1);
end

