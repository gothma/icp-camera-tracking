function tests = closest_points_delaunayn_test
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
setup()
end

function teardownOnce(testCase)
teardown()
end

function test_one_matching(testCase)
Y = struct();
Y.pc = [1,2,3];
X = struct();
X.pc = [1,2,3;4,5,6];
actual = closest_points_delaunayn(X,Y);
expected = [1];
verifyEqual(testCase, actual, expected);
end