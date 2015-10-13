classdef TestHelperBase < matlab.unittest.TestCase  
  
  properties (GetAccess = protected, SetAccess = protected)
    varsToReturnFromGetLastRowWithExtremeElementValue
  end
  
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
    
    function str = getMsg(~,msgStart,N)
      str = sprintf('%s при N = %d',msgStart,N);
    end
        
    function act(~)
    end
  end
  
end

