classdef DoPlotTillSteadyInOneFigureCoreTest < ...
    FakeCurrentDirNameHelper & LoadTestHelper...
      & MultiplePlotsOnSameFigureSingleFigureTestHelper
  
  properties
    resultsFilename        
    tstart
    tspan
  end
  
  methods (TestMethodSetup)
    function setup(testCase)                  
      setup@MultiplePlotsOnSameFigureSingleFigureTestHelper(testCase);
      testCase.tstart = 1;
      testCase.tspan = 1;
      
      vars = struct;
      tf = testCase.tstart+testCase.tspan;
      vars.t = 0:tf;
      testCase.varsToLoad = vars;      
    end
  end
  
  methods (Access = private)
    function setupSolution(testCase,ncol)    
      nrow = length(testCase.varsToLoad.t);
      w = zeros(nrow,ncol);
      for row = 1:nrow
        w(row,:) = (row-1)*ncol+1:row*ncol;
      end
      testCase.varsToLoad.w = w;
    end
    
    function verifyPredatorTimeDependencyPlottedForNEqualTo1(testCase,...
        predatorCenterPointVarIndex,msgStart)
      N = 1;
      nvar = 3;
      testCase.verifyPredatorTimeDependencyPlotted(N,nvar,...
        predatorCenterPointVarIndex,msgStart);
    end
    
    function verifyPredatorTimeDependencyPlottedForNEqualTo2(testCase,...
        predatorCenterPointVarIndex,msgStart)
      N = 2;
      nvar = 6;
      testCase.verifyPredatorTimeDependencyPlotted(N,nvar,...
        predatorCenterPointVarIndex,msgStart);
    end
    
    function verifyPredatorTimeDependencyPlotted(testCase,N,nvar,...
        predatorCenterPointVarIndex,msgStart)
      testCase.setupSolution(nvar);      
      nrow = testCase.tspan+1;
      ncol = 2;
      expLine = zeros(nrow,ncol);
      expLine(:,1) = testCase.tstart:testCase.tstart+testCase.tspan; 
      for row = 1:nrow
        offset = (testCase.tstart+row-1)*nvar;
        expLine(row,ncol) = offset+predatorCenterPointVarIndex;
      end
      msg = sprintf('%s при N = %d',msgStart,N);
      testCase.verifyLinePlotted(expLine,msg);
    end
    
    function verifyDensityTimeDependenciesPlotted(testCase,N,nvar,...
        firstPredatorCenterPointVarIndex,secondPredatorCenterPointVarIndex)
      testCase.setupSolution(nvar);
      
      testCase.act();            
      
      ncol = testCase.tspan+1;
      expX = testCase.tstart:testCase.tstart+testCase.tspan;
            
      expFirstPredatorY = zeros(1,ncol);
      expSecondPredatorY = zeros(1,ncol);
      
      for col = 1:ncol
        offset = (testCase.tstart+col-1)*nvar;
        expFirstPredatorY(col) = offset+firstPredatorCenterPointVarIndex;
        expSecondPredatorY(col) = offset+secondPredatorCenterPointVarIndex;
      end
      
      firstPredatorPlotCallIndices = find(arrayfun(...
        @(call) strcmp(call.fcn,'plot') && isequal(call.args.X,expX)...
            && isequal(call.args.Y,expFirstPredatorY),...
          testCase.callSequence));
      
      msg = sprintf('Не выведены графики зависимости плотностей хищников в центральной точке ареала от времени на одном графике при N = %d',N);
      
      testCase.assertFalse(isempty(firstPredatorPlotCallIndices),msg);
      
      firstPredatorPlotCallIndex = firstPredatorPlotCallIndices(1); 
      
      secondPredatorPlotCallIndices = find(arrayfun(...
        @(call) strcmp(call.fcn,'plot') && isequal(call.args.X,expX)...
            && isequal(call.args.Y,expSecondPredatorY),...
          testCase.callSequence));
      
      testCase.assertFalse(isempty(secondPredatorPlotCallIndices),msg);
      
      secondPredatorPlotCallIndex = secondPredatorPlotCallIndices(1); 
      
      holdCallIndices = find(arrayfun(@(call) strcmp(call.fcn,'hold')...
        && strcmp(call.args.arg,'on'),testCase.callSequence));
      
      testCase.assertFalse(isempty(holdCallIndices),msg);
      
      holdCallIndex = holdCallIndices(1);
      
      testCase.verifyTrue(holdCallIndex < firstPredatorPlotCallIndex...
          || holdCallIndex < secondPredatorPlotCallIndex,msg);
    end
  end
  
  methods (Access = protected)
    function act(testCase)
      doPlotTillSteadyInOneFigureCore(testCase.resultsFilename,...
        testCase.tstart,testCase.tspan,...
        @testCase.fakeCurrentDirName,@testCase.fakeLoad,...
        @testCase.fakePlot,@testCase.fakeHold,...
        @testCase.fakeLabel,@testCase.fakeXLabel,@testCase.fakeGCA,...
        @testCase.fakeSet);
    end
  end
  
  methods (Test)    
    function testLoadsSolution(testCase)
      testCase.resultsFilename = 'results.mat';
      testCase.dirname = 'dir\';
      ncol = 3;
      testCase.setupSolution(ncol);      
      filename = 'dir\solution_results\results.mat';
      varnames = {'t','w'};
      testCase.verifySolutionLoaded(filename,varnames);
    end
    
    function testPlotsFirstPredatorTimeDependencyForNEqualTo1(testCase)
      predatorCenterPointVarIndex = 2;
      testCase.verifyPredatorTimeDependencyPlottedForNEqualTo1(...
        predatorCenterPointVarIndex,...
        'Не выведен график первого хищника');
    end
    
    function testPlotsFirstPredatorTimeDependencyForNEqualTo2(testCase)
      predatorCenterPointVarIndex = 4;
      testCase.verifyPredatorTimeDependencyPlottedForNEqualTo2(...
        predatorCenterPointVarIndex,...
        'Не выведен график первого хищника');
    end
    
    function testPlotsSecondPredatorTimeDependencyForNEqualTo1(testCase)
      predatorCenterPointVarIndex = 3;
      testCase.verifyPredatorTimeDependencyPlottedForNEqualTo1(...
        predatorCenterPointVarIndex,...
        'Не выведен график второго хищника');
    end
    
    function testPlotsSecondPredatorTimeDependencyForNEqualTo2(testCase)
      predatorCenterPointVarIndex = 6;
      testCase.verifyPredatorTimeDependencyPlottedForNEqualTo2(...
        predatorCenterPointVarIndex,...
        'Не выведен график второго хищника');
    end
    
%     function testPlotsDensityTimeDependenciesForNEqualTo1(testCase)      
%       N = 1;      
%       nvar = 3;
%       firstPredatorCenterPointVarIndex = 2;
%       secondPredatorCenterPointVarIndex = 3;
%       testCase.verifyDensityTimeDependenciesPlotted(N,nvar,...
%         firstPredatorCenterPointVarIndex,...
%         secondPredatorCenterPointVarIndex);
%     end
%     
%     function testPlotsDensityTimeDependenciesForNEqualTo2(testCase)      
%       N = 2;      
%       nvar = 6;
%       firstPredatorCenterPointVarIndex = 4;
%       secondPredatorCenterPointVarIndex = 6;
%       testCase.verifyDensityTimeDependenciesPlotted(N,nvar,...
%         firstPredatorCenterPointVarIndex,...
%         secondPredatorCenterPointVarIndex);
%     end

    function testDoesNotOverwritePlots(testCase)
      nvar = 3;
      testCase.setupSolution(nvar);
      testCase.verifyPlotsAreNotOverwrited();
    end
  end
  
end

