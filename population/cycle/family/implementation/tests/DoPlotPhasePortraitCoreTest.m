classdef DoPlotPhasePortraitCoreTest < ...
    MultiplePlotsOnSameFigureTestHelper & FakeCurrentDirNameHelper...
    & FakeLoadHelper & SubplotTestHelper
  
  properties
  end
  
  methods (TestMethodSetup)
    function setup(testCase)
      testCase.dirname = 'dir\';      
    end
  end
  
  methods (Access = protected)
    function setupAxesHandlesToReturnFromSubplot(testCase,pos,handle)
      nrow = 1;
      ncol = 2;
      setupAxesHandlesToReturnFromSubplot@SubplotTestHelper(testCase,...
        nrow,ncol,pos,handle);
    end
  end
  
  methods    
    function fakeLabel(~,varargin)      
    end
    
    function fakeXLabel(~,varargin)      
    end
    
    function fakeYLabel(~,varargin)      
    end
    
    function h = fakeGCA(~)      
      h = 1;
    end
    
    function fakeSet(~,varargin)      
    end
    
    function setupSolutions(testCase,npt,N)
      nspecies = 3;
      nvar = N*nspecies;
      
      w = zeros(npt,nvar);
      for pt = 1:npt
        w(pt,:) = (pt-1)*nvar+1:pt*nvar;
      end
      testCase.setupSolutionToLoad('tillsteadyA.mat',w);
      
      w = zeros(npt,nvar);
      for pt = 1:npt
        w(pt,:) = (pt-1)*nvar+2:pt*nvar+1;
      end
      testCase.setupSolutionToLoad('tillsteadyB.mat',w);
    end
    
    function setupSolutionToLoad(testCase,filename,w)
      loadedVars = struct;
      loadedVars.filename = strcat('dir\solution_results\',filename);
      vars = struct;
      vars.w = w;
      loadedVars.vars = vars;
      testCase.varsToLoad = [testCase.varsToLoad,loadedVars];
    end
       
    function verifyPhasePortraitsPlotted(testCase,...
        handle,N,npt,APhasePortraitX,APhasePortraitY,...
        BPhasePortraitX,BPhasePortraitY,msg)      
      testCase.setupSolutions(npt,N);
      
      testCase.act();
      
      holdCallIndices = find(arrayfun(@(call) strcmp(call.fcn,'hold')...
        && call.args.handle == handle && strcmp(call.args.arg,'on'),...
        testCase.callSequence));
      
      testCase.assertFalse(isempty(holdCallIndices),msg);
      
      holdCallIndex = holdCallIndices(1);
            
      solutionAPlotCallIndices = find(arrayfun(...
        @(call) strcmp(call.fcn,'plot')...
            && call.args.handle == handle...
            && isequal(call.args.X,APhasePortraitX)...
            && isequal(call.args.Y,APhasePortraitY)...
            && ~isempty(strfind(call.args.LineSpec,'-')),...
          testCase.callSequence));
        
      testCase.assertFalse(isempty(solutionAPlotCallIndices),msg);
      
      solutionAPlotCallIndex = solutionAPlotCallIndices(1);
      
      solutionBPlotCallIndices = find(arrayfun(...
        @(call) strcmp(call.fcn,'plot')...
            && call.args.handle == handle...
            && isequal(call.args.X,BPhasePortraitX)...
            && isequal(call.args.Y,BPhasePortraitY)...
            && ~isempty(strfind(call.args.LineSpec,'-')),...
          testCase.callSequence));
        
      testCase.assertFalse(isempty(solutionBPlotCallIndices),msg);
      
      solutionBPlotCallIndex = solutionBPlotCallIndices(1);
      
      testCase.verifyTrue(holdCallIndex < solutionAPlotCallIndex...
        || holdCallIndex < solutionBPlotCallIndex,msg);
    end
  end
  
  methods (Access = protected)
    function act(testCase)
      doPlotPhasePortraitCore(@testCase.fakeClose,...
        @testCase.fakeCurrentDirName,@testCase.fakeLoad,...
        @testCase.fakeSubplot,@testCase.fakeHold,@testCase.fakePlot,...
        @testCase.fakeLabel,@testCase.fakeXLabel,@testCase.fakeYLabel,...
        @testCase.fakeGCA,@testCase.fakeSet);
    end
  end
  
  methods (Test)   
    function testClosesAll(testCase)
      npt = 30;
      N = 5;
      testCase.setupSolutions(npt,N);
      testClosesAll@MultiplePlotsOnSameFigureTestHelper(testCase);
    end
    
    function testPlotsPhasePortraitsForFirstPredatorAndNEqualTo5(testCase)
      N = 5;
      npt = 2;
      APhasePortraitX = 18;
      APhasePortraitY = 23;
      BPhasePortraitX = 19;
      BPhasePortraitY = 24;
      
      pos = 1;
      handle = 1;
      testCase.setupAxesHandlesToReturnFromSubplot(pos,handle);
      
      testCase.verifyPhasePortraitsPlotted(handle,N,npt,...
        APhasePortraitX,APhasePortraitY,...
        BPhasePortraitX,BPhasePortraitY,...
        'Не выведены фазовые портреты решений для первого хищника на одном графике при N = 5');
    end
    
    function testPlotsPhasePortraitsForFirstPredatorAndNEqualTo6(testCase)
      N = 6;
      npt = 2;
      APhasePortraitX = 22;
      APhasePortraitY = 28;
      BPhasePortraitX = 23;
      BPhasePortraitY = 29;
      
      pos = 1;
      handle = 1;
      testCase.setupAxesHandlesToReturnFromSubplot(pos,handle);
      
      testCase.verifyPhasePortraitsPlotted(handle,N,npt,...
        APhasePortraitX,APhasePortraitY,...
        BPhasePortraitX,BPhasePortraitY,...
        'Не выведены фазовые портреты решений для первого хищника на одном графике при N = 6');
    end
    
    function testPlotsPhasePortraitsForSecondPredatorAndNEqualTo5(testCase)
      N = 5;
      npt = 2;
      APhasePortraitX = 18;
      APhasePortraitY = 28;
      BPhasePortraitX = 19;
      BPhasePortraitY = 29;
      
      pos = 2;
      handle = 2;
      testCase.setupAxesHandlesToReturnFromSubplot(pos,handle);
      
      testCase.verifyPhasePortraitsPlotted(handle,N,npt,...
        APhasePortraitX,APhasePortraitY,...
        BPhasePortraitX,BPhasePortraitY,...
        'Не выведены фазовые портреты решений для второго хищника на одном графике при N = 5');
    end
    
    function testPlotsPhasePortraitsForSecondPredatorAndNEqualTo6(testCase)
      N = 6;
      npt = 2;
      APhasePortraitX = 22;
      APhasePortraitY = 34;
      BPhasePortraitX = 23;
      BPhasePortraitY = 35;
      
      pos = 2;
      handle = 2;
      testCase.setupAxesHandlesToReturnFromSubplot(pos,handle);
      
      testCase.verifyPhasePortraitsPlotted(handle,N,npt,...
        APhasePortraitX,APhasePortraitY,...
        BPhasePortraitX,BPhasePortraitY,...
        'Не выведены фазовые портреты решений для второго хищника на одном графике при N = 6');
    end
  end
  
end

