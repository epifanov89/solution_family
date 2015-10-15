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
      str = sprintf('%s ��� N = %d',msgStart,N);
    end        
    
    function [ rightParts,linearizedSystem,resource,nprey,npredator ] = ...
        fakeGetSystem(testCase,preyDiffusionCoeff,...
          secondPredatorDiffusionCoeff,firstPredatorMortality,...
          resourceDeviation,N)
      testCase.isGetParamsCalled = true;
      testCase.preyDiffusionCoeffPassedInToGetParams = preyDiffusionCoeff;
      testCase.secondPredatorDiffusionCoeffPassedInToGetParams = ...
        secondPredatorDiffusionCoeff;
      testCase.firstPredatorMortalityPassedInToGetParams = ...
        firstPredatorMortality;
      testCase.resourceDeviationPassedInToGetParams = ...
        resourceDeviation;
      testCase.NPassedInToGetParams = N;
      
      rightParts = testCase.rightParts;
      linearizedSystem = testCase.linearizedSystem;
      resource = testCase.resource;

      nprey = testCase.nprey;
      npredator = testCase.npredator;
    end
    
    function act(~)
    end
  end
  
end

