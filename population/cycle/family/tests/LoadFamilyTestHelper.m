classdef LoadFamilyTestHelper < MultipleLoadTestHelper
  
  properties (SetAccess = private, GetAccess = protected)
    filenamesPassedInToLoad
  end
  
  methods (Access = public)
    function setup(testCase)
      testCase.filenamesPassedInToLoad = {};
    end
  end
  
  methods (Access = protected)
    function vars = fakeLoad(testCase,filename,varargin)      
      testCase.filenamesPassedInToLoad = ...
        [testCase.filenamesPassedInToLoad,filename];
      vars = fakeLoad@MultipleLoadTestHelper(testCase,filename,varargin);
    end
  end
  
end

