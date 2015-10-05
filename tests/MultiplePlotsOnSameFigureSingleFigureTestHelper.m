classdef MultiplePlotsOnSameFigureSingleFigureTestHelper < ...
    SingleFigurePlotTestHelper & MultiplePlotsOnSameFigureTestHelperBase
    
  methods (Access = protected)        
    function fakeHold(testCase,arg)
      callInfo = testCase.processHoldCall(arg);
      testCase.callSequence = [testCase.callSequence,callInfo];
    end
    
    function h = fakePlot(testCase,X,Y,varargin)     
      callInfo = testCase.processPlotCall(X,Y,varargin);
      testCase.callSequence = [testCase.callSequence,callInfo];
      h = fakePlot@SingleFigurePlotTestHelper(testCase,X,Y,varargin{:});
    end
  end
  
end

