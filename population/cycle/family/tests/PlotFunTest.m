classdef PlotFunTest < matlab.unittest.TestCase
  
  properties
    funPassedInToFPlot
    limitsPassedInToFPlot    
  end
  
  methods    
    function fakeFPlot(testCase,fun,limits)      
      testCase.funPassedInToFPlot = fun;
      testCase.limitsPassedInToFPlot = limits;
    end
  end
  
  methods (Test)    
    function testPlotsFun(testCase)
      fun = @(x) 1+0.2*sin(2*pi*x);
      plotFun(fun);
      testCase.assertTrue(testCase.isFPlotCalled,...
        'Не построен график переданной функции');
      testCase.verifyEqual(testCase.funPassedInToFPlot,...
        fun,'Не построен график переданной функции');
      testCase.verifyEqual(testCase.limitsPassedInToFPlot,...
        [0 1],'Не построен график переданной функции');
    end
  end
  
end

