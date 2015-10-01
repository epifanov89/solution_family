classdef GetSystemTestHelper < matlab.unittest.TestCase
  
  properties (GetAccess = protected, SetAccess = protected)
    preyDiffusionCoeff
    secondPredatorDiffusionCoeff
    firstPredatorMortality
    resourceDeviation
    
    isGetParamsCalled
    preyDiffusionCoeffPassedInToGetParams
    secondPredatorDiffusionCoeffPassedInToGetParams
    firstPredatorMortalityPassedInToGetParams
    resourceDeviationPassedInToGetParams
    NPassedInToGetParams
    
    rightParts
    linearizedSystem
    resource
    nprey
    npredator
    tstep
  end
  
  methods (Access = protected)
    function [ rightParts,linearizedSystem,resource,...
        nprey,npredator,tstep ] = fakeParams(testCase,...
          preyDiffusionCoeff,secondPredatorDiffusionCoeff,...
          firstPredatorMortality,resourceDeviation,N)
      testCase.isGetParamsCalled = true;
      testCase.preyDiffusionCoeffPassedInToGetParams = preyDiffusionCoeff;
      testCase.secondPredatorDiffusionCoeffPassedInToGetParams = ...
        secondPredatorDiffusionCoeff;
      testCase.firstPredatorMortalityPassedInToGetParams = ...
        firstPredatorMortality;
      testCase.resourceDeviationPassedInToGetParams = resourceDeviation;
      testCase.NPassedInToGetParams = N;

      rightParts = testCase.rightParts;
      linearizedSystem = testCase.linearizedSystem;
      resource = testCase.resource;
      
      nprey = testCase.nprey;
      npredator = testCase.npredator;
      
      tstep = testCase.tstep;
    end
    
    function act(~)
    end
    
    function verifyGetsParams(testCase)       
      testCase.isGetParamsCalled = false;
      testCase.preyDiffusionCoeff = 0;
      testCase.secondPredatorDiffusionCoeff = 1;
      testCase.firstPredatorMortality = 2;
      testCase.resourceDeviation = 3;
      testCase.act();
      testCase.assertTrue(testCase.isGetParamsCalled,...
        'Не вызвана функция получения параметров');
      testCase.verifyEqual(...
        testCase.preyDiffusionCoeffPassedInToGetParams,...
        testCase.preyDiffusionCoeff,...
        'В функцию получения параметров передан неправильный коэффициент диффузии жертвы');
      testCase.verifyEqual(...
        testCase.secondPredatorDiffusionCoeffPassedInToGetParams,...
        testCase.secondPredatorDiffusionCoeff,...
        'В функцию получения параметров передан неправильный коэффициент диффузии второго хищника');
      testCase.verifyEqual(...
        testCase.firstPredatorMortalityPassedInToGetParams,...
        testCase.firstPredatorMortality,...
        'В функцию получения параметров передан неправильный коэффициент смертности первого хищника');
      testCase.verifyEqual(...
        testCase.resourceDeviationPassedInToGetParams,...
        testCase.resourceDeviation,...
        'В функцию получения параметров передана неправильная вариативность функции ресурса');
    end
  end
  
end

