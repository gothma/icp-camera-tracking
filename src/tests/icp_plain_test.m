function [ tests ] = icp_plain_test
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
setup()
end

function teardownOnce(testCase)
teardown()
end

function test_one_step(testCase)
[x, z, y] = find(ones(2,2));
X = PointCloudContainer();
Y = PointCloudContainer();
X.pc = pointCloud([x y z]);
expected = affine3d(makehgtform('translate', [0 10 0])');
Y.pc = pctransform(X.pc, expected);

[~, ~, actual] = icp_plain(X, Y, 'criterion', @(~,~,s) s > 1, 'verbose', false);

verifyEqual(testCase, actual{1}.T, expected.T, 'AbsTol', 0.001);

end

