classdef MultiplePlotsOnSameFigureTestHelper < PlotTestHelperBase
  
  properties (SetAccess = private, GetAccess = protected)
    callSequence
  end
    
  methods (Access = protected)      
    function verifyPointPlotted(testCase,pt,msg)
      testCase.act();
      testCase.verifyContains(testCase.plottedPoints,pt,msg);
    end
    
    function fakeHold(testCase,arg)
      callInfo = struct;
      callInfo.fcn = 'hold';
      args = struct;
      args.arg = arg;
      callInfo.args = args;
      testCase.callSequence = [testCase.callSequence,callInfo];
    end
    
    function h = fakePlot(testCase,X,Y,varargin)     
      callInfo = struct;
      callInfo.fcn = 'plot';
      callInfo.args = struct;
      testCase.callSequence = [testCase.callSequence,callInfo];

      h = fakePlot@PlotTestHelperBase(testCase,X,Y,varargin{:});
    end
  end
  
end

