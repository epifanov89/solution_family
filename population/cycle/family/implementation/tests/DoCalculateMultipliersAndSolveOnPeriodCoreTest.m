classdef DoCalculateMultipliersAndSolveOnPeriodCoreTest < matlab.unittest.TestCase
  %DOCALCULATEMULTIPLIERSANDSOLVEONPERIODCORETEST Summary of this class goes here
  %   Detailed explanation goes here
  
  properties
    rightParts
    linearizedSystem
    resource
    nprey
    npredator
    X
    tstep
    wpoincareend
    period
    tpoincare
    wpoincare
    w0
    w
    solno
    
    filename
    dir
    
    resultsFilepathForMFile
    finalMultipliersFilepath
    intermediateSolutionFilepath
    finalSolutionFilepath
    
    basepathPassedInToGetResultsFilepathArr
    filenamePassedInToGetResultsFilepathArr    
    resultsFilepathArr
    getResultsFilepathCallNo
    
    actRightPartsMultipliers
    actLinearizedSystem
    actSolver
    actTStepMultipliers
    actTLastMultipliers
    actWPoincareEndMultipliers
    actNVar
    actIntermediateMonodromyMatrixFilepath
    actFixedVarIndex
    actFixedVarValue
    actNonNegativeMultipliers
    actOutputFcnMultipliers
    actOutputSelMultipliers
    
    actRightPartsSolver
    actTStepSolver
    actTLastSolver
    actW0Solver
    actNonNegativeSolver
    actOutputFcnSolver
    actOutputSelSolver
    
    paramPassedInToGetFilename
    paramPassedInToGetFileDir
    
    existent
    loadedVars
    varsToReturnFromLoad
    savedVars 
    
    isGetResultsFilepathForMFileCalled
    filepathPassedInToGetResultsFilepathForMFile
    dirPassedInToGetResultsFilepathForMFile    
    
    isGetParamsCalled    
       
    printedValsArray
    displayedValsArray
    
    multipliers
    computationTime
    
    callSequence
    solverWasCalled
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
      testCase.wpoincareend = [1 2 1 2 1];
      testCase.w0 = [2 3 2 3 2];
      testCase.period = 30;
      testCase.w = [1 2 1 2 1];
      testCase.savedVars = struct;
      testCase.loadedVars = struct;
      testCase.varsToReturnFromLoad = struct;
      testCase.varsToReturnFromLoad.wpoincareend = [1 2 1 2 1];
      testCase.varsToReturnFromLoad.minpreypt = [2 3 2 3 2];
      testCase.varsToReturnFromLoad.T = 30;
      testCase.printedValsArray = {};
      testCase.displayedValsArray = [];
      testCase.callSequence = {};
      testCase.solverWasCalled = false;
      testCase.basepathPassedInToGetResultsFilepathArr = {};
      testCase.filenamePassedInToGetResultsFilepathArr = {};
      testCase.resultsFilepathForMFile = ...
        'intermediate_monodromy_matrix_filepath';
      testCase.finalMultipliersFilepath = 'final_multipliers_filepath';
      testCase.intermediateSolutionFilepath = 'intermediate_solution_filepath';
      testCase.finalSolutionFilepath = 'final_solution_filepath';
      testCase.resultsFilepathArr = {testCase.intermediateSolutionFilepath,...
                                     testCase.finalMultipliersFilepath,...
                                     testCase.finalSolutionFilepath};
      testCase.getResultsFilepathCallNo = 1;
    end
  end
  
  methods
    function [multipliers,computationTime] = fakeMultipliers(testCase,rightParts,linearizedSystem,...
        solver,tspan,wpoincareend,nvar,...
        intermediateMonodromyMatrixFilepath,...
        fixedVarIndex,fixedVarValue,opts,outputOpts)      
      testCase.actRightPartsMultipliers = rightParts;
      testCase.actLinearizedSystem = linearizedSystem;
      testCase.actSolver = solver;
      testCase.actTStepMultipliers = tspan(2)-tspan(1);
      testCase.actTLastMultipliers = tspan(end);
      testCase.actWPoincareEndMultipliers = wpoincareend;
      testCase.actNVar = nvar;
      testCase.actIntermediateMonodromyMatrixFilepath = ...
        intermediateMonodromyMatrixFilepath;
      testCase.actFixedVarIndex = fixedVarIndex;
      testCase.actFixedVarValue = fixedVarValue;
      testCase.actNonNegativeMultipliers = odeget(opts,'NonNegative');
      testCase.actOutputFcnMultipliers = odeget(outputOpts,'OutputFcn');
      testCase.actOutputSelMultipliers = odeget(outputOpts,'OutputSel');
      
      multipliers = testCase.multipliers;
      computationTime = testCase.computationTime;
    end
    
    function [t,w] = fakeSolver(testCase,rightParts,tspan,w0,opts)
      callInfo = struct;
      callInfo.fcn = 'fakeSolver';
      callInfo.args = [];
      
      testCase.callSequence = [testCase.callSequence,callInfo];
      
      testCase.solverWasCalled = true;
      
      testCase.actRightPartsSolver = rightParts;
      testCase.actTStepSolver = tspan(2)-tspan(1);
      testCase.actTLastSolver = tspan(end);
      testCase.actW0Solver = w0;

      testCase.actNonNegativeSolver = odeget(opts,'NonNegative');
      testCase.actOutputFcnSolver = odeget(opts,'OutputFcn');
      testCase.actOutputSelSolver = odeget(opts,'OutputSel');

      t = 100;
      w = testCase.w;
    end
        
    function [ rightParts,linearizedSystem,resource,nprey,npredator,X,tstep ] = fakeParams(testCase)
      testCase.isGetParamsCalled = true;
      
      tstep = testCase.tstep;

      nprey = testCase.nprey;
      npredator = testCase.npredator;

      X = testCase.X;

      rightParts = testCase.rightParts;
      linearizedSystem = testCase.linearizedSystem;
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
    
    function filepath = fakeGetResultsFilepathForMFile(...
        testCase,filepath,dir)
      testCase.isGetResultsFilepathForMFileCalled = true;
      testCase.filepathPassedInToGetResultsFilepathForMFile = filepath;
      testCase.dirPassedInToGetResultsFilepathForMFile = dir;      
      filepath = testCase.resultsFilepathForMFile;
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
    
    function S = fakeLoad(testCase,filename,varargin)
      if ~isfield(testCase.loadedVars,filename)
        testCase.loadedVars.(filename) = varargin;
      else
        testCase.loadedVars.(filename) = ...
          [testCase.loadedVars.(filename),varargin];
      end
      S = testCase.varsToReturnFromLoad;
    end
    
    function fakeSave(testCase,filename,varargin)      
      if ~isfield(testCase.savedVars,filename)
        testCase.savedVars.(filename) = varargin;
      else
        testCase.savedVars.(filename) = [testCase.savedVars.(filename),...
          varargin];
      end
    end
    
    function fakeFigure(testCase)
      callInfo = struct;
      callInfo.fcn = 'fakeFigure';
      callInfo.args = [];
      
      testCase.callSequence = [testCase.callSequence,callInfo];
    end
    
    function fakePrint(testCase,varargin)
      testCase.printedValsArray = [testCase.printedValsArray,varargin];
    end
    
    function fakeDisp(testCase,val)
      testCase.displayedValsArray = [testCase.displayedValsArray,val];
    end
    
    function markIntermediateSolutionFileExistent(testCase)
      testCase.existent = testCase.intermediateSolutionFilepath;
    end
    
    function act(testCase)
      doCalculateMultipliersAndSolveOnPeriodCore(testCase.solno,...
        @testCase.fakeGetFilename,@testCase.fakeGetFileDir,...
        @testCase.fakeGetResultsFilepathForMFile,...
        @testCase.fakeGetResultsFilepath,@testCase.fakeExist,...
        @testCase.fakeLoad,@testCase.fakeSave,@testCase.fakeParams,...
        @testCase.fakeMultipliers,@testCase.fakeSolver,...
        @testCase.fakeFigure,@testCase.fakePrint,@testCase.fakeDisp);
    end
  end
  
  methods (Test)
    function testGetsFilename(testCase)
      testCase.markIntermediateSolutionFileExistent();
      testCase.act();
      testCase.verifyEqual(testCase.paramPassedInToGetFilename,...
        'fullpath','�� ���� �������� ��� �����');
    end
    
    function testGetsFileDir(testCase)
      testCase.markIntermediateSolutionFileExistent();
      testCase.filename = 'filename';      
      testCase.act();
      testCase.verifyEqual(testCase.paramPassedInToGetFileDir,...
        testCase.filename,'�� ��� ������� ���� � �����, ���������� ����');
    end
    
    function testGetsSolutionFilepathes(testCase)      
      testCase.markIntermediateSolutionFileExistent();
      testCase.solno = 1;
      testCase.multipliers = [1.002 0.998];
      testCase.dir = 'dir\';
      testCase.act();
      testCase.assertEqual(length(...
        testCase.basepathPassedInToGetResultsFilepathArr),3,...
        '�� ������� ���� � ������ �� ������ � ������������ �������');
      testCase.assertEqual(length(...
        testCase.filenamePassedInToGetResultsFilepathArr),3,...
        '�� ������� ���� � ������ �� ������ � ������������ �������');
      testCase.verifyEqual(length(findCell(...
        testCase.basepathPassedInToGetResultsFilepathArr,...
        @(cell) strcmp(cell,testCase.dir))),3,...
        '���� � ����� � ������������ ������� �� ���������� � ����� ����� � �����');      
      testCase.verifyEqual(length(findCell(...
        testCase.filenamePassedInToGetResultsFilepathArr,...
        @(cell) ~isempty(strfind(cell,'A')))),3,...
        '� �������� ������ �� ������ � ������������ ������� ����������� �����, ���������� ����� �������');
    end
    
    function testGetsIntermediateMonodromyMatrixFilepath(testCase)
      testCase.markIntermediateSolutionFileExistent();
      testCase.filename = 'filename';
      testCase.isGetResultsFilepathForMFileCalled = false;
      testCase.act();
      testCase.assertTrue(testCase.isGetResultsFilepathForMFileCalled,...
        '�� �������� ��� ����� � �������������� ������������ �������');
      testCase.verifyEqual(...
        testCase.filepathPassedInToGetResultsFilepathForMFile,...
        testCase.filename,...
        '������� ������������ ���� � ����� � �����');
    end
    
    function testThrowsExceptionIfIntermediateSolutionFileDoesNotExist(testCase)
      testCase.existent = [];
      testCase.verifyError(@testCase.act,...
        'doCalculateMultipliersAndSolveOnPeriodCore:FileMustExist',...
        '�� ��������� ����������, ���� ���� � �������������� ������������ ������� �� ����������');      
    end
    
    function testLoadsIntermediateSolutionIfFileExists(testCase)
      testCase.markIntermediateSolutionFileExistent();
      testCase.act();
      testCase.verifyTrue(isfield(...
        testCase.loadedVars,testCase.intermediateSolutionFilepath),...
        '�� ������� ������� ��������');
      testCase.verifyFalse(isempty(find(strcmp(...
        testCase.loadedVars.(testCase.intermediateSolutionFilepath),...
        'wpoincareend'),1)),'�� ��������� ��������� ����� ����������� ��������');
      testCase.verifyFalse(isempty(find(strcmp(...
        testCase.loadedVars.(testCase.intermediateSolutionFilepath),...
        'minpreypt'),1)),'�� ��������� ����� � ����������� ���������� ��������� �����');
      testCase.verifyFalse(isempty(find(strcmp(...
        testCase.loadedVars.(testCase.intermediateSolutionFilepath),...
        'T'),1)),'�� �������� ������');
    end
    
    function testGetsParams(testCase)
      testCase.markIntermediateSolutionFileExistent();
      testCase.isGetParamsCalled = false;
      testCase.act();
      testCase.verifyTrue(testCase.isGetParamsCalled,...
        '�� ���� �������� ���������');
    end
    
    function testPassesParamsToCalculateMultipliers(testCase)
      testCase.markIntermediateSolutionFileExistent();
      expSolver = @testCase.fakeSolver;
      doCalculateMultipliersAndSolveOnPeriodCore(testCase.solno,...
        @testCase.fakeGetFilename,@testCase.fakeGetFileDir,...
        @testCase.fakeGetResultsFilepathForMFile,...
        @testCase.fakeGetResultsFilepath,@testCase.fakeExist,...
        @testCase.fakeLoad,@testCase.fakeSave,@testCase.fakeParams,...
        @testCase.fakeMultipliers,expSolver,...
        @testCase.fakeFigure,@testCase.fakePrint,@testCase.fakeDisp);
      testCase.verifyEqual(testCase.actRightPartsMultipliers,...
        testCase.rightParts,'�������� ������������ ������ ����� �������');
      testCase.verifyEqual(testCase.actLinearizedSystem,...
        testCase.linearizedSystem,...
        '�������� ������������ ������ ����� ������� � ���������');
      testCase.verifyEqual(testCase.actSolver,expSolver,...
        '������� ������������ ��������');
      testCase.verifyEqual(testCase.actTStepMultipliers,testCase.tstep,...
        '������� ������������ ��� �������������� �� �������');
      testCase.verifyGreaterThan(testCase.actTLastMultipliers,...
        testCase.varsToReturnFromLoad.T,...
        '�������� ������������ �������� ����� ��������� �������������� �� �������');
      testCase.verifyEqual(testCase.actWPoincareEndMultipliers,...
        testCase.wpoincareend,'�������� ������������ ��������� ������'); 
      testCase.verifyEqual(testCase.actIntermediateMonodromyMatrixFilepath,...
        testCase.resultsFilepathForMFile,...
        '�������� ������������ ��� ����� ��� ���������� ������������� ����������� ���������� ����������������');
      expFixedVarIndex = 3;
      testCase.verifyEqual(testCase.actFixedVarIndex,expFixedVarIndex,...
        '������� ������������ ����� ����������, ������� ���������� � ��������� ������� ��������� ����������� ��������');
      expFixedVarValue = 0.5;
      testCase.verifyEqual(testCase.actFixedVarValue,expFixedVarValue,...
        '�������� ������������ �������� ����������, ������� ���������� � ��������� ������� ��������� ����������� ��������');
      nspecies = testCase.nprey+testCase.npredator;
      nvar = length(testCase.X)*nspecies;
      testCase.verifyEqual(testCase.actNVar,nvar,...
        '�������� ������������ ����� ����������');
      nonNegative = 1:nvar;
      testCase.verifyEqual(testCase.actNonNegativeMultipliers,...
        nonNegative,...
        '�������� ������������ ������� ��������������� ����������');
      outputFcn = @odephas2;
      testCase.verifyEqual(testCase.actOutputFcnMultipliers,outputFcn,...
        '�������� ������������ ������� ������');
      outputSel = [3,8];
      testCase.verifyEqual(testCase.actOutputSelMultipliers,outputSel,...
        '�������� ������������ ������� ��������� ����������');
    end
    
    function testPassesParamsToSolverIfMultipliersAreComputed(testCase)
      testCase.markIntermediateSolutionFileExistent();
      testCase.multipliers = [1.002 0.998];      
      testCase.act();
      testCase.verifyEqual(testCase.actRightPartsSolver,testCase.rightParts,'�������� ������������ ������ ����� �������');
      testCase.verifyEqual(testCase.actTStepSolver,testCase.tstep,'������� ������������ ��� �������������� �� �������');
      testCase.verifyEqual(testCase.actTLastSolver,testCase.period,'�������� ������������ �������� ����� ��������� �������������� �� �������');
      testCase.verifyEqual(testCase.actW0Solver,testCase.w0,'�������� ������������ ��������� ������');
      nspecies = testCase.nprey+testCase.npredator;
      nvar = length(testCase.X)*nspecies;
      nonNegative = 1:nvar;
      testCase.verifyEqual(testCase.actNonNegativeSolver,nonNegative,'�������� ������������ ������� ��������������� ����������');
      outputFcn = @odephas2;
      testCase.verifyEqual(testCase.actOutputFcnSolver,outputFcn,'�������� ������������ ������� ������');
      outputSel = [3,8];
      testCase.verifyEqual(testCase.actOutputSelSolver,outputSel,'�������� ������������ ������� ��������� ����������');
    end
    
    function testDoesNotCallSolverIfMultipliersAreNotComputed(testCase)
      testCase.markIntermediateSolutionFileExistent();
      testCase.act();
      testCase.verifyFalse(testCase.solverWasCalled,'��� ������ ��������, ���� ������ ���������������� �� ��� ��������');
    end
    
    function testPrintsComputationTimeIfMultipliersComputed(testCase)
      testCase.markIntermediateSolutionFileExistent();
      testCase.multipliers = [1.002 0.998];
      testCase.computationTime = 100;
      testCase.act();
      testCase.verifyFalse(isempty(findCell(testCase.printedValsArray,...
        @(cell) cell == testCase.computationTime)),...
        '�� ���� �������� ����� ���������� ����������������');
    end
    
    function testDoesNotPrintComputationTimeIfMultipliersAreNotComputed(testCase)
      testCase.markIntermediateSolutionFileExistent();
      testCase.act();
      testCase.verifyTrue(isempty(findCell(testCase.printedValsArray,...
        @(cell) cell == testCase.computationTime)),...
        '���� �������� ����� ���������� ����������������, ���� ������ ���������������� �� ��� ��������');
    end
    
    function testDisplaysMultipliersIfTheyAreComputed(testCase)
      testCase.markIntermediateSolutionFileExistent();
      testCase.multipliers = [1.002 0.998];
      testCase.act();
      testCase.verifyEqual(testCase.displayedValsArray,...
        testCase.multipliers,'�� ���� �������� ���������������');
    end
    
    function testSavesMultipliersIfTheyAreComputed(testCase)
      testCase.markIntermediateSolutionFileExistent();
      testCase.multipliers = [1.002 0.998];
      testCase.act();
      testCase.verifyFalse(isempty(find(strcmp(...
        testCase.savedVars.(testCase.finalMultipliersFilepath),...
        'multipliers'),1)),'�� ���� ��������� ���������������');
    end
    
    function testSavesComputationTimeIfMultipliersAreComputed(testCase)
      testCase.markIntermediateSolutionFileExistent();
      testCase.multipliers = [1.002 0.998];
      testCase.act();
      testCase.verifyFalse(isempty(find(strcmp(...
        testCase.savedVars.(testCase.finalMultipliersFilepath),...
        'computationTime'),1)),...
        '�� ���� ��������� ����� ���������� ����������������');
    end
    
    function testDoesNotSaveMultipliersIfTheyAreNotComputed(testCase)
      testCase.markIntermediateSolutionFileExistent();
      testCase.act();
      testCase.verifyFalse(isfield(testCase.savedVars,...
        testCase.finalMultipliersFilepath),...
        '��� �������� ������ ������ ����������������');
    end
    
    function testCallsFigureBeforeSolver(testCase)
      testCase.markIntermediateSolutionFileExistent();
      testCase.multipliers = [1.002 0.998];      
      testCase.act();
      
      for callNo = 1:length(testCase.callSequence)
        callInfo = testCase.callSequence{callNo};
        if strcmp(callInfo.fcn,'fakeFigure')
          figureCallNo = callNo;
        elseif strcmp(callInfo.fcn,'fakeSolver')
          solverCallNo = callNo;
        end
      end
      
      testCase.verifyTrue(exist('figureCallNo','var') == 1,...
        '�� ���� ������� ����� ���� ��� �������');
      testCase.verifyLessThan(figureCallNo,solverCallNo,...
        '����� ���� �� ���� ������� ����� ������� ��������');
    end
    
    function testSavesSolutionOnPeriod(testCase)
      testCase.markIntermediateSolutionFileExistent();
      testCase.multipliers = [1.002 0.998];
      testCase.act();
      testCase.verifyTrue(isfield(testCase.savedVars,...
        testCase.finalSolutionFilepath),'������� �� ������� �� ���� ���������');
      testCase.verifyFalse(isempty(find(strcmp(...
        testCase.savedVars.(testCase.finalSolutionFilepath),'w'),1)),...
        '������� �� ������� �� ���� ���������');
    end
  end
  
end

