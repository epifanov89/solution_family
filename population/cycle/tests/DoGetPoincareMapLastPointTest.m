classdef DoGetPoincareMapLastPointTest < IsPassedInFunctionCalledTestHelper
  
  properties
    passedInGetPoincareMapLastPointIndex
    passedInGetInterpValue
    passedInW
    passedInFixedVarIndex
    passedInFixedVarValue
    pointToReturnFromPassedInFunction
  end
  
  methods (TestMethodSetup)
    function setup(testCase)
      setup@IsPassedInFunctionCalledTestHelper(testCase);
    end
  end
  
  methods (Access = protected)
    function point = fakeFcnToPassIn(testCase,...
        getPoincareMapLastPointIndex,getInterpValue,...
        w,fixedVarIndex,fixedVarValue)
      fakeFcnToPassIn@IsPassedInFunctionCalledTestHelper(testCase);
      testCase.passedInGetPoincareMapLastPointIndex = ...
        getPoincareMapLastPointIndex;
      testCase.passedInGetInterpValue = getInterpValue;
      testCase.passedInW = w;
      testCase.passedInFixedVarIndex = fixedVarIndex;
      testCase.passedInFixedVarValue = fixedVarValue;
      
      point = testCase.pointToReturnFromPassedInFunction;
    end
  end
  
  methods (Test)
    function testPassesRightParamsToPassedInFunction(testCase)
      w = 1;
      fixedVarIndex = 1;
      fixedVarValue = 1;
      testCase.pointToReturnFromPassedInFunction = 1;
      pt = doGetPoincareMapLastPoint(@testCase.fakeFcnToPassIn,...
        w,fixedVarIndex,fixedVarValue);
      testCase.assertPassedInFunctionCalled();
      testCase.verifyEqual(...
        testCase.passedInGetPoincareMapLastPointIndex,...
        @getPoincareMapLastPointIndex,...
        '�������� ������������ ������� ��������� ��������� ����� ����������� �������');
      testCase.verifyEqual(testCase.passedInGetInterpValue,...
        @getInterpValue,...
        '�������� ������������ ������� ���������� ������������������ �������� �������� ��������� ����������� �������');
      testCase.verifyEqual(testCase.passedInW,w,...
        '�������� ������������ �������');
      testCase.verifyEqual(testCase.passedInFixedVarIndex,...
        fixedVarIndex,...
        '������� ������������ ������ ������������� ���������� ������� ��������� ��������');
      testCase.verifyEqual(testCase.passedInFixedVarValue,...
        fixedVarValue,...
        '�������� ������������ �������� ������������� ���������� ������� ��������� ��������');
      testCase.verifyEqual(pt,...
        testCase.pointToReturnFromPassedInFunction,...
        '���������� ������������ ��������� ����� ����������� ��������');
    end
  end
  
end

