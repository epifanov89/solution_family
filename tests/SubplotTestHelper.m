classdef SubplotTestHelper < handle
  
  properties    
    axesHandlesToReturnFromSubplot
  end
  
  properties (GetAccess = protected)
    argsPassedInToSubplot
  end
  
  methods (Access = protected)
    function setupAxesHandlesToReturnFromSubplot(testCase,pos,handle)
      axesHandles = struct;
      axesHandles.pos = pos;
      axesHandles.handle = handle;
      testCase.axesHandlesToReturnFromSubplot = ...
        [testCase.axesHandlesToReturnFromSubplot,axesHandles];
    end
    
    function h = fakeSubplot(testCase,nrow,ncol,pos)
      args = struct;
      args.nrow = nrow;
      args.ncol = ncol;
      args.pos = pos;
      testCase.argsPassedInToSubplot = args;
      
      axesHandles = getArrayItems(...
        @(a) a.pos == pos,testCase.axesHandlesToReturnFromSubplot);
      if ~isempty(axesHandles)
        h = axesHandles.handle;
      else
        h = [];
      end
    end
  end
  
end

