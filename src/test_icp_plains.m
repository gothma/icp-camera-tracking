addpath('misc', 'utils');
X = [kron(linspace(0, 10, 100)', ones( 10, 1)), ...
     repmat(linspace(0, 20, 100)', 10, 1), ...
     zeros(1000,1)];

Y = bsxfun(@plus, X, [0 0 5]);



steps = 100;
[errors, rt] = icp_plain(X, Y, steps, ...
    struct('closest_points', @closest_points_without_delaunayn, ...
        'save_rotated_pc', 1));


new_Y = rt{end, 3};
figure,
    scatter3(X(:,1), X(:,2), X(:,3)),
    hold on,
    scatter3(Y(:,1), Y(:,2), Y(:,3)),
    scatter3(new_Y(:,1), new_Y(:,2), new_Y(:,3)),
    legend({'x', 'y', 'rot.y'})
    
figure,
    plot(errors);