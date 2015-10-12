classdef TestHelperBase < matlab.unittest.TestCase  
  methods (Access = protected)
    function verifyContainsItem(testCase,arr,item,msg)
      testCase.verifyTrue(containsItem(arr,item),msg);
    end
    
    function verifyDoesNotContainItem(testCase,arr,item,msg)
      testCase.verifyFalse(containsItem(arr,item),msg);
    end
    
    function verifyContains(testCase,func,arr,msg)
      testCase.verifyTrue(contains(func,arr),msg);
    end    
    
    function verifyDoesNotContain(testCase,func,arr,msg)
      testCase.verifyFalse(contains(func,arr),msg);
    end
    
    function act(~)
    end
  end
  
end

