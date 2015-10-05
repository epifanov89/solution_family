classdef MultipleLoadTestHelper < handle
  
  properties (GetAccess = protected,SetAccess = protected)    
    varsToLoad
  end  
  
  methods (Access = protected)    
    function vars = fakeLoad(testCase,filename,varargin)
      vars = testCase.getVarsWithNamesToLoadFromFile(filename,varargin);
    end
    
    function vars = getVarsWithNamesToLoadFromFile(testCase,filename,vars)
      if length(vars) == 1
        loadedVars = getArrayItems(...
          @(l) strcmp(l.filename,filename)...
            && isempty(setxor(fieldnames(l.vars)',vars{:})),...
          testCase.varsToLoad);
      else
        loadedVars = getArrayItems(...
          @(l) strcmp(l.filename,filename)...
            && isempty(setxor(fieldnames(l.vars)',vars)),...
          testCase.varsToLoad);
      end
      if ~isempty(loadedVars)
        vars = loadedVars.vars;
      else
        vars = struct;
      end
    end
    
    function vars = getVarsToLoadFromFile(testCase,filename)
      loadedVars = getArrayItems(@(l) strcmp(l.filename,filename),...
        testCase.varsToLoad);
      vars = loadedVars.vars;
    end
  end
  
end

