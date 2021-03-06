classdef DoCalculateMultipliersTest < IsPassedInFunctionCalledTestHelper
  
  properties
    passedInResultsFilename
    passedInPreyDiffusionCoeff
    passedInSecondPredatorDiffusionCoeff
    passedInFirstPredatorMortality
    passedInResourceDeviation
    passedInMFilename
    passedInGetFileDirname
    passedInExists
    passedInLoad
    passedInMakeDir
    passedInSave
    passedInGetPoincareMapLastPoint
    passedInGetPeriod
    passedInGetParams
    passedInCalculateMultipliers
    passedInSolver
    passedInPrint
    passedInDisplay
  end
  
  methods (TestMethodSetup)
    function setup(testCase)
      setup@IsPassedInFunctionCalledTestHelper(testCase);
    end
  end
  
  methods (Access = protected)
    function fakeFcnToPassIn(testCase,resultsFilename,...
        preyDiffusionCoeff,secondPredatorDiffusionCoeff,...
        firstPredatorMortality,resourceDeviation,mfilename,...
        getFileDirname,exists,load,makeDir,save,getPoincareMapLastPoint,...
        getPeriod,getParams,calculateMultipliers,solver,print,disp)
      fakeFcnToPassIn@IsPassedInFunctionCalledTestHelper(testCase);
      testCase.passedInResultsFilename = resultsFilename;
      testCase.passedInPreyDiffusionCoeff = preyDiffusionCoeff;      
      testCase.passedInSecondPredatorDiffusionCoeff = ...
        secondPredatorDiffusionCoeff;
      testCase.passedInFirstPredatorMortality = firstPredatorMortality;
      testCase.passedInResourceDeviation = resourceDeviation;
      testCase.passedInMFilename = mfilename;      
      testCase.passedInGetFileDirname = getFileDirname;
      testCase.passedInExists = exists;
      testCase.passedInLoad = load;
      testCase.passedInMakeDir = makeDir;
      testCase.passedInSave = save;
      testCase.passedInGetPoincareMapLastPoint = getPoincareMapLastPoint;
      testCase.passedInGetPeriod = getPeriod;
      testCase.passedInGetParams = getParams;
      testCase.passedInCalculateMultipliers = calculateMultipliers;
      testCase.passedInSolver = solver;
      testCase.passedInPrint = print;
      testCase.passedInDisplay = disp;
    end
  end
  
  methods (Test)
    function testPassesProperParamsToPassedInFunctionCore(testCase)
      resultsFilename = 'results_filename';
      preyDiffusionCoeff = 0;
      secondPredatorDiffusionCoeff = 1;
      firstPredatorMortality = 2;
      resourceDeviation = 3;
      solver = @() {};
      doCalculateMultipliers(@testCase.fakeFcnToPassIn,resultsFilename,...
        preyDiffusionCoeff,secondPredatorDiffusionCoeff,...
        firstPredatorMortality,resourceDeviation,solver);
      testCase.assertPassedInFunctionCalled();
      testCase.verifyEqual(testCase.passedInResultsFilename,...
        resultsFilename,'�������� ������������ ��� ������ � ������������');
      testCase.verifyEqual(testCase.passedInPreyDiffusionCoeff,...
        preyDiffusionCoeff,...
        '�������� ������������ �������� ������������ �������� ��������� ������');
      testCase.verifyEqual(testCase.passedInFirstPredatorMortality,...
        firstPredatorMortality,...
        '�������� ������������ �������� ��������� ���������� ������ ��������� �������');
      testCase.verifyEqual(testCase.passedInResourceDeviation,...
        resourceDeviation,...
        '�������� ������������ ��������� ������� �������');
      testCase.verifyEqual(...
        testCase.passedInSecondPredatorDiffusionCoeff,...
        secondPredatorDiffusionCoeff,...
        '�������� ������������ �������� ������������ �������� ������ ��������� �������');
      testCase.verifyEqual(testCase.passedInMFilename,@mfilename,...
        '�������� ������������ ������� ��������� ����� ����� � �����');
      testCase.verifyEqual(testCase.passedInGetFileDirname,...
        @getFileDirname,...
        '�������� ������������ ������� ��������� ����� ����� �����');
      testCase.verifyEqual(testCase.passedInExists,@exist,...
        '�������� ������������ ������� �������� ������������� �����/����������');
      testCase.verifyEqual(testCase.passedInLoad,@load,...
        '�������� ������������ ������� �������� ���������� �� �����');
      testCase.verifyEqual(testCase.passedInMakeDir,@mkdir,...
        '�������� ������������ ������� �������� �����');
      testCase.verifyEqual(testCase.passedInSave,@saveStruct,...
        '�������� ������������ ������� ���������� ���������� � ����');
      testCase.verifyEqual(testCase.passedInGetPoincareMapLastPoint,...
        @getPoincareMapLastPoint,...
        '�������� ������������ ������� ��������� �������� ����� ����������� ��������');
      testCase.verifyEqual(testCase.passedInGetPeriod,@getPeriod,...
        '�������� ������������ ������� ���������� �������');
      testCase.verifyEqual(testCase.passedInGetParams,...
        @predatorPrey2x1Params,'�������� ������������ ���������');
      testCase.verifyEqual(testCase.passedInCalculateMultipliers,...
        @multipliers_one_system_for_each_monodromy_matrix_column,...
        '�������� ������������ ������� ������� ����������������');
      testCase.verifyEqual(testCase.passedInSolver,solver,...
        '������� ������������ ��������');
      testCase.verifyEqual(testCase.passedInPrint,@fprintf,...
        '�������� ������������ ������� ������');
      testCase.verifyEqual(testCase.passedInDisplay,@disp,...
        '�������� ������������ ������� ������');
    end
  end
  
end

