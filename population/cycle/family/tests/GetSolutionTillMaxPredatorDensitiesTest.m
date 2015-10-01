classdef GetSolutionTillMaxPredatorDensitiesTest < matlab.unittest.TestCase
  
  methods (Access = private)
    function solTillMax = act(~,sol,ptstart)
      solTillMax = getSolutionTillMaxPredatorDensities(sol,ptstart);
    end
  end
  
  methods (Test)
    function testReturnsSolutionTillMaxPredatorDensitiesForNEqualTo2(testCase)
      sol = [1 1 1 0 1 0
             0 0 0 1 0 1
             1 1 1 0 1 0
             0 0 0 1 0 1];
      ptstart = 3;
      actRes = testCase.act(sol,ptstart);
      expRes = [1 1 1 0 1 0
                0 0 0 1 0 1];
      testCase.verifyEqual(actRes,expRes,...
        '�� ���������� ������� �� ���������� ����������� ��������� �������� ��� N = 2');
    end
    
    function testReturnsSolutionTillMaxPredatorDensitiesForNEqualTo3(testCase)
      sol = [1 1 1 1 0 1 1 0 1
             0 0 0 0 1 0 0 1 0
             1 1 1 1 0 1 1 0 1
             0 0 0 0 1 0 0 1 0];
      ptstart = 3;
      actRes = testCase.act(sol,ptstart);
      expRes = [1 1 1 1 0 1 1 0 1
                0 0 0 0 1 0 0 1 0];
      testCase.verifyEqual(actRes,expRes,...
        '�� ���������� ������� �� ���������� ����������� ��������� �������� ��� N = 3');
    end
    
    function testErrorIfPredatorsDoNotVarySimultaneouslyForNEqualTo2(testCase)
      sol = [0 0 0 0 0 1
             0 0 0 1 0 0];
      testCase.verifyError(@() getSolutionTillMaxPredatorDensities(sol),...
        'getSolutionTillMaxPredatorDensities:PredatorsMustVarySimultaneously',...
        '�� ��������� ����������, ����� ������� �� ������ ��� ������� ������������ ��� N = 2');
    end
    
    function testErrorIfPredatorsDoNotVarySimultaneouslyForNEqualTo3(testCase)
      sol = [0 0 0 0 0 0 0 1 0
             0 0 0 0 1 0 0 0 0];
      testCase.verifyError(@() getSolutionTillMaxPredatorDensities(sol),...
        'getSolutionTillMaxPredatorDensities:PredatorsMustVarySimultaneously',...
        '�� ��������� ����������, ����� ������� �� ������ ��� ������� ������������ ��� N = 3');
    end
  end
  
end

