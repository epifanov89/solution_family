classdef SubplotTestHelper < handle
  
  properties (SetAccess = protected, GetAccess = protected)
    axesHandlesToReturnFromSubplot
  end
  
  methods (Access = public)
    function h = fakeSubplot(testCase,nrow,ncol,pos)
      axesHandles = testCase.axesHandlesToReturnFromSubplot(arrayfun(...
        @(a) a.nrow == nrow && a.ncol == ncol && a.pos == pos,...
        testCase.axesHandlesToReturnFromSubplot));
      if ~isempty(axesHandles)
        h = axesHandles.handle;
      else
        h = 1;
      end
    end
  end
  
  methods (Access = protected)
    function setupAxesHandlesToReturnFromSubplot(testCase,nrow,ncol,...
        pos,handle)
      axesHandles = struct;
      axesHandles.nrow = nrow;
      axesHandles.ncol = ncol;
      axesHandles.pos = pos;
      axesHandles.handle = handle;
      testCase.axesHandlesToReturnFromSubplot = axesHandles;
    end
  end
  
end

