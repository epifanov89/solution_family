classdef SingleFigurePlotTestHelper < PlotTestHelperBase
  
  methods (Access = protected)
    function h = fakePlot(testCase,X,Y,LineSpec,varargin)      
      npt = length(X);
      islineplot = ~isempty(strfind(LineSpec,'-'));
      line = zeros(npt,2);
      for pointIndex = 1:npt
        pt = [X(pointIndex),Y(pointIndex)];
        if islineplot
          line(pointIndex,:) = pt;
        else
          testCase.processPointPlot(pt);
        end
      end
      
      testCase.plottedLines = [testCase.plottedLines,line];
      h = [];
    end
    
    function processPointPlot(~,~)      
    end
  end
  
end

