function [ out ] = closest_points_delaunayn( X, Y )
% For each point in X this returns the index of the closest point in Y
    p = inputParser();
    addRequired(p, 'X', @(x) isa(x.pc, 'pointCloud'));
    addRequired(p, 'Y', @(x) isa(x.pc, 'pointCloud'));
    parse(p, X, Y);
    
    if (~isfield(Y, 'delaunayn'))
        Y.delaunayn = delaunayn(Y.pc.Location);
    end
    
    try
        out = dsearchn(Y.pc.Location, Y.delaunayn, X.pc.Location);
    catch
        out = dsearchn(Y.pc.Location, X.pc.Location);
    end
end

