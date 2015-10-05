classdef MultipleFigurePlotsTestHelper < PlotTestHelperBase
  
  methods (Access = protected)
    function h = fakePlot(testCase,handle,X,Y,LineSpec,varargin)      
      npt = length(X);
      islineplot = ~isempty(strfind(LineSpec,'-'));
      data = zeros(npt,2);
      for pointIndex = 1:npt
        pt = [X(pointIndex),Y(pointIndex)];
        if islineplot
          data(pointIndex,:) = pt;
        else
          testCase.processPointPlot(handle,pt);
        end
      end
      
      line = struct;
      line.data = data;
      line.handle = handle;
      testCase.plottedLines = [testCase.plottedLines,line];
      h = [];
    end
    
    function verifyLinePlotted(testCase,handle,data,msg)
      line = struct;
      line.handle = handle;
      line.data = data;      
      verifyLinePlotted@PlotTestHelperBase(testCase,line,msg);
    end
    
    function processPointPlot(~,~,~)      
    end
  end
  
end

