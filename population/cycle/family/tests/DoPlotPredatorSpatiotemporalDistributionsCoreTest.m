classdef DoPlotPredatorSpatiotemporalDistributionsCoreTest < ...
    matlab.unittest.TestCase & FakeCurrentDirNameHelper...
      & MultipleLoadTestHelper & SubplotTestHelper
  
  properties
    argsPassedInToGetLastRowWithExtremeElementValue
    varsToReturnFromGetLastRowWithExtremeElementValue
    pointIndex
    argsPassedInToGetPeriod
    periodsToReturnFromGetPeriod
    argsPassedInToGetSolutionPart
    solutionParts
    argsPassedInToPlot3D
    argsPassedInToAxis
  end
  
  methods (TestMethodSetup)
    function setup(testCase)
      testCase.dirname = 'dir\';
      testCase.argsPassedInToGetLastRowWithExtremeElementValue = [];
      testCase.argsPassedInToGetPeriod = [];
      testCase.periodsToReturnFromGetPeriod = [];
      testCase.argsPassedInToGetSolutionPart = [];
      testCase.solutionParts = [];
      testCase.argsPassedInToPlot3D = [];
      testCase.argsPassedInToAxis = [];
    end
  end
  
  methods
    function setupSolutionToLoadFromFile(testCase,filename,t,w,...
        varIndex,period,...
        lastPointWithExtremeVarValueIndex,...
        preLastPointWithExtremeVarValueIndex)      
      loadedVars = struct;
      loadedVars.filename = strcat('dir\solution_results\',filename);
      
      vars = struct;
      vars.t = t;
      vars.w = w;
      
      loadedVars.vars = vars;
      
      testCase.varsToLoad = [testCase.varsToLoad,loadedVars];
            
      vars = struct;
      vars.sol = w;
      vars.colIndex = varIndex;
      sz = size(w);
      vars.rowIndexStart = sz(1);
      vars.row = [];
      vars.rowIndex = lastPointWithExtremeVarValueIndex;
      
      testCase.varsToReturnFromGetLastRowWithExtremeElementValue = ...
        [testCase.varsToReturnFromGetLastRowWithExtremeElementValue,vars];
      
      vars = struct;
      vars.sol = w;
      vars.colIndex = varIndex;
      vars.rowIndexStart = lastPointWithExtremeVarValueIndex;
      vars.row = [];
      vars.rowIndex = preLastPointWithExtremeVarValueIndex;
      
      testCase.varsToReturnFromGetLastRowWithExtremeElementValue = ...
        [testCase.varsToReturnFromGetLastRowWithExtremeElementValue,vars];
      
      periodToReturn = struct;
      periodToReturn.t = t;
      periodToReturn.w = w;
      periodToReturn.period = period;
      testCase.periodsToReturnFromGetPeriod = ...
        [testCase.periodsToReturnFromGetPeriod,periodToReturn];
    end
    
    function setupSolutionsToLoad(testCase,N,centerPointIndex,...
        periodA,periodB,...
        lastPointWithExtremeVarValueIndexA,...
        lastPointWithExtremeVarValueIndexB,...
        preLastPointWithExtremeVarValueIndexA,...
        preLastPointWithExtremeVarValueIndexB)
      nspecies = 3;
      nvar = N*nspecies;
      
      varIndex = N+centerPointIndex;
      
      testCase.varsToLoad = [];
      testCase.varsToReturnFromGetLastRowWithExtremeElementValue = [];
      
      npt = 30;
      t = zeros(1,npt);
      w = zeros(npt,nvar);
      testCase.setupSolutionToLoadFromFile('tillsteadyA.mat',t,w,...
        varIndex,periodA,...
        lastPointWithExtremeVarValueIndexA,...
        preLastPointWithExtremeVarValueIndexA);
      
      solPart = struct;
      solPart.tsol = t;
      solPart.wsol = w;
      
      gap = 100;
      npt = 2*gap;
      solPart.tpart = 0:1:npt-1;      
      
      wpart = zeros(npt,3*N);
      for pt = 1:npt
        offset = nspecies*(pt-1);
        wpart(pt,1:N) = offset;
        wpart(pt,N+1:2*N) = offset+1;
        wpart(pt,2*N+1:3*N) = offset+2;
      end
      solPart.wpart = wpart;
      
      testCase.solutionParts = [testCase.solutionParts,solPart];
      
      t = ones(1,npt);
      w = ones(npt,nvar);
      testCase.setupSolutionToLoadFromFile('tillsteadyB.mat',t,w,...
        varIndex,periodB,...
        lastPointWithExtremeVarValueIndexB,...
        preLastPointWithExtremeVarValueIndexB);
            
      solPart = struct;
      solPart.tsol = t;
      solPart.wsol = w;
      
      solPart.tpart = npt:1:2*npt-1;
      
      wpart = zeros(npt,3*N);
      for pt = 1:npt
        offset = nspecies*(npt+pt-1);
        wpart(pt,1:N) = offset;
        wpart(pt,N+1:2*N) = offset+1;
        wpart(pt,2*N+1:3*N) = offset+2;
      end
      solPart.wpart = wpart;
      
      testCase.solutionParts = [testCase.solutionParts,solPart];
    end
        
    function [row,rowIndex] = fakeGetLastRowWithExtremeElementValue(...
        testCase,sol,colIndex,extremeValueKind,rowIndexStart)
      if nargin < 5
        sz = size(sol);
        rowIndexStart = sz(1);
      end
      
      argsInfo = struct;
      argsInfo.sol = sol;
      argsInfo.colIndex = colIndex;
      argsInfo.extremeValueKind = extremeValueKind;
      argsInfo.rowIndexStart = rowIndexStart;
      testCase.argsPassedInToGetLastRowWithExtremeElementValue = ...
        [testCase.argsPassedInToGetLastRowWithExtremeElementValue,argsInfo];
      
      vars = testCase.varsToReturnFromGetLastRowWithExtremeElementValue(...
        arrayfun(@(v) isequal(v.sol,sol) && v.colIndex == colIndex...
          && v.rowIndexStart == rowIndexStart,...
          testCase.varsToReturnFromGetLastRowWithExtremeElementValue));
      
      if ~isempty(vars)
        row = vars.row;
        rowIndex = vars.rowIndex;
      else
        row = [];
        rowIndex = [];
      end
    end
    
    function T = fakeGetPeriod(testCase,t,w,fixedVarIndex,fixedVarValue)
      argsInfo = struct;
      argsInfo.t = t;
      argsInfo.w = w;
      argsInfo.fixedVarIndex = fixedVarIndex;
      argsInfo.fixedVarValue = fixedVarValue;
      testCase.argsPassedInToGetPeriod = ...
        [testCase.argsPassedInToGetPeriod,argsInfo];
      
      periodToReturnFromGetPeriod = ...
        testCase.periodsToReturnFromGetPeriod(arrayfun(...
          @(p) isequal(p.t,t) && isequal(p.w,w),...
          testCase.periodsToReturnFromGetPeriod));
      T = periodToReturnFromGetPeriod.period;
    end
    
    function [t,w] = fakeGetSolutionPart(testCase,t,w,pointIndex,tspan)
      argsInfo = struct;
      argsInfo.t = t;
      argsInfo.w = w;
      argsInfo.pointIndex = pointIndex;
      argsInfo.tspan = tspan;
      testCase.argsPassedInToGetSolutionPart = ...
        [testCase.argsPassedInToGetSolutionPart,argsInfo];
      
      solPart = testCase.solutionParts(arrayfun(...
        @(sol) isequal(sol.tsol,t) && isequal(sol.wsol,w),...
        testCase.solutionParts));
      t = solPart.tpart;
      w = solPart.wpart;
    end
    
    function h = fakePlot3D(testCase,handle,X,Y,Z)
      args = struct;      
      args.handle = handle;
      args.X = X;
      args.Y = Y;
      args.Z = Z;
      testCase.argsPassedInToPlot3D = [testCase.argsPassedInToPlot3D,args];
      h = 1;
    end
    
    function fakeSet(~,varargin)      
    end
    
    function fakeAxis(testCase,handle,lims)
      args = struct;
      args.handle = handle;
      args.lims = lims;
      testCase.argsPassedInToAxis = [testCase.argsPassedInToAxis,args];
    end
    
    function fakeXLabel(~,varargin)
    end
    
    function fakeYLabel(~,varargin)
    end
    
    function fakeZLabel(~,varargin)
    end
    
    function verifyGotSolutionPointWithMinFirstPredatorCenterPointDensity(...
        testCase,filename,N,centerPointIndex,...
        lastPointWithExtremeVarValueIndexA,...
        lastPointWithExtremeVarValueIndexB,...
        rowIndexStart,msg)
      periodA = 50;
      periodB = 30;
      preLastPointWithExtremeVarValueIndexA = 1;
      preLastPointWithExtremeVarValueIndexB = 2;
      testCase.setupSolutionsToLoad(N,centerPointIndex,periodA,periodB,...
        lastPointWithExtremeVarValueIndexA,...
        lastPointWithExtremeVarValueIndexB,...
        preLastPointWithExtremeVarValueIndexA,...
        preLastPointWithExtremeVarValueIndexB);
      testCase.act();
      
      vars = testCase.getVarsWithNamesToLoadFromFile(...
        strcat('dir\solution_results\',filename),{'t','w'});
      
      varIndex = N+centerPointIndex;
      
      argsInfo = struct;
      argsInfo.sol = vars.w;
      argsInfo.colIndex = varIndex;
      argsInfo.extremeValueKind = 'min';
      argsInfo.rowIndexStart = rowIndexStart;
      testCase.verifyFalse(isempty(find(arrayfun(...
        @(args) isequal(args,argsInfo),...
        testCase.argsPassedInToGetLastRowWithExtremeElementValue),1)),msg);
    end
    
    function verifyGotSolutionPeriod(testCase,filename,N,...
        centerPointIndex,msg)
      periodA = 30;
      periodB = 50;
      lastPointWithExtremeVarValueIndexA = 1;
      lastPointWithExtremeVarValueIndexB = 2;
      preLastPointWithExtremeVarValueIndexA = 3;
      preLastPointWithExtremeVarValueIndexB = 4;
      testCase.setupSolutionsToLoad(N,centerPointIndex,periodA,periodB,...
        lastPointWithExtremeVarValueIndexA,...
        lastPointWithExtremeVarValueIndexB,...
        preLastPointWithExtremeVarValueIndexA,...
        preLastPointWithExtremeVarValueIndexB);
      testCase.act();
      
      loadedVars = testCase.getVarsWithNamesToLoadFromFile(...
        strcat('dir\solution_results\',filename),{'t','w'});
      
      preyCenterPointVarIndex = centerPointIndex;
      
      expArgs = struct;
      expArgs.t = loadedVars.t;
      expArgs.w = loadedVars.w;
      expArgs.fixedVarIndex = preyCenterPointVarIndex;
      expArgs.fixedVarValue = 0.5;
      testCase.verifyFalse(isempty(find(arrayfun(...
        @(args) isequal(args,expArgs),...
        testCase.argsPassedInToGetPeriod),1)),msg);
    end
    
    function verifyGotSolutionOnTSpan(testCase,filename,N,...
        centerPointIndex,periodA,periodB,expTSpan,...
        preLastPointWithExtremeVarValueIndexA,...
        preLastPointWithExtremeVarValueIndexB,...
        expPointIndex,msg)
      lastPointWithExtremeVarValueIndexA = 1;
      lastPointWithExtremeVarValueIndexB = 2;
      testCase.setupSolutionsToLoad(N,centerPointIndex,periodA,periodB,...
        lastPointWithExtremeVarValueIndexA,...
        lastPointWithExtremeVarValueIndexB,...
        preLastPointWithExtremeVarValueIndexA,...
        preLastPointWithExtremeVarValueIndexB);
      
      testCase.act();
            
      vars = testCase.getVarsWithNamesToLoadFromFile(...
        strcat('dir\solution_results\',filename),{'t','w'});
      
      argsInfo = struct;
      argsInfo.t = vars.t;
      argsInfo.w = vars.w;
      argsInfo.pointIndex = expPointIndex;
      argsInfo.tspan = expTSpan;
      testCase.verifyFalse(isempty(find(arrayfun(...
        @(args) isequal(args,argsInfo),...
        testCase.argsPassedInToGetSolutionPart),1)),msg);
    end
        
    function verifyPlotted(testCase,handle,Y,Z,msg)
      N = 5;
      centerPointIndex = 3;
      periodA = 30;
      periodB = 50;
      lastPointWithExtremeVarValueIndexA = 1;
      lastPointWithExtremeVarValueIndexB = 2;
      preLastPointWithExtremeVarValueIndexA = 3;
      preLastPointWithExtremeVarValueIndexB = 4;
      testCase.setupSolutionsToLoad(N,centerPointIndex,periodA,periodB,...
        lastPointWithExtremeVarValueIndexA,...
        lastPointWithExtremeVarValueIndexB,...
        preLastPointWithExtremeVarValueIndexA,...
        preLastPointWithExtremeVarValueIndexB);      
      testCase.act();
      args = struct;
      args.handle = handle;
      args.X = [0 0.2 0.4 0.6 0.8];
      args.Y = Y;
      args.Z = Z;
      testCase.verifyFalse(isempty(find(arrayfun(@(a)...
        isequal(a,args),testCase.argsPassedInToPlot3D),1)),msg);
    end
    
    function verifyPlotFittedInLimits(testCase,handle,ZMin,ZMax,msg)
      N = 5;
      centerPointIndex = 3;
      periodA = 30;
      periodB = 50;
      lastPointWithExtremeVarValueIndexA = 1;
      lastPointWithExtremeVarValueIndexB = 2;
      preLastPointWithExtremeVarValueIndexA = 3;
      preLastPointWithExtremeVarValueIndexB = 4;
      testCase.setupSolutionsToLoad(N,centerPointIndex,periodA,periodB,...
        lastPointWithExtremeVarValueIndexA,...
        lastPointWithExtremeVarValueIndexB,...
        preLastPointWithExtremeVarValueIndexA,...
        preLastPointWithExtremeVarValueIndexB);
      pos = 1;
      axesHandle = 1;
      setupAxesHandles();
      pos = 2;
      axesHandle = 2;
      setupAxesHandles();
      pos = 3;
      axesHandle = 3;
      setupAxesHandles();
      pos = 4;
      axesHandle = 4;
      setupAxesHandles();
      testCase.act();      
      testCase.verifyFalse(isempty(find(arrayfun(@(a)...
        a.handle == handle && a.lims(1) <= 0 && a.lims(2) >= 1 ... 
          && a.lims(3) <= 0 && a.lims(4) >= periodA...
          && a.lims(5) <= ZMin && a.lims(6) >= ZMax,...
        testCase.argsPassedInToAxis),1)),msg);
      
      function setupAxesHandles()
        testCase.setupAxesHandlesToReturnFromSubplot(pos,axesHandle);
      end
    end    
  end
  
  methods (Access = protected)
    function verifySubplotCalled(testCase,pos,msg)
      N = 5;
      centerPointIndex = 3;
      periodA = 30;
      periodB = 50;
      lastPointWithExtremeVarValueIndexA = 1;
      lastPointWithExtremeVarValueIndexB = 2;
      preLastPointWithExtremeVarValueIndexA = 3;
      preLastPointWithExtremeVarValueIndexB = 4;
      testCase.setupSolutionsToLoad(N,centerPointIndex,periodA,periodB,...
        lastPointWithExtremeVarValueIndexA,...
        lastPointWithExtremeVarValueIndexB,...
        preLastPointWithExtremeVarValueIndexA,...
        preLastPointWithExtremeVarValueIndexB);
      nrow = 2;
      ncol = 2;
      verifySubplotCalled@SubplotTestHelper(testCase,nrow,ncol,pos,msg);
    end
    
    function act(testCase)
      doPlotPredatorSpatiotemporalDistributionsCore(...
        @testCase.fakeCurrentDirName,@testCase.fakeLoad,...
        @testCase.fakeGetLastRowWithExtremeElementValue,...
        @testCase.fakeGetPeriod,@testCase.fakeGetSolutionPart,...
        @testCase.fakeSubplot,@testCase.fakePlot3D,...        
        @testCase.fakeSet,@testCase.fakeAxis,...
        @testCase.fakeXLabel,@testCase.fakeYLabel,@testCase.fakeZLabel);
    end
  end
  
  methods (Test)
    function testGetsSolutionAPointWithMinFirstPredatorDensityForNEqualTo5(testCase)
      filename = 'tillsteadyA.mat';
      N = 5;
      centerPointIndex = 3;
      lastPointWithExtremeVarValueIndexA = 1;
      lastPointWithExtremeVarValueIndexB = 2;
      testCase.verifyGotSolutionPointWithMinFirstPredatorCenterPointDensity(...
        filename,N,centerPointIndex,...
        lastPointWithExtremeVarValueIndexA,...
        lastPointWithExtremeVarValueIndexB,...
        lastPointWithExtremeVarValueIndexA,...
        'Не получена точка решения A с минимумом первой популяции хищников в центре ареала при N = 5');
    end
    
    function testGetsSolutionBPointWithMinFirstPredatorDensityForNEqualTo5(testCase)
      filename = 'tillsteadyB.mat';
      N = 5;
      centerPointIndex = 3;
      lastPointWithExtremeVarValueIndexA = 1;
      lastPointWithExtremeVarValueIndexB = 2;
      testCase.verifyGotSolutionPointWithMinFirstPredatorCenterPointDensity(...
        filename,N,centerPointIndex,...
        lastPointWithExtremeVarValueIndexA,...
        lastPointWithExtremeVarValueIndexB,...
        lastPointWithExtremeVarValueIndexB,...
        'Не получена точка решения B с минимумом первой популяции хищников в центре ареала при N = 5');
    end
    
    function testGetsSolutionAPointWithMinFirstPredatorDensityForNEqualTo6(testCase)
      filename = 'tillsteadyA.mat';
      N = 6;
      centerPointIndex = 4;
      lastPointWithExtremeVarValueIndexA = 1;
      lastPointWithExtremeVarValueIndexB = 2;
      testCase.verifyGotSolutionPointWithMinFirstPredatorCenterPointDensity(...
        filename,N,centerPointIndex,...
        lastPointWithExtremeVarValueIndexA,...
        lastPointWithExtremeVarValueIndexB,...
        lastPointWithExtremeVarValueIndexA,...
        'Не получена точка решения A с минимумом первой популяции хищников в центре ареала при N = 6');
    end
    
    function testGetsSolutionBPointWithMinFirstPredatorDensityForNEqualTo6(testCase)
      filename = 'tillsteadyB.mat';
      N = 6;
      centerPointIndex = 4;
      lastPointWithExtremeVarValueIndexA = 1;
      lastPointWithExtremeVarValueIndexB = 2;
      testCase.verifyGotSolutionPointWithMinFirstPredatorCenterPointDensity(...
        filename,N,centerPointIndex,...
        lastPointWithExtremeVarValueIndexA,...
        lastPointWithExtremeVarValueIndexB,...
        lastPointWithExtremeVarValueIndexB,...
        'Не получена точка решения B с минимумом первой популяции хищников в центре ареала при N = 6');
    end
    
    function testGetsSolutionAPeriodForNEqualTo5(testCase)
      N = 5;
      centerPointIndex = 3;
      testCase.verifyGotSolutionPeriod('tillsteadyA.mat',N,...
        centerPointIndex,'Не получен период решения A при N = 5');
    end
    
    function testGetsSolutionAPeriodForNEqualTo6(testCase)
      N = 6;
      centerPointIndex = 4;
      testCase.verifyGotSolutionPeriod('tillsteadyA.mat',N,...
        centerPointIndex,'Не получен период решения A при N = 6');
    end
    
    function testGetsSolutionBPeriodForNEqualTo5(testCase)
      N = 5;
      centerPointIndex = 3;
      testCase.verifyGotSolutionPeriod('tillsteadyB.mat',N,...
        centerPointIndex,'Не получен период решения B при N = 5');
    end
    
    function testGetsSolutionBPeriodForNEqualTo6(testCase)
      N = 6;
      centerPointIndex = 4;
      testCase.verifyGotSolutionPeriod('tillsteadyB.mat',N,...
        centerPointIndex,'Не получен период решения B при N = 6');
    end
    
    function testGetsSolutionAOnGreaterPeriodWhenPeriodAIsGreater(testCase)
      N = 5;
      centerPointIndex = 3;
      periodA = 50;
      periodB = 30;
      preLastPointWithExtremeVarValueIndexA = 1;
      preLastPointWithExtremeVarValueIndexB = 2;
      testCase.verifyGotSolutionOnTSpan('tillsteadyA.mat',N,...
        centerPointIndex,periodA,periodB,periodA,...
        preLastPointWithExtremeVarValueIndexA,...
        preLastPointWithExtremeVarValueIndexB,...
        preLastPointWithExtremeVarValueIndexA,...
        'Не получено решение A на большем периоде, когда больший период - A');
    end
    
    function testGetsSolutionAOnGreaterPeriodWhenPeriodBIsGreater(testCase)
      N = 5;
      centerPointIndex = 3;
      periodA = 30;
      periodB = 50;
      preLastPointWithExtremeVarValueIndexA = 1;
      preLastPointWithExtremeVarValueIndexB = 2;
      testCase.verifyGotSolutionOnTSpan('tillsteadyA.mat',N,...
        centerPointIndex,periodA,periodB,periodB,...
        preLastPointWithExtremeVarValueIndexA,...
        preLastPointWithExtremeVarValueIndexB,...
        preLastPointWithExtremeVarValueIndexA,...
        'Не получено решение A на большем периоде, когда больший период - B');
    end
    
    function testGetsSolutionBOnGreaterPeriodWhenPeriodAIsGreater(testCase)
      N = 5;
      centerPointIndex = 3;
      periodA = 50;
      periodB = 30;
      preLastPointWithExtremeVarValueIndexA = 1;
      preLastPointWithExtremeVarValueIndexB = 2;
      testCase.verifyGotSolutionOnTSpan('tillsteadyB.mat',N,...
        centerPointIndex,periodA,periodB,periodA,...
        preLastPointWithExtremeVarValueIndexA,...
        preLastPointWithExtremeVarValueIndexB,...
        preLastPointWithExtremeVarValueIndexB,...
        'Не получено решение B на большем периоде, когда больший период - A');
    end
    
    function testGetsSolutionBOnGreaterPeriodWhenPeriodBIsGreater(testCase)
      N = 5;
      centerPointIndex = 3;
      periodA = 30;
      periodB = 50;
      preLastPointWithExtremeVarValueIndexA = 1;
      preLastPointWithExtremeVarValueIndexB = 2;
      testCase.verifyGotSolutionOnTSpan('tillsteadyB.mat',N,...
        centerPointIndex,periodA,periodB,periodB,...
        preLastPointWithExtremeVarValueIndexA,...
        preLastPointWithExtremeVarValueIndexB,...
        preLastPointWithExtremeVarValueIndexB,...
        'Не получено решение B на большем периоде, когда больший период - B');
    end
    
    function testCreatesFirstSubplot(testCase)
      pos = 1;
      testCase.verifySubplotCalled(pos,'Не создана первая область окна');
    end
    
    function testCreatesSecondSubplot(testCase)
      pos = 2;
      testCase.verifySubplotCalled(pos,'Не создана вторая область окна');
    end
    
    function testCreatesThirdSubplot(testCase)
      pos = 3;
      testCase.verifySubplotCalled(pos,'Не создана третья область окна');
    end
    
    function testCreatesFourthSubplot(testCase)
      pos = 4;
      testCase.verifySubplotCalled(pos,...
        'Не создана четвертая область окна');
    end
    
    function testPlotsSolutionAFirstPredatorPart(testCase)
      gap = 100;
      Y = [0 gap];
      N = 5;
      Z(1,1:N) = 1;
      Z(2,1:N) = 3*gap+1;
      
      pos = 1;      
      handle = 1;      
      testCase.setupAxesHandlesToReturnFromSubplot(pos,handle);
      
      testCase.verifyPlotted(handle,Y,Z,...
        'Не построен график первого хищника для решения A');
    end
    
    function testPlotsSolutionBFirstPredatorPart(testCase)
      gap = 100;
      Y = [2*gap 3*gap];
      N = 5;
      Z(1,1:N) = 6*gap+1;
      Z(2,1:N) = 9*gap+1;
     
      pos = 2;      
      handle = 2;      
      testCase.setupAxesHandlesToReturnFromSubplot(pos,handle);
      
      testCase.verifyPlotted(handle,Y,Z,...
        'Не построен график первого хищника для решения B');
    end
    
    function testPlotsSolutionASecondPredatorPart(testCase)      
      gap = 100;
      Y = [0 gap];
      N = 5;
      Z(1,1:N) = 2;
      Z(2,1:N) = 3*gap+2;
      
      pos = 3;      
      handle = 3;      
      testCase.setupAxesHandlesToReturnFromSubplot(pos,handle);
      
      testCase.verifyPlotted(handle,Y,Z,...
        'Не построен график второго хищника для решения A');
    end
    
    function testPlotsSolutionBSecondPredatorPart(testCase)
      gap = 100;
      Y = [2*gap 3*gap];
      N = 5;
      Z(1,1:N) = 6*gap+2;
      Z(2,1:N) = 9*gap+2;
      
      pos = 4;      
      handle = 4;      
      testCase.setupAxesHandlesToReturnFromSubplot(pos,handle);
      
      testCase.verifyPlotted(handle,Y,Z,...
        'Не построен график второго хищника для решения B');
    end
    
    function testSolutionAFirstPredatorPlotFitsInLimits(testCase)    
      handle = 1;      
      ZMin = 1;
      ZMax = 301;
      testCase.verifyPlotFittedInLimits(handle,ZMin,ZMax,...
        'График первого хищника для решения A не помещается в границах рисунка');
    end
    
    function testSolutionBFirstPredatorPlotFitsInLimits(testCase)      
      handle = 2;
      ZMin = 601;
      ZMax = 901;
      testCase.verifyPlotFittedInLimits(handle,ZMin,ZMax,...
        'График первого хищника для решения B не помещается в границах рисунка');
    end
    
    function testSolutionASecondPredatorPlotFitsInLimits(testCase)
      handle = 3;
      ZMin = 2;
      ZMax = 302;
      testCase.verifyPlotFittedInLimits(handle,ZMin,ZMax,...
        'График второго хищника для решения A не помещается в границах рисунка');
    end
    
    function testSolutionBSecondPredatorPlotFitsInLimits(testCase)
      handle = 4;
      ZMin = 602;
      ZMax = 902;
      testCase.verifyPlotFittedInLimits(handle,ZMin,ZMax,...
        'График второго хищника для решения B не помещается в границах рисунка');
    end
    
    function testAllPlotsAreInSameZLimits(testCase)      
      N = 5;
      centerPointIndex = 3;
      periodA = 30;
      periodB = 50;
      lastPointWithExtremeVarValueIndexA = 1;
      lastPointWithExtremeVarValueIndexB = 2;
      preLastPointWithExtremeVarValueIndexA = 3;
      preLastPointWithExtremeVarValueIndexB = 4;
      testCase.setupSolutionsToLoad(N,centerPointIndex,periodA,periodB,...
        lastPointWithExtremeVarValueIndexA,...
        lastPointWithExtremeVarValueIndexB,...
        preLastPointWithExtremeVarValueIndexA,...
        preLastPointWithExtremeVarValueIndexB);            
      testCase.act();
      firstArgsPassedInToAxis = testCase.argsPassedInToAxis(1);
      expNSameZLimAxis = 4;
      testCase.verifyEqual(length(find(arrayfun(...
        @(a) a.lims(5) == firstArgsPassedInToAxis.lims(5)...
          && a.lims(6) == firstArgsPassedInToAxis.lims(6),...
        testCase.argsPassedInToAxis))),expNSameZLimAxis,...
        'Графики построены в разных пределах по высоте');
    end
  end
  
end

