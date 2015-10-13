classdef DoSolveAndSaveResultsTest < matlab.unittest.TestCase
  
  properties
    isPassedInFunctionCalled
    passedInSolNo
    passedInTF
    passedInGetFilename
    passedInGetFileDir
    passedInGetResultsFilepath
    passedInExists
    passedInGetZeroFirstPredatorInitialData
    passedInGetCombinedPredatorDensitiesInitialData
    passedInLoad
    passedInSave
    passedInGetParams
    passedInSolver
    passedInGetLastRow
    passedInGetPeriod
  end
  
  methods
    function fakeFcnToPassIn(testCase,solno,tf,getFilename,...
        getFileDir,getResultsFilepath,exists,...
        getZeroFirstPredatorInitialData,...
        getCombinedPredatorDensitiesInitialData,load,save,getParams,...
        solver,getLastRow,getPeriod)
      testCase.isPassedInFunctionCalled = true;
      testCase.passedInSolNo = solno;
      testCase.passedInTF = tf;
      testCase.passedInGetFilename = getFilename;
      testCase.passedInGetFileDir = getFileDir;
      testCase.passedInGetResultsFilepath = ...
        getResultsFilepath;
      testCase.passedInExists = exists;
      testCase.passedInGetZeroFirstPredatorInitialData = ...
        getZeroFirstPredatorInitialData;
      testCase.passedInGetCombinedPredatorDensitiesInitialData = ...
        getCombinedPredatorDensitiesInitialData;
      testCase.passedInLoad = load;
      testCase.passedInSave = save;
      testCase.passedInGetParams = getParams;
      testCase.passedInSolver = solver;
      testCase.passedInGetLastRow = getLastRow;
      testCase.passedInGetPeriod = getPeriod;
    end
  end
  
  methods (Test)
    function testPassesProperParamsToPassedInFunction(testCase)
      solno = 1;
      tf = 50;
      testCase.isPassedInFunctionCalled = false;
      doSolveAndSaveResults(solno,tf,@testCase.fakeFcnToPassIn);
      testCase.assertTrue(testCase.isPassedInFunctionCalled,...
        '������� doSolveAndSaveResultsCore() �� �������');
      testCase.verifyEqual(testCase.passedInSolNo,solno,...
        '������� ������������ ����� �������');
      testCase.verifyEqual(testCase.passedInTF,tf,...
        '������� ������������ �������� ������ ��������� �������������� �� �������');
      testCase.verifyEqual(testCase.passedInGetFilename,@mfilename,...
        '�������� ������������ ������� ��������� ����� �����');
      testCase.verifyEqual(testCase.passedInGetFileDir,@getFileDir,...
        '�������� ������������ ������� ��������� ���� � �����, ���������� ����');
      testCase.verifyEqual(testCase.passedInGetResultsFilepath,...
        @getResultsFilepath,...
        '�������� ������������ ������� ��������� ���� � ����� � �������������� ������������ �������');
      testCase.verifyEqual(testCase.passedInExists,@exist,...
        '�������� ������������ ������� �������� ������������� �����/����������');
      testCase.verifyEqual(...
        testCase.passedInGetZeroFirstPredatorInitialData,...
        @getZeroFirstPredatorInitialData,...
        '�������� ������������ ������� ��������� ��������� ������ � ������� ���������� ������ ��������� ��������');
      testCase.verifyEqual(...
        testCase.passedInGetCombinedPredatorDensitiesInitialData,...
        @getCombinedPredatorDensitiesInitialData,...
        '�������� ������������ ������� ��������� ��������� ������ � �������� ����������� ���������� ��������� ��������');
      testCase.verifyEqual(testCase.passedInLoad,@load,...
        '�������� ������������ ������� �������� ���������� �� �����');
      testCase.verifyEqual(testCase.passedInSave,@save,...
        '�������� ������������ ������� ���������� ���������� � ����');
      testCase.verifyEqual(testCase.passedInGetParams,...
        @predatorPrey2x1Params,'�������� ������������ ���������');
      testCase.verifyEqual(testCase.passedInSolver,@myode4,...
        '������� ������������ ��������');
      testCase.verifyEqual(testCase.passedInGetLastRow,@getLastRow,...
        '�������� ������������ ������� ��������� ��������� ������ �������');
      testCase.verifyEqual(testCase.passedInGetPeriod,@getPeriod,...
        '�������� ������������ ������� ���������� �������');
    end
  end
  
end

