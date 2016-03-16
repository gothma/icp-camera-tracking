function [ out ] = closest_points_kdtree( X, Y )

    p = inputParser();
    addRequired(p, 'X', @(x) isa(x, 'PointCloudContainer'));
    addRequired(p, 'Y', @(x) isa(x, 'PointCloudContainer'));
    parse(p, X, Y);
    
    if (~Y.hasKDTree())
        Y.KDTree = KDTreeSearcher(Y.pc);
    end
    out = knnsearch(Y.KDTree, X.pc);
end

