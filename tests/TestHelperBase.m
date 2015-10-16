classdef TestHelperBase < matlab.unittest.TestCase  
  
  properties (GetAccess = protected, SetAccess = protected)
    varsToReturnFromGetLastRowWithExtremeElementValue
    
    isGetSystemCalled
    rightParts
    linearizedSystem
    resource
    nprey
    npredator
    tstep
    
    displayedValArr
  end
  
  properties (GetAccess = protected)
    preyDiffusionCoeffPassedInToGetSystem
    secondPredatorDiffusionCoeffPassedInToGetSystem
    firstPredatorMortalityPassedInToGetSystem
    resourceVariationPassedInToGetSystem
    NPassedInToGetSystem
  end
  
  methods (Access = protected)
    function verifyContainsItem(testCase,arr,item,msg)
      testCase.verifyTrue(containsItem(arr,item),msg);
    end
    
    function assertDoesNotContainItem(testCase,arr,item,msg)
      testCase.assertFalse(containsItem(arr,item),msg);
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
    
    function verifyGetsSystem(testCase,preyDiffusionCoeff,...
        secondPredatorDiffusionCoeff,firstPredatorMortality,...
        resourceVariation,N)       
      testCase.isGetSystemCalled = false;      
      testCase.act();
      testCase.assertTrue(testCase.isGetSystemCalled,...
        'Не вызвана функция получения правых частей системы');
      testCase.verifyEqual(...
        testCase.preyDiffusionCoeffPassedInToGetSystem,...
        preyDiffusionCoeff,...
        'В функцию получения правых частей системы передан неправильный коэффициент диффузии жертвы');
      testCase.verifyEqual(...
        testCase.secondPredatorDiffusionCoeffPassedInToGetSystem,...
        secondPredatorDiffusionCoeff,...
        'В функцию получения правых частей системы передан неправильный коэффициент диффузии второго хищника');
      testCase.verifyEqual(...
        testCase.firstPredatorMortalityPassedInToGetSystem,...
        firstPredatorMortality,...
        'В функцию получения правых частей системы передана неправильная смертность первого хищника');
      testCase.verifyEqual(...
        testCase.resourceVariationPassedInToGetSystem,resourceVariation,...
        'В функцию получения правых частей системы передана неправильная вариативность ресурса');
      testCase.verifyEqual(testCase.NPassedInToGetSystem,N,...
        'В функцию получения правых частей системы передано неправильное число точек сетки');
    end
    
    function verifyDisplayed(testCase,val,msg)
      testCase.displayedValArr = {};
      testCase.act();
      testCase.verifyEqual(testCase.displayedValArr,val,msg);
    end
    
    function [ rightParts,linearizedSystem,resource,nprey,npredator,...
          tstep ] = fakeGetSystem(testCase,preyDiffusionCoeff,...
        secondPredatorDiffusionCoeff,firstPredatorMortality,...
        resourceVariation,N)
      testCase.isGetSystemCalled = true;
      testCase.preyDiffusionCoeffPassedInToGetSystem = preyDiffusionCoeff;
      testCase.secondPredatorDiffusionCoeffPassedInToGetSystem = ...
        secondPredatorDiffusionCoeff;
      testCase.firstPredatorMortalityPassedInToGetSystem = ...
        firstPredatorMortality;
      testCase.resourceVariationPassedInToGetSystem = ...
        resourceVariation;
      testCase.NPassedInToGetSystem = N;
      
      rightParts = testCase.rightParts;
      linearizedSystem = testCase.linearizedSystem;
      resource = testCase.resource;

      nprey = testCase.nprey;
      npredator = testCase.npredator;
      
      tstep = testCase.tstep;
    end
    
    function fakeDisp(testCase,val)
      testCase.displayedValArr = [testCase.displayedValArr,val];
    end
    
    function act(~)
    end
  end
  
end

