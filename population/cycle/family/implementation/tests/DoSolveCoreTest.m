classdef DoSolveCoreTest < matlab.unittest.TestCase
  
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
    
    argsPassedInToGetInitialDataArr
    
    existent
    createdDirArray
    varsToReturnFromLoad
    loadedVars
    savedVars
    
    isGetParamsCalled
    preyDiffusionCoeffPassedInToGetParams
    secondPredatorDiffusionCoeffPassedInToGetParams
    resourceDeviationPassedInToGetParams
    NPassedInToGetParams
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
      testCase.resourceDeviation = 0.2;
      testCase.tspan = 0:0.002:50;
      testCase.w0 = [1 2 1 2 1 1 2 1 2 1 1 2 1 2 1];
      testCase.w = [2 3 2 3 2 2 3 2 3 2 2 3 2 3 2
                    4 5 4 5 4 4 5 4 5 4 4 5 4 5 4];
      testCase.t = [2 3];
      
      testCase.argsPassedInToGetInitialDataArr = [];
      
      testCase.varsToReturnFromLoad = struct;
      testCase.varsToReturnFromLoad.w = [2 3 2 3 2 2 3 2 3 2 2 3 2 3 2
                                         1 2 1 2 1 1 2 1 2 1 1 2 1 2 1];
      testCase.varsToReturnFromLoad.t = [0 1];
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
          secondPredatorDiffusionCoeff,resourceDeviation,N)
      testCase.isGetParamsCalled = true;
      testCase.preyDiffusionCoeffPassedInToGetParams = preyDiffusionCoeff;
      testCase.secondPredatorDiffusionCoeffPassedInToGetParams = ...
        secondPredatorDiffusionCoeff;
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
    
    function w0 = fakeGetInitialData(testCase,N,h)
      argsInfo = struct;
      argsInfo.N = N;
      argsInfo.h = h;
      testCase.argsPassedInToGetInitialDataArr = ...
        [testCase.argsPassedInToGetInitialDataArr,argsInfo];
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
      doSolveCore(testCase.solutionResultsFilename,...
        testCase.preyDiffusionCoeff,...
        testCase.secondPredatorDiffusionCoeff,...
        testCase.resourceDeviation,testCase.N,testCase.tspan,...
        @testCase.fakeGetInitialData,@testCase.fakeGetFilename,...
        @testCase.fakeGetFileDir,@testCase.fakeExist,...
        @testCase.fakeLoad,@testCase.fakeMakeDir,@testCase.fakeSave,...
        @testCase.fakeParams,@testCase.fakeSolver);
    end
  end
  
  methods (Test)
    function testGetsFilename(testCase)
      testCase.act();
      testCase.verifyEqual(testCase.paramPassedInToGetFilename,...
        'fullpath','Не получено имя файла');
    end
    
    function testGetsFileDir(testCase)
      testCase.filename = 'filename';
      testCase.act();
      testCase.verifyEqual(testCase.paramPassedInToGetFileDir,...
        testCase.filename,'Не получен путь к папке с файлом');
    end
    
    function testGetsInitialDataIfFileDoesNotExist(testCase)
      testCase.existent = struct;
      testCase.existent.('file') = [];
      testCase.act();
      argsInfo = struct;
      argsInfo.N = testCase.N;
      a = 1;
      argsInfo.h = a/testCase.N;
      testCase.verifyFalse(isempty(find(...
        arrayfun(@(args) isequal(args,argsInfo),...
        testCase.argsPassedInToGetInitialDataArr),1)),...
        'Не получены начальные данные');
    end
    
    function testDoesNotGetInitialDataIfFileExists(testCase)
      testCase.solutionResultsFilename = 'results.mat';
      testCase.existent = struct;
      testCase.existent.('file') = 'solution_results\results.mat';
      testCase.act();
      testCase.verifyTrue(...
        isempty(testCase.argsPassedInToGetInitialDataArr),...
        'Получены начальные данные для решения до установления, хотя уже было сохраненное решение'); 
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
        loaded),testCase.loadedVars),1)),'Не загружено решение');
    end
    
    function testDoesNotAttemptToLoadSolutionIfFileDoesNotExist(testCase)
      testCase.dir = 'dir\';
      testCase.solutionResultsFilename = 'results.mat';
      testCase.existent = struct;
      testCase.existent.('file') = [];
      testCase.act();
      testCase.verifyFalse(isfield(testCase.loadedVars,...
        'dir\solution_results\results.mat'),...
        'Попытка загрузки из несуществующего файла');
    end
    
    function testGetsParams(testCase)
      testCase.isGetParamsCalled = false;
      testCase.act();
      testCase.assertTrue(testCase.isGetParamsCalled,...
        'Не получены параметры');
      testCase.verifyEqual(...
        testCase.preyDiffusionCoeffPassedInToGetParams,...
        testCase.preyDiffusionCoeff,...
        'В функцию получения системы передан неправильный коэффициент диффузии жертвы');
      testCase.verifyEqual(...
        testCase.secondPredatorDiffusionCoeffPassedInToGetParams,...
        testCase.secondPredatorDiffusionCoeff,...
        'В функцию получения системы передан неправильный коэффициент диффузии второго хищника');
      testCase.verifyEqual(...
        testCase.resourceDeviationPassedInToGetParams,...
        testCase.resourceDeviation,...
        'В функцию получения системы передано неправильное отклонение функции ресурса');
      testCase.verifyEqual(testCase.NPassedInToGetParams,testCase.N,...
        'В функцию получения системы передано неправильное число точек сетки');
    end
    
    function testSolvesSystem(testCase)      
      testCase.w0 = [1 2 1 2 1 0 1 0 0 0 0 1 0 0 0];
      testCase.act();
      
      testCase.verifyEqual(testCase.actRightParts,testCase.rightParts,...
        'Переданы неправильные правые части системы');
      testCase.verifyEqual(testCase.actTSpan,...
        testCase.tspan,...
        'Передан неправильный временной интервал интегрирования');
      testCase.verifyEqual(testCase.actW0,...
        testCase.w0,...
        'Переданы неправильные начальные данные');
      
      nspecies = testCase.nprey+testCase.npredator;
      nvar = testCase.N*nspecies;
      nonNegative = 1:nvar;
      testCase.verifyEqual(testCase.actNonNegative,nonNegative,...
        'Переданы неправильные индексы неотрицательных переменных'); 
      
      testCase.verifyEqual(testCase.actRelTol,1e-6,...
        'Передано неправильное относительное допутимое отклонение');
      testCase.verifyEqual(testCase.actAbsTol,1e-9,...
        'Передано неправильное абсолютное допутимое отклонение');
    end
    
    function testOutputsPhasePortrait(testCase)
      testCase.act();
      testCase.verifyEqual(testCase.actOutputFcn,@odephas2,...
        'В ходе решения не строится фазовый портрет');
    end
    
    function testOutputsRightFirstVarForNEqualTo5(testCase)
      testCase.N = 5;
      testCase.act();
      expFirstOutputVarIndex = 3;
      testCase.verifyEqual(testCase.actOutputSel(1),...
        expFirstOutputVarIndex,...
        'Передан неправильный индекс первой выводимой переменной');
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
        'Передан неправильный индекс второй выводимой переменной');
      
      testCase.w0 = [1 2 1 2 1 0 1 0 0 0 0 0 0 0 0];
      testCase.act();
      expSecondOutputVarIndex = 8;
      testCase.assertEqual(testCase.actOutputSel(2),...
        expSecondOutputVarIndex,...
        'Передан неправильный индекс второй выводимой переменной, когда плотность второй популяции хищников равна нулю');
      
      testCase.w0 = [1 2 1 2 1 0 0 0 0 0 0 1 0 0 0];
      testCase.act();
      expSecondOutputVarIndex = 13;
      testCase.verifyEqual(testCase.actOutputSel(2),...
        expSecondOutputVarIndex,...
        'Передан неправильный индекс второй выводимой переменной, когда плотность первой популяции хищников равна нулю');
    end
        
    function testOutputsRightFirstVarForNEqualTo6(testCase)
      testCase.N = 6;
      testCase.act();
      expFirstOutputVarIndex = 4;
      testCase.verifyEqual(testCase.actOutputSel(1),...
        expFirstOutputVarIndex,...
        'Передан неправильный индекс первой выводимой переменной');
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
        'Передан неправильный индекс второй выводимой переменной');
      
      testCase.w0 = [1 2 1 2 1 2 0 1 0 0 0 0 0 0 0 0 0 0];
      testCase.act();
      expSecondOutputVarIndex = 10;
      testCase.assertEqual(testCase.actOutputSel(2),...
        expSecondOutputVarIndex,...
        'Передан неправильный индекс второй выводимой переменной, когда плотность второй популяции хищников равна нулю');
      
      testCase.w0 = [1 2 1 2 1 2 0 0 0 0 0 0 0 1 0 0 0 0];
      testCase.act();
      expSecondOutputVarIndex = 16;
      testCase.verifyEqual(testCase.actOutputSel(2),...
        expSecondOutputVarIndex,...
        'Передан неправильный индекс второй выводимой переменной, когда плотность первой популяции хищников равна нулю');
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
        'Передан неправильный индекс второй выводимой переменной');
      
      testCase.varsToReturnFromLoad.w = [2 3 2 3 2 2 3 2 3 2 2 3 2 3 2
                                         1 2 1 2 1 0 1 0 0 0 0 0 0 0 0];
      testCase.act();
      expSecondOutputVarIndex = 8;
      testCase.verifyEqual(testCase.actOutputSel(2),...
        expSecondOutputVarIndex,...
        'Передан неправильный индекс второй выводимой переменной, когда плотность второй популяции хищников равна нулю');
      
      testCase.varsToReturnFromLoad.w = [2 3 2 3 2 2 3 2 3 2 2 3 2 3 2
                                         1 2 1 2 1 0 0 0 0 0 0 1 0 0 0];
      testCase.act();
      expSecondOutputVarIndex = 13;
      testCase.verifyEqual(testCase.actOutputSel(2),...
        expSecondOutputVarIndex,...
        'Передан неправильный индекс второй выводимой переменной, когда плотность второй популяции хищников равна нулю');
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
        'Передан неправильный индекс второй выводимой переменной');
      
      testCase.varsToReturnFromLoad.w = [2 3 2 3 2 3 2 3 2 3 2 3 2 3 2 3 2 3
                                         1 2 1 2 1 2 0 1 0 0 0 0 0 0 0 0 0 0];
      testCase.act();
      expSecondOutputVarIndex = 10;
      testCase.verifyEqual(testCase.actOutputSel(2),...
        expSecondOutputVarIndex,...
        'Передан неправильный индекс второй выводимой переменной, когда плотность второй популяции хищников равна нулю');
      
      testCase.varsToReturnFromLoad.w = [2 3 2 3 2 3 2 3 2 3 2 3 2 3 2 3 2 3
                                         1 2 1 2 1 2 0 0 0 0 0 0 0 1 0 0 0 0];
      testCase.act();
      expSecondOutputVarIndex = 16;
      testCase.verifyEqual(testCase.actOutputSel(2),...
        expSecondOutputVarIndex,...
        'Передан неправильный индекс второй выводимой переменной, когда плотность первой популяции хищников равна нулю');
    end    
    
    function testCreatesSolutionResultsDirIfItDoesNotExistYet(testCase)
      testCase.dir = 'dir\';
      testCase.existent = struct;
      testCase.existent.('dir') = [];
      testCase.act();
      testCase.verifyFalse(isempty(find(strcmp(...
        testCase.createdDirArray,...
        'dir\solution_results\'),1)),...
        'Не создана папка с промежуточными результатами решения');
    end
    
    function testDoesNotAttemptToCreateSolutionResultsDirIfItAlreadyExists(testCase)
      testCase.dir = 'dir\';
      testCase.existent = struct;
      testCase.existent.('dir') = 'dir\solution_results\';
      testCase.act();
      testCase.verifyTrue(isempty(find(strcmp(...
        testCase.createdDirArray,...
        'dir\solution_results\'),1)),...
        'Попытка создать уже существующую папку с промежуточными результатами решения');
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
      vars.t = [testCase.varsToReturnFromLoad.t,testCase.t];
      saved.vars = vars;
      testCase.verifyFalse(isempty(find(arrayfun(...
        @(s) isequal(s,saved),testCase.savedVars),1)),...
        'Не сохранено решение');
    end
  end
  
end

