classdef DoCalculateMultipliersAndSolveOnPeriodTest < matlab.unittest.TestCase
  %DOCALCULATEMULTIPLIERSANDSOLVEONPERIODTEST Summary of this class goes here
  %   Detailed explanation goes here
  
  properties
    isPassedInFunctionCalled
    passedInSolNo
    passedInGetFilename
    passedInGetFileDir
    passedInGetResultsFilepathForMFile
    passedInGetResultsFilepath
    passedInExists
    passedInLoad
    passedInSave
    passedInGetParams
    passedInCalculateMultipliers
    passedInSolver    
    passedInFigure
    passedInPrint
    passedInDisplay
  end
  
  methods
    function fakeFcnToPassIn(testCase,solno,getFilename,...
        getFileDir,getResultsFilepathForMFile,getResultsFilepath,exists,...
        load,save,getParams,calculateMultipliers,solver,fig,print,disp)
      testCase.isPassedInFunctionCalled = true;
      testCase.passedInSolNo = solno;
      testCase.passedInGetFilename = getFilename;
      testCase.passedInGetFileDir = getFileDir;
      testCase.passedInGetResultsFilepathForMFile = ...
        getResultsFilepathForMFile;
      testCase.passedInGetResultsFilepath = getResultsFilepath;    
      testCase.passedInExists = exists;
      testCase.passedInLoad = load;
      testCase.passedInSave = save;
      testCase.passedInGetParams = getParams;
      testCase.passedInCalculateMultipliers = calculateMultipliers;
      testCase.passedInSolver = solver;
      testCase.passedInFigure = fig;
      testCase.passedInPrint = print;
      testCase.passedInDisplay = disp;
    end
  end
  
  methods (Test)
    function testPassesProperParamsToPassedInFunctionCore(testCase)
      solno = 1;
      testCase.isPassedInFunctionCalled = false;
      doCalculateMultipliersAndSolveOnPeriod(solno,...
        @testCase.fakeFcnToPassIn);
      testCase.assertTrue(testCase.isPassedInFunctionCalled,...
        '���������� ������� �� �������');
      testCase.verifyEqual(testCase.passedInSolNo,solno,...
        '������� ������������ ����� �������');
      testCase.verifyEqual(testCase.passedInGetFilename,@mfilename,...
        '�������� ������������ ������� ��������� ����� �����');
      testCase.verifyEqual(testCase.passedInGetFileDir,@getFileDir,...
        '�������� ������������ ������� ��������� ���� � �����, ���������� ����');
      testCase.verifyEqual(...
        testCase.passedInGetResultsFilepathForMFile,...
        @getResultsFilepathForMFile,...
        '�������� ������������ ������� ��������� ���� � ����� ����������� ��� �������� ����� � �����');      
      testCase.verifyEqual(testCase.passedInGetResultsFilepath,...
        @getResultsFilepath,...
        '�������� ������������ ������� ��������� ���� � ����� �����������');
      testCase.verifyEqual(testCase.passedInExists,@exist,...
        '�������� ������������ ������� �������� ������������� �����/����������');
      testCase.verifyEqual(testCase.passedInLoad,@load,...
        '�������� ������������ ������� �������� ���������� �� �����');
      testCase.verifyEqual(testCase.passedInSave,@save,...
        '�������� ������������ ������� ���������� ���������� � ����');
      testCase.verifyEqual(testCase.passedInGetParams,...
        @predatorPrey2x1Params,'�������� ������������ ���������');
      testCase.verifyEqual(testCase.passedInCalculateMultipliers,...
        @multipliers_one_system_for_each_monodromy_matrix_column,...
        '�������� ������������ ������� ������� ����������������');
      testCase.verifyEqual(testCase.passedInSolver,@myode4,...
        '������� ������������ ��������');
      testCase.verifyEqual(testCase.passedInFigure,@figure,...
        '�������� ������������ ������� ������� ������ ����');
      testCase.verifyEqual(testCase.passedInPrint,@fprintf,...
        '�������� ������������ ������� ������');
      testCase.verifyEqual(testCase.passedInDisplay,@display,...
        '�������� ������������ ������� ������');
    end
  end
  
end

