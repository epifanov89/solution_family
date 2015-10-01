classdef DoFindAndSavePointWithMaxPredatorDensitiesTest < matlab.unittest.TestCase
  %DOFINDANDSAVEPOINTWITHMAXPREDATORDENSITIESTEST Summary of this class goes here
  %   Detailed explanation goes here
  
  properties
    isPassedInFunctionCalled
    passedInResultsFilename
    passedInSecondPredatorDiffusionCoeff
    passedInGetFilename
    passedInGetFileDir
    passedInGetDirpath
    passedInGetResultsFilepath
    passedInExists
    passedInLoad
    passedInSave
    passedInGetParams
    passedInFigure
    passedInSolver
    passedInPeriod
    passedInGetFirstPointWithExtremeVarValues
  end
  
  methods
    function fakeFcnToPassIn(testCase,resultsFilename,...
        secondPredatorDiffusionCoeff,getFilename,...
        getFileDir,getDirpath,getResultsFilepath,exists,load,save,...
        getParams,figure,solver,getFirstPointWithExtremeVarValues)
      testCase.isPassedInFunctionCalled = true;
      testCase.passedInResultsFilename = resultsFilename;
      testCase.passedInSecondPredatorDiffusionCoeff = secondPredatorDiffusionCoeff;
      testCase.passedInGetFilename = getFilename;
      testCase.passedInGetFileDir = getFileDir;
      testCase.passedInGetDirpath = getDirpath;
      testCase.passedInGetResultsFilepath = getResultsFilepath;
      testCase.passedInExists = exists;
      testCase.passedInLoad = load;
      testCase.passedInSave = save;
      testCase.passedInGetParams = getParams;
      testCase.passedInFigure = figure;
      testCase.passedInSolver = solver;
      testCase.passedInGetFirstPointWithExtremeVarValues = ...
        getFirstPointWithExtremeVarValues;
    end
  end
  
  methods (Test)
    function testPassesProperParamsToPassedInFunction(testCase)
      resultsFilename = 'results_filename';
      secondPredatorDiffusionCoeff = 0.2;
      testCase.isPassedInFunctionCalled = false;
      doFindAndSavePointWithMaxPredatorDensities(...
        @testCase.fakeFcnToPassIn,resultsFilename,...
        secondPredatorDiffusionCoeff);
      testCase.assertTrue(testCase.isPassedInFunctionCalled,...
        '���������� ������� �� �������');
      testCase.verifyEqual(testCase.passedInResultsFilename,resultsFilename,...
        '�������� ������������ ��� ����� �����������');
      testCase.verifyEqual(...
        testCase.passedInSecondPredatorDiffusionCoeff,...
        secondPredatorDiffusionCoeff,...
        '�������� ������������ �������� ������������ �������� ������ ��������� ��������');
      testCase.verifyEqual(testCase.passedInGetFilename,@mfilename,...
        '�������� ������������ ������� ��������� ����� �����');
      testCase.verifyEqual(testCase.passedInGetFileDir,@getFileDir,...
        '�������� ������������ ������� ��������� ���� � �����, ���������� ����');
      testCase.verifyEqual(testCase.passedInGetDirpath,@getDirpath,...
        '�������� ������������ ������� ��������� ���� � ����� � ������������');
      testCase.verifyEqual(...
        testCase.passedInGetResultsFilepath,...
        @getResultsFilepath,...
        '�������� ������������ ������� ��������� ���� � ����� �����������');
      testCase.verifyEqual(testCase.passedInExists,@exist,...
        '�������� ������������ ������� �������� ������������� �����/����������');      
      testCase.verifyEqual(testCase.passedInLoad,@load,...
        '�������� ������������ ������� �������� ���������� �� �����');
      testCase.verifyEqual(testCase.passedInSave,@saveStruct,...
        '�������� ������������ ������� ���������� ���������� � ����');
      testCase.verifyEqual(testCase.passedInGetParams,...
        @predatorPrey2x1Params,'�������� ������������ ���������');
      testCase.verifyEqual(testCase.passedInFigure,@figure,...
        '�������� ������������ ������� �������� ������ ����');
      testCase.verifyEqual(testCase.passedInSolver,@myode4,...
        '������� ������������ ��������');
      testCase.verifyEqual(...
        testCase.passedInGetFirstPointWithExtremeVarValues,...
        @getFirstPointWithExtremeVarValues,...
        '�������� ������������ ������� ���������� ������ ����� � �������������� ���������� ���������� � ����������� ���������');
    end
  end
  
end

