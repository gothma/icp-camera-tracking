X = [kron(linspace(0, 10, 100)', ones( 10, 1)), ...
     repmat(linspace(0, 20, 100)', 10, 1), ...
     zeros(1000,1)];

Y = bsxfun(@plus, X, [0 0 5]);



steps = 10;
[errors, rt] = icp_plain(X, Y, steps);

summed_rotation = zeros(1, 3);
for i=1:steps
   summed_rotation = summed_rotation + rt{i, 2}; 
end


new_Y = rt{steps, 3};
figure,
    scatter3(X(:,1), X(:,2), X(:,3)),
    hold on,
    scatter3(Y(:,1), Y(:,2), Y(:,3)),
    scatter3(new_Y(:,1), new_Y(:,2), new_Y(:,3)),
    legend({'x', 'y', 'rot.y'})
    
figure,
    plot(errors);