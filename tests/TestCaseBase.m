classdef TestCaseBase < matlab.unittest.TestCase
  
  properties (GetAccess = protected,SetAccess = protected)    
    dirname
    filenamesPassedInToLoad
    varsToLoad
  end
  
  methods    
    function dirname = fakeCurrentDirName(testCase)
      dirname = testCase.dirname;
    end
    
    function S = fakeLoad(testCase,filename,varargin)
      testCase.filenamesPassedInToLoad = ...
        [testCase.filenamesPassedInToLoad,filename];
      
      loaded = testCase.varsToLoad(arrayfun(...
        @(l) strcmp(l.filename,filename),testCase.varsToLoad));
      S = loaded.vars;
    end
  end
    
end

