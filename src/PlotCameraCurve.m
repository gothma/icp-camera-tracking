

R_t = readGroundTruth('../test/ICP_quasi_ground_truth_poses.txt');
figure,
hold on,
accum = zeros(3,1);
accum_R = eye(3);
for i=1:size(R_t, 1)
    R = R_t{i, 1};
    t = R_t{i, 2};
    accum_R = accum_R * R;
    accum = accum + t;
    
    scatter3(t(1), t(2), t(3))
    scatter3(accum(1), accum(2), accum(3))
    %plotCamera('Location', accum, 'Orientation', R, 'Opacity', 0),
    drawnow,
    pause(0.1)    
end
    
    