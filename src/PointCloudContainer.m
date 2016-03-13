classdef PointCloudContainer < handle
    
    properties
        delaunayn;
        KDTree;
        homogenous;
        pc;
        color;
    end
    
    methods        
        function self = PointCloudContainer(pointcloud, color)
            self = self@handle();
            if nargin > 0
                self.homogenous = [pointcloud ones(size(pointcloud, 1), 1)];
            end
            if nargin == 2
                self.color = color;
            end
            self.KDTree = false;
        end
        
        function value = get.pc(self)
            value = bsxfun(@rdivide, self.homogenous(:,1:3), self.homogenous(:, 4));
        end
      
        function b = hasDelaunayn (self)
            b = size(self.delaunayn, 1) ~= 0;
        end
        
        function b = hasKDTree(self)
            b = isa(self.KDTree, 'KDTreeSearcher');
        end
        
        function new = transform(self, transform)
            assert(isa(transform, 'affine3d'))
            new = PointCloudContainer();
            new.homogenous = self.homogenous * transform.T;
            new.color = self.color;
        end
        
        function show(self)
            if exist('pcshow', 'file')
                pcshow(self.pc, self.color);
            end                
        end
    end
    
end

