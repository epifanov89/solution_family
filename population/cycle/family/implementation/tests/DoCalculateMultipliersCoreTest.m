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
    N
    
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
    function verifyRightVarIndicesPassedToCalculateMultipliers(testCase,...
        N,preyCenterPointVarIndex,firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex)
      lastPoint = testCase.getZeroArrayWithNVarColumns(N);
      lastPoint(N+2) = 1;      
      lastPoint(2*N+2) = 1;
      testCase.setupSolutionToLoad(lastPoint);
            
      testCase.act();
      
      msgEnding = sprintf(' ��� N = %d',N);
      
      testCase.verifyEqual(...
        testCase.fixedVarIndexPassedInToCalculateMultipliers,...
        preyCenterPointVarIndex,...
        strcat('� ������� ���������� ���������������� ������� ������������ ����� ����������, ������� ���������� � ��������� ������� ��������� ����������� ��������,',msgEnding));
      
      testCase.verifyEqual(...
        testCase.outputSelPassedInToCalculateMultipliers(1),...
        preyCenterPointVarIndex,...
        strcat('� ������� ���������� ���������������� ������� ������������ ������ ������ ��������� ����������',msgEnding));
      expSecondOutputVarIndex = [firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex];
      testCase.verifyFalse(isempty(find(expSecondOutputVarIndex,...
        testCase.outputSelPassedInToCalculateMultipliers(2))),...
        strcat('� ������� ���������� ���������������� ������� ������������ ������ ������ ��������� ����������, ����� ��������� ����� ��������� �������� ������� �� ����,',msgEnding));
      
      lastPoint = testCase.getZeroArrayWithNVarColumns(N);      
      lastPoint(N+2) = 1;
      testCase.poincareMapLastPoint = lastPoint;
      testCase.setupSolutionToLoad(lastPoint);
      
      testCase.act();
      testCase.verifyEqual(...
        testCase.outputSelPassedInToCalculateMultipliers(2),...
        firstPredatorCenterPointVarIndex,...
        strcat('� ������� ���������� ���������������� ������� ������������ ������ ������ ��������� ����������, ����� ��������� ������ ��������� �������� ����� ����,',msgEnding));
      
      testCase.setupZeroFirstPredatorSolutionToLoad(N);
      
      testCase.act();
      testCase.verifyEqual(...
        testCase.outputSelPassedInToCalculateMultipliers(2),...
        secondPredatorCenterPointVarIndex,...
        strcat('� ������� ���������� ���������������� ������� ������������ ������ ������ ��������� ����������, ����� ��������� ������ ��������� �������� ����� ����,',msgEnding));
    end
    
    function setupZeroFirstPredatorSolutionToLoadForNEqualTo5(testCase)
      N = 5;
      testCase.setupTSpan();      
      testCase.setupZeroFirstPredatorSolutionToLoad(N);      
    end
    
    function setupZeroFirstPredatorSolutionToLoad(testCase,N)      
      lastPoint = testCase.getZeroArrayWithNVarColumns(N);      
      testCase.setupSolutionToLoad(lastPoint);
    end
    
    function setupTSpan(testCase)
      testCase.tstep = 1;
      testCase.period = 1;
    end
    
    function arr = getZeroArrayWithNVarColumns(~,N)
      nspecies = 3;
      ncol = nspecies*N;
      arr = zeros(1,ncol);
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
      testCase.setupZeroFirstPredatorSolutionToLoadForNEqualTo5();
      testCase.verifyGotMFilename();
    end
    
    function testGetsFileDirname(testCase)
      testCase.setupZeroFirstPredatorSolutionToLoadForNEqualTo5();
      testCase.verifyGotFileDirname();
    end
    
    function testLoadsSolution(testCase)
      testCase.solutionResultsFilename = 'results.mat';
      testCase.dirname = 'dir\';      
      testCase.setupZeroFirstPredatorSolutionToLoadForNEqualTo5();
      testCase.act();      
      args = struct;
      args.filename = 'dir\solution_results\results.mat';
      args.varnames = {'t','w'};      
      testCase.verifyContainsItem(testCase.argsPassedInToLoad,args,...
        '�� ��������� �������');
    end
    
    function testGetsSystem(testCase)      
      testCase.setupZeroFirstPredatorSolutionToLoadForNEqualTo5();
      testCase.preyDiffusionCoeff = 1;
      testCase.secondPredatorDiffusionCoeff = 2;
      testCase.firstPredatorMortality = 3;
      testCase.resourceVariation = 4;
      testCase.N = 5;
      testCase.verifyGetsSystem(testCase.preyDiffusionCoeff,...
        testCase.secondPredatorDiffusionCoeff,...
        testCase.firstPredatorMortality,testCase.resourceVariation,...
        testCase.N);
    end
    
    function testGetsPoincareMapLastPoint(testCase)
      testCase.isGetPoincareMapLastPointCalled = false;
      testCase.setupZeroFirstPredatorSolutionToLoadForNEqualTo5();
      testCase.act();
      testCase.assertTrue(testCase.isGetPoincareMapLastPointCalled,...
        '�� ������� ������� ��������� ��������� ����� ����������� ��������');
      testCase.verifyEqual(...
        testCase.solPassedInToGetPoincareMapLastPoint,...
        testCase.varsToLoad.w,...
        '� ������� ��������� ��������� ����� ����������� �������� �������� ������������ �������');
      expFixedVarIndex = 3;      
      testCase.verifyEqual(...
        testCase.fixedVarIndexPassedInToGetPoincareMapLastPoint,...
        expFixedVarIndex,...
        '� ������� ��������� ��������� ����� ����������� �������� ������� ������������ ������ ����������, ������� ���������� � ��������� ������� ��������� ����������� ��������');
      expFixedVarValue = 0.5;
      testCase.verifyEqual(...
        testCase.fixedVarValuePassedInToGetPoincareMapLastPoint,...
        expFixedVarValue,...
        '� ������� ��������� ��������� ����� ����������� �������� ������� ������������ �������� ����������, ������� ���������� � ��������� ������� ��������� ����������� ��������');
    end
    
    function testGetsPeriod(testCase)
      testCase.isGetPeriodCalled = false;
      testCase.setupZeroFirstPredatorSolutionToLoadForNEqualTo5();
      testCase.act();
      testCase.assertTrue(testCase.isGetPeriodCalled,...
        '�� ������� ������� ��������� �������');
      testCase.verifyEqual(...
        testCase.timesPassedInToGetPeriod,...
        testCase.varsToLoad.t,...
        '� ������� ���������� ������� ������� ������������ ������ ������');
      testCase.verifyEqual(...
        testCase.solPassedInToGetPeriod,...
        testCase.varsToLoad.w,...
        '� ������� ���������� ������� �������� ������������ �������');
      expFixedVarIndex = 3;      
      testCase.verifyEqual(...
        testCase.fixedVarIndexPassedInToGetPeriod,...
        expFixedVarIndex,...
        '� ������� ���������� ������� ������� ������������ ������ ����������, ������� ���������� � ��������� ������� ��������� ����������� ��������');
      expFixedVarValue = 0.5;
      testCase.verifyEqual(...
        testCase.fixedVarValuePassedInToGetPeriod,...
        expFixedVarValue,...
        '� ������� ���������� ������� �������� ������������ �������� ����������, ������� ���������� � ��������� ������� ��������� ����������� ��������');
    end
    
    function testCalculateMultipliers(testCase)      
      testCase.solutionResultsFilename = 'results.mat';
      testCase.dirname = 'dir\';
      
      testCase.rightParts = 0;
      testCase.linearizedSystem = 1;
      testCase.solver = 2;
      testCase.tstep = 4;  
      
      N = 5;
      testCase.setupZeroFirstPredatorSolutionToLoad(N);
         
      testCase.period = 6;
      
      testCase.isCalculateMultipliersCalled = false;
      testCase.act();
      testCase.assertTrue(testCase.isCalculateMultipliersCalled,...
        '�� ������� ������� ���������� ����������������');
      testCase.verifyEqual(...
        testCase.rightPartsPassedInToCalculateMultipliers,...
        testCase.rightParts,...
        '� ������� ���������� ���������������� �������� ������������ ������ ����� �������');
      testCase.verifyEqual(...
        testCase.linearizedSystemPassedInToCalculateMultipliers,...
        testCase.linearizedSystem,...
        '� ������� ���������� ���������������� �������� ������������ ������ ����� ������� � ���������');
      testCase.verifyEqual(...
        testCase.solverPassedInToCalculateMultipliers,testCase.solver,...
        '� ������� ���������� ���������������� ������� ������������ ��������');
      testCase.verifyEqual(testCase.tstepPassedInToCalculateMultipliers,...
        testCase.tstep,...
        '� ������� ���������� ���������������� ������� ������������ ��� �������������� �� �������');
      testCase.verifyGreaterThan(...
        testCase.tlastPassedInToCalculateMultipliers,testCase.period,...
        '� ������� ���������� ���������������� �������� ������������ �������� ����� ��������� �������������� �� �������');
      testCase.verifyEqual(...
        testCase.poincareMapLastPointPassedInToCalculateMultipliers,...
        testCase.poincareMapLastPoint,...
        '� ������� ���������� ���������������� �������� ������������ ��������� ������');
      expMonodromyMatrixFilename = 'dir\monodromy_matrix\results.mat';
      testCase.verifyEqual(...
        testCase.monodromyMatrixFilenamePassedInToCalculateMultipliers,...
        expMonodromyMatrixFilename,...
        '� ������� ���������� ���������������� �������� ������������ ��� ����� ��� ���������� ������������� �����������');      
      expFixedVarValue = 0.5;
      testCase.verifyEqual(...
        testCase.fixedVarValuePassedInToCalculateMultipliers,...
        expFixedVarValue,...
        '� ������� ���������� ���������������� �������� ������������ �������� ����������, ������� ���������� � ��������� ������� ��������� ����������� ��������');
      expNVar = 15;
      testCase.verifyEqual(testCase.nvarPassedInToCalculateMultipliers,...
        expNVar,...
        '� ������� ���������� ���������������� �������� ������������ ����� ����������');
      expNonNegative = 1:expNVar;
      testCase.verifyEqual(...
        testCase.nonNegativePassedInToCalculateMultipliers,...
        expNonNegative,...
        '� ������� ���������� ���������������� �������� ������������ ������� ��������������� ����������');
      outputFcn = @odephas2;
      testCase.verifyEqual(...
        testCase.outputFcnPassedInToCalculateMultipliers,outputFcn,...
        '� ������� ���������� ���������������� �������� ������������ ������� ������');
      
      preyCenterPointVarIndex = 3;
      firstPredatorCenterPointVarIndex = 8;
      secondPredatorCenterPointVarIndex = 13;
      testCase.verifyRightVarIndicesPassedToCalculateMultipliers(N,...
        preyCenterPointVarIndex,firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
      
      N = 6;
      preyCenterPointVarIndex = 4;
      firstPredatorCenterPointVarIndex = 10;
      secondPredatorCenterPointVarIndex = 16;
      testCase.verifyRightVarIndicesPassedToCalculateMultipliers(N,...
        preyCenterPointVarIndex,firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
    end
    
    function testPrintsComputationTimeIfMultipliersComputed(testCase)
      testCase.setupZeroFirstPredatorSolutionToLoadForNEqualTo5();
      testCase.multipliers = 0;
      testCase.printedValsArray = {};
      testCase.computationTime = 1;
      testCase.act();
      testCase.verifyContainsItem(testCase.printedValsArray,...
        testCase.computationTime,...
        '�� �������� ����� ���������� ����������������');
    end
    
    function testDoesNotPrintComputationTimeIfMultipliersAreNotComputed(testCase)
      testCase.setupZeroFirstPredatorSolutionToLoadForNEqualTo5();
      testCase.computationTime = 0;
      testCase.act();
      testCase.verifyDoesNotContainItem(testCase.printedValsArray,...
        testCase.computationTime,...
        '�������� ����� ���������� ����������������, ���� ������ ���������������� �� ��� ��������');
    end
    
    function testDisplaysMultipliersIfTheyAreComputed(testCase)
      testCase.setupZeroFirstPredatorSolutionToLoadForNEqualTo5();
      testCase.multipliers = {0 1};
      testCase.printedValsArray = {};
      testCase.verifyDisplayed(testCase.multipliers,...
        '�� �������� ���������������');
    end
    
    function testCreatesMultipliersFolderIfMultipliersAreComputed(testCase)
      testCase.setupZeroFirstPredatorSolutionToLoadForNEqualTo5();
      testCase.dirname = 'dir\';
      testCase.multipliers = 0;
      testCase.printedValsArray = {};
      testCase.act();
      testCase.verifyEqual(testCase.createdDirName,'dir\multipliers\',...
        '�� ������� ����� ��� ����������� ���������� ����������������');
    end
    
    function testDoesNotCreateMultipliersFolderIfMultipliersAreNotComputed(testCase)
      testCase.setupZeroFirstPredatorSolutionToLoadForNEqualTo5();
      testCase.dirname = 'dir\';
      testCase.act();
      testCase.verifyNotEqual(testCase.createdDirName,...
        'dir\multipliers\',...
        'C������ ����� ��� ����������� ���������� ����������������, ����� ��������������� �� ���������');
    end
    
    function testDoesNotAttemptToCreateMultipliersFolderIfItAlreadyExists(testCase)
      testCase.setupZeroFirstPredatorSolutionToLoadForNEqualTo5();
      testCase.multipliers = 0;
      testCase.printedValsArray = {};
      testCase.dirname = 'dir\';
      testCase.existent = 'dir\multipliers\';
      testCase.act();
      testCase.verifyNotEqual(testCase.createdDirName,testCase.existent,...
        '������� �������� ����� ��� ����������� ���������� ����������������, ����� ��� ��� ������������');
    end
    
    function testSavesVarsIfMultipliersAreComputed(testCase)
      testCase.solutionResultsFilename = 'results.mat';
      testCase.dirname = 'dir\';
      testCase.setupZeroFirstPredatorSolutionToLoadForNEqualTo5();
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
        argsInfo,'�� ��������� ����������');
    end
        
    function testDoesNotSaveVarsIfMultipliersAreNotComputed(testCase)
      testCase.setupZeroFirstPredatorSolutionToLoadForNEqualTo5();
      testCase.multipliers = [];
      testCase.act();
      testCase.verifyDoesNotContainItem(testCase.argsPassedInToSaveArr,...
          'dir\multipliers\results.mat',...
        '������� ��������� �������������� ����������');
    end
  end
  
end

