classdef DoSolveAndFindPoincareMapCoreTest < TestCaseBase
  
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
    t
    w
    tpoincare
    wpoincare
    solutionResultsFilename
    preyDiffusionCoeff
    secondPredatorDiffusionCoeff
    resourceDeviation
    N
    
    actRightParts
    actTSpan
    actW0
    actNonNegative
    actOutputFcn
    actOutputSel
    actFixedVarIndex
    actFixedVarValue
    actW
        
    argsPassedInToGetInitialDataArr
    
    existent
    createdDirArray
    savedVars
    
    preyDiffusionCoeffPassedInToGetParams
    secondPredatorDiffusionCoeffPassedInToGetParams
    resourceDeviationPassedInToGetParams
    NPassedInToGetParams
  end
  
  methods (TestMethodSetup)
    function setup(testCase)      
      testCase.N = 5;
      
      testCase.rightParts = @() {};
      testCase.linearizedSystem = @() {};
      testCase.resource = @() {};      
      testCase.nprey = 1;
      testCase.npredator = 2;
      testCase.tstep = 0.002;
      testCase.tf = 50;
      testCase.w0 = [1 2 1 2 1 1 2 1 2 1 1 2 1 2 1];      
      testCase.t = [2 3];
      testCase.wpoincare = [2 3
                            4 5];
      
      testCase.argsPassedInToGetInitialDataArr = [];
      
      testCase.filenamesPassedInToLoad = {};
      
      testCase.savedVars = [];
      testCase.createdDirArray = {};
    end
  end
  
  methods (Access = private)
    function [t,w,tpoincare,wpoincare] = fakeSolver(testCase,rightParts,...
        tspan,w0,options,fixedVarIndex,fixedVarValue)
      testCase.actRightParts = rightParts;
      testCase.actTSpan = tspan;
      testCase.actW0 = w0;

      testCase.actNonNegative = odeget(options,'NonNegative');
      testCase.actOutputFcn = odeget(options,'OutputFcn');
      testCase.actOutputSel = odeget(options,'OutputSel');
      testCase.actFixedVarIndex = fixedVarIndex;
      testCase.actFixedVarValue = fixedVarValue;

      t = testCase.t;
      w = testCase.w;
      tpoincare = testCase.tpoincare;
      wpoincare = testCase.wpoincare;
    end

    function [ rightParts,linearizedSystem,resource,nprey,npredator,tstep ] = ...
        fakeParams(testCase,preyDiffusionCoeff,...
          secondPredatorDiffusionCoeff,resourceDeviation,N)
      testCase.secondPredatorDiffusionCoeffPassedInToGetParams = ...
        secondPredatorDiffusionCoeff;
      testCase.preyDiffusionCoeffPassedInToGetParams = preyDiffusionCoeff;
      testCase.resourceDeviationPassedInToGetParams = resourceDeviation;
      testCase.NPassedInToGetParams = N;
      
      rightParts = testCase.rightParts;
      linearizedSystem = testCase.linearizedSystem;
      resource = testCase.resource;

      nprey = testCase.nprey;
      npredator = testCase.npredator;

      tstep = testCase.tstep;
    end
      
    function exists = fakeExist(testCase,name,~)
      exists = ~isempty(find(strcmp(testCase.existent,name),1));
    end
    
    function w0 = fakeGetInitialData(testCase,N,h)
      argsInfo = struct;
      argsInfo.N = N;
      argsInfo.h = h;
      testCase.argsPassedInToGetInitialDataArr = ...
        [testCase.argsPassedInToGetInitialDataArr,argsInfo];
      w0 = testCase.w0;
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
    
    function setupResultsFilename(testCase)
      testCase.dirname = 'dir\';
      testCase.solutionResultsFilename = 'results.mat';
    end
    
    function setupResultsFileExistent(testCase)
      testCase.existent = 'dir\solution_results\results.mat';
    end
    
    function setupNewSolution(testCase,N)
      nrow = 2;
      nspecies = 3;
      ncol = N*nspecies;
      testCase.w = ones(nrow,ncol);
    end
    
    function setupBothNonZeroPredatorsSolutionToLoad(testCase,N)
      testCase.setupResultsFilename();
      testCase.setupResultsFileExistent();
      testCase.setupNewSolution(N);
      
      testCase.varsToLoad = struct;
      testCase.varsToLoad.filename = 'dir\solution_results\results.mat';
      vars = struct;
      
      nspecies = 3;
      nrow = 2;
      ncol = nspecies*N;
      
      vars.w = zeros(nrow,ncol);
      vars.w(1,:) = 1;
      vars.w(2,1:N) = 1;
      
      vars.w(2,N+1) = 0;
      vars.w(2,N+2) = 1;
      vars.w(2,N+3:2*N) = 0;
      
      vars.w(2,2*N+1) = 0;
      vars.w(2,2*N+2) = 1;
      vars.w(2,2*N+3:3*N) = 0;
      
      testCase.varsToLoad.vars = vars;
    end
    
    function setupZeroFirstPredatorSolutionToLoad(testCase,N)
      testCase.setupResultsFilename();
      testCase.setupResultsFileExistent();
      testCase.setupNewSolution(N);
      
      testCase.varsToLoad = struct;
      testCase.varsToLoad.filename = 'dir\solution_results\results.mat';
      vars = struct;
      
      nspecies = 3;
      nrow = 2;
      ncol = nspecies*N;
      
      vars.w = zeros(nrow,ncol);
      vars.w(1,:) = 1;
      vars.w(2,1:N) = 1;
      
      vars.w(2,N+1:2*N) = 0;
      
      vars.w(2,2*N+1) = 0;
      vars.w(2,2*N+2) = 1;
      vars.w(2,2*N+3:3*N) = 0;
      
      testCase.varsToLoad.vars = vars;
    end
    
    function setupZeroSecondPredatorSolutionToLoad(testCase,N)
      testCase.setupResultsFilename();
      testCase.setupResultsFileExistent();
      testCase.setupNewSolution(N);
      
      testCase.varsToLoad = struct;
      testCase.varsToLoad.filename = 'dir\solution_results\results.mat';
      vars = struct;
      
      nspecies = 3;
      nrow = 2;
      ncol = nspecies*N;
      
      vars.w = zeros(nrow,ncol);
      vars.w(1,:) = 1;
      vars.w(2,1:N) = 1;
      
      vars.w(2,N+1) = 0;
      vars.w(2,N+2) = 1;
      vars.w(2,N+3:2*N) = 0;
      
      vars.w(2,2*N+1:3*N) = 0;
      
      testCase.varsToLoad.vars = vars;
    end  
    
    function act(testCase)
      doSolveAndFindPoincareMapCore(testCase.solutionResultsFilename,...
        testCase.preyDiffusionCoeff,...
        testCase.secondPredatorDiffusionCoeff,...
        testCase.resourceDeviation,testCase.N,testCase.tf,...
        @testCase.fakeGetInitialData,@testCase.fakeCurrentDirName,...        
        @testCase.fakeExist,@testCase.fakeLoad,@testCase.fakeMakeDir,...
        @testCase.fakeSave,@testCase.fakeParams,@testCase.fakeSolver);
    end
  end
  
  methods (Test)
    function testGetsInitialDataIfFileDoesNotExist(testCase)
      testCase.existent = [];
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
      testCase.setupBothNonZeroPredatorsSolutionToLoad(testCase.N);
      testCase.act();
      testCase.verifyTrue(...
        isempty(testCase.argsPassedInToGetInitialDataArr),...
        'Получены начальные данные для решения до установления, хотя уже было сохраненное решение'); 
    end
    
    function testDoesNotAttemptToLoadSolutionIfFileDoesNotExist(testCase)
      testCase.existent = [];
      testCase.act();
      testCase.verifyTrue(isempty(find(strcmp(...
        testCase.filenamesPassedInToLoad,...
        'dir\solution_results\results.mat'),1)),...
        'Попытка загрузки из несуществующего файла');
    end
    
    function testGetsParams(testCase)
      testCase.secondPredatorDiffusionCoeff = 0.24;
      testCase.act();
      testCase.verifyEqual(...
        testCase.preyDiffusionCoeffPassedInToGetParams,...
        testCase.preyDiffusionCoeff,...
        'Передан неправильный коэффициент диффузии жертвы');
      testCase.verifyEqual(...
        testCase.secondPredatorDiffusionCoeffPassedInToGetParams,...
        testCase.secondPredatorDiffusionCoeff,...
        'Передан неправильный коэффициент диффузии второго хищника');
      testCase.verifyEqual(...
        testCase.resourceDeviationPassedInToGetParams,...
        testCase.resourceDeviation,...
        'Передана неправильная амплитуда функции ресурса');
      testCase.verifyEqual(testCase.NPassedInToGetParams,testCase.N,...
        'Не получены параметры');
      testCase.verifyEqual(testCase.NPassedInToGetParams,testCase.N,...
        'Не получены параметры');
    end
    
    function testSolvesSystemFromScratch(testCase)
      testCase.w0 = [1 2 1 2 1 0 1 0 0 0 0 1 0 0 0];
      testCase.act();
      
      testCase.verifyEqual(testCase.actRightParts,testCase.rightParts,...
        'Переданы неправильные правые части системы');
      testCase.verifyEqual(testCase.actTSpan,...
        0:testCase.tstep:testCase.tf,...
        'Передан неправильный временной интервал интегрирования');
      testCase.verifyEqual(testCase.actW0,...
        testCase.w0,...
        'Переданы неправильные начальные данные');
      
      nspecies = testCase.nprey+testCase.npredator;
      nvar = testCase.N*nspecies;
      nonNegative = 1:nvar;
      testCase.verifyEqual(testCase.actNonNegative,nonNegative,...
        'Переданы неправильные индексы неотрицательных переменных');
    end
    
    function testContinuesToSolveSystem(testCase)
      testCase.setupBothNonZeroPredatorsSolutionToLoad(testCase.N);
      
      testCase.act();
      
      testCase.verifyEqual(testCase.actRightParts,testCase.rightParts,...
        'Переданы неправильные правые части системы');
      testCase.verifyEqual(testCase.actTSpan,...
        0:testCase.tstep:testCase.tf,...
        'Передан неправильный временной интервал интегрирования');
      testCase.verifyEqual(testCase.actW0,...
        [1 1 1 1 1 0 1 0 0 0 0 1 0 0 0],...
        'Переданы неправильные начальные данные');
      
      nspecies = testCase.nprey+testCase.npredator;
      nvar = testCase.N*nspecies;
      nonNegative = 1:nvar;
      testCase.verifyEqual(testCase.actNonNegative,nonNegative,...
        'Переданы неправильные индексы неотрицательных переменных');
    end
    
    function testFindsPoincareMap(testCase)
      testCase.act();
      testCase.assertEqual(testCase.actFixedVarIndex,3,...
        'Передан неправильный индекс переменной, которая фигурирует в уравнении секущей плоскости отображения Пуанкаре');
      testCase.verifyEqual(testCase.actFixedVarValue,0.5,...
        'Передано неправильное значение переменной, которая фигурирует в уравнении секущей плоскости отображения Пуанкаре');
    end
    
    function testOutputsPhasePortrait(testCase)
      testCase.act();
      testCase.verifyEqual(testCase.actOutputFcn,@odephas2,...
        'В ходе решения не строится фазовый портрет');
    end
    
    function testOutputsRightFirstVarForNEqualTo5(testCase)
      testCase.existent = [];
      testCase.N = 5;
      testCase.act();
      expFirstOutputVarIndex = 3;
      testCase.verifyEqual(testCase.actOutputSel(1),...
        expFirstOutputVarIndex,...
        'Передан неправильный индекс первой выводимой переменной');
    end
    
    function testOutputsRightSecondVarForNEqualTo5WhenSolutionResultsFileDoesNotExist(testCase)
      testCase.existent = [];
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
      testCase.existent = [];
      testCase.N = 6;
      testCase.act();
      expFirstOutputVarIndex = 4;
      testCase.verifyEqual(testCase.actOutputSel(1),...
        expFirstOutputVarIndex,...
        'Передан неправильный индекс первой выводимой переменной');
    end
    
    function testOutputsRightSecondVarForNEqualTo6WhenSolutionResultsFileDoesNotExist(testCase)
      testCase.existent = [];
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
      testCase.N = 5;
      
      testCase.setupBothNonZeroPredatorsSolutionToLoad(testCase.N);
              
      testCase.act();
      expSecondOutputVarIndex = [8 13];
      testCase.verifyFalse(isempty(find(expSecondOutputVarIndex,...
        testCase.actOutputSel(2))),...
        'Передан неправильный индекс второй выводимой переменной');
      
      testCase.setupZeroSecondPredatorSolutionToLoad(testCase.N);
      
      testCase.act();
      expSecondOutputVarIndex = 8;
      testCase.verifyEqual(testCase.actOutputSel(2),...
        expSecondOutputVarIndex,...
        'Передан неправильный индекс второй выводимой переменной, когда плотность второй популяции хищников равна нулю');
      
      testCase.setupZeroFirstPredatorSolutionToLoad(testCase.N);
      
      testCase.act();
      expSecondOutputVarIndex = 13;
      testCase.verifyEqual(testCase.actOutputSel(2),...
        expSecondOutputVarIndex,...
        'Передан неправильный индекс второй выводимой переменной, когда плотность второй популяции хищников равна нулю');
    end
    
    function testOutputsRightSecondVarForNEqualTo6WhenSolutionResultsFileExists(testCase)
      testCase.N = 6;
      
      testCase.setupBothNonZeroPredatorsSolutionToLoad(testCase.N);
      
      testCase.act();
      expSecondOutputVarIndex = [10 16];
      testCase.verifyFalse(isempty(find(expSecondOutputVarIndex,...
        testCase.actOutputSel(2))),...
        'Передан неправильный индекс второй выводимой переменной');
      
      testCase.setupZeroSecondPredatorSolutionToLoad(testCase.N);
      
      testCase.act();
      expSecondOutputVarIndex = 10;
      testCase.verifyEqual(testCase.actOutputSel(2),...
        expSecondOutputVarIndex,...
        'Передан неправильный индекс второй выводимой переменной, когда плотность второй популяции хищников равна нулю');
      
      testCase.setupZeroFirstPredatorSolutionToLoad(testCase.N);
      
      testCase.act();
      expSecondOutputVarIndex = 16;
      testCase.verifyEqual(testCase.actOutputSel(2),...
        expSecondOutputVarIndex,...
        'Передан неправильный индекс второй выводимой переменной, когда плотность первой популяции хищников равна нулю');
    end    
    
    function testCreatesSolutionResultsDir(testCase)
      testCase.setupResultsFilename();
      testCase.act();
      testCase.verifyFalse(isempty(find(strcmp(...
        testCase.createdDirArray,...
        'dir\solution_results\'),1)),...
        'Не создана папка с промежуточными результатами решения');
    end
    
    function testSavesSolution(testCase)
      testCase.setupBothNonZeroPredatorsSolutionToLoad(5);
      
      testCase.act();
      
      resultsFilename = 'dir\solution_results\results.mat';
      loaded = testCase.varsToLoad(arrayfun(...
        @(l) strcmp(l.filename,resultsFilename),...
        testCase.varsToLoad));
      
      testCase.verifyFalse(isempty(find(arrayfun(...
        @(s) strcmp(s.filename,resultsFilename)...
        && isequal(s.vars.w,...
          [loaded.vars.w;testCase.w]),...
        testCase.savedVars),1)),...
        'Не сохранено решение');
    end
    
    function testSavesLastPoincareMapPoint(testCase)
      testCase.setupResultsFilename();
      testCase.act();
      testCase.verifyFalse(isempty(find(arrayfun(...
        @(s) strcmp(s.filename,'dir\solution_results\results.mat')...
        && isequal(s.vars.wpoincareend,[4 5]),testCase.savedVars),1)),...
        'Не сохранена последняя точка отображения Пуанкаре');
    end
    
    function testSavesPeriodIfMoreThan2SecantPlaneIntersections(testCase)
      testCase.setupResultsFilename();
      testCase.tpoincare = [40 70 100];
      testCase.act();
      testCase.verifyFalse(isempty(find(arrayfun(...
        @(s) strcmp(s.filename,'dir\solution_results\results.mat')...
        && s.vars.T == 60,testCase.savedVars),1)),...
        'Не сохранен период');
    end
    
    function testDoesNotSavePeriodIfLessThan3SecantPlaneIntersections(testCase)
      testCase.setupResultsFilename();
      testCase.tpoincare = [40 70];
      testCase.act();
      testCase.verifyTrue(isempty(find(arrayfun(...
        @(s) strcmp(s.filename,'dir\solution_results\results.mat')...
        && isfield(s.vars,'T'),testCase.savedVars),1)),...
        'Попытка сохранить период, когда менее трех пересечений секущей плоскости');
    end
  end
  
end

