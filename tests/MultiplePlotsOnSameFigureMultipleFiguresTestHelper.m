classdef MultiplePlotsOnSameFigureMultipleFiguresTestHelper < ...
    MultipleFigurePlotsTestHelper & MultiplePlotsOnSameFigureTestHelperBase
    
  methods (Access = protected)        
    function fakeHold(testCase,handle,arg)
      callInfo = testCase.processHoldCall(arg);
      callInfo.args.handle = handle;
      testCase.callSequence = [testCase.callSequence,callInfo];
    end
    
    function h = fakePlot(testCase,handle,X,Y,varargin)     
      callInfo = testCase.processPlotCall(X,Y,varargin);
      callInfo.args.handle = handle;
      testCase.callSequence = [testCase.callSequence,callInfo];
      h = fakePlot@MultipleFigurePlotsTestHelper(testCase,handle,X,Y,...
        varargin{:});
    end
  end
  
end

