classdef GetPoincareMapLastPointIndexTest < matlab.unittest.TestCase
  
  methods (Test)
    function testReturnsLastPointIndex(testCase)
      vec = [1 3 7 9 7 3 1 3 7 9];
      fixedVarValue = 6;
      ptstart = 8;
      actPointIndex = getPoincareMapLastPointIndex(vec,...
        fixedVarValue,ptstart);
      expPointIndex = 5;
      testCase.verifyEqual(actPointIndex,expPointIndex,...
        'Не возвращен индекс последней точки отображения Пуанкаре');
    end
  end
  
end

