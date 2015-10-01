classdef GetZeroFirstPredatorInitialDataTest < matlab.unittest.TestCase
  %GETZEROFIRSTPREDATORINITIALDATATEST Summary of this class goes here
  %   Detailed explanation goes here
  
  methods (Test)
    function testFirstPredatorZero(testCase)
      N = 10;
      h = 0.1;
      ic = getZeroFirstPredatorInitialData(N,h);
      actFirstPredatorIC = ic(N+1:2*N);
      expFirstPredatorIC = zeros(1,N);
      testCase.assertGreaterThan(length(ic),0,...
        '¬озвращены пустые начальные данные');
      testCase.verifyEqual(actFirstPredatorIC,expFirstPredatorIC,...
        '¬озвращены начальные данные с ненулевой плотностью первой попул€ции хищников');
    end
  end
  
end

