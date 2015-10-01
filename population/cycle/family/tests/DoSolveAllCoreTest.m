classdef DoSolveAllCoreTest < matlab.unittest.TestCase...
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
    existent
    argsPassedInToSolveOne
  end
  
  methods (TestMethodSetup)
    function setup(testCase)
      testCase.dirname = 'dir\';
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
    
    function e = fakeExist(testCase,filename,kind)
      e = ~isempty(find(cellfun(@(name) strcmp(name,filename),...
        testCase.existent.(kind)),1));
    end
    
    function act(testCase)
      doSolveAllCore(testCase.preyDiffusionCoeff,...
        testCase.secondPredatorDiffusionCoeff,...
        testCase.firstPredatorMortality,...
        testCase.resourceDeviation,testCase.N,testCase.tspan,...
        testCase.solver,testCase.nsol,testCase.familyName,...
        @testCase.fakeCurrentDirName,@testCase.fakeExist,...
        @testCase.fakeSolveOne);
    end
  end
  
  methods (Test)
    function testFindsZeroFirstPredatorSolutionIfItHasNotFoundYet(testCase)
      testCase.existent = struct;
      testCase.existent.('file') = {'dir\solution_results\family\1.mat'};
      testCase.act();
      expArgs = struct;
      expArgs.solutionResultsFilename = 'family\0.mat';
      expArgs.preyDiffusionCoeff = testCase.preyDiffusionCoeff;
      expArgs.secondPredatorDiffusionCoeff = ...
        testCase.secondPredatorDiffusionCoeff;
      expArgs.firstPredatorMortality = testCase.firstPredatorMortality;
      expArgs.resourceDeviation = testCase.resourceDeviation;
      expArgs.N = testCase.N;
      expArgs.tspan = testCase.tspan;
      expArgs.solver = testCase.solver;
      expArgs.getInitialData = @getZeroFirstPredatorInitialData;
      testCase.verifyFalse(isempty(find(arrayfun(...
        @(actArgs) isequal(actArgs,expArgs),...
        testCase.argsPassedInToSolveOne),1)),...
        'Ќе найдено решение семейства с нулевым первым хищником');
    end
    
    function testDoesNotFindZeroFirstPredatorSolutionIfItIsAlreadyFound(testCase)
      testCase.existent = struct;
      testCase.existent.('file') = {'dir\solution_results\family\0.mat'};
      testCase.act();
      expArgs = struct;
      expArgs.solutionResultsFilename = 'family\0.mat';
      expArgs.preyDiffusionCoeff = testCase.preyDiffusionCoeff;
      expArgs.secondPredatorDiffusionCoeff = ...
        testCase.secondPredatorDiffusionCoeff;
      expArgs.firstPredatorMortality = testCase.firstPredatorMortality;
      expArgs.resourceDeviation = testCase.resourceDeviation;
      expArgs.N = testCase.N;
      expArgs.tspan = testCase.tspan;
      expArgs.solver = testCase.solver;
      expArgs.getInitialData = @getZeroFirstPredatorInitialData;
      testCase.verifyTrue(isempty(find(arrayfun(...
        @(actArgs) isequal(actArgs,expArgs),...
        testCase.argsPassedInToSolveOne),1)),...
        'ѕопытка повторно найти решение семейства с нулевым первым хищником');
    end
    
    function testFindsFirstFamilySolutionIfItHasNotBeenFoundYet(testCase)
      testCase.existent = struct;
      testCase.existent.('file') = {'dir\solution_results\family\0.mat'};
      testCase.act();
      testCase.verifyFalse(isempty(find(arrayfun(...
        @(actArgs) strcmp(actArgs.solutionResultsFilename,'family\1.mat')...
          && actArgs.preyDiffusionCoeff == testCase.preyDiffusionCoeff...
          && actArgs.secondPredatorDiffusionCoeff == testCase.secondPredatorDiffusionCoeff...
          && actArgs.firstPredatorMortality == testCase.firstPredatorMortality...
          && actArgs.resourceDeviation == testCase.resourceDeviation...
          && actArgs.N == testCase.N...
          && isequal(actArgs.tspan,testCase.tspan)...
          && isequal(actArgs.solver,testCase.solver),...
        testCase.argsPassedInToSolveOne),1)),...
        'Ќе найдено первое решение семейства');
    end
    
    function testDoesNotFindFirstFamilySolutionIfItIsAlreadyFound(testCase)
      testCase.existent = struct;
      testCase.existent.('file') = {'dir\solution_results\family\1.mat'};
      testCase.act();
      testCase.verifyTrue(isempty(find(arrayfun(...
        @(actArgs) strcmp(actArgs.solutionResultsFilename,'family\1.mat')...
          && actArgs.preyDiffusionCoeff == testCase.preyDiffusionCoeff...
          && actArgs.secondPredatorDiffusionCoeff == testCase.secondPredatorDiffusionCoeff...
          && actArgs.firstPredatorMortality == testCase.firstPredatorMortality...
          && actArgs.resourceDeviation == testCase.resourceDeviation...
          && actArgs.N == testCase.N...
          && isequal(actArgs.tspan,testCase.tspan)...
          && isequal(actArgs.solver,testCase.solver),...
        testCase.argsPassedInToSolveOne),1)),...
        'ѕопытка повторно найти первое решение семейства');
    end
  end
  
end

