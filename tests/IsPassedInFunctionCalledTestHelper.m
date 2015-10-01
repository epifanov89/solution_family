classdef IsPassedInFunctionCalledTestHelper < matlab.unittest.TestCase
  
  properties
    isPassedInFunctionCalled
  end
  
  methods (Access = public)
    function setup(testCase)
      testCase.isPassedInFunctionCalled = false;
    end
  end
  
  methods (Access = protected)
    function fakeFcnToPassIn(testCase)
      testCase.isPassedInFunctionCalled = true;
    end
    
    function assertPassedInFunctionCalled(testCase)
      testCase.assertTrue(testCase.isPassedInFunctionCalled,...
        'Не вызвана переданная функция');
    end
  end
  
end

