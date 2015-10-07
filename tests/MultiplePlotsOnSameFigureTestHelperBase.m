classdef MultiplePlotsOnSameFigureTestHelperBase < TestHelperBase
  
  properties (SetAccess = protected, GetAccess = protected)
    callSequence
  end
    
  methods (Access = protected)        
    function callInfo = processHoldCall(~,arg)
      callInfo = struct;
      callInfo.fcn = 'hold';
      args = struct;
      args.arg = arg;
      callInfo.args = args;
    end
    
    function callInfo = processPlotCall(varargin)     
      callInfo = struct;
      callInfo.fcn = 'plot';
      callInfo.args = struct;
    end
    
    function verifyPlotsAreNotOverwrited(testCase) 
      testCase.act();
      
      callInfo = struct;
      callInfo.fcn = 'hold';
      args = struct;
      args.arg = 'on';
      callInfo.args = args;
      holdOnCallIndices = getArrayItemIndices(...
        callInfo,testCase.callSequence);
      testCase.assertFalse(isempty(holdOnCallIndices),...
        'Некоторые графики затираются следующими');
      
      callInfo.fcn = 'plot';
      args = struct;
      callInfo.args = args;
      plotCallIndices = getArrayItemIndices(...
        callInfo,testCase.callSequence);
      plotBeforeHoldOnIndices = ...
        find(plotCallIndices < holdOnCallIndices(1));
      testCase.assertLessThanOrEqual(length(plotBeforeHoldOnIndices),1,...
        'Некоторые графики затираются следующими');
      
      callInfo.fcn = 'hold';
      args = struct;
      args.arg = 'off';
      callInfo.args = args;
      holdOffCallIndices = getArrayItemIndices(...
        callInfo,testCase.callSequence);
      holdOffBeforeLastPlotCallIndices = find(...
        holdOffCallIndices < plotCallIndices(end),1);
      testCase.verifyTrue(isempty(holdOffBeforeLastPlotCallIndices),...
        'Некоторые графики затираются следующими');
    end
  end
  
end

