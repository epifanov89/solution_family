classdef DoGetPeriodTest < IsPassedInFunctionCalledTestHelper
  
  properties
    passedInGetPoincareMapLastPointIndex
    passedInGetInterpValue
    passedInT
    passedInW
    passedInFixedVarIndex
    passedInFixedVarValue
    periodToReturnFromPassedInFunction
  end
  
  methods (TestMethodSetup)
    function setup(testCase)
      setup@IsPassedInFunctionCalledTestHelper(testCase);
    end
  end
  
  methods (Access = protected)
    function T = fakeFcnToPassIn(testCase,getPoincareMapLastPointIndex,...
        getInterpValue,t,w,fixedVarIndex,fixedVarValue)
      fakeFcnToPassIn@IsPassedInFunctionCalledTestHelper(testCase);
      testCase.passedInGetPoincareMapLastPointIndex = ...
        getPoincareMapLastPointIndex;
      testCase.passedInGetInterpValue = getInterpValue;
      testCase.passedInT = t;
      testCase.passedInW = w;
      testCase.passedInFixedVarIndex = fixedVarIndex;
      testCase.passedInFixedVarValue = fixedVarValue;
      
      T = testCase.periodToReturnFromPassedInFunction;
    end
  end
  
  methods (Test)
    function testPassesRightParamsToPassedInFunction(testCase)
      t = [1 2];
      w = [1 2
           3 4];
      fixedVarIndex = 3;
      fixedVarValue = 0.5;
      testCase.periodToReturnFromPassedInFunction = 30;
      T = doGetPeriod(@testCase.fakeFcnToPassIn,t,w,fixedVarIndex,fixedVarValue);
      testCase.assertPassedInFunctionCalled();
      testCase.verifyEqual(...
        testCase.passedInGetPoincareMapLastPointIndex,...
        @getPoincareMapLastPointIndex,...
        '�������� ������������ ������� ��������� ���������� ����� ����������� ��������');
      testCase.verifyEqual(testCase.passedInGetInterpValue,...
        @getInterpValue,...
        '�������� ������������ ������� ���������� ������������������ ��������');      
      testCase.verifyEqual(testCase.passedInT,t,...
        '�������� ������������ ������� �������');
      testCase.verifyEqual(testCase.passedInW,w,...
        '�������� ������������ ����� �������');
      testCase.verifyEqual(testCase.passedInFixedVarIndex,fixedVarIndex,...
        '������� ������������ ������ ������������� ���������� ������� ��������� ��������');
      testCase.verifyEqual(testCase.passedInFixedVarValue,fixedVarValue,...
        '�������� ������������ �������� ������������� ���������� ������� ��������� ��������');
      testCase.verifyEqual(T,...
        testCase.periodToReturnFromPassedInFunction,...
        '�� ��������� ������, ������������ �� ���������� �������')
    end
  end
  
end

