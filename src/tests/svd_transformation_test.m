function tests = closest_points_delaunayn_test
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
setup()
end

function teardownOnce(testCase)
teardown()
end

function testTranslation(testCase)
[x, z, y] = find(ones(2,2));
X.pc = pointCloud([x y z]);
expected = affine3d(makehgtform('translate', [2 3 4])');
Y.pc = pctransform(X.pc, expected);

[i_actual, error] = svd_transformation(X, Y, 1:4, ones(4,1));

verifyEqual(testCase, inv(i_actual.T), expected.T);
verifyEqual(testCase, error, 0);

end

function testRotation(testCase)
[x, z, y] = find(ones(2,2));
X.pc = pointCloud([x y z]);
expected = affine3d(makehgtform('axisrotate', [1 2 3], pi/2)');
Y.pc = pctransform(X.pc, expected);

[i_actual, error] = svd_transformation(X, Y, 1:4, ones(4,1));

verifyEqual(testCase, inv(i_actual.T), expected.T, 'AbsTol', 0.001);
verifyEqual(testCase, error, 0, 'AbsTol', 0.001);

end

function testRigid(testCase)
[x, z, y] = find(ones(2,2));
X.pc = pointCloud([x y z]);
expected = affine3d(makehgtform('axisrotate', [1 2 3], pi/2)' * makehgtform('translate', [2 3 4])');
Y.pc = pctransform(X.pc, expected);

[i_actual, error] = svd_transformation(X, Y, 1:4, ones(4,1));

verifyEqual(testCase, inv(i_actual.T), expected.T, 'AbsTol', 0.001);
verifyEqual(testCase, error, 0, 'AbsTol', 0.001);

end