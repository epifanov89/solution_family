classdef MultipleLoadTestHelper < handle
  
  properties (GetAccess = protected,SetAccess = protected)    
    varsToLoad
  end  
  
  methods (Access = protected)    
    function vars = fakeLoad(testCase,filename,varargin)
      vars = testCase.getVarsWithNamesToLoadFromFile(filename,varargin);
    end
    
    function vars = getVarsWithNamesToLoadFromFile(testCase,filename,vars)
      loadedVars = testCase.varsToLoad(arrayfun(...
        @(l) strcmp(l.filename,filename)...
          && isempty(setxor(fieldnames(l.vars)',vars{:})),...
        testCase.varsToLoad));
      if ~isempty(loadedVars)
        vars = loadedVars.vars;
      else
        vars = struct;
      end
    end
    
    function vars = getVarsToLoadFromFile(testCase,filename)
      loadedVars = testCase.varsToLoad(arrayfun(...
        @(l) strcmp(l.filename,filename),testCase.varsToLoad));
      vars = loadedVars.vars;
    end
  end
  
end

