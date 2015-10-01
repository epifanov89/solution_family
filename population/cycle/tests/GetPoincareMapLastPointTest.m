classdef GetPoincareMapLastPointTest < matlab.unittest.TestCase
  
  methods (Test)
    function testReturnsPoincareMapLastPoint(testCase)
      w = [1  2
           3  4
           5  6
           7  8
           9 10
           9  8
           7  6
           5  4
           3  2
           1  0
           1  2
           3  4
           5  6
           7  8
           9 10
           9  8
           7  6
           5  4
           3  2
           1  0];
      fixedVarIndex = 1;
      fixedVarValue = 6;
      actPoincareMapLastPoint = getPoincareMapLastPoint(w,fixedVarIndex,...
        fixedVarValue);
      expPoincareMapLastPoint = [6 5];
      testCase.verifyEqual(actPoincareMapLastPoint,...
        expPoincareMapLastPoint,...
        'Возвращена неправильная последняя точка отображения Пуанкаре');
    end
  end
  
end

