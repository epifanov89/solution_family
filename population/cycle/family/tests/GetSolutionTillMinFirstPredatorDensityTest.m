classdef GetSolutionTillMinFirstPredatorDensityTest < matlab.unittest.TestCase
  
  methods (Access = private)
    function solTillMin = act(~,sol,startIndex)
      solTillMin = getSolutionTillMinFirstPredatorDensity(sol,startIndex);
    end
  end
  
  methods (Test)
    function testReturnsSolutionTillMinFirstPredatorDensityForNEqualTo2(testCase)
      sol = [1 1 1 1 1 1
             2 2 2 0 2 2
             0 0 0 1 0 0];
      startIndex = 3;
      actRes = testCase.act(sol,startIndex);
      expRes = [0 0 0 1 0 0
                2 2 2 0 2 2];
      testCase.verifyEqual(actRes,expRes,...
        'Ќе возвращено решение до минимума плостности первой попул€ции хищника при N = 2');
    end
    
    function testReturnsSolutionTillMinFirstPredatorDensityForNEqualTo3(testCase)
      sol = [1 1 1 1 1 1 1 1 1
             2 2 2 2 0 2 2 2 2
             0 0 0 0 1 0 0 0 0];
      startIndex = 3;
      actRes = testCase.act(sol,startIndex);
      expRes = [0 0 0 0 1 0 0 0 0
                2 2 2 2 0 2 2 2 2];
      testCase.verifyEqual(actRes,expRes,...
        'Ќе возвращено решение до минимума плостности первой попул€ции хищника при N = 3');
    end
    
    function testReturnsSolutionTillFirstPoint(testCase)
      sol = [2 2 2 0 2 2
             0 0 0 1 0 0];
      actRes = getSolutionTillMinFirstPredatorDensity(sol);
      expRes = [0 0 0 1 0 0
                2 2 2 0 2 2];
      testCase.verifyEqual(actRes,expRes,...
        'Ќе возвращено решение до минимума плостности первой попул€ции хищника, когда точкой с мимнимумом плостности первой попул€ции хищника €вл€етс€ перва€ точка');
    end
  end
  
end

