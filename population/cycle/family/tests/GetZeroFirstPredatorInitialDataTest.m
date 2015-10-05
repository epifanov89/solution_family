classdef GetZeroFirstPredatorInitialDataTest < matlab.unittest.TestCase
  %GETZEROFIRSTPREDATORINITIALDATATEST Summary of this class goes here
  %   Detailed explanation goes here
  
  methods (Test)
    function testFirstPredatorZero(testCase)
      N = 10;
      ic = getZeroFirstPredatorInitialData(N);
      actFirstPredatorIC = ic(N+1:2*N);
      expFirstPredatorIC = zeros(1,N);
      testCase.assertGreaterThan(length(ic),0,...
        '���������� ������ ��������� ������');
      testCase.verifyEqual(actFirstPredatorIC,expFirstPredatorIC,...
        '���������� ��������� ������ � ��������� ���������� ������ ��������� ��������');
    end
  end
  
end

