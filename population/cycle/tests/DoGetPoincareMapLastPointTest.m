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
        'Передана неправильная функция получения последней точки отображения Пункаре');
      testCase.verifyEqual(testCase.passedInGetInterpValue,...
        @getInterpValue,...
        'Передана неправильная функция нахождения интерполированного значения соседних элементов переданного вектора');
      testCase.verifyEqual(testCase.passedInW,w,...
        'Передана неправильная матрица');
      testCase.verifyEqual(testCase.passedInFixedVarIndex,...
        fixedVarIndex,...
        'Передан неправильный индекс фиксированной переменной секущей плоскости Пуанкаре');
      testCase.verifyEqual(testCase.passedInFixedVarValue,...
        fixedVarValue,...
        'Передано неправильное значение фиксированной переменной секущей плоскости Пуанкаре');
      testCase.verifyEqual(pt,...
        testCase.pointToReturnFromPassedInFunction,...
        'Возвращена неправильная последняя точка отображения Пуанкаре');
    end
  end
  
end

