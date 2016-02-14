function transformation = load_ground_truth(file, framenumbers)
% Returns the relative translation and rotation from a file
% file: The ground truth file in csv format: for each frame 3 lines
% rotation matrix and 3 lines translation vector
% framenumbers: Select single frames (index starts at 0)

frames = textread(file);

switch nargin
    case 1
        N = size(frames, 1) / 6;
        framenumbers = 0:N-1;
    case 2
        N = size(framenumbers, 2);
end

transformation = cell(N, 1);
cell_ind = 1;
for i = framenumbers
    R = frames(i*6+1:i*6+3, :);
    t = frames(i*6+4:i*6+6, 1);
    transformation{cell_ind} = affine3d([[R t]; [0 0 0 1]]');
    cell_ind = cell_ind + 1;
end

end