classdef PlotTestHelperBase < TestHelperBase
  
  properties (SetAccess = protected, GetAccess = protected)
    plottedLines
  end
  
  properties (SetAccess = private, GetAccess = protected)
    argPassedInToClose
  end
  
  methods (Access = public)
    function setup(testCase)
      testCase.plottedLines = {};
    end
    
    function testClosesAll(testCase)
      testCase.act();
      testCase.verifyEqual(testCase.argPassedInToClose,'all',...
        '�� ������� ��� ���� ��������');
    end
  end
  
  methods (Access = protected)
    function verifyLinePlotted(testCase,line,msg)
      testCase.act();
      testCase.verifyContainsItem(testCase.plottedLines,line,msg);
    end
        
    function fakeClose(testCase,arg)
      testCase.argPassedInToClose = arg;
    end
        
    function h = fakeLabel(varargin)
      h = [];
    end

    function h = fakeXLabel(varargin)
      h = [];
    end

    function h = fakeYLabel(varargin)
      h = [];
    end
    
    function h = fakeZLabel(varargin)
      h = [];
    end
    
    function h = fakeGCA(~)
      h = [];
    end

    function fakeSet(varargin)
    end
  end
  
end

