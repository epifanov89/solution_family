classdef GetInterpValueTest < matlab.unittest.TestCase
  
  methods (Test)
    function testReturnsInterpValue(testCase)
      x = [1 3 5 7 9 9 7 5 3 1 1 3 5 7 9 9 7 5 3 1];
      v = [1 3 7 8 10 11 15 17 20 21 25 28 32 35 40 42 45 49 51 56];
      fixedVarValue = 6;
      pt = 17;
      actvq = getInterpValue(x,v,fixedVarValue,pt);
      expvq = 47;
      testCase.verifyEqual(actvq,expvq,...
        'Возвращено неправильное интерполированное значение');
    end
  end
  
end

