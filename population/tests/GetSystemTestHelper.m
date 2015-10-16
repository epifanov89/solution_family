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
    
    function verifyGetsParams(testCase,preyDiffusionCoeff,...
        secondPredatorDiffusionCoeff,firstPredatorMortality,...
        resourceVariation)       
      testCase.isGetParamsCalled = false;      
      testCase.act();
      testCase.assertTrue(testCase.isGetParamsCalled,...
        '�� ������� ������� ��������� ����������');
      testCase.verifyEqual(...
        testCase.preyDiffusionCoeffPassedInToGetParams,...
        testCase.preyDiffusionCoeff,...
        '� ������� ��������� ���������� ������� ������������ ����������� �������� ������');
      testCase.verifyEqual(...
        testCase.secondPredatorDiffusionCoeffPassedInToGetParams,...
        testCase.secondPredatorDiffusionCoeff,...
        '� ������� ��������� ���������� ������� ������������ ����������� �������� ������� �������');
      testCase.verifyEqual(...
        testCase.firstPredatorMortalityPassedInToGetParams,...
        testCase.firstPredatorMortality,...
        '� ������� ��������� ���������� ������� ������������ ����������� ���������� ������� �������');
      testCase.verifyEqual(...
        testCase.resourceVariationPassedInToGetParams,...
        testCase.resourceVariation,...
        '� ������� ��������� ���������� �������� ������������ ������������� ������� �������');
    end
  end
  
end

