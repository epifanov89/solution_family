classdef DoSolveAllCoreTest < TestHelperBase...
    & FakeCurrentDirNameHelper
  
  properties
    preyDiffusionCoeff
    famSecondPredatorDiffusionCoeff
    famBreakingSecondPredatorDiffusionCoeff
    firstPredatorMortality
    resourceDeviation
    N
    tspan
    solver
    nsol
    familyName
    namePassedInToDir
    listing
    argsPassedInToSolveOne
    isStoppedArr
    solveOneCallNo
  end
  
  methods (TestMethodSetup)
    function setup(testCase)
      testCase.preyDiffusionCoeff = 0.2;
      testCase.famSecondPredatorDiffusionCoeff = 0.24;
      testCase.famBreakingSecondPredatorDiffusionCoeff = 0.12;
      testCase.firstPredatorMortality = 1;
      testCase.resourceDeviation = 0.2;
      testCase.N = 24;
      testCase.tspan = 0:0.002:100;
      testCase.solver = @myode4;
      testCase.nsol = 1;
      testCase.familyName = 'family\';
      testCase.solveOneCallNo = 1;
    end
  end
  
  methods
    function setupFamDirListing(testCase)  
      testCase.setupFamSolsDirListing();
      testCase.setupStandaloneSols();
    end
    
    function setupFamSolsDirListing(testCase)
      for solNo = 0:testCase.nsol
        filename = sprintf('solution_results\\families\\family\\%d.mat',...
          solNo);
        testCase.setupDirListing(filename);
      end
    end
    
    function setupFamSol1(testCase)
      filename = 'solution_results\families\family\0.mat';
      testCase.setupDirListing(filename);
    end
    
    function setupFamSol2(testCase)
      filename = 'solution_results\families\family\1.mat';
      testCase.setupDirListing(filename);
    end
    
    function setupStandaloneSols(testCase)
      testCase.setupZeroFirstPredatorSol();
      testCase.setupZeroSecondPredatorSol();
    end
    
    function setupZeroFirstPredatorSol(testCase)
      filename = 'solution_results\families\family\zeroFirstPredator.mat';
      testCase.setupDirListing(filename);
    end
    
    function setupZeroSecondPredatorSol(testCase)
      filename = 'solution_results\families\family\zeroSecondPredator.mat';
      testCase.setupDirListing(filename);
    end
    
    function setupDirListing(testCase,filename)
      file = struct;
      file.name = filename;
      testCase.listing = [testCase.listing,file];
    end
    
    function verifyDoesNotFindZeroFirstPredatorSolIfOneOfFamSolsWasStopped(...
        testCase,msg)
      testCase.act();
      expArgs = testCase.getZeroFirstPredatorSolArgs();
      testCase.verifyDoesNotContainItem(testCase.argsPassedInToSolveOne,...
        expArgs,msg);
    end
    
    function verifyDoesNotFindZeroSecondPredatorSolIfOneOfPrevSolsWasStopped(...
        testCase,msg)
      testCase.isStoppedArr = true;
      testCase.act();
      expArgs = testCase.getZeroSecondPredatorSolArgs();
      testCase.verifyDoesNotContainItem(testCase.argsPassedInToSolveOne,...
        expArgs,msg);
    end
    
    function files = fakeDir(testCase,name)   
      testCase.namePassedInToDir = name;
      files = testCase.listing;
    end
    
    function isStopped = fakeSolveOne(testCase,solutionResultsFilename,...
        preyDiffusionCoeff,secondPredatorDiffusionCoeff,...
        firstPredatorMortality,resourceDeviation,N,tspan,...
        getInitialData,solver)
      args = struct;
      args.solutionResultsFilename = solutionResultsFilename;
      args.preyDiffusionCoeff = preyDiffusionCoeff;
      args.secondPredatorDiffusionCoeff = secondPredatorDiffusionCoeff;
      args.firstPredatorMortality = firstPredatorMortality;
      args.resourceDeviation = resourceDeviation;
      args.N = N;
      args.tspan = tspan;
      args.getInitialData = getInitialData;
      args.solver = solver;
      testCase.argsPassedInToSolveOne = ...
        [testCase.argsPassedInToSolveOne,args];
      
      if length(testCase.isStoppedArr) >= testCase.solveOneCallNo
        isStopped = testCase.isStoppedArr(testCase.solveOneCallNo);
        testCase.solveOneCallNo = testCase.solveOneCallNo+1;
      else
        isStopped = false;
      end
    end
    
    function args = getFamSol1Args(testCase)
      filename = 'families\family\0.mat';
      secondPredatorDiffusionCoeff = ...
        testCase.famSecondPredatorDiffusionCoeff;
      getInitialData = @getZeroFirstPredatorInitialData;
      args = testCase.getSolArgs(filename,secondPredatorDiffusionCoeff,...
        getInitialData);
    end
    
    function args = getZeroFirstPredatorSolArgs(testCase)
      filename = 'families\family\zeroFirstPredator.mat';
      secondPredatorDiffusionCoeff = ...
        testCase.famBreakingSecondPredatorDiffusionCoeff;
      getInitialData = @getZeroFirstPredatorInitialData;
      args = testCase.getSolArgs(filename,secondPredatorDiffusionCoeff,...
        getInitialData);
    end
    
    function args = getZeroSecondPredatorSolArgs(testCase)
      filename = 'families\family\zeroSecondPredator.mat';
      secondPredatorDiffusionCoeff = ...
        testCase.famBreakingSecondPredatorDiffusionCoeff;
      getInitialData = @getZeroSecondPredatorInitialData;
      args = testCase.getSolArgs(filename,secondPredatorDiffusionCoeff,...
        getInitialData);
    end
    
    function args = getSolArgs(testCase,filename,...
        secondPredatorDiffusionCoeff,getInitialData)
      args = struct;
      args.solutionResultsFilename = filename;
      args.preyDiffusionCoeff = testCase.preyDiffusionCoeff;
      args.secondPredatorDiffusionCoeff = secondPredatorDiffusionCoeff;
      args.firstPredatorMortality = testCase.firstPredatorMortality;
      args.resourceDeviation = testCase.resourceDeviation;
      args.N = testCase.N;
      args.tspan = testCase.tspan;
      args.solver = testCase.solver;
      args.getInitialData = getInitialData;
    end
    
    function found = isFamSol2Found(testCase,args)
      filename = 'families\family\1.mat';
      found = testCase.isSolFound(filename,args);
    end
    
    function found = isFamSol3Found(testCase,args)
      filename = 'families\family\2.mat';
      found = testCase.isSolFound(filename,args);
    end
    
    function found = isSolFound(testCase,filename,args)
      found = strcmp(args.solutionResultsFilename,filename)...
        && args.preyDiffusionCoeff == testCase.preyDiffusionCoeff...
        && args.secondPredatorDiffusionCoeff == ...
          testCase.famSecondPredatorDiffusionCoeff...
        && args.firstPredatorMortality == ...
          testCase.firstPredatorMortality...
        && args.resourceDeviation == testCase.resourceDeviation...
        && args.N == testCase.N...
        && isequal(args.tspan,testCase.tspan)...
        && isequal(args.solver,testCase.solver);
    end
  end
  
  methods (Access = protected)
    function act(testCase)
      doSolveAllCore(testCase.preyDiffusionCoeff,...
        testCase.firstPredatorMortality,...
        testCase.resourceDeviation,testCase.N,testCase.tspan,...
        testCase.solver,testCase.nsol,testCase.familyName,...
        @testCase.fakeCurrentDirName,@testCase.fakeDir,...
        @testCase.fakeSolveOne);
    end
  end
  
  methods (Test)
    function testGetsFamDirListing(testCase)
      testCase.dirname = 'dir\';
      testCase.setupZeroFirstPredatorSol();
      testCase.act();
      testCase.verifyEqual(testCase.namePassedInToDir,...
        'dir\solution_results\families\family\*.mat',...
        '�� ������� ������ ���� ������ ���������');
    end
       
    function testFindsSol1IfItWasNotStarted(testCase)
      testCase.setupFamSol2();
      testCase.act();
      expArgs = testCase.getFamSol1Args();
      testCase.verifyContainsItem(testCase.argsPassedInToSolveOne,...
        expArgs,'�� ������� 1-� �������');
    end
    
    function testDoesNotFindSol1IfItWasStartedButNotAllFamSolsWereStarted(testCase)
      testCase.setupFamSol1();
      testCase.setupStandaloneSols();
      testCase.act();
      expArgs = testCase.getFamSol1Args();
      testCase.verifyDoesNotContainItem(testCase.argsPassedInToSolveOne,...
        expArgs,...
        '������� �������� ����� 1-� �������, ����� ��� �� ��� ������� ��������� ���� ������');
    end
    
    function testDoesNotFindSol1IfItWasStartedButNotAllStandaloneSolsWereStarted(testCase)
      testCase.setupFamSolsDirListing();
      testCase.setupZeroFirstPredatorSol();
      testCase.act();
      expArgs = testCase.getFamSol1Args();
      testCase.verifyDoesNotContainItem(testCase.argsPassedInToSolveOne,...
        expArgs,...
        '������� �������� ����� 1-� �������, ����� ��� �� ��� ������� � ����� ������� �������� ���� ������');
    end
    
    function testFindsSol2IfItWasNotStarted(testCase)
      testCase.setupFamSol1();
      testCase.act();
      testCase.verifyContains(@testCase.isFamSol2Found,...
        testCase.argsPassedInToSolveOne,...
        '�� ������� 2-� �������');
    end
    
    function testDoesNotFindSol2IfItWasStartedButNotAllFamSolsWereStarted(testCase)
      testCase.setupFamSol2();  
      testCase.setupStandaloneSols();
      testCase.act();
      testCase.verifyDoesNotContain(@testCase.isFamSol2Found,...
        testCase.argsPassedInToSolveOne,...
        '������� �������� ����� 2-� �������, ����� ��� �� ��� ������� ��������� ���� ������');
    end
    
    function testDoesNotFindSol2IfItWasStartedButNotAllStandaloneSolsWereStarted(testCase)
      testCase.setupFamSolsDirListing();  
      testCase.setupZeroFirstPredatorSol();
      testCase.act();
      testCase.verifyDoesNotContain(@testCase.isFamSol2Found,...
        testCase.argsPassedInToSolveOne,...
        '������� �������� ����� 2-� �������, ����� ��� �� ��� ������� � ����� ������� �������� ���� ������');
    end
    
    function testContinuesToFindSol1IfAllSolsWereStarted(testCase)
      testCase.setupFamDirListing();      
      testCase.act();
      expArgs = testCase.getFamSol1Args();
      testCase.verifyContainsItem(testCase.argsPassedInToSolveOne,...
        expArgs,'�� ���������� 1-� �������');
    end
    
    function testContinuesToFindSol2IfAllSolsWereStarted(testCase)
      testCase.setupFamDirListing();
      testCase.act();
      testCase.verifyContains(@testCase.isFamSol2Found,...
        testCase.argsPassedInToSolveOne,'�� ���������� 2-� �������');
    end
    
    function testDoesNotFindSol2IfSol1WasStoppedWhenNotAllSolsWereStarted(testCase)
      testCase.isStoppedArr = true;
      testCase.act();
      testCase.verifyDoesNotContain(@testCase.isFamSol2Found,...
        testCase.argsPassedInToSolveOne,...
        '������� ����� 2-� �������, ���� 1-� ������� ���� ��������, ����� ��� �� ��� ������� ���� ������');
    end
    
    function testDoesNotFindSol3IfSol1WasStoppedWhenNotAllSolsWereStarted(testCase)
      testCase.nsol = 2;
      testCase.isStoppedArr = true;      
      testCase.act();
      testCase.verifyDoesNotContain(@testCase.isFamSol3Found,...
        testCase.argsPassedInToSolveOne,...
        '������� ����� 3-� �������, ���� 1-� ������� ���� ��������, ����� ��� �� ��� ������� ���� ������');
    end
    
    function testDoesNotFindSol3IfSol2WasStoppedWhenNotAllSolsWereStarted(testCase)
      testCase.nsol = 2;
      testCase.isStoppedArr = [false,true];      
      testCase.act();
      testCase.verifyDoesNotContain(@testCase.isFamSol3Found,...
        testCase.argsPassedInToSolveOne,...
        '������� ����� 3-� �������, ���� 2-� ������� ���� ��������, ����� ��� �� ��� ������� ���� ������');
    end
    
    function testDoesNotFindSol2IfSol1WasStoppedWhenAllSolsWereStarted(testCase)
      testCase.isStoppedArr = true;
      testCase.setupFamDirListing();
      testCase.act();
      testCase.verifyDoesNotContain(@testCase.isFamSol2Found,...
        testCase.argsPassedInToSolveOne,...
        '������� ����� 2-� �������, ���� 1-� ������� ���� ��������, ����� ��� ������� ��� ���� ������');
    end
    
    function testDoesNotFindSol3IfSol1WasStoppedWhenAllSolsWereStarted(testCase)
      testCase.nsol = 2;
      testCase.isStoppedArr = true;    
      testCase.setupFamDirListing();
      testCase.act();
      testCase.verifyDoesNotContain(@testCase.isFamSol3Found,...
        testCase.argsPassedInToSolveOne,...
        '������� ����� 3-� �������, ���� 1-� ������� ���� ��������, ����� ��� ������� ��� ���� ������');
    end
    
    function testDoesNotFindSol3IfSol2WasStoppedWhenAllSolsWereStarted(testCase)
      testCase.nsol = 2;
      testCase.isStoppedArr = [false,true];    
      testCase.setupFamDirListing();
      testCase.act();
      testCase.verifyDoesNotContain(@testCase.isFamSol3Found,...
        testCase.argsPassedInToSolveOne,...
        '������� ����� 3-� �������, ���� 2-� ������� ���� ��������, ����� ��� ������� ��� ���� ������');
    end
    
    function testFindsZeroPredator1SolIfItWasNotStarted(testCase)
      testCase.setupFamSol1();
      testCase.act();
      expArgs = testCase.getZeroFirstPredatorSolArgs();
      testCase.verifyContainsItem(testCase.argsPassedInToSolveOne,...
        expArgs,'�� ������� ������� � ������� 1-� ��������');
    end
    
    function testDoesNotFindZeroPredator1SolIfNotAllFamSolsWereStarted(testCase)
      testCase.setupFamSol1();
      testCase.setupStandaloneSols();
      testCase.act();
      expArgs = testCase.getZeroFirstPredatorSolArgs();
      testCase.verifyDoesNotContainItem(testCase.argsPassedInToSolveOne,...
        expArgs,...
        '������� �������� ����� ������� � ������� 1-� ��������, ����� �� ��� ������� ��������� ���� ������');
    end
    
    function testDoesNotFindZeroPredator1SolIfNotAllStandaloneSolsWereStarted(testCase)
      testCase.setupFamSolsDirListing();
      testCase.setupZeroFirstPredatorSol();
      testCase.act();
      expArgs = testCase.getZeroFirstPredatorSolArgs();
      testCase.verifyDoesNotContainItem(testCase.argsPassedInToSolveOne,...
        expArgs,...
        '������� �������� ����� ������� � ������� 1-� ��������, ����� ������� � ������� 2-� �������� �� ���� ������');
    end
    
    function testContinuesToFindZeroPredator1SolIfAllSolsWereStarted(testCase)
      testCase.setupFamDirListing();
      testCase.act();
      expArgs = testCase.getZeroFirstPredatorSolArgs();
      testCase.verifyContainsItem(testCase.argsPassedInToSolveOne,...
        expArgs,'�� ���������� ������� � ������� 1-� ��������');
    end
    
    function testDoesNotFindZeroPredator1SolWhenNoSolsWereStartedIfSol1WasStopped(testCase)               
      testCase.isStoppedArr = true;      
      testCase.verifyDoesNotFindZeroFirstPredatorSolIfOneOfFamSolsWasStopped(...
        '������� ����� ������� � ������� 1-� ��������, ���� 1-� ������� ���� ��������, ����� �� ���� ������� ��������� ��� �� ���� ������');
    end
    
    function testDoesNotFindZeroPredator1SolWhenNoSolsWereStartedIfSol2WasStopped(testCase)      
      testCase.isStoppedArr = [false,true];
      testCase.verifyDoesNotFindZeroFirstPredatorSolIfOneOfFamSolsWasStopped(...
        '������� ����� ������� � ������� 1-� ��������, ���� 2-� ������� ���� ��������, ����� �� ���� ������� ��������� ��� �� ���� ������');
    end
    
    function testDoesNotFindZeroPredator1SolWhenNotAllSolsWereStartedIfOneOfFamSolsWasStopped(testCase)
      testCase.setupFamSol1();
      testCase.setupZeroSecondPredatorSol();      
      testCase.isStoppedArr = true;
      msg = '������� ����� ������� � ������� 1-� ��������, ���� ���� �� ���������� ������� ���� ��������, ����� ��� �� ��� ������� ��������� ���� ������';      
      testCase.verifyDoesNotFindZeroFirstPredatorSolIfOneOfFamSolsWasStopped(msg);
    end
    
    function testDoesNotFindZeroPredator1SolWhenAllSolsWereStartedIfSol1WasStoppped(testCase)
      testCase.setupFamDirListing();      
      testCase.isStoppedArr = true;      
      testCase.verifyDoesNotFindZeroFirstPredatorSolIfOneOfFamSolsWasStopped(...
        '������� ����� ������� � ������� 1-� ��������, ���� 1-� ������� ���� ��������, ����� ��� ������� ��� ���� ������');
    end
    
    function testDoesNotFindZeroPredator1SolWhenAllSolsWereStartedIfSol2WasStoppped(testCase)
      testCase.setupFamDirListing();      
      testCase.isStoppedArr = [false,true];
      testCase.verifyDoesNotFindZeroFirstPredatorSolIfOneOfFamSolsWasStopped(...
        '������� ����� ������� � ������� 1-� ��������, ���� 2-� ������� ���� ��������, ����� ��� ������� ��� ���� ������');
    end
    
    function testFindsZeroSecondPredatorSolIfItHasNotBeenStartedYet(testCase)
      testCase.setupFamSol2();
      testCase.act();
      expArgs = testCase.getZeroSecondPredatorSolArgs();
      testCase.verifyContainsItem(testCase.argsPassedInToSolveOne,...
        expArgs,'�� ������� ������� � ������� 2-� ��������');
    end
    
    function testDoesNotFindZeroSecondPredatorSolIfNotAllFamSolsHaveBeenStartedYet(testCase)
      testCase.setupFamSol2();
      testCase.setupStandaloneSols();
      testCase.act();
      expArgs = testCase.getZeroFirstPredatorSolArgs();
      testCase.verifyDoesNotContainItem(testCase.argsPassedInToSolveOne,...
        expArgs,...
        '������� �������� ����� ������� � ������� 2-� ��������, ����� �� ��� ������� ��������� ���� ������');
    end
    
    function testDoesNotFindZeroPredator2SolIfNotAllStandaloneSolsHaveBeenStartedYet(testCase)
      testCase.setupFamSolsDirListing();
      testCase.setupZeroSecondPredatorSol();
      testCase.act();
      expArgs = testCase.getZeroSecondPredatorSolArgs();
      testCase.verifyDoesNotContainItem(testCase.argsPassedInToSolveOne,...
        expArgs,...
        '������� �������� ����� ������� � ������� 2-� ��������, ����� ������� � ������� 1-� �������� �� ���� ������');
    end
    
    function testContinuesToFindZeroSecondPredatorSolIfAllSolsHaveBeenStartedAlready(testCase)
      testCase.setupFamDirListing();
      testCase.act();
      expArgs = testCase.getZeroSecondPredatorSolArgs();
      testCase.verifyContainsItem(testCase.argsPassedInToSolveOne,...
        expArgs,'�� ���������� ������� � ������� 2-� ��������');
    end
    
    function testDoesNotFindZeroPredator2SolWhenNoSolsWereStartedIfSol1WasStopped(testCase)
      testCase.isStoppedArr = true;
      testCase.verifyDoesNotFindZeroSecondPredatorSolIfOneOfPrevSolsWasStopped(...
        '������� ����� ������� � ������� 2-� ��������, ���� 1-� ������� ���� ��������, ����� �� ���� ������� ��������� ��� �� ���� ������');
    end
    
    function testDoesNotFindZeroPredator2SolWhenNoSolsWereStartedIfSol2WasStopped(testCase)
      testCase.isStoppedArr = [false,true];
      testCase.verifyDoesNotFindZeroSecondPredatorSolIfOneOfPrevSolsWasStopped(...
        '������� ����� ������� � ������� 2-� ��������, ���� 2-� ������� ���� ��������, ����� �� ���� ������� ��������� ��� �� ���� ������');
    end
    
    function testDoesNotFindZeroPredator2SolWhenNoSolsWereStartedIfZeroPredator1SolWasStopped(testCase)
      testCase.isStoppedArr = [false,false,true];
      testCase.verifyDoesNotFindZeroSecondPredatorSolIfOneOfPrevSolsWasStopped(...
        '������� ����� ������� � ������� 2-� ��������, ���� ������� � ������� 1-� �������� ���� ��������, ����� �� ���� ������� ��������� ��� �� ���� ������');
    end
    
    function testDoesNotFindZeroPredator2SolWhenNotAllFamSolsWereStartedIfOneOfFamSolsWasStopped(testCase)
      testCase.setupFamSol1();
      testCase.setupZeroFirstPredatorSol();      
      testCase.isStoppedArr = true;
      testCase.verifyDoesNotFindZeroSecondPredatorSolIfOneOfPrevSolsWasStopped(...
        '������� ����� ������� � ������� 2-� ��������, ���� ���� �� ������� ��������� ���� ��������');
    end
    
    function testDoesNotFindZeroPredator2SolWhenNotAllStandaloneSolsWereStartedIfZeroPredator1SolWasStopped(testCase)
      testCase.setupFamSolsDirListing(); 
      testCase.isStoppedArr = true;
      testCase.verifyDoesNotFindZeroSecondPredatorSolIfOneOfPrevSolsWasStopped(...
        '������� ����� ������� � ������� 2-� ��������, ���� ������� � ������� 1-� �������� ���� ��������');
    end
    
    function testDoesNotFindZeroPredator2SolWhenAllSolsWereStartedIfSol1WasStopped(testCase)
      testCase.setupFamDirListing();   
      testCase.isStoppedArr = true;
      testCase.verifyDoesNotFindZeroSecondPredatorSolIfOneOfPrevSolsWasStopped(...
        '������� ����� ������� � ������� 2-� ��������, ���� 1-� ������� ���� ��������, ����� ��� ������� ��� ���� ������');
    end
    
    function testDoesNotFindZeroPredator2SolWhenAllSolsWereStartedIfSol2WasStopped(testCase)
      testCase.setupFamDirListing();   
      testCase.isStoppedArr = [false,true];
      testCase.verifyDoesNotFindZeroSecondPredatorSolIfOneOfPrevSolsWasStopped(...
        '������� ����� ������� � ������� 2-� ��������, ���� 2-� ������� ���� ��������, ����� ��� ������� ��� ���� ������');
    end
    
    function testDoesNotFindZeroPredator2SolWhenAllSolsWereStartedIfZeroPredator1SolWasStopped(testCase)
      testCase.setupFamDirListing();   
      testCase.isStoppedArr = [false,false,true];
      testCase.verifyDoesNotFindZeroSecondPredatorSolIfOneOfPrevSolsWasStopped(...
        '������� ����� ������� � ������� 2-� ��������, ���� ������� � ������� 1-� �������� ���� ��������, ����� ��� ������� ��� ���� ������');
    end
  end
  
end

