classdef PlotTestHelperBase < matlab.unittest.TestCase & TestHelperBase
  
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
        'Не закрыты все окна рисунков');
    end
  end
  
  methods (Access = protected)
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
  end
  
end

