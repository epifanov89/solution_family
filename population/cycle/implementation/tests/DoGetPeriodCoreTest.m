classdef DoGetPeriodCoreTest < matlab.unittest.TestCase...
    & PoincareMapTestHelper
  
  methods (Test)
    function testReturnsPeriod(testCase)
      t = [1 3 7 8 10 11 15 17 20 21 25 28 32 35 40 42 45 49 51 56];
      w = [1 2
           3 4
           5 6
           7 8
           9 10
           9 10
           7 8
           5 6
           3 4
           1 2
           1 2
           3 4
           5 6
           7 8
           9 10
           9 10
           7 8
           5 6
           3 4
           1 2];         
      fixedVarIndex = 1;
      fixedVarValue = 6;
      
      point = struct;
      point.vec = [1 3 5 7 9 9 7 5 3 1 1 3 5 7 9 9 7 5 3 1]';
      point.fixedVarValue = fixedVarValue;
      point.ptstart = 20;
      prevPoint = 5;
      point.pointIndex = prevPoint;
      testCase.pointIndicesToReturnFromGetPoincareMapLastPointIndex = point;
      
      vq = struct;
      vq.x = [1 3 5 7 9 9 7 5 3 1 1 3 5 7 9 9 7 5 3 1]';
      vq.v = t;
      vq.fixedVarValue = fixedVarValue;
      vq.pt = prevPoint;
      vq.vq = 10;
      testCase.vqToReturnFromGetInterpValue = vq;
      
      point.ptstart = prevPoint;
      prevPoint = 7;
      point.pointIndex = prevPoint;
      testCase.pointIndicesToReturnFromGetPoincareMapLastPointIndex = ...
        [testCase.pointIndicesToReturnFromGetPoincareMapLastPointIndex,point];
      
      point.ptstart = prevPoint;
      prevPoint = 10;
      point.pointIndex = prevPoint;
      testCase.pointIndicesToReturnFromGetPoincareMapLastPointIndex = ...
        [testCase.pointIndicesToReturnFromGetPoincareMapLastPointIndex,point];
      
      vq.pt = prevPoint;
      vq.vq = 5;
      
      testCase.vqToReturnFromGetInterpValue = ...
        [testCase.vqToReturnFromGetInterpValue,vq];
      
      actPeriod = doGetPeriodCore(@testCase.fakeGetPoincareMapLastPointIndex,...
        @testCase.fakeGetInterpValue,t,w,fixedVarIndex,fixedVarValue);
      expPeriod = 5;
      testCase.verifyEqual(actPeriod,expPeriod,...
        'Возвращен неправильный период');
    end
  end
  
end

