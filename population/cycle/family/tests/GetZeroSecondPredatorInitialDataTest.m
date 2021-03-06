classdef GetZeroSecondPredatorInitialDataTest < matlab.unittest.TestCase
  
  methods (Test)
    function testSecondPredatorDensityIsZero(testCase)
      N = 10;
      ic = getZeroSecondPredatorInitialData(N);
      actFirstPredatorIC = ic(2*N+1:3*N);
      expFirstPredatorIC = zeros(1,N);
      testCase.assertGreaterThan(length(ic),0,...
        '���������� ������ ��������� ������');
      testCase.verifyEqual(actFirstPredatorIC,expFirstPredatorIC,...
        '���������� ��������� ������ � ��������� ���������� ������ ��������� ��������');
    end
  end
  
end

