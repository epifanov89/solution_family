classdef SubplotTestHelper < TestHelperBase
  
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
      testCase.argsPassedInToSubplot = ...
        [testCase.argsPassedInToSubplot,args];
      
      axesHandles = getArrayItems(...
        @(a) a.pos == pos,testCase.axesHandlesToReturnFromSubplot);
      if ~isempty(axesHandles)
        h = axesHandles.handle;
      else
        h = [];
      end
    end
    
    function verifySubplotCalled(testCase,nrow,ncol,pos,msg)
      testCase.act();
      args = struct;
      args.nrow = nrow;
      args.ncol = ncol;
      args.pos = pos;
      testCase.verifyContains(testCase.argsPassedInToSubplot,args,msg);
    end
  end
  
end

