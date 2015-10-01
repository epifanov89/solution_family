classdef FakePlotHelper < handle
  
  properties (GetAccess = protected)
    plottedPoints
    plottedLines
  end
  
  properties (GetAccess = protected,SetAccess = protected)
    lineHandles
    callSequence
  end
  
  methods (Access = public)
    function setup(testCase)
      testCase.callSequence = [];
    end
    
    function h = fakePlot(testCase,axesHandle,X,Y,LineSpec,varargin)
      npoint = length(X);
      islineplot = ~isempty(strfind(LineSpec,'-'));
      if islineplot
        line = zeros(npoint,2);
      end
      
      for pointIndex = 1:npoint
        point = [X(pointIndex),Y(pointIndex)];
        if islineplot
          line(pointIndex,:) = point;
        else
          pointInfo = struct;
          pointInfo.data = point;
          pointInfo.axesHandle = axesHandle;
          testCase.plottedPoints = [testCase.plottedPoints,pointInfo];
        end
      end
      
      if islineplot
        lineInfo = struct;
        lineInfo.data = line;
        lineInfo.axesHandle = axesHandle;
        testCase.plottedLines = [testCase.plottedLines;lineInfo];
      end
      
      callInfo = struct;
      callInfo.fcn = 'plot';
      args = struct;
      args.axesHandle = axesHandle;
      args.X = X;
      args.Y = Y;
      args.LineSpec = LineSpec;
      callInfo.args = args;
      testCase.callSequence = [testCase.callSequence,callInfo];
      
      lineIndices = find(arrayfun(@(lineInfo) isequal(lineInfo.X,X)...
        && isequal(lineInfo.Y,Y),testCase.lineHandles),1);      
      if ~isempty(lineIndices)
        lines = testCase.lineHandles(lineIndices);
        line = lines(1);
        h = line.handle;
      else
        h = 0;
      end
    end
  end
  
end

