classdef DoSolveOneCoreTest < matlab.unittest.TestCase
  
  properties
    rightParts
    linearizedSystem
    resource
    nprey
    npredator
    tspan
    w0
    t
    w
    tpoincare
    wpoincare
    solutionResultsFilename
    preyDiffusionCoeff
    secondPredatorDiffusionCoeff
    firstPredatorMortality
    resourceDeviation
    N
    
    filename
    dir
    
    actRightParts
    actTSpan
    actW0
    actNonNegative
    actOutputFcn
    actOutputSel
    actRelTol
    actAbsTol
    actW
    
    paramPassedInToGetFilename
    paramPassedInToGetFileDir
    
    NPassedInToGetInitialDataArr
    
    existent
    createdDirArray
    varsToReturnFromLoad
    loadedVars
    savedVars
    
    isGetParamsCalled
    preyDiffusionCoeffPassedInToGetParams
    secondPredatorDiffusionCoeffPassedInToGetParams
    firstPredatorMortalityPassedInToGetParams
    resourceDeviationPassedInToGetParams
    NPassedInToGetParams
    
    isStopped
  end
  
  methods (TestMethodSetup)
    function setup(testCase)
      testCase.rightParts = @() {};
      testCase.linearizedSystem = @() {};
      testCase.resource = @() {};      
      testCase.nprey = 1;
      testCase.npredator = 2;
      testCase.N = 5;
      testCase.preyDiffusionCoeff = 0.2;
      testCase.secondPredatorDiffusionCoeff = 0.12;
      testCase.firstPredatorMortality = 1;
      testCase.resourceDeviation = 0.2;
      testCase.tspan = 0:0.002:50;
      testCase.w0 = [1 2 1 2 1 1 2 1 2 1 1 2 1 2 1];
      testCase.w = [2 3 2 3 2 2 3 2 3 2 2 3 2 3 2
                    4 5 4 5 4 4 5 4 5 4 4 5 4 5 4];
      testCase.t = [2 3]';
      
      testCase.NPassedInToGetInitialDataArr = [];
      
      testCase.varsToReturnFromLoad = struct;
      testCase.varsToReturnFromLoad.w = [2 3 2 3 2 2 3 2 3 2 2 3 2 3 2
                                         1 2 1 2 1 1 2 1 2 1 1 2 1 2 1];
      testCase.varsToReturnFromLoad.t = [0 1]';
      testCase.loadedVars = [];
      testCase.savedVars = [];
      testCase.createdDirArray = {};
    end
  end
  
  methods
    function [t,w,tpoincare,wpoincare] = fakeSolver(testCase,rightParts,...
        tspan,w0,options)
      testCase.actRightParts = rightParts;
      testCase.actTSpan = tspan;
      testCase.actW0 = w0;

      testCase.actNonNegative = odeget(options,'NonNegative');
      testCase.actOutputFcn = odeget(options,'OutputFcn');
      testCase.actOutputSel = odeget(options,'OutputSel');
      testCase.actRelTol = odeget(options,'RelTol');
      testCase.actAbsTol = odeget(options,'AbsTol');

      t = testCase.t;
      w = testCase.w;
      tpoincare = testCase.tpoincare;
      wpoincare = testCase.wpoincare;
    end

    function [ rightParts,linearizedSystem,resource,nprey,npredator ] = ...
        fakeParams(testCase,preyDiffusionCoeff,...
          secondPredatorDiffusionCoeff,firstPredatorMortality,...
          resourceDeviation,N)
      testCase.isGetParamsCalled = true;
      testCase.preyDiffusionCoeffPassedInToGetParams = preyDiffusionCoeff;
      testCase.secondPredatorDiffusionCoeffPassedInToGetParams = ...
        secondPredatorDiffusionCoeff;
      testCase.firstPredatorMortalityPassedInToGetParams = ...
        firstPredatorMortality;
      testCase.resourceDeviationPassedInToGetParams = ...
        resourceDeviation;
      testCase.NPassedInToGetParams = N;
      
      rightParts = testCase.rightParts;
      linearizedSystem = testCase.linearizedSystem;
      resource = testCase.resource;

      nprey = testCase.nprey;
      npredator = testCase.npredator;
    end
    
    function filename = fakeGetFilename(testCase,param)
      testCase.paramPassedInToGetFilename = param;
      filename = testCase.filename;
    end
    
    function dir = fakeGetFileDir(testCase,param)
      testCase.paramPassedInToGetFileDir = param;
      dir = testCase.dir;
    end
      
    function exists = fakeExist(testCase,name,kind)
      if ~isfield(testCase.existent,kind)
        exists = false;
      else
        exists = ~isempty(find(strcmp(testCase.existent.(kind),name),1));
      end
    end
    
    function w0 = fakeGetInitialData(testCase,N)
      testCase.NPassedInToGetInitialDataArr = ...
        [testCase.NPassedInToGetInitialDataArr,N];
      w0 = testCase.w0;
    end
    
    function S = fakeLoad(testCase,filename,varargin)
      sameFilenameLoadedVars = testCase.loadedVars(...
        arrayfun(@(l) strcmp(l.filename,filename),testCase.loadedVars));
      
      if isempty(sameFilenameLoadedVars)
        loaded = struct;
        loaded.filename = filename;
        loaded.vars = varargin;
        testCase.loadedVars = [testCase.loadedVars,loaded];
      else
        sameFilenameLoadedVars.vars = ...
          [sameFilenameLoadedVars.vars,varargin];
      end
      
      S = testCase.varsToReturnFromLoad;
    end
    
    function fakeSave(testCase,filename,varsToSave)
      sameFilenameSavedVars = testCase.savedVars(arrayfun(...
        @(s) strcmp(s.filename,filename),testCase.savedVars));
      if isempty(sameFilenameSavedVars)
        saved = struct;
        saved.filename = filename;
        saved.vars = varsToSave;
        testCase.savedVars = [testCase.savedVars,saved];
      else
        sameFilenameSavedVars.vars = [sameFilenameSavedVars.vars,...
          varsToSave];
      end
    end
    
    function fakeMakeDir(testCase,path)
      testCase.createdDirArray = [testCase.createdDirArray,path];
    end
    
    function act(testCase)
      testCase.isStopped = doSolveOneCore(...
        testCase.solutionResultsFilename,testCase.preyDiffusionCoeff,...
        testCase.secondPredatorDiffusionCoeff,...
        testCase.firstPredatorMortality,testCase.resourceDeviation,...
        testCase.N,testCase.tspan,@testCase.fakeGetInitialData,...
        @testCase.fakeGetFilename,@testCase.fakeGetFileDir,...
        @testCase.fakeExist,...
        @testCase.fakeLoad,@testCase.fakeMakeDir,@testCase.fakeSave,...
        @testCase.fakeParams,@testCase.fakeSolver);
    end
  end
  
  methods (Test)
    function testGetsFilename(testCase)
      testCase.act();
      testCase.verifyEqual(testCase.paramPassedInToGetFilename,...
        'fullpath','�� �������� ��� �����');
    end
    
    function testGetsFileDir(testCase)
      testCase.filename = 'filename';
      testCase.act();
      testCase.verifyEqual(testCase.paramPassedInToGetFileDir,...
        testCase.filename,'�� ������� ���� � ����� � ������');
    end
    
    function testGetsInitialDataIfFileDoesNotExist(testCase)
      testCase.existent = struct;
      testCase.existent.('file') = [];
      testCase.act();
      testCase.verifyFalse(isempty(find(...
        arrayfun(@(N) isequal(N,testCase.N),...
        testCase.NPassedInToGetInitialDataArr),1)),...
        '�� �������� ��������� ������');
    end
    
    function testDoesNotGetInitialDataIfFileExists(testCase)
      testCase.solutionResultsFilename = 'results.mat';
      testCase.existent = struct;
      testCase.existent.('file') = 'solution_results\results.mat';
      testCase.act();
      testCase.verifyTrue(...
        isempty(testCase.NPassedInToGetInitialDataArr),...
        '�������� ��������� ������ ��� ������� �� ������������, ���� ��� ���� ����������� �������'); 
    end
    
    function testLoadsSolutionIfFileExists(testCase)
      testCase.dir = 'dir\';
      testCase.solutionResultsFilename = 'results.mat';
      testCase.existent = struct;
      testCase.existent.('file') = 'dir\solution_results\results.mat';
      testCase.act();
      loaded = struct;
      loaded.filename = 'dir\solution_results\results.mat';
      loaded.vars = {'t','w'};
      testCase.verifyFalse(isempty(find(arrayfun(...
        @(l) isequal(l,...
        loaded),testCase.loadedVars),1)),'�� ��������� �������');
    end
    
    function testDoesNotAttemptToLoadSolutionIfFileDoesNotExist(testCase)
      testCase.dir = 'dir\';
      testCase.solutionResultsFilename = 'results.mat';
      testCase.existent = struct;
      testCase.existent.('file') = [];
      testCase.act();
      testCase.verifyFalse(isfield(testCase.loadedVars,...
        'dir\solution_results\results.mat'),...
        '������� �������� �� ��������������� �����');
    end
    
    function testGetsParams(testCase)
      testCase.isGetParamsCalled = false;
      testCase.act();
      testCase.assertTrue(testCase.isGetParamsCalled,...
        '�� �������� ���������');
      testCase.verifyEqual(...
        testCase.preyDiffusionCoeffPassedInToGetParams,...
        testCase.preyDiffusionCoeff,...
        '� ������� ��������� ������� ������� ������������ ����������� �������� ������');
      testCase.verifyEqual(...
        testCase.secondPredatorDiffusionCoeffPassedInToGetParams,...
        testCase.secondPredatorDiffusionCoeff,...
        '� ������� ��������� ������� ������� ������������ ����������� �������� ������� �������');
      testCase.verifyEqual(...
        testCase.firstPredatorMortalityPassedInToGetParams,...
        testCase.firstPredatorMortality,...
        '� ������� ��������� ������� ������� ������������ ����������� ���������� ������� �������');
      testCase.verifyEqual(...
        testCase.resourceDeviationPassedInToGetParams,...
        testCase.resourceDeviation,...
        '� ������� ��������� ������� �������� ������������ ���������� ������� �������');
      testCase.verifyEqual(testCase.NPassedInToGetParams,testCase.N,...
        '� ������� ��������� ������� �������� ������������ ����� ����� �����');
    end
    
    function testSolvesSystem(testCase)      
      testCase.w0 = [1 2 1 2 1 0 1 0 0 0 0 1 0 0 0];
      testCase.act();
      
      testCase.verifyEqual(testCase.actRightParts,testCase.rightParts,...
        '�������� ������������ ������ ����� �������');
      testCase.verifyEqual(testCase.actTSpan,...
        testCase.tspan,...
        '������� ������������ ��������� �������� ��������������');
      testCase.verifyEqual(testCase.actW0,...
        testCase.w0,...
        '�������� ������������ ��������� ������');
      
      nspecies = testCase.nprey+testCase.npredator;
      nvar = testCase.N*nspecies;
      nonNegative = 1:nvar;
      testCase.verifyEqual(testCase.actNonNegative,nonNegative,...
        '�������� ������������ ������� ��������������� ����������'); 
      
      testCase.verifyEqual(testCase.actRelTol,1e-6,...
        '�������� ������������ ������������� ��������� ����������');
      testCase.verifyEqual(testCase.actAbsTol,1e-9,...
        '�������� ������������ ���������� ��������� ����������');
    end
    
    function testOutputsPhasePortrait(testCase)
      testCase.act();
      testCase.verifyEqual(testCase.actOutputFcn,@odephas2,...
        '� ���� ������� �� �������� ������� �������');
    end
    
    function testOutputsRightFirstVarForNEqualTo5(testCase)
      testCase.N = 5;
      testCase.act();
      expFirstOutputVarIndex = 3;
      testCase.verifyEqual(testCase.actOutputSel(1),...
        expFirstOutputVarIndex,...
        '������� ������������ ������ ������ ��������� ����������');
    end
    
    function testOutputsRightSecondVarForNEqualTo5WhenSolutionResultsFileDoesNotExist(testCase)
      testCase.existent = struct;
      testCase.existent.('file') = [];
      testCase.N = 5;
      
      testCase.w0 = [1 2 1 2 1 0 1 0 0 0 0 1 0 0 0];
      testCase.act();
      expSecondOutputVarIndex = [8 13];
      testCase.assertFalse(isempty(find(expSecondOutputVarIndex,...
        testCase.actOutputSel(2))),...
        '������� ������������ ������ ������ ��������� ����������');
      
      testCase.w0 = [1 2 1 2 1 0 1 0 0 0 0 0 0 0 0];
      testCase.act();
      expSecondOutputVarIndex = 8;
      testCase.assertEqual(testCase.actOutputSel(2),...
        expSecondOutputVarIndex,...
        '������� ������������ ������ ������ ��������� ����������, ����� ��������� ������ ��������� �������� ����� ����');
      
      testCase.w0 = [1 2 1 2 1 0 0 0 0 0 0 1 0 0 0];
      testCase.act();
      expSecondOutputVarIndex = 13;
      testCase.verifyEqual(testCase.actOutputSel(2),...
        expSecondOutputVarIndex,...
        '������� ������������ ������ ������ ��������� ����������, ����� ��������� ������ ��������� �������� ����� ����');
    end
        
    function testOutputsRightFirstVarForNEqualTo6(testCase)
      testCase.N = 6;
      testCase.act();
      expFirstOutputVarIndex = 4;
      testCase.verifyEqual(testCase.actOutputSel(1),...
        expFirstOutputVarIndex,...
        '������� ������������ ������ ������ ��������� ����������');
    end
    
    function testOutputsRightSecondVarForNEqualTo6WhenSolutionResultsFileDoesNotExist(testCase)
      testCase.existent = struct;
      testCase.existent.('file') = [];
      testCase.N = 6;
      
      testCase.w0 = [1 2 1 2 1 2 0 1 0 0 0 0 0 0 1 0 0 0];
      testCase.act();
      expSecondOutputVarIndex = [10 16];
      testCase.assertFalse(isempty(find(expSecondOutputVarIndex,...
        testCase.actOutputSel(2))),...
        '������� ������������ ������ ������ ��������� ����������');
      
      testCase.w0 = [1 2 1 2 1 2 0 1 0 0 0 0 0 0 0 0 0 0];
      testCase.act();
      expSecondOutputVarIndex = 10;
      testCase.assertEqual(testCase.actOutputSel(2),...
        expSecondOutputVarIndex,...
        '������� ������������ ������ ������ ��������� ����������, ����� ��������� ������ ��������� �������� ����� ����');
      
      testCase.w0 = [1 2 1 2 1 2 0 0 0 0 0 0 0 1 0 0 0 0];
      testCase.act();
      expSecondOutputVarIndex = 16;
      testCase.verifyEqual(testCase.actOutputSel(2),...
        expSecondOutputVarIndex,...
        '������� ������������ ������ ������ ��������� ����������, ����� ��������� ������ ��������� �������� ����� ����');
    end
    
    function testOutputsRightSecondVarForNEqualTo5WhenSolutionResultsFileExists(testCase)
      testCase.solutionResultsFilename = 'results.mat';
      testCase.existent = struct;
      testCase.existent.('file') = 'solution_results\results.mat';
      testCase.N = 5;
      
      testCase.varsToReturnFromLoad.w = [2 3 2 3 2 2 3 2 3 2 2 3 2 3 2
                                         1 2 1 2 1 0 1 0 0 0 0 1 0 0 0];
      testCase.act();
      expSecondOutputVarIndex = [8 13];
      testCase.verifyFalse(isempty(find(expSecondOutputVarIndex,...
        testCase.actOutputSel(2))),...
        '������� ������������ ������ ������ ��������� ����������');
      
      testCase.varsToReturnFromLoad.w = [2 3 2 3 2 2 3 2 3 2 2 3 2 3 2
                                         1 2 1 2 1 0 1 0 0 0 0 0 0 0 0];
      testCase.act();
      expSecondOutputVarIndex = 8;
      testCase.verifyEqual(testCase.actOutputSel(2),...
        expSecondOutputVarIndex,...
        '������� ������������ ������ ������ ��������� ����������, ����� ��������� ������ ��������� �������� ����� ����');
      
      testCase.varsToReturnFromLoad.w = [2 3 2 3 2 2 3 2 3 2 2 3 2 3 2
                                         1 2 1 2 1 0 0 0 0 0 0 1 0 0 0];
      testCase.act();
      expSecondOutputVarIndex = 13;
      testCase.verifyEqual(testCase.actOutputSel(2),...
        expSecondOutputVarIndex,...
        '������� ������������ ������ ������ ��������� ����������, ����� ��������� ������ ��������� �������� ����� ����');
    end
    
    function testOutputsRightSecondVarForNEqualTo6WhenSolutionResultsFileExists(testCase)
      testCase.solutionResultsFilename = 'results.mat';
      testCase.existent = struct;
      testCase.existent.('file') = 'solution_results\results.mat';
      testCase.N = 6;
      testCase.w = [];
                  
      testCase.varsToReturnFromLoad.w = [2 3 2 3 2 3 2 3 2 3 2 3 2 3 2 3 2 3
                                         1 2 1 2 1 2 0 1 0 0 0 0 0 1 0 0 0 0];      
      testCase.act();
      expSecondOutputVarIndex = [10 16];
      testCase.verifyFalse(isempty(find(expSecondOutputVarIndex,...
        testCase.actOutputSel(2))),...
        '������� ������������ ������ ������ ��������� ����������');
      
      testCase.varsToReturnFromLoad.w = [2 3 2 3 2 3 2 3 2 3 2 3 2 3 2 3 2 3
                                         1 2 1 2 1 2 0 1 0 0 0 0 0 0 0 0 0 0];
      testCase.act();
      expSecondOutputVarIndex = 10;
      testCase.verifyEqual(testCase.actOutputSel(2),...
        expSecondOutputVarIndex,...
        '������� ������������ ������ ������ ��������� ����������, ����� ��������� ������ ��������� �������� ����� ����');
      
      testCase.varsToReturnFromLoad.w = [2 3 2 3 2 3 2 3 2 3 2 3 2 3 2 3 2 3
                                         1 2 1 2 1 2 0 0 0 0 0 0 0 1 0 0 0 0];
      testCase.act();
      expSecondOutputVarIndex = 16;
      testCase.verifyEqual(testCase.actOutputSel(2),...
        expSecondOutputVarIndex,...
        '������� ������������ ������ ������ ��������� ����������, ����� ��������� ������ ��������� �������� ����� ����');
    end    
    
    function testCreatesSolutionResultsDirIfItHasNotExistedYet(testCase)
      testCase.dir = 'dir\';
      testCase.existent = struct;
      testCase.existent.('dir') = [];
      testCase.act();
      testCase.verifyFalse(isempty(find(strcmp(...
        testCase.createdDirArray,...
        'dir\solution_results\'),1)),...
        '�� ������� ����� � �������������� ������������ �������');
    end
    
    function testDoesNotAttemptToCreateSolutionResultsDirIfItHasExistAlready(testCase)
      testCase.dir = 'dir\';
      testCase.existent = struct;
      testCase.existent.('dir') = 'dir\solution_results\';
      testCase.act();
      testCase.verifyTrue(isempty(find(strcmp(...
        testCase.createdDirArray,...
        'dir\solution_results\'),1)),...
        '������� ������� ��� ������������ ����� � �������������� ������������ �������');
    end
    
    function testSavesSolution(testCase)
      testCase.dir = 'dir\';
      testCase.solutionResultsFilename = 'results.mat';
      testCase.existent = struct;
      testCase.existent.('file') = 'dir\solution_results\results.mat';
      testCase.act();
      saved = struct;
      saved.filename = 'dir\solution_results\results.mat';
      vars = struct;
      vars.w = [testCase.varsToReturnFromLoad.w;testCase.w];
      vars.t = [0 1 2 3]';
      saved.vars = vars;
      testCase.verifyFalse(isempty(find(arrayfun(...
        @(s) isequal(s,saved),testCase.savedVars),1)),...
        '�� ��������� �������');
    end
    
    function testReturnsIsStoppedIfDidNotReachTFinish(testCase)
      testCase.act();
      testCase.verifyTrue(testCase.isStopped,...
        '�� ����������, ��� ������� ������� ��� �������, ����� �� ��������� �������� ������ ������� ��������������');
    end
    
    function testReturnsIsNotStoppedIfReachedTFinish(testCase)
      testCase.t = [2 50]';
      testCase.act();
      testCase.verifyFalse(testCase.isStopped,...
        '����������, ��� ������� ������� ��� �������, ���� �������� ������ ������� �������������� ���������');
    end
  end
  
end

