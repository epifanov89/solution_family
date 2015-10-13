classdef DoSolveTillSteadyCoreTest < matlab.unittest.TestCase
  
  properties
    rightParts
    linearizedSystem
    resource
    nprey
    npredator
    X
    tstep
    tf
    w0    
    w
    solno
    tpoincare
    minpreypt
    
    filename
    dir
    
    basepathPassedInToGetDirpathArr
    dirnamePassedInToGetDirpathArr
    intermediateSolutionsDirpath
    finalSolutionsDirpath
    dirpathArr
    getDirpathCallNo
    
    dirPassedInToGetResultsFilepathArr
    filenamePassedInToGetResultsFilepathArr
    intermediateSolutionFilepath
    finalSolutionFilepath
    resultsFilepathArr
    getResultsFilepathCallNo
    
    isSolverCalled
    actRightParts
    actTSpan
    actW0
    actNonNegative
    actOutputFcn
    actOutputSel
    actFixedVarIndex
    actFixedVarValue
    actW
    
    paramPassedInToGetFilename
    paramPassedInToGetFileDir
    
    isGetInitialDataToSolveTillSteadyCalled
    solNoPassedInToGetInitialDataToSolveTillSteady
    nSpatialStepsPassedInToGetInitialDataToSolveTillSteady
    spatialStepSizePassedInToGetInitialDataToSolveTillSteady
    
    existent
    createdDirArray
    loadedVars
    savedVars
    
    isGetParamsCalled
    paramPassedInToGetLastRow
    paramPassedInToGetPeriod
    
    isGetPointWithExtremeVarValuesCalled
    solutionPassedInToGetPointWithExtremeVarValues
    varIndicesPassedInToGetPointWithExtremeVarValues
    kindPassedInToGetPointWithExtremeVarValues
  end
  
  methods (TestMethodSetup)
    function setup(testCase)
      testCase.solno = 1;      
      testCase.rightParts = @() {};
      testCase.linearizedSystem = @() {};
      testCase.resource = @() {};      
      testCase.nprey = 1;
      testCase.npredator = 2;
      testCase.X = [0 0.2 0.4 0.6 0.8];
      testCase.tstep = 0.002;
      testCase.tf = 50;
      testCase.w0 = [1 2 1 2 1];
      testCase.w = [1 2 1 2 1];
      testCase.minpreypt = [1 2 1 2 1];
      testCase.loadedVars = struct;
      testCase.savedVars = struct;
      testCase.createdDirArray = {};
      testCase.basepathPassedInToGetDirpathArr = {};
      testCase.dirnamePassedInToGetDirpathArr = {};
      testCase.intermediateSolutionsDirpath = ...
        'intermediate_solutions_dirpath';
      testCase.finalSolutionsDirpath = 'final_solutions_dirpath';
      testCase.dirpathArr = {testCase.intermediateSolutionsDirpath,...
                             testCase.finalSolutionsDirpath};
      testCase.getDirpathCallNo = 1;
      testCase.dirPassedInToGetResultsFilepathArr = {};
      testCase.filenamePassedInToGetResultsFilepathArr = {};
      testCase.intermediateSolutionFilepath = ...
        'intermediate_solution_filepath';
      testCase.finalSolutionFilepath = 'final_solution_filepath';
      testCase.resultsFilepathArr = {testCase.intermediateSolutionFilepath,...
                                     testCase.finalSolutionFilepath};
      testCase.getResultsFilepathCallNo = 1;
    end
  end
  
  methods
    function [t,w,tpoincare,wpoincare] = fakeSolver(testCase,rightParts,...
        tspan,w0,options,fixedVarIndex,fixedVarValue)
      testCase.isSolverCalled = true;
      
      testCase.actRightParts = rightParts;
      testCase.actTSpan = tspan;
      testCase.actW0 = w0;

      testCase.actNonNegative = odeget(options,'NonNegative');
      testCase.actOutputFcn = odeget(options,'OutputFcn');
      testCase.actOutputSel = odeget(options,'OutputSel');

      testCase.actFixedVarIndex = fixedVarIndex;
      testCase.actFixedVarValue = fixedVarValue;

      t = [];
      w = testCase.w;
      tpoincare = testCase.tpoincare;
      wpoincare = [];
    end

    function [ rightParts,linearizedSystem,resource,nprey,npredator,X,tstep ] = ...
        fakeParams(testCase)
      testCase.isGetParamsCalled = true;
      
      rightParts = testCase.rightParts;
      linearizedSystem = testCase.linearizedSystem;
      resource = testCase.resource;

      nprey = testCase.nprey;
      npredator = testCase.npredator;

      X = testCase.X;      
      tstep = testCase.tstep;
    end
    
    function filename = fakeGetFilename(testCase,param)
      testCase.paramPassedInToGetFilename = param;
      filename = testCase.filename;
    end
    
    function dir = fakeGetFileDir(testCase,param)
      testCase.paramPassedInToGetFileDir = param;
      dir = testCase.dir;
    end
    
    function dirpath = fakeGetDirpath(testCase,basepath,dirname)
      testCase.basepathPassedInToGetDirpathArr = ...
        [testCase.basepathPassedInToGetDirpathArr,basepath];
      testCase.dirnamePassedInToGetDirpathArr = ...
        [testCase.dirnamePassedInToGetDirpathArr,dirname];
      dirpath = testCase.dirpathArr{testCase.getDirpathCallNo};
      testCase.getDirpathCallNo = testCase.getDirpathCallNo+1;
    end
    
    function filepath = fakeGetResultsFilepath(testCase,...
        dir,filename)
      testCase.dirPassedInToGetResultsFilepathArr = ...
        [testCase.dirPassedInToGetResultsFilepathArr,dir];
      testCase.filenamePassedInToGetResultsFilepathArr = ...
        [testCase.filenamePassedInToGetResultsFilepathArr,filename];
      filepath = ...
        testCase.resultsFilepathArr{testCase.getResultsFilepathCallNo};
      testCase.getResultsFilepathCallNo = ...
        testCase.getResultsFilepathCallNo+1;
    end
    
    function exists = fakeExist(testCase,name,~)
      exists = ~isempty(find(strcmp(testCase.existent,name),1));
    end
    
    function w0 = fakeGetInitialDataToSolveTillSteady(testCase,solno,N,h)
      testCase.isGetInitialDataToSolveTillSteadyCalled = true;
      testCase.solNoPassedInToGetInitialDataToSolveTillSteady = solno;
      testCase.nSpatialStepsPassedInToGetInitialDataToSolveTillSteady = N;
      testCase.spatialStepSizePassedInToGetInitialDataToSolveTillSteady = h;
      w0 = testCase.w0;
    end

    function S = fakeLoad(testCase,filename,varargin)
      if ~isfield(testCase.loadedVars,filename)
        testCase.loadedVars.(filename) = varargin;
      else
        testCase.loadedVars.(filename) = ...
          [testCase.loadedVars.(filename),varargin];
      end
      S = struct;
      S.w0 = testCase.w0;
    end
    
    function fakeSave(testCase,filename,varargin)
      if ~isfield(testCase.savedVars,filename)
        testCase.savedVars.(filename) = varargin;
      else
        testCase.savedVars.(filename) = [testCase.savedVars.(filename),...
          varargin];
      end
    end
    
    function fakeMakeDir(testCase,path)
      testCase.createdDirArray = [testCase.createdDirArray,path];
    end
    
    function wtillmaxpredatordensities = ...
        fakeGetSolutionTillMaxPredatorDensities(testCase,w)
      testCase.actW = w;
      wtillmaxpredatordensities = w;
    end
    
    function lastRow = fakeGetLastRow(testCase,sol)
      testCase.paramPassedInToGetLastRow = sol;
      lastRow = sol(end,:);
    end
    
    function T = fakeGetPeriod(testCase,tpoincare)
      testCase.paramPassedInToGetPeriod = tpoincare;
      T = 0;
    end
    
    function pt = fakeGetPointWithExtremeVarValues(testCase,sol,...
        varIndices,kind)
      testCase.isGetPointWithExtremeVarValuesCalled = true;
      testCase.solutionPassedInToGetPointWithExtremeVarValues = sol;
      testCase.varIndicesPassedInToGetPointWithExtremeVarValues = ...
        varIndices;
      testCase.kindPassedInToGetPointWithExtremeVarValues = kind;
      
      pt = testCase.minpreypt;
    end
    
    function act(testCase)
      doSolveTillSteadyCore(testCase.solno,testCase.tf,...
        @testCase.fakeGetFilename,@testCase.fakeGetFileDir,...
        @testCase.fakeExist,...
        @testCase.fakeGetInitialDataToSolveTillSteady,...
        @testCase.fakeLoad,@testCase.fakeMakeDir,@testCase.fakeSave,...
        @testCase.fakeParams,@testCase.fakeSolver,...
        @testCase.fakeGetPointWithExtremeVarValues,...
        @testCase.fakeGetLastRow,@testCase.fakeGetPeriod,...        
        @testCase.fakeGetDirpath,@testCase.fakeGetResultsFilepath,...
        @testCase.fakeGetSolutionTillMaxPredatorDensities);
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
    
    function testGetsDirpathes(testCase)
      testCase.existent = [];
      testCase.dir = 'dir\';
      testCase.act();
      testCase.verifyEqual(length(findCell(...
        testCase.basepathPassedInToGetDirpathArr,...
        @(cell) strcmp(cell,testCase.dir))),2,...
        '�� ������� ���� � ����� �� ����� � ������������ �������');
    end
    
    function testGetsSolutionFilepathes(testCase)
      testCase.solno = 1;
      testCase.existent = [];
      testCase.dir = 'dir\';
      testCase.act();
      testCase.verifyEqual(length(findCell(...
        testCase.dirPassedInToGetResultsFilepathArr,...
        @(cell) strcmp(cell,testCase.intermediateSolutionsDirpath))),1,...
        '�� ������� ���� � ����� � �������������� ������������ �������');
      testCase.verifyEqual(length(findCell(...
        testCase.dirPassedInToGetResultsFilepathArr,...
        @(cell) strcmp(cell,testCase.finalSolutionsDirpath))),1,...
        '�� ������� ���� � ����� � �������������� ������������ �������');
      testCase.verifyEqual(length(findCell(...
        testCase.filenamePassedInToGetResultsFilepathArr,...
        @(cell) ~isempty(strfind(cell,'A')))),2,...
        '�� ������� ���� � ������ �� ������ � ������������ �������');
    end
    
    function testGetsInitialDataIfFileDoesNotExist(testCase)
      testCase.existent = [];
      testCase.isGetInitialDataToSolveTillSteadyCalled = false;
      testCase.act();
      testCase.assertTrue(...
        testCase.isGetInitialDataToSolveTillSteadyCalled,...
        '�� �������� ��������� ������ ��� ������� �� ������������');
      testCase.verifyEqual(...
        testCase.solNoPassedInToGetInitialDataToSolveTillSteady,...
        testCase.solno,...
        '������� ������������ ����� �������');      
      testCase.verifyEqual(...
        testCase.nSpatialStepsPassedInToGetInitialDataToSolveTillSteady,...
        length(testCase.X),...
        '�������� ������������ ����� ����� ��������� ������');
      exph = testCase.X(2)-testCase.X(1);
      testCase.verifyEqual(...
        testCase.spatialStepSizePassedInToGetInitialDataToSolveTillSteady,...
        exph,'������� ������������ ��� ��������� ������');
    end
    
    function testLoadsInitialDataIfFileExists(testCase)
      testCase.existent = testCase.intermediateSolutionFilepath;
      testCase.act();
      testCase.verifyTrue(isfield(testCase.loadedVars,...
        testCase.intermediateSolutionFilepath),...
        '�� ��������� ��������� ������');
      testCase.verifyFalse(isempty(find(strcmp(...
        testCase.loadedVars.(testCase.intermediateSolutionFilepath),...
        'w0'),1)),'�� ��������� ��������� ������');
    end
    
    function testGetsParams(testCase)
      testCase.isGetParamsCalled = false;
      testCase.act();
      testCase.verifyTrue(testCase.isGetParamsCalled,...
        '�� �������� ���������');
    end
    
    function testPassesParamsToSolver(testCase)
      testCase.isSolverCalled = false;
      testCase.act();

      testCase.assertTrue(testCase.isSolverCalled,'�� ������ ��������');
      
      testCase.verifyEqual(testCase.actRightParts,testCase.rightParts,...
        '�������� ������������ ������ ����� �������');
      testCase.verifyEqual(testCase.actTSpan,...
        0:testCase.tstep:testCase.tf,...
        '������� ������������ ��������� �������� ��������������');
      testCase.verifyEqual(testCase.actW0,testCase.w0,...
        '�������� ������������ ��������� ������');
      
      nspecies = testCase.nprey+testCase.npredator;
      nvar = length(testCase.X)*nspecies;
      nonNegative = 1:nvar;
      testCase.verifyEqual(testCase.actNonNegative,nonNegative,...
        '�������� ������������ ������� ��������������� ����������');
      outputFcn = @odephas2;
      testCase.verifyEqual(testCase.actOutputFcn,outputFcn,...
        '�������� ������������ ������� ������');
      outputSel = [3,8];
      testCase.verifyEqual(testCase.actOutputSel,outputSel,...
        '�������� ������������ ������� ��������� ����������');
      
      testCase.verifyEqual(testCase.actFixedVarIndex,3,...
        '������� ������������ ����� ����������, ������� ���������� � ��������� ������� ��������� ����������� ��������');
      testCase.verifyEqual(testCase.actFixedVarValue,0.5,...
        '�������� ������������ �������� ����������, ������� ���������� � ��������� ������� ��������� ����������� ��������');
    end
    
    function testGetsSolutionTillMaxPredatorDensities(testCase)
      testCase.act();
      testCase.verifyEqual(testCase.actW,testCase.w,...
        '�� �������� ������� �� ���������� ���������� ��������� �������� ��� ������� ���������� ������������');
    end
    
    function testCreatesOnlyIntermediateSolutionsFolderIfDoesNotNeedToSaveSolutionTillMaxPredatorDensities(testCase)
      testCase.existent = testCase.intermediateSolutionFilepath;
      testCase.dir = 'dir\';
      testCase.act();
      testCase.assertFalse(isempty(find(strcmp(testCase.createdDirArray,...
        testCase.intermediateSolutionsDirpath),1)),...
        '�� ������� ����� � �������������� ������������ �������');
      testCase.verifyTrue(isempty(find(strcmp(testCase.createdDirArray,...
        testCase.finalSolutionsDirpath),1)),...
        'C������ ����� � �������������� ������������ �������, ���� �� ���� ��������� ������� �� ���������� ���������� ��������� ��������');
    end
    
    function testCreatesFinalSolutionsFolderIfNeedsToSaveSolutionTillMaxPredatorDensities(testCase)
      testCase.existent = [];
      testCase.dir = 'dir\';
      testCase.act();
      testCase.assertFalse(isempty(find(strcmp(testCase.createdDirArray,...
        testCase.finalSolutionsDirpath),1)),...
        '�� ������� ����� � �������������� ������������ �������');
    end
    
    function testSavesSolutionTillMaxPredatorDensitiesIfNeeded(testCase)
      testCase.existent = [];
      testCase.act();
      testCase.verifyFalse(isempty(find(strcmp(...
        testCase.savedVars.(testCase.finalSolutionFilepath),'w'),1)),...
        '�� ��������� �������');
    end
    
    function testDoesNotSaveSolutionTillMaxPredatorDensitiesIfIntermediateSolutionExists(testCase)
      testCase.existent = testCase.intermediateSolutionFilepath;
      testCase.act();
      testCase.verifyFalse(isfield(testCase.savedVars,...
        testCase.finalSolutionFilepath),...
        '�������������� ������� ���� ��������� ��� ����������������');
    end
    
    function testPassesSolutionToGetLastRow(testCase)
      testCase.act();
      testCase.verifyEqual(testCase.paramPassedInToGetLastRow,...
        testCase.w,'�� ���� �������� ��������� ����� �������');
    end
    
    function testPassesMoreThan2PoincareSecantPlaneIntersectionTimesToGetPeriod(testCase)
      testCase.tpoincare = [40 70 100];
      testCase.act();
      testCase.verifyEqual(testCase.paramPassedInToGetPeriod,...
        testCase.tpoincare,'�� ��� ������ ������');
    end
    
    function testDoesNotPassLessThan3PoincareSecantPlaneIntersectionTimesToGetPeriod(testCase)
      testCase.tpoincare = [70 100];
      testCase.act();
      testCase.verifyNotEqual(testCase.paramPassedInToGetPeriod,...
        testCase.tpoincare,...
        '������� getPeriod() ��� ������� ������ �� ����� 3-� ���������');
    end
    
    function testSavesLastPoint(testCase)
      testCase.act();
      testCase.verifyTrue(isfield(testCase.savedVars,...
        testCase.intermediateSolutionFilepath),...
        '��������� ����� ������� �� ���������');
      testCase.verifyFalse(isempty(find(strcmp(...
        testCase.savedVars.(testCase.intermediateSolutionFilepath),'w0'),1)),...
        '��������� ����� ������� �� ���������');
    end
    
    function testSavesPeriodIfMoreThan2PoincareSecantPlaneIntersections(testCase)
      testCase.tpoincare = [40 70 100];
      testCase.act();
      testCase.verifyFalse(isempty(find(strcmp(...
        testCase.savedVars.(testCase.intermediateSolutionFilepath),'T'),1)),...
        '������ �� ��������');
    end
    
    function testGetsPointWithMinPreyDensity(testCase)
      testCase.isGetPointWithExtremeVarValuesCalled = false;
      testCase.act();
      testCase.verifyTrue(...
        testCase.isGetPointWithExtremeVarValuesCalled,...
        '�� �������� ����� ������� � ����������� ���������� ��������� �����');
      testCase.verifyEqual(...
        testCase.solutionPassedInToGetPointWithExtremeVarValues,...
        testCase.w,...
        '�������� ������������ ������� �������');
      expVarIndex = 3;
      testCase.verifyEqual(...
        testCase.varIndicesPassedInToGetPointWithExtremeVarValues,...
        expVarIndex,...
        '������� ������������ ������ ����������, ����� � ������������ ��������� ������� ��������� �����');
      testCase.verifyEqual(...
        testCase.kindPassedInToGetPointWithExtremeVarValues,'min',...
        '������� ������������ ��� ����������');
    end
    
    function testSavesPointWithMinPreyDensity(testCase)
      testCase.act();
      
      testCase.verifyTrue(isfield(testCase.savedVars,...
        testCase.intermediateSolutionFilepath),...
        '����� ������� � ����������� ���������� ��������� ����� �� ���� ���������');
      testCase.verifyFalse(isempty(find(strcmp(...
        testCase.savedVars.(testCase.intermediateSolutionFilepath),...
        'minpreypt'),1)),...
        '����� ������� � ����������� ���������� ��������� ����� �� ���� ���������');
    end
  end
  
end

