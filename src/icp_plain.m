function [ total_transformation, errors, transformations ] = icp_plain( from, to, varargin)
%ICP_PLAIN Summary of this function goes here
%   X - The current point cloud
%   Y - The point cloud that X should be integrated in
    p = inputParser;
    addRequired(p, 'X', @isPointCloud);
    addRequired(p, 'Y', @isPointCloud);
    addParameter(p, 'criterion', @(x, y, z) false);
    addParameter(p, 'closest_points', @closest_points_delaunayn);
    addParameter(p, 'save_rotated_pc', false);
    addParameter(p, 'verbose', true);
    addParameter(p, 'icp_error_func', @error_icp);
    addParameter(p, 'weighting', @(~, ~, c) ones(size(c,1), 1));
    addParameter(p, 'sampling', @(pc) pc);
    
    parse(p, from, to, varargin{:});
    opt = p.Results;
    
    from = opt.sampling(from);
    to = opt.sampling(to);
    
    errors = [];
    transform = affine3d(eye(4));
    total_transformation = affine3d(eye(4));
    transformations = {};
    times = [0];
    i = 1;

    while ~opt.criterion(transform, errors, i)
        tic

        if opt.verbose
            display(sprintf('ICP step %i', i));
        end

        % For each point in "to" find the closest point on "from"
        if opt.verbose
            disp('Corresponding points')
        end
        correspondences = opt.closest_points(from, to);
        weights = opt.weighting(from, to, correspondences);
        
        if opt.verbose
            disp('Transformation')
        end
        [transform, error] = svd_transformation(from, to, correspondences, weights, opt.icp_error_func);
        
        from = from.transform(transform);

        % Save intermediate results
        errors = [errors; error];
        transformations{i} = transform;
        total_transformation.T = total_transformation.T * transform.T;
        i = i + 1;
        
        times = [times; toc];
        
        if opt.verbose
            figure(12)
            plot(errors)
            figure(13)
            plot(cumsum(times))
            drawnow
        end
    end
end

function y = isPointCloud(x)
    y = isa(x, 'PointCloudContainer');
end
