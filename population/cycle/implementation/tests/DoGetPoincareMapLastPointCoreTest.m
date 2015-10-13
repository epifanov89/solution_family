classdef DoGetPoincareMapLastPointCoreTest < matlab.unittest.TestCase...
    & PoincareMapTestHelper
    
  methods (Test)
    function testReturnsPoincareMapLastPoint(testCase)
      w = [1 2 3
           5 6 7
           3 4 5];
      fixedVarIndex = 1;
      fixedVarValue = 4;
      
      pointIndex = struct;
      pointIndex.vec = [1 5 3]';
      pointIndex.fixedVarValue = fixedVarValue;
      pointIndex.ptstart = 3;
      prevPoint = 2;
      pointIndex.pointIndex = prevPoint;
      testCase.pointIndicesToReturnFromGetPoincareMapLastPointIndex = pointIndex;
      
      vq = struct;
      vq.x = [1 5 3]';
      vq.v = [1 5 3]';
      vq.fixedVarValue = fixedVarValue;
      vq.pt = prevPoint;
      vq.vq = 4;
      testCase.vqToReturnFromGetInterpValue = vq;
      
      vq.v = [2 6 4]';
      vq.vq = 5;
      testCase.vqToReturnFromGetInterpValue = [testCase.vqToReturnFromGetInterpValue,vq];
      
      vq.v = [3 7 5]';
      vq.vq = 6;
      testCase.vqToReturnFromGetInterpValue = [testCase.vqToReturnFromGetInterpValue,vq];
      
      actLastPoint = doGetPoincareMapLastPointCore(...
        @testCase.fakeGetPoincareMapLastPointIndex,...
        @testCase.fakeGetInterpValue,w,fixedVarIndex,fixedVarValue);
      expLastPoint = [4 5 6];
      testCase.verifyEqual(actLastPoint,expLastPoint,...
        'Возвращена неправильная последняя точка отображения Пуанкаре');
    end
  end
  
end

