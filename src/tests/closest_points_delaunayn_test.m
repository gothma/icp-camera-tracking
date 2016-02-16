function tests = closest_points_delaunayn_test
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
setup()
end

function teardownOnce(testCase)
teardown()
end

function test_four_matching_points(testCase)
X = PointCloudContainer([0,0,0
    0,1,0
    1,0,0
    1,1,0]);
Y = PointCloudContainer([1,1,1
    1,0,1
    0,1,1
    0,0,1]);
actual = closest_points_delaunayn(X,Y);
expected = [4,3,2,1]';
verifyEqual(testCase, actual, expected);

end

function test_two_matching(testCase)
X = PointCloudContainer([1,2,3;4,5,6]);
Y = PointCloudContainer([7,8,9]);
actual = closest_points_delaunayn(X,Y);
expected = [1;1];
verifyEqual(testCase, actual, expected);
end

function test_one_matching(testCase)
X = PointCloudContainer([1,2,3]);
Y = PointCloudContainer([1,2,3;4,5,6]);
actual = closest_points_delaunayn(X,Y);
expected = 1;
verifyEqual(testCase, actual, expected);
end