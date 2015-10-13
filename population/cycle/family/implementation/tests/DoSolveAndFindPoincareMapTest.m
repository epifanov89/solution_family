classdef DoSolveAndFindPoincareMapTest < matlab.unittest.TestCase
  
  properties
    passedInSolutionResultsFilename
    passedInPreyDiffusionCoeff
    passedInSecondPredatorDiffusionCoeff
    passedInResourceDeviation
    passedInN
    passedInTF
    passedInGetInitialData
    passedInCurrentDirName
    passedInExists    
    passedInLoad
    passedInMakeDir
    passedInSave
    passedInGetParams
    passedInSolver
  end
  
  methods
    function fakeFcnToPassIn(testCase,solutionResultsFilename,...
        preyDiffusionCoeff,secondPredatorDiffusionCoeff,...
        resourceDeviation,N,tf,getInitialData,currentDirName,exists,...
        load,makeDir,save,getParams,solver)
      testCase.passedInSolutionResultsFilename = solutionResultsFilename;
      testCase.passedInPreyDiffusionCoeff = preyDiffusionCoeff;
      testCase.passedInSecondPredatorDiffusionCoeff = ...
        secondPredatorDiffusionCoeff;      
      testCase.passedInResourceDeviation = resourceDeviation;
      testCase.passedInN = N;
      testCase.passedInTF = tf;
      testCase.passedInGetInitialData = getInitialData;
      testCase.passedInCurrentDirName = currentDirName;
      testCase.passedInExists = exists;      
      testCase.passedInLoad = load;
      testCase.passedInMakeDir = makeDir;
      testCase.passedInSave = save;
      testCase.passedInGetParams = getParams;
      testCase.passedInSolver = solver;
    end
  end
  
  methods (Test)
    function testPassesProperParamsToPassedInFunction(testCase)
      solutionResultsFilename = 'solution_results_filename';
      preyDiffusionCoeff = 0.2;
      secondPredatorDiffusionCoeff = 0.24;
      resourceDeviation = 0.2;
      N = 24;
      tf = 50;
      getInitialData = @() {};
      doSolveAndFindPoincareMap(@testCase.fakeFcnToPassIn,...
        solutionResultsFilename,preyDiffusionCoeff,...
        secondPredatorDiffusionCoeff,resourceDeviation,N,tf,...
        getInitialData);
      testCase.verifyEqual(testCase.passedInSolutionResultsFilename,...
        solutionResultsFilename,...
        '�������� ������������ ��� ����� ����������� �������');
      testCase.verifyEqual(testCase.passedInPreyDiffusionCoeff,...
        preyDiffusionCoeff,...
        '�������� ������������ �������� ������������ �������� ������');
      testCase.verifyEqual(...
        testCase.passedInSecondPredatorDiffusionCoeff,...
        secondPredatorDiffusionCoeff,...
        '�������� ������������ �������� ������������ �������� ������� �������');
      testCase.verifyEqual(testCase.passedInResourceDeviation,...
        resourceDeviation,...
        '�������� ������������ ��������� ������� �������');
      testCase.verifyEqual(testCase.passedInN,N,...
        '�������� ������������ ����� ����� �����');
      testCase.verifyEqual(testCase.passedInTF,tf,...
        '������� ������������ �������� ������ ��������� �������������� �� �������');
      testCase.verifyEqual(...
        testCase.passedInGetInitialData,...
        getInitialData,...
        '�������� ������������ ������� ��������� ��������� ������ ��� ������� �� ������������');
      testCase.verifyEqual(testCase.passedInCurrentDirName,@currentDirName,...
        '�������� ������������ ������� ��������� ����� ������� �����');
      testCase.verifyEqual(testCase.passedInExists,@exist,...
        '�������� ������������ ������� �������� ������������� �����/����������');      
      testCase.verifyEqual(testCase.passedInLoad,@load,...
        '�������� ������������ ������� �������� ���������� �� �����');
      testCase.verifyEqual(testCase.passedInMakeDir,@mkdir,...
        '�������� ������������ ������� �������� �����');
      testCase.verifyEqual(testCase.passedInSave,@saveStruct,...
        '�������� ������������ ������� ���������� ���������� � ����');
      testCase.verifyEqual(testCase.passedInGetParams,...
        @predatorPrey2x1Params,'�������� ������������ ���������');
      testCase.verifyEqual(testCase.passedInSolver,@myode4,...
        '������� ������������ ��������');
    end
  end
  
end

