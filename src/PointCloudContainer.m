classdef PointCloudContainer < handle
    
    properties
        delaunayn;
        pc;
    end
    
    methods
        function b = hasDelaunayn (pcc)
            b = size(pcc.delaunayn, 1) ~= 0;
        end
    end
    
end

