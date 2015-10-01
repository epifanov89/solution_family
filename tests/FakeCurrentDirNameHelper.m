classdef FakeCurrentDirNameHelper < handle
  
  properties (GetAccess = protected,SetAccess = protected)    
    dirname
  end
  
  methods    
    function dirname = fakeCurrentDirName(testCase)
      dirname = testCase.dirname;
    end
  end
    
end

