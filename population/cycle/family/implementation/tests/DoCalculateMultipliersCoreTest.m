classdef DoCalculateMultipliersCoreTest < ...
    MFilenameAndGetFileDirnameTestBase & LoadTestHelper...
    & SaveVarsTestHelper
  
  properties
    solutionResultsFilename
    solver
      
    preyDiffusionCoeff
    secondPredatorDiffusionCoeff
    firstPredatorMortality
    resourceVariation
    
    isGetPoincareMapLastPointCalled
    solPassedInToGetPoincareMapLastPoint
    fixedVarIndexPassedInToGetPoincareMapLastPoint
    fixedVarValuePassedInToGetPoincareMapLastPoint
    poincareMapLastPoint       
    
    isGetPeriodCalled
    timesPassedInToGetPeriod
    solPassedInToGetPeriod
    fixedVarIndexPassedInToGetPeriod
    fixedVarValuePassedInToGetPeriod
    period
    
    isCalculateMultipliersCalled
    rightPartsPassedInToCalculateMultipliers
    linearizedSystemPassedInToCalculateMultipliers
    solverPassedInToCalculateMultipliers
    tstepPassedInToCalculateMultipliers
    tlastPassedInToCalculateMultipliers
    poincareMapLastPointPassedInToCalculateMultipliers
    nvarPassedInToCalculateMultipliers
    monodromyMatrixFilenamePassedInToCalculateMultipliers
    fixedVarIndexPassedInToCalculateMultipliers
    fixedVarValuePassedInToCalculateMultipliers
    nonNegativePassedInToCalculateMultipliers
    outputFcnPassedInToCalculateMultipliers
    outputSelPassedInToCalculateMultipliers    
    multipliers
    computationTime    
    
    existent
    createdDirName     
       
    printedValsArray
    displayedValsArray
  end
    
  methods
    function [multipliers,computationTime] = fakeCalculateMultipliers(...
        testCase,rightParts,linearizedSystem,solver,tspan,...
        poincareMapLastPoint,nvar,monodromyMatrixFilename,...
        fixedVarIndex,fixedVarValue,opts,outputOpts)      
      testCase.isCalculateMultipliersCalled = true;
      testCase.rightPartsPassedInToCalculateMultipliers = rightParts;
      testCase.linearizedSystemPassedInToCalculateMultipliers = ...
        linearizedSystem;
      testCase.solverPassedInToCalculateMultipliers = solver;
      testCase.tstepPassedInToCalculateMultipliers = tspan(2)-tspan(1);
      testCase.tlastPassedInToCalculateMultipliers = tspan(end);
      testCase.poincareMapLastPointPassedInToCalculateMultipliers = ...
        poincareMapLastPoint;
      testCase.nvarPassedInToCalculateMultipliers = nvar;
      testCase.monodromyMatrixFilenamePassedInToCalculateMultipliers = ...
        monodromyMatrixFilename;
      testCase.fixedVarIndexPassedInToCalculateMultipliers = fixedVarIndex;
      testCase.fixedVarValuePassedInToCalculateMultipliers = fixedVarValue;
      testCase.nonNegativePassedInToCalculateMultipliers = ...
        odeget(opts,'NonNegative');
      testCase.outputFcnPassedInToCalculateMultipliers = ...
        odeget(outputOpts,'OutputFcn');
      testCase.outputSelPassedInToCalculateMultipliers = ...
        odeget(outputOpts,'OutputSel');
      
      multipliers = testCase.multipliers;
      computationTime = testCase.computationTime;
    end
        
    function exists = fakeExist(testCase,name,~)
      exists = ~isempty(find(strcmp(testCase.existent,name),1));
    end
    
    function fakeMakeDir(testCase,folderName)
      testCase.createdDirName = folderName;
    end
    
    function pt = fakeGetPoincareMapLastPoint(testCase,w,fixedVarIndex,...
        fixedVarValue)
      testCase.isGetPoincareMapLastPointCalled = true;
      testCase.solPassedInToGetPoincareMapLastPoint = w;
      testCase.fixedVarIndexPassedInToGetPoincareMapLastPoint = ...
        fixedVarIndex;
      testCase.fixedVarValuePassedInToGetPoincareMapLastPoint = ...
        fixedVarValue;      
      
      pt = testCase.poincareMapLastPoint;
    end
    
    function T = fakeGetPeriod(testCase,t,w,fixedVarIndex,fixedVarValue)
      testCase.isGetPeriodCalled = true;
      testCase.timesPassedInToGetPeriod = t;
      testCase.solPassedInToGetPeriod = w;
      testCase.fixedVarIndexPassedInToGetPeriod = fixedVarIndex;
      testCase.fixedVarValuePassedInToGetPeriod = fixedVarValue;
      
      T = testCase.period;
    end
    
    function fakePrint(testCase,varargin)
      testCase.printedValsArray = [testCase.printedValsArray,varargin];
    end
  end
  
  methods (Access = protected)
    function act(testCase)
      doCalculateMultipliersCore(testCase.solutionResultsFilename,...
        testCase.preyDiffusionCoeff,...
        testCase.secondPredatorDiffusionCoeff,...
        testCase.firstPredatorMortality,testCase.resourceVariation,...
        @testCase.fakeMFilename,@testCase.fakeGetFileDirname,...
        @testCase.fakeExist,@testCase.fakeLoad,@testCase.fakeMakeDir,...
        @testCase.fakeSave,@testCase.fakeGetPoincareMapLastPoint,...
        @testCase.fakeGetPeriod,@testCase.fakeGetSystem,...
        @testCase.fakeCalculateMultipliers,testCase.solver,...
        @testCase.fakePrint,@testCase.fakeDisp);
    end
  end
  
  methods (Access = private)    
    function verifyGotPreyCenterPointVarExtremeValForNEqualTo3(testCase,...
        extremeValueKind,msgStart)
      N = 3;
      colIndex = 2;
      testCase.setupZeroFirstPredatorSolutionToLoadForNEqualTo3();
      testCase.verifyGotPreyCenterPointVarExtremeVal(N,colIndex,...
        extremeValueKind,msgStart);
    end
    
    function verifyGotPreyCenterPointVarExtremeValForNEqualTo4(testCase,...
        extremeValueKind,msgStart)
      N = 4;
      colIndex = 3;
      testCase.setupZeroFirstPredatorSolutionToLoadForNEqualTo4();
      testCase.verifyGotPreyCenterPointVarExtremeVal(N,colIndex,...
        extremeValueKind,msgStart);
    end
    
    function verifyGotPreyCenterPointVarExtremeVal(testCase,N,colIndex,...
        extremeValueKind,msgStart)
      testCase.act();
      args = struct;
      args.matr = testCase.varsToLoad.w;
      args.colIndex = colIndex;
      args.extremeValueKind = extremeValueKind;      
      testCase.verifyContainsItem(...
        testCase.argsPassedInToGetLastRowWithExtremeElementValue,args,...
        testCase.getMsg(msgStart,N));
    end
    
    function verifyRightVarIndicesPassedToCalculateMultipliers(testCase,...
        N,nvar,preyCenterPointVarIndex,firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex)      
      lastPoint = zeros(1,nvar);
      lastPoint(N+2) = 1;      
      lastPoint(2*N+2) = 1;
      testCase.setupSolutionToLoad(lastPoint);
            
      testCase.act();
      
      msgEnding = sprintf(' при N = %d',N);
      
      testCase.verifyEqual(...
        testCase.fixedVarIndexPassedInToCalculateMultipliers,...
        preyCenterPointVarIndex,...
        strcat('В функцию вычисления мультипликаторов передан неправильный номер переменной, которая фигурирует в уравнении секущей плоскости отображения Пуанкаре,',msgEnding));
      
      testCase.verifyEqual(...
        testCase.outputSelPassedInToCalculateMultipliers(1),...
        preyCenterPointVarIndex,...
        strcat('В функцию вычисления мультипликаторов передан неправильный индекс первой выводимой переменной',msgEnding));
      expSecondOutputVarIndex = [firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex];
      testCase.verifyFalse(isempty(find(expSecondOutputVarIndex,...
        testCase.outputSelPassedInToCalculateMultipliers(2))),...
        strcat('В функцию вычисления мультипликаторов передан неправильный индекс второй выводимой переменной, когда плотность обеих популяций хищников отлична от нуля,',msgEnding));
      
      lastPoint = zeros(1,nvar);      
      lastPoint(N+2) = 1;
      testCase.poincareMapLastPoint = lastPoint;
      testCase.setupSolutionToLoad(lastPoint);
      
      testCase.act();
      testCase.verifyEqual(...
        testCase.outputSelPassedInToCalculateMultipliers(2),...
        firstPredatorCenterPointVarIndex,...
        strcat('В функцию вычисления мультипликаторов передан неправильный индекс второй выводимой переменной, когда плотность второй популяции хищников равна нулю,',msgEnding));
      
      testCase.setupZeroFirstPredatorSolutionToLoad(nvar);
      
      testCase.act();
      testCase.verifyEqual(...
        testCase.outputSelPassedInToCalculateMultipliers(2),...
        secondPredatorCenterPointVarIndex,...
        strcat('В функцию вычисления мультипликаторов передан неправильный индекс второй выводимой переменной, когда плотность первой популяции хищников равна нулю,',msgEnding));
    end
    
    function setupNonUniformSolutionToLoadForNEqualTo3(testCase)          
      testCase.setupZeroFirstPredatorSolutionToLoadForNEqualTo3();      
      preyCenterPointVarIndex = 2;
      testCase.varsToLoad.w(2,preyCenterPointVarIndex) = -1;
      testCase.varsToLoad.w(7,preyCenterPointVarIndex) = 4;
    end
    
    function setupZeroFirstPredatorSolutionToLoadForNEqualTo3(testCase)
      nvar = 9;
      testCase.setupTSpan();      
      testCase.setupZeroFirstPredatorSolutionToLoad(nvar);      
    end
    
    function setupZeroFirstPredatorSolutionToLoadForNEqualTo4(testCase)
      nvar = 12;
      testCase.setupTSpan();      
      testCase.setupZeroFirstPredatorSolutionToLoad(nvar);      
    end
    
    function setupZeroFirstPredatorSolutionToLoad(testCase,nvar)      
      lastPoint = zeros(1,nvar);      
      testCase.setupSolutionToLoad(lastPoint);
    end
    
    function setupTSpan(testCase)
      testCase.tstep = 1;
      testCase.period = 1;
    end
    
    function setupSolutionToLoad(testCase,poincareMapLastPoint)       
      testCase.poincareMapLastPoint = poincareMapLastPoint;      
      
      vars = struct;            
      vars.t = 1;
      
      nrow = 20;
      ncol = length(poincareMapLastPoint);
      
      w = zeros(nrow,ncol);
      for row = 1:nrow
        w(row,:) = poincareMapLastPoint;
      end
      
      vars.w = w;
      
      testCase.varsToLoad = vars;      
    end
  end
  
  methods (Test)
    function testGetsMFilename(testCase)
      testCase.setupZeroFirstPredatorSolutionToLoadForNEqualTo3();
      testCase.verifyGotMFilename();
    end
    
    function testGetsFileDirname(testCase)
      testCase.setupZeroFirstPredatorSolutionToLoadForNEqualTo3();
      testCase.verifyGotFileDirname();
    end
    
    function testLoadsSolution(testCase)
      testCase.solutionResultsFilename = 'results.mat';
      testCase.dirname = 'dir\';      
      testCase.setupZeroFirstPredatorSolutionToLoadForNEqualTo3();
      testCase.act();      
      args = struct;
      args.filename = 'dir\solution_results\results.mat';
      args.varnames = {'t','w'};      
      testCase.verifyContainsItem(testCase.argsPassedInToLoad,args,...
        'Не загружено решение');
    end
    
    function testGetsSystem(testCase)      
      testCase.setupZeroFirstPredatorSolutionToLoadForNEqualTo3();
      testCase.preyDiffusionCoeff = 1;
      testCase.secondPredatorDiffusionCoeff = 2;
      testCase.firstPredatorMortality = 3;
      testCase.resourceVariation = 4;
      N = 3;
      testCase.verifyGetsSystem(testCase.preyDiffusionCoeff,...
        testCase.secondPredatorDiffusionCoeff,...
        testCase.firstPredatorMortality,testCase.resourceVariation,N);
    end
    
%     function testGetsPreyCenterPointVarMinValForNEqualTo3(testCase)
%       testCase.verifyGotPreyCenterPointVarExtremeValForNEqualTo3('min',...
%         'Не получен минимум жертвы в центре ареала');
%     end
%     
%     function testGetsPreyCenterPointVarMinValForNEqualTo4(testCase)
%       testCase.verifyGotPreyCenterPointVarExtremeValForNEqualTo4('min',...
%         'Не получен минимум жертвы в центре ареала');
%     end
%     
%     function testGetsPreyCenterPointVarMaxValForNEqualTo3(testCase)
%       testCase.verifyGotPreyCenterPointVarExtremeValForNEqualTo3('max',...
%         'Не получен максимум жертвы в центре ареала');
%     end
%     
%     function testGetsPreyCenterPointVarMaxValForNEqualTo4(testCase)
%       testCase.verifyGotPreyCenterPointVarExtremeValForNEqualTo4('max',...
%         'Не получен максимум жертвы в центре ареала');
%     end
    
    function testGetsPoincareMapLastPoint(testCase)
      testCase.isGetPoincareMapLastPointCalled = false;
      
      testCase.setupNonUniformSolutionToLoadForNEqualTo3();
      
      testCase.act();
      testCase.assertTrue(testCase.isGetPoincareMapLastPointCalled,...
        'Не вызвана функция получения последней точки отображения Пуанкаре');
      testCase.verifyEqual(...
        testCase.solPassedInToGetPoincareMapLastPoint,...
        testCase.varsToLoad.w,...
        'В функцию получения последней точки отображения Пуанкаре передано неправильное решение');
      expFixedVarIndex = 2;      
      testCase.verifyEqual(...
        testCase.fixedVarIndexPassedInToGetPoincareMapLastPoint,...
        expFixedVarIndex,...
        'В функцию получения последней точки отображения Пуанкаре передан неправильный индекс переменной, которая фигурирует в уравнении секущей плоскости отображения Пуанкаре');
      expFixedVarValue = 1.5;
      testCase.verifyEqual(...
        testCase.fixedVarValuePassedInToGetPoincareMapLastPoint,...
        expFixedVarValue,...
        'В функцию получения последней точки отображения Пуанкаре передано неправильное значение переменной, которая фигурирует в уравнении секущей плоскости отображения Пуанкаре');
    end
    
    function testGetsPeriod(testCase)
      testCase.isGetPeriodCalled = false;
      testCase.setupNonUniformSolutionToLoadForNEqualTo3();
      testCase.act();
      testCase.assertTrue(testCase.isGetPeriodCalled,...
        'Не вызвана функция получения периода');
      testCase.verifyEqual(...
        testCase.timesPassedInToGetPeriod,...
        testCase.varsToLoad.t,...
        'В функцию нахождения периода передан неправильный массив времен');
      testCase.verifyEqual(...
        testCase.solPassedInToGetPeriod,...
        testCase.varsToLoad.w,...
        'В функцию нахождения периода передано неправильное решение');
      expFixedVarIndex = 2;      
      testCase.verifyEqual(...
        testCase.fixedVarIndexPassedInToGetPeriod,...
        expFixedVarIndex,...
        'В функцию нахождения периода передан неправильный индекс переменной, которая фигурирует в уравнении секущей плоскости отображения Пуанкаре');
      expFixedVarValue = 1.5;
      testCase.verifyEqual(...
        testCase.fixedVarValuePassedInToGetPeriod,...
        expFixedVarValue,...
        'В функцию нахождения периода передано неправильное значение переменной, которая фигурирует в уравнении секущей плоскости отображения Пуанкаре');
    end
    
    function testCalculateMultipliers(testCase)      
      testCase.solutionResultsFilename = 'results.mat';
      testCase.dirname = 'dir\';
      
      testCase.rightParts = 0;
      testCase.linearizedSystem = 1;
      testCase.solver = 2;
      testCase.tstep = 4;  
      
      testCase.setupNonUniformSolutionToLoadForNEqualTo3();
         
      testCase.period = 6;
      
      testCase.isCalculateMultipliersCalled = false;
      testCase.act();
      testCase.assertTrue(testCase.isCalculateMultipliersCalled,...
        'Не вызвана функция вычисления мультипликаторов');
      testCase.verifyEqual(...
        testCase.rightPartsPassedInToCalculateMultipliers,...
        testCase.rightParts,...
        'В функцию вычисления мультипликаторов переданы неправильные правые части системы');
      testCase.verifyEqual(...
        testCase.linearizedSystemPassedInToCalculateMultipliers,...
        testCase.linearizedSystem,...
        'В функцию вычисления мультипликаторов переданы неправильные правые части системы в вариациях');
      testCase.verifyEqual(...
        testCase.solverPassedInToCalculateMultipliers,testCase.solver,...
        'В функцию вычисления мультипликаторов передан неправильный решатель');
      testCase.verifyEqual(testCase.tstepPassedInToCalculateMultipliers,...
        testCase.tstep,...
        'В функцию вычисления мультипликаторов передан неправильный шаг интегрирования по времени');
      testCase.verifyGreaterThan(...
        testCase.tlastPassedInToCalculateMultipliers,testCase.period,...
        'В функцию вычисления мультипликаторов передано неправильное конечное время интервала интегрирования по времени');
      testCase.verifyEqual(...
        testCase.poincareMapLastPointPassedInToCalculateMultipliers,...
        testCase.poincareMapLastPoint,...
        'В функцию вычисления мультипликаторов переданы неправильные начальные данные');
      expMonodromyMatrixFilename = 'dir\monodromy_matrix\results.mat';
      testCase.verifyEqual(...
        testCase.monodromyMatrixFilenamePassedInToCalculateMultipliers,...
        expMonodromyMatrixFilename,...
        'В функцию вычисления мультипликаторов передано неправильное имя файла для сохранения промежуточных результатов');      
      expFixedVarValue = 1.5;
      testCase.verifyEqual(...
        testCase.fixedVarValuePassedInToCalculateMultipliers,...
        expFixedVarValue,...
        'В функцию вычисления мультипликаторов передано неправильное значение переменной, которая фигурирует в уравнении секущей плоскости отображения Пуанкаре');
      nvar = 9;
      testCase.verifyEqual(testCase.nvarPassedInToCalculateMultipliers,...
        nvar,...
        'В функцию вычисления мультипликаторов передано неправильное число переменных');
      expNonNegative = 1:nvar;
      testCase.verifyEqual(...
        testCase.nonNegativePassedInToCalculateMultipliers,...
        expNonNegative,...
        'В функцию вычисления мультипликаторов переданы неправильные индексы неотрицательных переменных');
      outputFcn = @odephas2;
      testCase.verifyEqual(...
        testCase.outputFcnPassedInToCalculateMultipliers,outputFcn,...
        'В функцию вычисления мультипликаторов передана неправильная функция вывода');
      
      N = 3;
      preyCenterPointVarIndex = 2;
      firstPredatorCenterPointVarIndex = 5;
      secondPredatorCenterPointVarIndex = 8;
      testCase.verifyRightVarIndicesPassedToCalculateMultipliers(N,nvar,...
        preyCenterPointVarIndex,firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
      
      N = 4;
      nvar = 12;
      preyCenterPointVarIndex = 3;
      firstPredatorCenterPointVarIndex = 7;
      secondPredatorCenterPointVarIndex = 11;
      testCase.verifyRightVarIndicesPassedToCalculateMultipliers(N,nvar,...
        preyCenterPointVarIndex,firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
    end
    
    function testPrintsComputationTimeIfMultipliersComputed(testCase)
      testCase.setupZeroFirstPredatorSolutionToLoadForNEqualTo3();
      testCase.multipliers = 0;
      testCase.printedValsArray = {};
      testCase.computationTime = 1;
      testCase.act();
      testCase.verifyContainsItem(testCase.printedValsArray,...
        testCase.computationTime,...
        'Не выведено время вычисления мультипликаторов');
    end
    
    function testDoesNotPrintComputationTimeIfMultipliersAreNotComputed(testCase)
      testCase.setupZeroFirstPredatorSolutionToLoadForNEqualTo3();
      testCase.computationTime = 0;
      testCase.act();
      testCase.verifyDoesNotContainItem(testCase.printedValsArray,...
        testCase.computationTime,...
        'Выведено время вычисления мультипликаторов, хотя расчет мультипликаторов не был завершен');
    end
    
    function testDisplaysMultipliersIfTheyAreComputed(testCase)
      testCase.setupZeroFirstPredatorSolutionToLoadForNEqualTo3();
      testCase.multipliers = {0 1};
      testCase.printedValsArray = {};
      testCase.verifyDisplayed(testCase.multipliers,...
        'Не выведены мультипликаторы');
    end
    
    function testCreatesMultipliersFolderIfMultipliersAreComputed(testCase)
      testCase.setupZeroFirstPredatorSolutionToLoadForNEqualTo3();
      testCase.dirname = 'dir\';
      testCase.multipliers = 0;
      testCase.printedValsArray = {};
      testCase.act();
      testCase.verifyEqual(testCase.createdDirName,'dir\multipliers\',...
        'Не создана папка для результатов вычисления мультипликаторов');
    end
    
    function testDoesNotCreateMultipliersFolderIfMultipliersAreNotComputed(testCase)
      testCase.setupZeroFirstPredatorSolutionToLoadForNEqualTo3();
      testCase.dirname = 'dir\';
      testCase.act();
      testCase.verifyNotEqual(testCase.createdDirName,...
        'dir\multipliers\',...
        'Cоздана папка для результатов вычисления мультипликаторов, когда мультипликаторы не вычислены');
    end
    
    function testDoesNotAttemptToCreateMultipliersFolderIfItAlreadyExists(testCase)
      testCase.setupZeroFirstPredatorSolutionToLoadForNEqualTo3();
      testCase.multipliers = 0;
      testCase.printedValsArray = {};
      testCase.dirname = 'dir\';
      testCase.existent = 'dir\multipliers\';
      testCase.act();
      testCase.verifyNotEqual(testCase.createdDirName,testCase.existent,...
        'Попытка создания папки для результатов вычисления мультипликаторов, когда она уже существовала');
    end
    
    function testSavesVarsIfMultipliersAreComputed(testCase)
      testCase.solutionResultsFilename = 'results.mat';
      testCase.dirname = 'dir\';
      testCase.setupZeroFirstPredatorSolutionToLoadForNEqualTo3();
      testCase.multipliers = [0 1];
      testCase.printedValsArray = {};
      testCase.computationTime = 2;
      testCase.act();
      argsInfo = struct;
      argsInfo.filename = 'dir\multipliers\results.mat';
      vars = struct;
      vars.multipliers = testCase.multipliers;
      vars.computationTime = testCase.computationTime;
      argsInfo.vars = vars;
      testCase.verifyContainsItem(testCase.argsPassedInToSaveArr,...
        argsInfo,'Не сохранены результаты');
    end
        
    function testDoesNotSaveVarsIfMultipliersAreNotComputed(testCase)
      testCase.setupZeroFirstPredatorSolutionToLoadForNEqualTo3();
      testCase.multipliers = [];
      testCase.act();
      testCase.verifyDoesNotContainItem(testCase.argsPassedInToSaveArr,...
          'dir\multipliers\results.mat',...
        'Попытка сохранить несуществующие результаты');
    end
  end
  
end

