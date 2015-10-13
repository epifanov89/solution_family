classdef DoSolveTillSteadyTest < matlab.unittest.TestCase
  %DOSOLVETILLSTEADYTEST Summary of this class goes here
  %   Detailed explanation goes here
  
  properties
    isPassedInFunctionCalled
    passedInSolNo
    passedInTF
    passedInGetFilename
    passedInGetFileDir
    passedInExists
    passedInGetInitialDataToSolveTillSteady
    passedInLoad
    passedInSave
    passedInGetParams
    passedInSolver
    passedInGetFirstPointWithExtremeVarValues
    passedInGetLastRow
    passedInGetPeriod
    passedInGetResultsFilepath
    passedInGetSolutionTillMaxPredatorDensities
  end
  
  methods
    function fakeFcnToPassIn(testCase,solno,tf,getFilename,...
        getFileDir,exists,getInitialDataToSolveTillSteady,...
        load,save,getParams,solver,getFirstPointWithExtremeVarValues,...
        getLastRow,getPeriod,getResultsFilepath,...
        getSolutionTillMaxPredatorDensities)
      testCase.isPassedInFunctionCalled = true;
      testCase.passedInSolNo = solno;
      testCase.passedInTF = tf;
      testCase.passedInGetFilename = getFilename;
      testCase.passedInGetFileDir = getFileDir;
      testCase.passedInExists = exists;
      testCase.passedInGetInitialDataToSolveTillSteady = ...
        getInitialDataToSolveTillSteady;
      testCase.passedInLoad = load;
      testCase.passedInSave = save;
      testCase.passedInGetParams = getParams;
      testCase.passedInSolver = solver;
      testCase.passedInGetFirstPointWithExtremeVarValues = ...
        getFirstPointWithExtremeVarValues;
      testCase.passedInGetLastRow = getLastRow;
      testCase.passedInGetPeriod = getPeriod;
      testCase.passedInGetResultsFilepath = getResultsFilepath;
      testCase.passedInGetSolutionTillMaxPredatorDensities = ...
        getSolutionTillMaxPredatorDensities;
    end
  end
  
  methods (Test)
    function testPassesProperParamsToPassedInFunction(testCase)
      solno = 1;
      tf = 50;
      testCase.isPassedInFunctionCalled = false;
      doSolveTillSteady(solno,tf,@testCase.fakeFcnToPassIn);
      testCase.assertTrue(testCase.isPassedInFunctionCalled,...
        '���������� ������� �� �������');
      testCase.verifyEqual(testCase.passedInSolNo,solno,...
        '������� ������������ ����� �������');
      testCase.verifyEqual(testCase.passedInTF,tf,...
        '������� ������������ ������ ����� ��������� �������������� �� �������');
      testCase.verifyEqual(testCase.passedInGetFilename,@mfilename,...
        '�������� ������������ ������� ��������� ����� �����');
      testCase.verifyEqual(testCase.passedInGetFileDir,@getFileDir,...
        '�������� ������������ ������� ��������� ���� � �����, ���������� ����');
      testCase.verifyEqual(testCase.passedInExists,@exist,...
        '�������� ������������ ������� �������� ������������� �����/����������');
      testCase.verifyEqual(...
        testCase.passedInGetInitialDataToSolveTillSteady,...
        @getInitialDataToSolveTillSteady,...
        '�������� ������������ ������� ��������� ��������� ������ ��� ������� �� ������������');
      testCase.verifyEqual(testCase.passedInLoad,@load,...
        '�������� ������������ ������� �������� ���������� �� �����');
      testCase.verifyEqual(testCase.passedInSave,@save,...
        '�������� ������������ ������� ���������� ���������� � ����');
      testCase.verifyEqual(testCase.passedInGetParams,...
        @predatorPrey2x1Params,'�������� ������������ ���������');
      testCase.verifyEqual(testCase.passedInSolver,@myode4,...
        '������� ������������ ��������');
      testCase.verifyEqual(...
        testCase.passedInGetFirstPointWithExtremeVarValues,...
        @getFirstPointWithExtremeVarValues,...
        '�������� ������������ ������� ��������� ������ ����� � �������������� ���������� ���������� � ����������� ���������');
      testCase.verifyEqual(testCase.passedInGetLastRow,@getLastRow,...
        '�������� ������������ ������� ��������� ��������� ������ �������');
      testCase.verifyEqual(testCase.passedInGetPeriod,@getPeriod,...
        '�������� ������������ ������� ���������� �������');
      testCase.verifyEqual(testCase.passedInGetResultsFilepath,...
        @getResultsFilepath,...
        '�������� ������������ ������� ��������� ���� � ����� �����������');
      testCase.verifyEqual(...
        testCase.passedInGetSolutionTillMaxPredatorDensities,...
        @getSolutionTillMaxPredatorDensities,...
        '�������� ������������ ������� ��������� ������� �� ������������ ���������� ��������� ��������');
    end
  end
  
end

