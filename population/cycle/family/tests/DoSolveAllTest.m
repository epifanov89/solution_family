classdef DoSolveAllTest < matlab.unittest.TestCase
  
  properties
    isPassedInFunctionCalled
    passedInPreyDiffusionCoeff
    passedInSecondPredatorDiffusionCoeff
    passedInFirstPredatorMortality
    passedInResourceDeviation
    passedInN
    passedInTSpan
    passedInSolver
    passedInNSol
    passedInFamilyName
    passedInCurrentDirName
    passedInExist
    passedInSolveOne
  end
  
  methods
    function fakeFcnToPassIn(testCase,preyDiffusionCoeff,...
        secondPredatorDiffusionCoeff,firstPredatorMortality,...
        resourceDeviation,N,tspan,solver,nsol,familyName,currentDirName,...
        exist,solveOne)
      testCase.isPassedInFunctionCalled = true;
      testCase.passedInPreyDiffusionCoeff = preyDiffusionCoeff;
      testCase.passedInSecondPredatorDiffusionCoeff = ...
        secondPredatorDiffusionCoeff;
      testCase.passedInFirstPredatorMortality = firstPredatorMortality;
      testCase.passedInResourceDeviation = resourceDeviation;
      testCase.passedInN = N;
      testCase.passedInTSpan = tspan;
      testCase.passedInSolver = solver;
      testCase.passedInNSol = nsol;
      testCase.passedInFamilyName = familyName;
      testCase.passedInCurrentDirName = currentDirName;
      testCase.passedInExist = exist;
      testCase.passedInSolveOne = solveOne;
    end
  end
  
  methods (Test)
    function testPassesParamsToPassedInFunction(testCase)
      testCase.isPassedInFunctionCalled = false;
      preyDiffusionCoeff = 0.2;
      secondPredatorDiffusionCoeff = 0.24;
      firstPredatorMortality = 1;
      resourceDeviation = 0.2;
      N = 24;
      tspan = 0:0.002:100;
      solver = @myode4;
      nsol = 10;
      familyName = 'family';
      doSolveAll(@testCase.fakeFcnToPassIn,preyDiffusionCoeff,...
        secondPredatorDiffusionCoeff,firstPredatorMortality,...
        resourceDeviation,N,tspan,solver,nsol,familyName);
      testCase.assertTrue(testCase.isPassedInFunctionCalled,...
        '�� ������� ���������� �������');
      testCase.verifyEqual(testCase.passedInPreyDiffusionCoeff,...
        preyDiffusionCoeff,...
        '������� ������������ ����������� �������� ������');
      testCase.verifyEqual(...
        testCase.passedInSecondPredatorDiffusionCoeff,...
        secondPredatorDiffusionCoeff,...
        '������� ������������ ����������� �������� ������� �������');
      testCase.verifyEqual(...
        testCase.passedInFirstPredatorMortality,...
        firstPredatorMortality,...
        '������� ������������ ����������� ���������� ������� �������');
      testCase.verifyEqual(testCase.passedInResourceDeviation,...
        resourceDeviation,...
        '�������� ������������ ��������� ������� �������');
      testCase.verifyEqual(testCase.passedInN,N,...
        '�������� ������������ ����� ����� �����');
      testCase.verifyEqual(testCase.passedInTSpan,tspan,...
        '������� ������������ �������� �������������� �� �������');
      testCase.verifyEqual(testCase.passedInSolver,solver,...
        '������� ������������ ��������');
      testCase.verifyEqual(testCase.passedInNSol,nsol,...
        '�������� ������������ ����� ������� ���������');
      testCase.verifyEqual(testCase.passedInFamilyName,familyName,...
        '�������� ������������ ��� ���������');
      testCase.verifyEqual(testCase.passedInCurrentDirName,...
        @currentDirName,...
        '�������� ������������ ������� ��������� ����� ������� �����');
      testCase.verifyEqual(testCase.passedInExist,@exist,...
        '�������� ������������ ������� �������� ������������� �����');
      testCase.verifyEqual(testCase.passedInSolveOne,@solveOne,...
        '�������� ������������ ������� ���������� ������ �������');
    end
  end
  
end

