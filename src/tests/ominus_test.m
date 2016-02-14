function [ tests ] = ominus_test
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
setup()
end

function teardownOnce(testCase)
teardown()
end

function test_translation(testCase)
a = affine3d(makehgtform('translate', [1 2 3])');
b = affine3d(makehgtform('translate', [4 5 6])');
expected = affine3d(makehgtform('translate', [3 3 3])');
actual = ominus(a,b);
verifyEqual(testCase, actual.T, expected.T);
end