classdef PlotTestHelperBase < matlab.unittest.TestCase
  
  properties (SetAccess = private, GetAccess = protected)
    argPassedInToClose
    plottedLines
  end
  
  methods (Access = public)
    function setup(testCase)
      testCase.plottedLines = {};
    end
  end
  
  methods (Access = protected)
    function testClosesAll(testCase)
      testCase.act();
      testCase.verifyEqual(testCase.argPassedInToClose,'all',...
        'Не закрыты все окна рисунков');
    end
    
    function verifyLinePlotted(testCase,line,msg)
      testCase.act();
      testCase.verifyContains(testCase.plottedLines,line,msg);
    end
    
    function verifyContains(testCase,arr,item,msg)
      testCase.verifyTrue(contains(arr,item),msg);
    end
    
    function fakeClose(testCase,arg)
      testCase.argPassedInToClose = arg;
    end
    
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
    
    function fakeLabel(varargin)
    end

    function fakeXLabel(varargin)
    end

    function fakeYLabel(varargin)
    end
    
    function h = fakeGCA(~)
      h = [];
    end

    function fakeSet(varargin)
    end
    
    function processPointPlot(~,~)      
    end
    
    function act(~)
    end    
  end
  
end

