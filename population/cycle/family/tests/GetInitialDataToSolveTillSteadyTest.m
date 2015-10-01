classdef GetInitialDataToSolveTillSteadyTest < matlab.unittest.TestCase
    
  methods (Test)
    function testReturnsRightFirstPredatorInitialDataIfSolNoEqualsTo1(testCase)
      N = 4;
      w0 = getInitialDataToSolveTillSteady(1,N);
      testCase.assertGreaterThanOrEqual(w0(7),0.08,...
        '���������� ������������ �������� ��������� ������ ��������� ��������');
      testCase.verifyLessThanOrEqual(w0(7),0.12,...
        '���������� ������������ �������� ��������� ������ ��������� ��������');
    end
    
    function testReturnsRightSecondPredatorInitialDataIfSolNoEqualsTo1(testCase)
      N = 4;
      w0 = getInitialDataToSolveTillSteady(1,N);
      testCase.assertGreaterThanOrEqual(w0(11),0.18,...
        '���������� ������������ �������� ��������� ������ ��������� ��������');
      testCase.verifyLessThanOrEqual(w0(11),0.22,...
        '���������� ������������ �������� ��������� ������ ��������� ��������');
    end
    
    function testReturnsRightFirstPredatorInitialDataIfSolNoEqualsTo2(testCase)
      N = 4;      
      w0 = getInitialDataToSolveTillSteady(2,N);
      testCase.verifyGreaterThanOrEqual(w0(7),0.18,...
        '���������� ������������ �������� ��������� ������ ��������� ��������');
      testCase.verifyLessThanOrEqual(w0(7),0.22,...
        '���������� ������������ �������� ��������� ������ ��������� ��������');
    end
    
    function testReturnsRightSecondPredatorInitialDataIfSolNoEqualsTo2(testCase)
      N = 4;      
      w0 = getInitialDataToSolveTillSteady(2,N);
      testCase.verifyGreaterThanOrEqual(w0(11),0.08,...
        '���������� ������������ �������� ��������� ������ ��������� ��������');
      testCase.verifyLessThanOrEqual(w0(11),0.12,...
        '���������� ������������ �������� ��������� ������ ��������� ��������');
    end
  end
  
end

