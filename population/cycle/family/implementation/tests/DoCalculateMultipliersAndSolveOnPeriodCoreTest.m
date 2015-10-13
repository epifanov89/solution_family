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
        'fullpath','Не было получено имя файла');
    end
    
    function testGetsFileDir(testCase)
      testCase.markIntermediateSolutionFileExistent();
      testCase.filename = 'filename';      
      testCase.act();
      testCase.verifyEqual(testCase.paramPassedInToGetFileDir,...
        testCase.filename,'Не был получен путь к папке, содержащей файл');
    end
    
    function testGetsSolutionFilepathes(testCase)      
      testCase.markIntermediateSolutionFileExistent();
      testCase.solno = 1;
      testCase.multipliers = [1.002 0.998];
      testCase.dir = 'dir\';
      testCase.act();
      testCase.assertEqual(length(...
        testCase.basepathPassedInToGetResultsFilepathArr),3,...
        'Не получен путь к одному из файлов с результатами решения');
      testCase.assertEqual(length(...
        testCase.filenamePassedInToGetResultsFilepathArr),3,...
        'Не получен путь к одному из файлов с результатами решения');
      testCase.verifyEqual(length(findCell(...
        testCase.basepathPassedInToGetResultsFilepathArr,...
        @(cell) strcmp(cell,testCase.dir))),3,...
        'Путь к файлу с результатами решения не начинается с папки файла с кодом');      
      testCase.verifyEqual(length(findCell(...
        testCase.filenamePassedInToGetResultsFilepathArr,...
        @(cell) ~isempty(strfind(cell,'A')))),3,...
        'В названии одного из файлов с результатами решения отсутствует буква, означающая номер решения');
    end
    
    function testGetsIntermediateMonodromyMatrixFilepath(testCase)
      testCase.markIntermediateSolutionFileExistent();
      testCase.filename = 'filename';
      testCase.isGetResultsFilepathForMFileCalled = false;
      testCase.act();
      testCase.assertTrue(testCase.isGetResultsFilepathForMFileCalled,...
        'Не получено имя файла с промежуточными результатами решения');
      testCase.verifyEqual(...
        testCase.filepathPassedInToGetResultsFilepathForMFile,...
        testCase.filename,...
        'Передан неправильный путь к файлу с кодом');
    end
    
    function testThrowsExceptionIfIntermediateSolutionFileDoesNotExist(testCase)
      testCase.existent = [];
      testCase.verifyError(@testCase.act,...
        'doCalculateMultipliersAndSolveOnPeriodCore:FileMustExist',...
        'Не выброшено исключение, хотя файл с промежуточными результатами решения не существует');      
    end
    
    function testLoadsIntermediateSolutionIfFileExists(testCase)
      testCase.markIntermediateSolutionFileExistent();
      testCase.act();
      testCase.verifyTrue(isfield(...
        testCase.loadedVars,testCase.intermediateSolutionFilepath),...
        'Не вызвана функция загрузки');
      testCase.verifyFalse(isempty(find(strcmp(...
        testCase.loadedVars.(testCase.intermediateSolutionFilepath),...
        'wpoincareend'),1)),'Не загружена последняя точка отображения Пуанкаре');
      testCase.verifyFalse(isempty(find(strcmp(...
        testCase.loadedVars.(testCase.intermediateSolutionFilepath),...
        'minpreypt'),1)),'Не загружена точка с минимальной плотностью популяции жертв');
      testCase.verifyFalse(isempty(find(strcmp(...
        testCase.loadedVars.(testCase.intermediateSolutionFilepath),...
        'T'),1)),'Не загружен период');
    end
    
    function testGetsParams(testCase)
      testCase.markIntermediateSolutionFileExistent();
      testCase.isGetParamsCalled = false;
      testCase.act();
      testCase.verifyTrue(testCase.isGetParamsCalled,...
        'Не были получены параметры');
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
        testCase.rightParts,'Переданы неправильные правые части системы');
      testCase.verifyEqual(testCase.actLinearizedSystem,...
        testCase.linearizedSystem,...
        'Переданы неправильные правые части системы в вариациях');
      testCase.verifyEqual(testCase.actSolver,expSolver,...
        'Передан неправильный решатель');
      testCase.verifyEqual(testCase.actTStepMultipliers,testCase.tstep,...
        'Передан неправильный шаг интегрирования по времени');
      testCase.verifyGreaterThan(testCase.actTLastMultipliers,...
        testCase.varsToReturnFromLoad.T,...
        'Передано неправильное конечное время интервала интегрирования по времени');
      testCase.verifyEqual(testCase.actWPoincareEndMultipliers,...
        testCase.wpoincareend,'Переданы неправильные начальные данные'); 
      testCase.verifyEqual(testCase.actIntermediateMonodromyMatrixFilepath,...
        testCase.resultsFilepathForMFile,...
        'Передано неправильное имя файла для сохранения промежуточных результатов вычисления мультипликаторов');
      expFixedVarIndex = 3;
      testCase.verifyEqual(testCase.actFixedVarIndex,expFixedVarIndex,...
        'Передан неправильный номер переменной, которая фигурирует в уравнении секущей плоскости отображения Пуанкаре');
      expFixedVarValue = 0.5;
      testCase.verifyEqual(testCase.actFixedVarValue,expFixedVarValue,...
        'Передано неправильное значение переменной, которая фигурирует в уравнении секущей плоскости отображения Пуанкаре');
      nspecies = testCase.nprey+testCase.npredator;
      nvar = length(testCase.X)*nspecies;
      testCase.verifyEqual(testCase.actNVar,nvar,...
        'Передано неправильное число переменных');
      nonNegative = 1:nvar;
      testCase.verifyEqual(testCase.actNonNegativeMultipliers,...
        nonNegative,...
        'Переданы неправильные индексы неотрицательных переменных');
      outputFcn = @odephas2;
      testCase.verifyEqual(testCase.actOutputFcnMultipliers,outputFcn,...
        'Передана неправильная функция вывода');
      outputSel = [3,8];
      testCase.verifyEqual(testCase.actOutputSelMultipliers,outputSel,...
        'Переданы неправильные индексы выводимых переменных');
    end
    
    function testPassesParamsToSolverIfMultipliersAreComputed(testCase)
      testCase.markIntermediateSolutionFileExistent();
      testCase.multipliers = [1.002 0.998];      
      testCase.act();
      testCase.verifyEqual(testCase.actRightPartsSolver,testCase.rightParts,'Переданы неправильные правые части системы');
      testCase.verifyEqual(testCase.actTStepSolver,testCase.tstep,'Передан неправильный шаг интегрирования по времени');
      testCase.verifyEqual(testCase.actTLastSolver,testCase.period,'Передано неправильное конечное время интервала интегрирования по времени');
      testCase.verifyEqual(testCase.actW0Solver,testCase.w0,'Переданы неправильные начальные данные');
      nspecies = testCase.nprey+testCase.npredator;
      nvar = length(testCase.X)*nspecies;
      nonNegative = 1:nvar;
      testCase.verifyEqual(testCase.actNonNegativeSolver,nonNegative,'Переданы неправильные индексы неотрицательных переменных');
      outputFcn = @odephas2;
      testCase.verifyEqual(testCase.actOutputFcnSolver,outputFcn,'Передана неправильная функция вывода');
      outputSel = [3,8];
      testCase.verifyEqual(testCase.actOutputSelSolver,outputSel,'Переданы неправильные индексы выводимых переменных');
    end
    
    function testDoesNotCallSolverIfMultipliersAreNotComputed(testCase)
      testCase.markIntermediateSolutionFileExistent();
      testCase.act();
      testCase.verifyFalse(testCase.solverWasCalled,'Был вызван решатель, хотя расчет мультипликаторов не был завершен');
    end
    
    function testPrintsComputationTimeIfMultipliersComputed(testCase)
      testCase.markIntermediateSolutionFileExistent();
      testCase.multipliers = [1.002 0.998];
      testCase.computationTime = 100;
      testCase.act();
      testCase.verifyFalse(isempty(findCell(testCase.printedValsArray,...
        @(cell) cell == testCase.computationTime)),...
        'Не было выведено время вычисления мультипликаторов');
    end
    
    function testDoesNotPrintComputationTimeIfMultipliersAreNotComputed(testCase)
      testCase.markIntermediateSolutionFileExistent();
      testCase.act();
      testCase.verifyTrue(isempty(findCell(testCase.printedValsArray,...
        @(cell) cell == testCase.computationTime)),...
        'Было выведено время вычисления мультипликаторов, хотя расчет мультипликаторов не был завершен');
    end
    
    function testDisplaysMultipliersIfTheyAreComputed(testCase)
      testCase.markIntermediateSolutionFileExistent();
      testCase.multipliers = [1.002 0.998];
      testCase.act();
      testCase.verifyEqual(testCase.displayedValsArray,...
        testCase.multipliers,'Не были выведены мультипликаторы');
    end
    
    function testSavesMultipliersIfTheyAreComputed(testCase)
      testCase.markIntermediateSolutionFileExistent();
      testCase.multipliers = [1.002 0.998];
      testCase.act();
      testCase.verifyFalse(isempty(find(strcmp(...
        testCase.savedVars.(testCase.finalMultipliersFilepath),...
        'multipliers'),1)),'Не были сохранены мультипликаторы');
    end
    
    function testSavesComputationTimeIfMultipliersAreComputed(testCase)
      testCase.markIntermediateSolutionFileExistent();
      testCase.multipliers = [1.002 0.998];
      testCase.act();
      testCase.verifyFalse(isempty(find(strcmp(...
        testCase.savedVars.(testCase.finalMultipliersFilepath),...
        'computationTime'),1)),...
        'Не было сохранено время вычисления мультипликаторов');
    end
    
    function testDoesNotSaveMultipliersIfTheyAreNotComputed(testCase)
      testCase.markIntermediateSolutionFileExistent();
      testCase.act();
      testCase.verifyFalse(isfield(testCase.savedVars,...
        testCase.finalMultipliersFilepath),...
        'Был сохранен пустой массив мультипликаторов');
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
        'Не было создано новое окно для рисунка');
      testCase.verifyLessThan(figureCallNo,solverCallNo,...
        'Новое окно не было создано перед вызовом решателя');
    end
    
    function testSavesSolutionOnPeriod(testCase)
      testCase.markIntermediateSolutionFileExistent();
      testCase.multipliers = [1.002 0.998];
      testCase.act();
      testCase.verifyTrue(isfield(testCase.savedVars,...
        testCase.finalSolutionFilepath),'Решение на периоде не было сохранено');
      testCase.verifyFalse(isempty(find(strcmp(...
        testCase.savedVars.(testCase.finalSolutionFilepath),'w'),1)),...
        'Решение на периоде не было сохранено');
    end
  end
  
end

