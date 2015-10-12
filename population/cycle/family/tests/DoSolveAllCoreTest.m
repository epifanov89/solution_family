classdef DoSolveAllCoreTest < TestHelperBase...
    & FakeCurrentDirNameHelper
  
  properties
    preyDiffusionCoeff
    secondPredatorDiffusionCoeff
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
  end
  
  methods (TestMethodSetup)
    function setup(testCase)
      testCase.preyDiffusionCoeff = 0.2;
      testCase.secondPredatorDiffusionCoeff = 0.24;
      testCase.firstPredatorMortality = 1;
      testCase.resourceDeviation = 0.2;
      testCase.N = 24;
      testCase.tspan = 0:0.002:100;
      testCase.solver = @myode4;
      testCase.nsol = 1;
      testCase.familyName = 'family\';
    end
  end
  
  methods
    function setupFamDirListing(testCase)      
      testCase.setupZeroFirstPredatorSol();      
      testCase.setupFamFirstSol();
    end
    
    function setupZeroFirstPredatorSol(testCase)
      filename = 'solution_results\families\family\0.mat';
      testCase.setupDirListing(filename);
      testCase.setupForeignFile();
    end
    
    function setupFamFirstSol(testCase)
      filename = 'solution_results\families\family\1.mat';
      testCase.setupDirListing(filename);
      testCase.setupForeignFile();
    end
    
    function setupForeignFile(testCase)
      filename = 'solution_results\families\family\foreign_file.mat';
      testCase.setupDirListing(filename);
    end
    
    function setupDirListing(testCase,filename)
      file = struct;
      file.name = filename;
      testCase.listing = [testCase.listing,file];
    end
    
    function files = fakeDir(testCase,name)   
      testCase.namePassedInToDir = name;
      files = testCase.listing;
    end
    
    function fakeSolveOne(testCase,solutionResultsFilename,...
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
    end
    
    function args = getZeroFirstPredatorSolArgs(testCase)
      args = struct;
      args.solutionResultsFilename = 'families\family\0.mat';
      args.preyDiffusionCoeff = testCase.preyDiffusionCoeff;
      args.secondPredatorDiffusionCoeff = ...
        testCase.secondPredatorDiffusionCoeff;
      args.firstPredatorMortality = testCase.firstPredatorMortality;
      args.resourceDeviation = testCase.resourceDeviation;
      args.N = testCase.N;
      args.tspan = testCase.tspan;
      args.solver = testCase.solver;
      args.getInitialData = @getZeroFirstPredatorInitialData;
    end
    
    function found = isFamFirstSolFound(testCase,args)
      filename = 'families\family\1.mat';
      found = testCase.isSolFound(filename,args);
    end
    
    function found = isSolFound(testCase,filename,args)
      found = strcmp(args.solutionResultsFilename,filename)...
        && args.preyDiffusionCoeff == testCase.preyDiffusionCoeff...
        && args.secondPredatorDiffusionCoeff == ...
          testCase.secondPredatorDiffusionCoeff...
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
        testCase.secondPredatorDiffusionCoeff,...
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
      filename = 'dir\solution_results\families\family\0.mat';
      testCase.setupDirListing(filename);
      testCase.act();
      testCase.verifyEqual(testCase.namePassedInToDir,...
        'dir\solution_results\families\family\*.mat',...
        'Не получен список имен файлов семейства');
    end
    
    function testDoesNotSolveForForeignFiles(testCase)
      testCase.setupZeroFirstPredatorSol();      
      filename = 'families\family\foreign_file.mat';
      testCase.verifyDoesNotContain(...
        @(args) testCase.isSolFound(filename,args),...
        testCase.argsPassedInToSolveOne,...
        'Попытка найти решение, не относящееся к семейству');
    end
    
    function testFindsZeroFirstPredatorSolIfItHasNotBeenFoundYet(testCase)
      testCase.setupFamFirstSol();
      testCase.act();
      expArgs = testCase.getZeroFirstPredatorSolArgs();
      testCase.verifyContainsItem(testCase.argsPassedInToSolveOne,...
        expArgs,'Не найдено решение с нулевым первым хищником');
    end
    
    function testDoesNotFindZeroFirstPredatorSolIfItHasBeenFoundAlreadyButNotAllSolsHaveBeenFoundYet(testCase)
      testCase.setupZeroFirstPredatorSol();
      testCase.act();
      expArgs = testCase.getZeroFirstPredatorSolArgs();
      testCase.verifyDoesNotContainItem(testCase.argsPassedInToSolveOne,...
        expArgs,...
        'Попытка повторно найти решение с нулевым первым хищником');
    end
    
    function testFindsFirstFamSolIfItHasNotBeenFoundYet(testCase)
      testCase.setupZeroFirstPredatorSol();
      testCase.act();
      testCase.verifyContains(@testCase.isFamFirstSolFound,...
        testCase.argsPassedInToSolveOne,...
        'Не найдено первое решение');
    end
    
    function testDoesNotFindFirstFamSolIfItHasBeenFoundAlreadyButNotAllSolsHaveBeenFoundYet(testCase)
      testCase.setupFamFirstSol();      
      testCase.act();
      testCase.verifyDoesNotContain(@testCase.isFamFirstSolFound,...
        testCase.argsPassedInToSolveOne,...
        'Попытка повторно найти первое решение');
    end
    
    function testContinuesToFindZeroFirstPredatorSolIfAllSolsHaveBeenFoundAlready(testCase)
      testCase.setupFamDirListing();      
      testCase.act();
      expArgs = testCase.getZeroFirstPredatorSolArgs();
      testCase.verifyContainsItem(testCase.argsPassedInToSolveOne,...
        expArgs,'Не продолжено решение с нулевым первым хищником');
    end
    
    function testContinuesToFindFamFirstSolIfAllSolsHaveBeenFoundAlready(testCase)
      testCase.setupFamDirListing();
      testCase.act();
      testCase.verifyContains(@testCase.isFamFirstSolFound,...
        testCase.argsPassedInToSolveOne,'Не продолжено первое решение');
    end
  end
  
end

