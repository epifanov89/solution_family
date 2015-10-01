classdef GetSolutionTillMinPredatorDensitiesTest < matlab.unittest.TestCase
  
  methods (Access = private)
    function solTillMin = act(~,sol,startIndex)
      solTillMin = getSolutionTillMinPredatorDensities(sol,startIndex);
    end
  end
  
  methods (Test)
    function testReturnsSolutionTillMinFirstPredatorDensityForNEqualTo2(testCase)
      sol = [0 0 0 1 0 1
             1 1 1 0 1 0
             0 0 0 1 0 1
             0 0 0 0 0 0];
      startIndex = 3;
      actRes = testCase.act(sol,startIndex);
      expRes = [0 0 0 1 0 1
                1 1 1 0 1 0];
      testCase.verifyEqual(actRes,expRes,...
        'Не возвращено решение до минимума плостности первой популяции хищника при N = 2');
    end
    
    function testReturnsSolutionTillMinFirstPredatorDensityForNEqualTo3(testCase)
      sol = [0 0 0 0 1 0 0 1 0
             1 1 1 1 0 1 1 0 1
             0 0 0 0 1 0 0 1 0
             0 0 0 0 0 0 0 0 0];
      startIndex = 3;
      actRes = testCase.act(sol,startIndex);
      expRes = [0 0 0 0 1 0 0 1 0
                1 1 1 1 0 1 1 0 1];
      testCase.verifyEqual(actRes,expRes,...
        'Не возвращено решение до минимума плостности первой популяции хищника при N = 3');
    end
    
    function testErrorIfPredatorsDoNotVarySimultaneouslyForNEqualTo2(testCase)
      sol = [0 0 0 0 0 1
             0 0 0 1 0 0];
      testCase.verifyError(@() getSolutionTillMinPredatorDensities(sol),...
        'getSolutionTillMinPredatorDensities:PredatorsMustVarySimultaneously',...
        'Не выброшено исключение, когда хищники не растут или убывают одновременно, при N = 2');
    end
    
    function testErrorIfPredatorsDoNotVarySimultaneouslyForNEqualTo3(testCase)
      sol = [0 0 0 0 0 0 0 1 0
             0 0 0 0 1 0 0 0 0];
      testCase.verifyError(@() getSolutionTillMinPredatorDensities(sol),...
        'getSolutionTillMinPredatorDensities:PredatorsMustVarySimultaneously',...
        'Не выброшено исключение, когда хищники не растут или убывают одновременно, при N = 3');
    end
  end
  
end

