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
        'Передана неправильная функция получения предыдущей точки отображения Пуанкаре');
      testCase.verifyEqual(testCase.passedInGetInterpValue,...
        @getInterpValue,...
        'Передана неправильная функция нахождения интерполированного значения');      
      testCase.verifyEqual(testCase.passedInT,t,...
        'Передены неправильные времена решения');
      testCase.verifyEqual(testCase.passedInW,w,...
        'Передены неправильные точки решения');
      testCase.verifyEqual(testCase.passedInFixedVarIndex,fixedVarIndex,...
        'Передан неправильный индекс фиксированной переменной секущей плоскости Пуанкаре');
      testCase.verifyEqual(testCase.passedInFixedVarValue,fixedVarValue,...
        'Передано неправильное значение фиксированной переменной секущей плоскости Пуанкаре');
      testCase.verifyEqual(T,...
        testCase.periodToReturnFromPassedInFunction,...
        'Не возвращен период, возвращенный из переданной функции')
    end
  end
  
end

