classdef DoFindAndSavePointWithMaxPredatorDensitiesCoreTest < matlab.unittest.TestCase
  
  properties
    rightParts
    linearizedSystem
    resource
    nprey
    npredator
    X
    tstep
    tlast
    w0
    period
    w
    resultsFilename
    secondPredatorDiffusionCoeff
    
    filename
    dir
    
    basepathesPassedInToGetDirpath
    intermediateResultsDirpath
    finalResultsDirpath
    dirpathes
    getDirpathCallNo
    
    dirsPassedInToGetResultsFilepath
    filenamesPassedInToGetResultsFilepath
    intermediateResultsFilepath
    finalResultsFilepath
    resultsFilepathes
    getResultsFilepathCallNo
    
    actNVar
    actFixedVarIndex
    actFixedVarValue
    
    actRightPartsSolver
    actTStepSolver
    actTLastSolver
    actW0Solver
    actNonNegativeSolver
    actOutputFcnSolver
    actOutputSelSolver
    
    isGetFirstPointWithExtremeVarValuesCalled
    solutionPassedInToGetFirstPointWithExtremeVarValues
    varIndicesPassedInToGetFirstPointWithExtremeVarValues
    kindPassedInToGetFirstPointWithExtremeVarValues
    
    existent
    loadedVars
    varsToReturnFromLoad
    savedVars
    isappend
    
    isGetParamsCalled
    secondPredatorDiffusionCoeffPassedInToGetParams
    
    printedValsArray
    displayedValsArray
        
    callSequence
    isSolverCalled
    
    paramPassedInToGetFilename
    paramPassedInToGetFileDir
    
    maxPredatorDensitiesPoint
  end
  
  methods (TestMethodSetup)
    function setup(testCase)
      testCase.resultsFilename = 'results_filename';
      testCase.secondPredatorDiffusionCoeff = 0.2;
      testCase.rightParts = @() {};
      testCase.linearizedSystem = @() {};
      testCase.resource = @() {};
      testCase.nprey = 1;
      testCase.npredator = 2;
      testCase.X = [0 0.2 0.4 0.6 0.8];
      testCase.tstep = 0.002;
      testCase.tlast = 100;
      testCase.w0 = [1 2 1 2 1];
      testCase.period = 30;
      testCase.w = [1 2 1 2 1];
      testCase.loadedVars = struct;      
      testCase.savedVars = struct;
      testCase.isappend = struct;
      testCase.printedValsArray = {};
      testCase.displayedValsArray = [];
      testCase.callSequence = {};
      testCase.basepathesPassedInToGetDirpath = {};
      testCase.intermediateResultsDirpath = 'intermediate_results\\';
      testCase.finalResultsDirpath = 'final_results\\';      
      testCase.dirpathes = {testCase.intermediateResultsDirpath,...
                            testCase.finalResultsDirpath};
      testCase.getDirpathCallNo = 1;
      testCase.dirsPassedInToGetResultsFilepath = {};
      testCase.filenamesPassedInToGetResultsFilepath = {};
      testCase.intermediateResultsFilepath = ...
        'intermediate_results_filepath';
      testCase.finalResultsFilepath = 'final_results_filepath';
      testCase.resultsFilepathes = {testCase.intermediateResultsFilepath,...
                                    testCase.finalResultsFilepath};
      testCase.getResultsFilepathCallNo = 1;
      testCase.existent = struct;
      testCase.varsToReturnFromLoad = struct;
      testCase.varsToReturnFromLoad.(testCase.intermediateResultsFilepath) = struct;
      testCase.varsToReturnFromLoad.(testCase.intermediateResultsFilepath).w0 = [1 2 1 2 1 1 2 1 2 1 1 2 1 2 1];
      testCase.varsToReturnFromLoad.(testCase.intermediateResultsFilepath).T = 30;
    end
  end
  
  methods
    function [ rightParts,linearizedSystem,resource,nprey,npredator,X,...
        tstep,tlast ] = fakeParams(testCase,secondPredatorDiffusionCoeff)
      testCase.isGetParamsCalled = true;
      testCase.secondPredatorDiffusionCoeffPassedInToGetParams = secondPredatorDiffusionCoeff;
      
      tstep = testCase.tstep;
      tlast = testCase.tlast;

      nprey = testCase.nprey;
      npredator = testCase.npredator;

      X = testCase.X;

      rightParts = testCase.rightParts;
      linearizedSystem = testCase.linearizedSystem;
      resource = testCase.resource;                           
    end
    
    function [t,w] = fakeSolver(testCase,rightParts,tspan,w0,opts)
      testCase.isSolverCalled = true;
      
      callInfo = struct;
      callInfo.fcn = 'fakeSolver';
      callInfo.args = [];
      
      testCase.callSequence = [testCase.callSequence,callInfo];
      
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
    
    function filename = fakeGetFilename(testCase,param)
      testCase.paramPassedInToGetFilename = param;
      filename = testCase.filename;
    end
    
    function dir = fakeGetFileDir(testCase,param)
      testCase.paramPassedInToGetFileDir = param;
      dir = testCase.dir;
    end
        
    function dirpath = fakeGetDirpath(testCase,basepath,~)
      testCase.basepathesPassedInToGetDirpath = ...
        [testCase.basepathesPassedInToGetDirpath,basepath];
      dirpath = testCase.dirpathes{testCase.getDirpathCallNo};
      testCase.getDirpathCallNo = testCase.getDirpathCallNo+1;
    end
    
    function filepath = fakeGetResultsFilepath(testCase,...
        dir,filename)
      testCase.dirsPassedInToGetResultsFilepath = ...
        [testCase.dirsPassedInToGetResultsFilepath,dir];
      testCase.filenamesPassedInToGetResultsFilepath = ...
        [testCase.filenamesPassedInToGetResultsFilepath,filename];
      filepath = ...
        testCase.resultsFilepathes{testCase.getResultsFilepathCallNo};
      testCase.getResultsFilepathCallNo = ...
        testCase.getResultsFilepathCallNo+1;
    end
    
    function exists = fakeExist(testCase,name,kind)
      exists = ~isempty(find(strcmp(testCase.existent.(kind),name),1));
    end
    
    function S = fakeLoad(testCase,filename,varargin)
      if ~isfield(testCase.loadedVars,filename)
        testCase.loadedVars.(filename) = varargin;
      else
        testCase.loadedVars.(filename) = ...
          [testCase.loadedVars.(filename),varargin];
      end
      S = testCase.varsToReturnFromLoad.(filename);
    end
    
    function fakeSave(testCase,filename,struct,isappend)      
      testCase.savedVars.(filename) = struct;      
      testCase.isappend.(filename) = isappend;
    end
    
    function wmax = fakeGetFirstPointWithExtremeVarValues(testCase,sol,...
        varIndices,mode)
      testCase.isGetFirstPointWithExtremeVarValuesCalled = true;
      testCase.solutionPassedInToGetFirstPointWithExtremeVarValues = sol;
      testCase.varIndicesPassedInToGetFirstPointWithExtremeVarValues = ...
        varIndices;
      testCase.kindPassedInToGetFirstPointWithExtremeVarValues = ...
        mode;
      wmax = testCase.maxPredatorDensitiesPoint;
    end
    
    function fakeFigure(testCase)
      callInfo = struct;
      callInfo.fcn = 'fakeFigure';
      callInfo.args = [];
      
      testCase.callSequence = [testCase.callSequence,callInfo];
    end
    
    function act(testCase)
      doFindAndSavePointWithMaxPredatorDensitiesCore(...
        testCase.resultsFilename,testCase.secondPredatorDiffusionCoeff,...
        @testCase.fakeGetFilename,...
        @testCase.fakeGetFileDir,@testCase.fakeGetDirpath,...
        @testCase.fakeGetResultsFilepath,...
        @testCase.fakeExist,@testCase.fakeLoad,@testCase.fakeSave,...
        @testCase.fakeParams,@testCase.fakeFigure,@testCase.fakeSolver,...
        @testCase.fakeGetFirstPointWithExtremeVarValues);
    end
    
    function markIntermediateResultsFileExistent(testCase)
      if ~isfield(testCase.existent,'file')
        testCase.existent.('file') = {testCase.intermediateResultsFilepath};
      else
        testCase.existent.('file') = [testCase.existent.('file'),...
          testCase.intermediateResultsFilepath];
      end
    end
  end
  
  methods (Test)
    function testGetsFilename(testCase)
      testCase.markIntermediateResultsFileExistent();
      testCase.act();
      testCase.verifyEqual(testCase.paramPassedInToGetFilename,...
        'fullpath','Не было получено имя файла');
    end
    
    function testGetsFileDir(testCase)
      testCase.markIntermediateResultsFileExistent();
      testCase.filename = 'filename';
      testCase.act();
      testCase.verifyEqual(testCase.paramPassedInToGetFileDir,...
        testCase.filename,'Не был получен путь к папке, содержащей файл');
    end
    
    function testGetsDirpathes(testCase)
      testCase.markIntermediateResultsFileExistent();
      testCase.dir = 'dir\';
      testCase.act();
      testCase.verifyEqual(length(findCell(...
        testCase.basepathesPassedInToGetDirpath,...
        @(cell) strcmp(cell,testCase.dir))),2,...
        'Не получен путь к одной из папок с результатами');
    end
    
    function testGetsResultsFilepathes(testCase)
      testCase.markIntermediateResultsFileExistent();
      testCase.act();
      testCase.verifyFalse(isempty(find(strcmp(...
        testCase.dirsPassedInToGetResultsFilepath,...
        testCase.intermediateResultsDirpath),1)),...
        'Не получен путь к файлу с промежуточными результатами решения');
      testCase.verifyFalse(isempty(find(strcmp(...
        testCase.dirsPassedInToGetResultsFilepath,...
        testCase.finalResultsDirpath),1)),...
        'Не получен путь к файлу с окончательными результатами решения');
      testCase.verifyEqual(length(findCell(...
        testCase.filenamesPassedInToGetResultsFilepath,...
        @(cell) strcmp(cell,testCase.resultsFilename))),2,...
        'Не получен путь к одному из файлов с результатами');
    end
    
    function testThrowsExceptionIfIntermediateSolutionFileDoesNotExist(testCase)
      testCase.existent.('file') = [];
      testCase.verifyError(@testCase.act,...
        'doFindAndSavePointWithMaxPredatorDensitiesCore:IntermediateSolutionFileMustExist',...
        'Не выброшено исключение, что файл с промежуточными результатами решения не существует');
    end
    
    function testLoadsInitialData(testCase)
      testCase.markIntermediateResultsFileExistent();
      testCase.act();
      testCase.verifyFalse(isempty(find(strcmp(...
        testCase.loadedVars.(testCase.intermediateResultsFilepath),...
        'w0'),1)),'Не загружены начальные данные');
    end
    
    function testLoadsPeriod(testCase)
      testCase.markIntermediateResultsFileExistent();
      testCase.act();
      testCase.verifyFalse(isempty(find(strcmp(...
        testCase.loadedVars.(testCase.intermediateResultsFilepath),'T'),1)),...
        'Не загружен период');
    end
    
    function testGetsParams(testCase)
      testCase.markIntermediateResultsFileExistent();
      testCase.isGetParamsCalled = false;
      testCase.act();
      testCase.assertTrue(testCase.isGetParamsCalled,'Не получены параметры');
      testCase.verifyEqual(...
        testCase.secondPredatorDiffusionCoeffPassedInToGetParams,...
        testCase.secondPredatorDiffusionCoeff,...
        'Передан неправильный коэффициент диффузии второй популяции хищников');
    end
    
    function testPassesParamsToSolverIfMultipliersAreComputed(testCase)
      testCase.markIntermediateResultsFileExistent();
      testCase.isSolverCalled = false;
      testCase.varsToReturnFromLoad.(testCase.intermediateResultsFilepath).w0 = [1 2 1 2 1 0 1 0 0 0 0 1 0 0 0];
      testCase.act();
      testCase.assertTrue(testCase.isSolverCalled,'Не вызван решатель');
      testCase.verifyEqual(testCase.actRightPartsSolver,...
        testCase.rightParts,'Переданы неправильные правые части системы');
      testCase.verifyEqual(testCase.actTStepSolver,testCase.tstep,...
        'Передан неправильный шаг интегрирования по времени');
      testCase.verifyEqual(testCase.actTLastSolver,testCase.period,...
        'Передано неправильное конечное время интервала интегрирования по времени');
      testCase.verifyEqual(testCase.actW0Solver,testCase.varsToReturnFromLoad.(testCase.intermediateResultsFilepath).w0,...
        'Переданы неправильные начальные данные');
      nspecies = testCase.nprey+testCase.npredator;
      nvar = length(testCase.X)*nspecies;
      nonNegative = 1:nvar;
      testCase.verifyEqual(testCase.actNonNegativeSolver,nonNegative,...
        'Переданы неправильные индексы неотрицательных переменных');
      outputFcn = @odephas2;
      testCase.verifyEqual(testCase.actOutputFcnSolver,outputFcn,...
        'Передана неправильная функция вывода');
      expFirstOutputIndex = 3;
      testCase.verifyEqual(testCase.actOutputSelSolver(1),expFirstOutputIndex,...
        'Передан неправильный индекс первой выводимой переменной');
      expSecondOutputIndex = [8,13];
      testCase.verifyFalse(isempty(find(expSecondOutputIndex,...
        testCase.actOutputSelSolver(2))),...
        'Передан неправильный индекс второй выводимой переменной');
      
      testCase.isSolverCalled = false;
      testCase.varsToReturnFromLoad.(testCase.intermediateResultsFilepath).w0 = [1 2 1 2 1 0 0 0 0 0 0 1 0 0 0];
      testCase.getDirpathCallNo = 1;
      testCase.getResultsFilepathCallNo = 1;
      testCase.act();
      expSecondOutputVarIndex = 13;
      testCase.verifyEqual(testCase.actOutputSelSolver(2),...
        expSecondOutputVarIndex,...
        'Передан неправильный индекс второй выводимой переменной');
      
      testCase.isSolverCalled = false;
      testCase.varsToReturnFromLoad.(testCase.intermediateResultsFilepath).w0 = [1 2 1 2 1 0 1 0 0 0 0 0 0 0 0];
      testCase.getDirpathCallNo = 1;
      testCase.getResultsFilepathCallNo = 1;
      testCase.act();
      expSecondOutputVarIndex = 8;
      testCase.verifyEqual(testCase.actOutputSelSolver(2),expSecondOutputVarIndex,...
        'Передан неправильный индекс второй выводимой переменной');
    end
    
    function testGetsFirstPointWithMaxPredatorDensities(testCase)
      testCase.markIntermediateResultsFileExistent();
      testCase.act();
      testCase.verifyTrue(...
        testCase.isGetFirstPointWithExtremeVarValuesCalled,...
        'Не получена точка с максимальными плотностями популяций хищников в средней точке ареала');
      testCase.verifyEqual(...
        testCase.solutionPassedInToGetFirstPointWithExtremeVarValues,...
        testCase.w,'Передана неправильная матрица решения');
      testCase.verifyEqual(...
        testCase.varIndicesPassedInToGetFirstPointWithExtremeVarValues,...
        [8,13],...
        'Переданы неправильные индексы переменных, точку с максимальными значениями которых требуется найти');
      testCase.verifyEqual(...
        testCase.kindPassedInToGetFirstPointWithExtremeVarValues,'max',...
        'Передан неправильный тип экстремума');
    end
    
    function testSavesMaxPredatorDensitiesPoint(testCase)
      testCase.markIntermediateResultsFileExistent();
      testCase.maxPredatorDensitiesPoint = [1 2];
      testCase.act();
      testCase.verifyTrue(isfield(testCase.savedVars,...
        testCase.finalResultsFilepath),...
        'Последние максимальные плотности популяций хищников в средней точке ареала не были сохранены');
      testCase.verifyTrue(isfield(...
        testCase.savedVars.(testCase.finalResultsFilepath),...
        'maxPredatorDensitiesPoint'),...
        'Последние максимальные плотности популяций хищников в средней точке ареала не были сохранены');
      testCase.verifyEqual(testCase.savedVars.(testCase.finalResultsFilepath).maxPredatorDensitiesPoint,...
        testCase.maxPredatorDensitiesPoint,...
        'Последние максимальные плотности популяций хищников в средней точке ареала не были сохранены');
    end
    
    function testPassesInRightIsAppendToSaveVars(testCase)
      testCase.markIntermediateResultsFileExistent();
      testCase.act();
      testCase.assertTrue(isfield(testCase.isappend,testCase.finalResultsFilepath),...
        'Не передан флаг, означающий добавлять ли переменные к файлу');
      testCase.verifyFalse(testCase.isappend.(testCase.finalResultsFilepath),...
        'Попытка добавить переменные к несуществующему файлу');
      
      testCase.getDirpathCallNo = 1;
      testCase.getResultsFilepathCallNo = 1;
      testCase.existent.('file') = [testCase.existent.('file'),...
        testCase.finalResultsFilepath];
      testCase.act();
      testCase.verifyTrue(testCase.isappend.(testCase.finalResultsFilepath),...
        'Затерты переменные, сохраненные ранее');      
    end
    
    function testCallsFigureBeforeSolver(testCase)
      testCase.markIntermediateResultsFileExistent();
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
        'Не было создано новое окно для рисунка');
      testCase.verifyLessThan(figureCallNo,solverCallNo,...
        'Новое окно не было создано перед вызовом решателя');
    end
  end
  
end

