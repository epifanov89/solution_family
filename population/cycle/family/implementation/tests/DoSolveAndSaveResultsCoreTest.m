classdef DoSolveAndSaveResultsCoreTest < matlab.unittest.TestCase
  
  properties
    rightParts
    resource
    nprey
    npredator
    X
    tstep
    tf
    w0
    tpoincare
    wpoincare
    w
    solno
    
    filename
    dir
    
    basepathPassedInToGetResultsFilepathArr
    filenamePassedInToGetResultsFilepathArr
    intermediateSolutionFilepath
    finalSolutionFilepath
    resultsFilepathArr
    getResultsFilepathCallNo

    areaLengthPassedInToGetZeroFirstPredatorInitialData
    numberOfSpatialStepsPassedInToGetZeroFirstPredatorInitialData
    
    actRightParts
    actTSpan
    actW0
    actNonNegative
    actOutputFcn
    actOutputSel
    actFixedVarIndex
    actFixedVarValue
    
    isGetIntermediateSolutionFilepathCalled
    isGetFinalSolutionFilepathCalled
    isGetZeroFirstPredatorInitialDataCalled
    isGetCombinedPredatorDensitiesInitialDataCalled
    isGetParamsCalled
    isSolverCalled
    
    dirPassedInToGetIntermediateSolutionFilepath
    filenamePassedInToGetIntermediateSolutionFilepath
    dirPassedInToGetFinalSolutionFilepath
    filenamePassedInToGetFinalSolutionFilepath
    
    dirPassedInToGetCombinedPredatorDensitiesInitialData
    getResultsFilepathPassedInToGetCombinedPredatorDensitiesInitialData
    existsPassedInToGetCombinedPredatorDensitiesInitialData
    loadVarsPassedInToGetCombinedPredatorDensitiesInitialData
    solNoPassedInToGetCombinedPredatorDensitiesInitialData
    
    existent
    loadedVars
    savedVars    
    paramPassedInToGetFilename
    paramPassedInToGetFileDir
    paramsPassedToGetLastPoint
    paramsPassedToGetPeriod
  end
  
  methods (TestMethodSetup)
    function setup(testCase)
      testCase.solno = 0;
      testCase.rightParts = @() {};
      testCase.resource = @() {};
      testCase.nprey = 1;
      testCase.npredator = 2;
      testCase.X = [0 0.2 0.4 0.6 0.8];
      testCase.tstep = 0.002;
      testCase.tf = 100;
      testCase.w0 = [1 2 1 2 1];
      testCase.w = [1 2 1 2 1];
      testCase.loadedVars = struct;
      testCase.savedVars = struct;      
      testCase.basepathPassedInToGetResultsFilepathArr = {};
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

      t = 100;
      w = testCase.w;
      tpoincare = testCase.tpoincare;
      wpoincare = testCase.wpoincare;
    end

    function [ rightParts,resource,nprey,npredator,X,tstep ] = ...
        fakeParams(testCase)
      testCase.isGetParamsCalled = true;
      
      tstep = testCase.tstep;

      % ����� ��������� �����
      nprey = testCase.nprey;
      % ����� ��������� ��������
      npredator = testCase.npredator;

      X = testCase.X;

      rightParts = testCase.rightParts;
      resource = testCase.resource;                           
    end

    function filename = fakeGetFilename(testCase,param)
      testCase.paramPassedInToGetFilename = param;
      filename = testCase.filename;
    end
    
    function dir = fakeGetFileDir(testCase,param)
      testCase.paramPassedInToGetFileDir = param;
      dir = testCase.dir;
    end
    
    function filepath = fakeGetResultsFilepath(testCase,...
        basepath,~,filename)
      testCase.basepathPassedInToGetResultsFilepathArr = ...
        [testCase.basepathPassedInToGetResultsFilepathArr,basepath];
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
    
    function w0 = fakeGetZeroFirstPredatorInitialData(testCase,L,N)
      testCase.isGetZeroFirstPredatorInitialDataCalled = true;
      testCase.areaLengthPassedInToGetZeroFirstPredatorInitialData = L;
      testCase.numberOfSpatialStepsPassedInToGetZeroFirstPredatorInitialData = N;
      w0 = testCase.w0;
    end
    
    function w0 = fakeGetCombinedPredatorDensitiesInitialData(testCase,...
        dir,getResultsFilepath,exists,loadVars,solno,nsol)
      testCase.isGetCombinedPredatorDensitiesInitialDataCalled = true;
      testCase.dirPassedInToGetCombinedPredatorDensitiesInitialData = dir;
      testCase.getResultsFilepathPassedInToGetCombinedPredatorDensitiesInitialData = getResultsFilepath;
      testCase.existsPassedInToGetCombinedPredatorDensitiesInitialData = exists;
      testCase.loadVarsPassedInToGetCombinedPredatorDensitiesInitialData = loadVars;
      testCase.solNoPassedInToGetCombinedPredatorDensitiesInitialData = solno;
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
       
    function lastrow = fakeGetLastRow(testCase,w)
      if isempty(testCase.paramsPassedToGetLastPoint)
        testCase.paramsPassedToGetLastPoint = {w};
      else
        testCase.paramsPassedToGetLastPoint = ...
          [testCase.paramsPassedToGetLastPoint,w];
      end
      
      lastrow = [1 2 1 2 1];
    end
        
    function T = fakeGetPeriod(testCase,tpoincare)
      if isempty(testCase.paramsPassedToGetPeriod)
        testCase.paramsPassedToGetPeriod = {tpoincare};
      else
        testCase.paramsPassedToGetPeriod = ...
          [testCase.paramsPassedToGetPeriod,tpoincare];
      end
      
      T = tpoincare(end)-tpoincare(end-2);
    end
    
    function act(testCase)
      doSolveAndSaveResultsCore(testCase.solno,testCase.tf,...
        @testCase.fakeGetFilename,@testCase.fakeGetFileDir,...
        @testCase.fakeGetResultsFilepath,@testCase.fakeExist,...
        @testCase.fakeGetZeroFirstPredatorInitialData,...
        @testCase.fakeGetCombinedPredatorDensitiesInitialData,...
        @testCase.fakeLoad,@testCase.fakeSave,@testCase.fakeParams,...
        @testCase.fakeSolver,@testCase.fakeGetLastRow,...
        @testCase.fakeGetPeriod);
    end
  end
  
  methods (Test)  
    function testCallsParams(testCase)
      testCase.isGetParamsCalled = false;
      testCase.act();
      testCase.verifyTrue(testCase.isGetParamsCalled,...
        '�� ���� �������� ���������');
    end
    
    function testGetsFilename(testCase)
      testCase.act();
      testCase.verifyEqual(testCase.paramPassedInToGetFilename,...
        'fullpath','�� ���� �������� ��� �����');
    end
    
    function testGetsFileDir(testCase)
      testCase.filename = 'filename';
      testCase.act();
      testCase.verifyEqual(testCase.paramPassedInToGetFileDir,...
        testCase.filename,'�� ��� ������� ���� � �����, ���������� ����');
    end
    
    function testGetsSolutionFilepathes(testCase)
      testCase.dir = 'dir\';
      testCase.act();
      testCase.verifyEqual(length(findCell(...
        testCase.basepathPassedInToGetResultsFilepathArr,...
        @(cell) strcmp(cell,testCase.dir))),2,...
        '�� ������� ���� � ������ �� ������ � ������������ �������');      
      testCase.verifyEqual(length(findCell(...
        testCase.filenamePassedInToGetResultsFilepathArr,...
        @(cell) ~isempty(strfind(cell,num2str(testCase.solno))))),2,...
        '�� ������� ���� � ������ �� ������ � ������������ �������');
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
    
    function testGetsZeroFirstPredatorInitialDataIfSolNoIsZeroAndFileDoesNotExist(testCase)
      testCase.solno = 0;
      testCase.existent = [];
      testCase.isGetZeroFirstPredatorInitialDataCalled = false;
      testCase.act();
      testCase.assertTrue(...
        testCase.isGetZeroFirstPredatorInitialDataCalled,...
        '�� �������� ��������� ������ � ������� ���������� ������ ��������� ��������');
      h = testCase.X(2)-testCase.X(1);
      expL = testCase.X(end)-testCase.X(1)+h;
      testCase.assertEqual(...
        testCase.areaLengthPassedInToGetZeroFirstPredatorInitialData,...
        expL,...
        '� ������� ��������� ��������� ������ � ������� ���������� ������ ��������� �������� �������� ������������ ����� ������');
      expN = length(testCase.X);
      testCase.assertEqual(...
        testCase.numberOfSpatialStepsPassedInToGetZeroFirstPredatorInitialData,...
        expN,...
        '� ������� ��������� ��������� ������ � ������� ���������� ������ ��������� �������� �������� ������������ ����� �������� �� ���������������� ����������');
    end
    
    function testGetsCombinedPredatorDensitiesInitialDataIfSolNoIsNotZeroAndFileDoesNotExist(testCase)
      testCase.solno = 1;
      testCase.existent = [];
      testCase.dir = 'dir\';
      testCase.isGetCombinedPredatorDensitiesInitialDataCalled = false;
      getResultsFilepath = @testCase.fakeGetResultsFilepath;
      exists = @testCase.fakeExist;
      loadVars = @testCase.fakeLoad;
      doSolveAndSaveResultsCore(testCase.solno,testCase.tf,...
        @testCase.fakeGetFilename,@testCase.fakeGetFileDir,...
        getResultsFilepath,exists,...
        @testCase.fakeGetZeroFirstPredatorInitialData,...
        @testCase.fakeGetCombinedPredatorDensitiesInitialData,...
        loadVars,@testCase.fakeSave,@testCase.fakeParams,...
        @testCase.fakeSolver,@testCase.fakeGetLastRow,...
        @testCase.fakeGetPeriod);
      testCase.assertTrue(...
        testCase.isGetCombinedPredatorDensitiesInitialDataCalled,...
        '�� �������� ��������� ������ � ��������� ���������� ������ ��������� ��������');
      testCase.verifyEqual(...
        testCase.dirPassedInToGetCombinedPredatorDensitiesInitialData,...
        testCase.dir,...
        '������� ������������ ���� � ����� � ������ ����');      
      testCase.verifyEqual(...
        testCase.getResultsFilepathPassedInToGetCombinedPredatorDensitiesInitialData,...
        getResultsFilepath,...
        '�������� ������������ ������� ��������� ���� � ����� � �������������� ������������ �������');      
      testCase.verifyEqual(...
        testCase.existsPassedInToGetCombinedPredatorDensitiesInitialData,...
        exists,...
        '�������� ������������ ������� �������� ������������� �����');      
      testCase.verifyEqual(...
        testCase.loadVarsPassedInToGetCombinedPredatorDensitiesInitialData,...
        loadVars,...
        '�������� ������������ ������� �������� �������� ���������� �� �����');
      testCase.verifyEqual(...
        testCase.solNoPassedInToGetCombinedPredatorDensitiesInitialData,...
        testCase.solno,'������� ������������ ����� �������');
    end
    
    function testPassesProperParamsToSolver(testCase)
      testCase.isSolverCalled = false;
      testCase.solno = 0;
      testCase.act();
      
      testCase.assertTrue(testCase.isSolverCalled,...
        '�� ��� ������ ��������');
      
      testCase.verifyEqual(testCase.actRightParts,testCase.rightParts,...
        '�������� ������������ ������ ����� �������');
      testCase.verifyEqual(testCase.actTSpan,...
        0:testCase.tstep:testCase.tf,...
        '������� ������������ �������� �������������� �� �������');
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
      expOutputSel = [3,13];
      testCase.verifyEqual(testCase.actOutputSel,expOutputSel,...
        '�������� ������������ ������� ��������� ����������');
      
      testCase.verifyEqual(testCase.actFixedVarIndex,3,...
        '������� ������������ ����� ����������, ������� ���������� � ��������� ������� ��������� ����������� ��������');
      testCase.verifyEqual(testCase.actFixedVarValue,0.5,...
        '�������� ������������ �������� ����������, ������� ���������� � ��������� ������� ��������� ����������� ��������');
      
      testCase.isSolverCalled = false;
      testCase.solno = 4;
      testCase.getResultsFilepathCallNo = 1;
      testCase.act();
      testCase.assertTrue(testCase.isSolverCalled,...
        '�� ��� ������ ��������');
      expFirstOutputIndex = 3;
      testCase.verifyEqual(testCase.actOutputSel(1),expFirstOutputIndex,...
        '������� ������������ ������ ������ ��������� ����������');
      expSecondOutputIndex = [8,13];
      testCase.verifyFalse(isempty(find(expSecondOutputIndex,...
        testCase.actOutputSel(2))),...
        '������� ������������ ������ ������ ��������� ����������');
      
      testCase.isSolverCalled = false;
      testCase.solno = 10;
      testCase.getResultsFilepathCallNo = 1;
      testCase.act();
      testCase.assertTrue(testCase.isSolverCalled,...
        '�� ��� ������ ��������');
      expOutputSel = [3,8];
      testCase.verifyEqual(testCase.actOutputSel,expOutputSel,...
        '�������� ������������ ������� ��������� ����������');
    end
    
    function testPassesSolutionToGetLastRow(testCase)
      testCase.act();
      testCase.verifyTrue(~isempty(findCell(...
        testCase.paramsPassedToGetLastPoint,testCase.w)),...
        '�� �������� ��������� ����� �������');
    end   

    function testPassesMoreThan2PoincareSecantPlaneIntersectionTimesToGetPeriod(testCase)
      testCase.tpoincare = [40 70 100];
      testCase.wpoincare = [1 2 1 2 1];
      testCase.act();
      testCase.verifyFalse(isempty(findCell(...
        testCase.paramsPassedToGetPeriod,...
        @(cell) isequal(cell,testCase.tpoincare))),'�� ������ ������');
    end
    
    function testDoesNotPassLessThan3PoincareSecantPlaneIntersectionTimesToGetPeriod(testCase)
      testCase.tpoincare = [70 100];
      testCase.wpoincare = [1 2 1 2 1];
      testCase.act();
      testCase.verifyTrue(isempty(findCell(...
        testCase.paramsPassedToGetPeriod,...
        @(cell) isequal(testCase.tpoincare))),...
        '������� getPeriod() ������� ������ �� ����� 3-� ���������');
    end
    
    function testSavesLastPoint(testCase)
      testCase.act();
      testCase.verifyFalse(isempty(find(strcmp(...
        testCase.savedVars.(testCase.intermediateSolutionFilepath),'w0'),1)),...
        '��������� ����� ������� �� ���������');
    end
    
    function testSavesPeriodIfThereAreMoreThanTwoPoincareSecantPlaneIntersections(testCase)
      testCase.tpoincare = [40 70 100];
      testCase.act();
      testCase.verifyFalse(isempty(find(strcmp(...
        testCase.savedVars.(testCase.finalSolutionFilepath),'T'),1)),...
        '������ �� ��������');
    end
  end
  
end

