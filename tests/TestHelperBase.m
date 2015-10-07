classdef TestHelperBase < matlab.unittest.TestCase
  
  methods (Access = protected)
    function verifyContains(testCase,arr,item,msg)
      testCase.verifyTrue(contains(arr,item),msg);
    end
    
    function act(~)
    end
  end
  
end

