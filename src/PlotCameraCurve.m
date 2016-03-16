

R_t = readGroundTruth('../test/ICP_quasi_ground_truth_poses.txt');
xyz = cell2mat(R_t(:, 2)')';
uvw = diff(xyz);
figure,
hold on,

% quiver3(xyz(1:end-1,1), xyz(1:end-1,2), xyz(1:end-1,3), uvw(:,1), uvw(:,2), uvw(:,3))


for i=1:size(xyz, 1)-1
    
    quiver3(xyz(i,1), xyz(i,2), xyz(i,3), uvw(i,1), uvw(i,2), uvw(i,3))
    %plotCamera('Location', accum, 'Orientation', R, 'Opacity', 0),
    drawnow,
    pause(0.05)    
end
    
    