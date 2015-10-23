classdef DoPlotPredatorSpatiotemporalDistributionsCoreTest < ...
    matlab.unittest.TestCase & FakeCurrentDirNameHelper...
      & MultipleLoadTestHelper & SubplotTestHelper...
      & MultipleFigurePlotsTestHelper
  
  properties
    famDirName
    sol1Filename
    sol2Filename
    tf
    nspecies
    gap
    solAIndexOfLastPtWithPredator1Max
    solAIndexOfPreLastPtWithPredator1Max
    solAIndexOfLastPtWithPredator1MinBeforePreLastPtWithPredator1Max
    solBIndexOfLastPtWithPredator1Max
    solBIndexOfPreLastPtWithPredator1Max
    solBIndexOfLastPtWithPredator1MinBeforePreLastPtWithPredator1Max
    argsPassedInToGetLastRowWithExtremeElementValue
    pointIndex
    argsPassedInToGetPeriod
    periodsToReturnFromGetPeriod
    argsPassedInToGetSolutionPart
    solutionParts
    argsPassedInToPlot3D
    argsPassedInToAxis
    lastYTickArr
  end
  
  methods (TestMethodSetup)
    function setup(testCase)
      testCase.dirname = 'dir\';
      testCase.famDirName = ...
        'dir\solution_results\families\p=1+0.5sin(2 pi x)\l2=1.1\';
      testCase.sol1Filename = '1.mat';
      testCase.sol2Filename = '9.mat';
      testCase.gap = 100;
      testCase.tf = 20*testCase.gap-1;
      testCase.nspecies = 3;   
      testCase.solAIndexOfLastPtWithPredator1MinBeforePreLastPtWithPredator1Max = ...
        testCase.gap;
      testCase.solAIndexOfPreLastPtWithPredator1Max = 250;
      testCase.solAIndexOfLastPtWithPredator1Max = 500;            
      testCase.solBIndexOfLastPtWithPredator1MinBeforePreLastPtWithPredator1Max = ...
        2*testCase.gap; 
      testCase.solBIndexOfPreLastPtWithPredator1Max = 4*testCase.gap;      
      testCase.solBIndexOfLastPtWithPredator1Max = 6*testCase.gap;           
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
    function setupAlignedSolutionsOfSameLengthToLoadForNEqualTo3(testCase)
      testCase.setupAlignedSolutionsToLoadForNEqualTo3(testCase.tf,...
        testCase.tf);
    end
    
    function setupAlignedSolutionsToLoadForNEqualTo3(testCase,solATF,...
        solBTF)
      solATStep = 2;
      solBTStep = 1;
      testCase.setupSolutionsToLoadForNEqualTo3(solATStep,solBTStep,...
        solATF,solBTF);
    end
    
    function setupAlignedSolutionsToLoad(testCase,N,nvar,solATF,solBTF)
      solATStep = 2;
      solBTStep = 1;
      testCase.setupSolutionsToLoad(N,nvar,solATStep,solBTStep,solATF,...
        solBTF);
    end
    
    function setupNotAlignedSolutionsToLoadForNEqualTo3(testCase)
      solATStep = 1.5;
      solBTStep = 1;
      testCase.setupSolutionsToLoadForNEqualTo3(solATStep,solBTStep,...
        testCase.tf,testCase.tf);
    end
    
    function setupSolutionsToLoadForNEqualTo3(testCase,solATStep,...
        solBTStep,solATF,solBTF)
      N = 3;
      nvar = 9;
      testCase.setupSolutionsToLoad(N,nvar,solATStep,solBTStep,solATF,...
        solBTF);
    end
    
    function setupSolutionsToLoad(testCase,N,nvar,solATStep,solBTStep,...
        solATF,solBTF)      
      offset = 0;            
      tstep = solATStep;
      
      testCase.setupSolutionToLoadFromFile(testCase.sol1Filename,N,nvar,...
        tstep,offset,solATF,...
        testCase.solAIndexOfLastPtWithPredator1Max,...
        testCase.solAIndexOfPreLastPtWithPredator1Max,...
        testCase.solAIndexOfLastPtWithPredator1MinBeforePreLastPtWithPredator1Max);
      
      offset = fix((solATF+1)/solATStep)*testCase.nspecies;
      tstep = solBTStep;      
      
      testCase.setupSolutionToLoadFromFile(testCase.sol2Filename,N,nvar,...
        tstep,offset,solBTF,...
        testCase.solBIndexOfLastPtWithPredator1Max,...
        testCase.solBIndexOfPreLastPtWithPredator1Max,...
        testCase.solBIndexOfLastPtWithPredator1MinBeforePreLastPtWithPredator1Max);
    end
    
    function setupSolutionToLoadFromFile(testCase,filename,N,nvar,tstep,...
        offset,tf,indexOfLastPtWithPredator1Max,...
        indexOfPreLastPtWithPredator1Max,...
        indexOfLastPtWithPredator1MinBeforePreLastPtWithPredator1Max)      
      loadedVars = struct;
      loadedVars.filename = strcat(testCase.famDirName,filename);
      
      t = 0:tstep:tf;
      npt = fix((tf+1)/tstep);
      w = zeros(npt,nvar);      
      for pt = 1:npt
        w(pt,1:N) = offset+1;
        w(pt,N+1:2*N) = offset+2;
        w(pt,2*N+1:3*N) = offset+3;
        offset = offset+testCase.nspecies;
      end
      
      vars = struct;
      vars.t = t;
      vars.w = w;
      
      loadedVars.vars = vars;
      
      testCase.varsToLoad = [testCase.varsToLoad,loadedVars];
      
      vars = struct;
      vars.sol = w;
      vars.rowIndexStart = length(t);
      vars.row = [];
      vars.rowIndex = indexOfLastPtWithPredator1Max;
            
      testCase.varsToReturnFromGetLastRowWithExtremeElementValue = ...
        [testCase.varsToReturnFromGetLastRowWithExtremeElementValue,vars];
      
      vars = struct;
      vars.sol = w;
      vars.rowIndexStart = indexOfLastPtWithPredator1Max;
      vars.row = [];
      vars.rowIndex = indexOfPreLastPtWithPredator1Max;
      
      testCase.varsToReturnFromGetLastRowWithExtremeElementValue = ...
        [testCase.varsToReturnFromGetLastRowWithExtremeElementValue,vars];
      
      vars = struct;
      vars.sol = w;
      vars.rowIndexStart = indexOfPreLastPtWithPredator1Max;
      vars.row = [];
      vars.rowIndex = ...
        indexOfLastPtWithPredator1MinBeforePreLastPtWithPredator1Max;
      
      testCase.varsToReturnFromGetLastRowWithExtremeElementValue = ...
        [testCase.varsToReturnFromGetLastRowWithExtremeElementValue,vars];
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
        [testCase.argsPassedInToGetLastRowWithExtremeElementValue,...
          argsInfo];
      
      varsToReturn = getArrayItems(@(v) isequal(v.sol,sol)...
          && v.rowIndexStart == rowIndexStart,...
        testCase.varsToReturnFromGetLastRowWithExtremeElementValue);
      
      row = varsToReturn.row;
      rowIndex = varsToReturn.rowIndex;
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
    
    function fakeAxis(testCase,handle,lims)
      args = struct;
      args.handle = handle;
      args.lims = lims;
      testCase.argsPassedInToAxis = [testCase.argsPassedInToAxis,args];
    end
    
    function verifyGotSolLastPtWithPredator1MaxForNEqualTo3(testCase,...
        filename,msgStart)
      rowIndexStart = testCase.npt;
      testCase.verifyGotSolPtWithPredator1MaxForNEqualTo3(filename,...
        rowIndexStart,msgStart);
    end
    
    function verifyGotSolLastPtWithPredator1MaxForNEqualTo4(testCase,...
        filename,msgStart)      
      rowIndexStart = testCase.npt;
      testCase.verifyGotSolPtWithPredator1MaxForNEqualTo4(filename,...
        rowIndexStart,msgStart);
    end
    
    function verifyGotSolPtWithPredator1MaxForNEqualTo3(testCase,...
        filename,rowIndexStart,msgStart)
      extremumKind = 'max';
      testCase.verifyGotSolPtWithPredator1ExtremumForNEqualTo3(filename,...
        extremumKind,rowIndexStart,msgStart);
    end
    
    function verifyGotSolPtWithPredator1MaxForNEqualTo4(testCase,...
        filename,rowIndexStart,msgStart)
      extremumKind = 'max';
      testCase.verifyGotSolPtWithPredator1ExtremumForNEqualTo4(filename,...
        extremumKind,rowIndexStart,msgStart);
    end
        
    function verifyGotSolPtWithPredator1MinForNEqualTo3(testCase,...
        filename,rowIndexStart,msgStart)
      extremumKind = 'min';
      testCase.verifyGotSolPtWithPredator1ExtremumForNEqualTo3(filename,...
        extremumKind,rowIndexStart,msgStart);
    end
    
    function verifyGotSolPtWithPredator1MinForNEqualTo4(testCase,...
        filename,rowIndexStart,msgStart)
      extremumKind = 'min';
      testCase.verifyGotSolPtWithPredator1ExtremumForNEqualTo4(filename,...
        extremumKind,rowIndexStart,msgStart);
    end
        
    function verifyGotSolPtWithPredator1ExtremumForNEqualTo3(testCase,...
        filename,extremumKind,rowIndexStart,msg)
      N = 3;
      nvar = 9;
      firstPredatorCenterPointVarIndex = 5;
      testCase.verifyGotSolPtWithPredator1Extremum(filename,N,nvar,...
        firstPredatorCenterPointVarIndex,extremumKind,rowIndexStart,msg);
    end
    
    function verifyGotSolPtWithPredator1ExtremumForNEqualTo4(testCase,...
        filename,extremumKind,rowIndexStart,msg)
      N = 4;
      nvar = 12;
      firstPredatorCenterPointVarIndex = 7;
      testCase.verifyGotSolPtWithPredator1Extremum(filename,N,nvar,...
        firstPredatorCenterPointVarIndex,extremumKind,rowIndexStart,msg);
    end
    
    function verifyGotSolPtWithPredator1Extremum(testCase,filename,N,...
        nvar,firstPredatorCenterPointVarIndex,extremumKind,...
        rowIndexStart,msgStart)
      testCase.setupAlignedSolutionsToLoad(N,nvar,testCase.tf,testCase.tf);
      testCase.act();
      
      vars = testCase.getVarsWithNamesToLoadFromFile(...
        strcat(testCase.famDirName,filename),{'t','w'});
            
      argsInfo = struct;
      argsInfo.sol = vars.w;
      argsInfo.colIndex = firstPredatorCenterPointVarIndex;
      argsInfo.extremeValueKind = extremumKind;
      argsInfo.rowIndexStart = rowIndexStart;
      testCase.verifyFalse(isempty(find(arrayfun(...
        @(args) isequal(args,argsInfo),...
        testCase.argsPassedInToGetLastRowWithExtremeElementValue),1)),...
        testCase.getMsg(msgStart,N));
    end
    
    function verifySolAPredatorPlottedWhenSolATimesAreAlignedWithSolBTimes(...
        testCase,pos,predatorNo,solATF,solBTF,msg)
      testCase.setupAlignedSolutionsToLoadForNEqualTo3(solATF,solBTF);
      nrow = 3;
      tstep = 2;
      testCase.verifySolAPredatorPlotted(pos,predatorNo,nrow,tstep,msg);
    end
    
    function verifySolAPredatorPlottedWhenSolATimesAreNotAlignedWithSolBTimes(...
        testCase,pos,predatorNo,msg)
      testCase.setupNotAlignedSolutionsToLoadForNEqualTo3();
      nrow = 3;
      tstep = 1.5;
      testCase.verifySolAPredatorPlotted(pos,predatorNo,nrow,tstep,msg);
    end
    
    function verifySolAPredatorPlotted(testCase,pos,predatorNo,nrow,...
        tstep,msg)      
      offset = ...
        (testCase.solAIndexOfLastPtWithPredator1MinBeforePreLastPtWithPredator1Max-1)*...
          testCase.nspecies;
      testCase.verifySolPredatorPlotted(pos,predatorNo,nrow,...
        tstep,offset,msg);
    end
    
    function verifySolBPredatorPlotted(testCase,pos,predatorNo,solATF,...
        solBTF,msg)
      testCase.setupAlignedSolutionsToLoadForNEqualTo3(solATF,solBTF);
      nrow = 5;
      tstep = 1;
      offset = ((solATF+1)/2+...
          testCase.solBIndexOfLastPtWithPredator1MinBeforePreLastPtWithPredator1Max-1)*...
        testCase.nspecies;
      testCase.verifySolPredatorPlotted(pos,predatorNo,nrow,...
        tstep,offset,msg);
    end
    
    function verifySolPredatorPlotted(testCase,pos,predatorNo,...
        nrow,tstep,offset,msg)
      testCase.setupAxesHandlesToReturnFromSubplot(pos);          
      
      Y = zeros(1,nrow);
      N = 3;      
      Z = zeros(nrow,N);
      for pt = 1:nrow
        Y(pt) = (pt-1)*tstep*testCase.gap;
        Z(pt,:) = offset+1+predatorNo;
        offset = offset+testCase.nspecies*testCase.gap;
      end
            
      testCase.verifyPlotted(pos,Y,Z,msg);
    end
    
    function verifyPlotted(testCase,handle,Y,Z,msg)      
      testCase.act();
      args = struct;
      args.handle = handle;
      args.X = [0 1/3 2/3];
      args.Y = Y;
      args.Z = Z;
      testCase.verifyContainsItem(testCase.argsPassedInToPlot3D,args,msg);
    end
    
    function verifyPlotFittedInLimits(testCase,handle,ZMin,ZMax,msg)
      testCase.setupAlignedSolutionsOfSameLengthToLoadForNEqualTo3();
      nplot = 4;
      for pos = 1:nplot
        testCase.setupAxesHandlesToReturnFromSubplot(pos);
      end
      testCase.act();      
      
      tspan = ...
        testCase.solBIndexOfLastPtWithPredator1Max-...
        testCase.solBIndexOfLastPtWithPredator1MinBeforePreLastPtWithPredator1Max+1;
      
      testCase.verifyContains(@(a)...
        a.handle == handle && a.lims(1) <= 0 && a.lims(2) >= 1 ... 
          && a.lims(3) <= 0 && a.lims(4) >= tspan...
          && a.lims(5) <= ZMin && a.lims(6) >= ZMax,...
        testCase.argsPassedInToAxis,msg);
    end
    
    function verifyLastYTickIsNearestIntegerLessThanOrEqualToLastTime(...
        testCase,pos)               
      tstep = 1.007;
      
      testCase.setupSolutionsToLoadForNEqualTo3(tstep,tstep,testCase.tf,...
        testCase.tf);
      
      testCase.setupAxesHandlesToReturnFromSubplot(pos);          
      testCase.act();
      expLastYTick = struct;
      expLastYTick.handle = pos;
      expLastYTick.YTick = 402;
      testCase.verifyContainsItem(testCase.lastYTickArr,expLastYTick,...
        sprintf(...
          'Последняя метка на оси времени %d-го графика не соответсутвует последнему целому значению',...
          pos));
    end
    
    function [N,nvar,predator1CenterPtVarIndex] = ...
        getVarNumbersAndIndicesForNEqualTo3(~)
      N = 3;
      nvar = 9;
      predator1CenterPtVarIndex = 5;
    end
  end
  
  methods (Access = protected)
    function setupAxesHandlesToReturnFromSubplot(testCase,pos)
      handle = pos;
      setupAxesHandlesToReturnFromSubplot@SubplotTestHelper(testCase,...
        pos,handle);
    end
    
    function fakeSet(testCase,h,varargin)
      YTickIndexArr = find(strcmp(varargin,'YTick'));
      if ~isempty(YTickIndexArr)
        YTickArr = varargin{YTickIndexArr(1)+1};
        lastYTickPassedInToSet = struct;
        lastYTickPassedInToSet.handle = h;
        lastYTickPassedInToSet.YTick = YTickArr(end);
        testCase.lastYTickArr = [testCase.lastYTickArr,...
          lastYTickPassedInToSet];
      end
    end
    
    function verifySubplotCalled(testCase,pos,msg)
      testCase.setupAlignedSolutionsToLoadForNEqualTo3(testCase.tf,...
        testCase.tf);
      nrow = 2;
      ncol = 2;
      verifySubplotCalled@SubplotTestHelper(testCase,nrow,ncol,pos,msg);
    end
    
    function act(testCase)
      doPlotPredatorSpatiotemporalDistributionsCore(...
        @testCase.fakeCurrentDirName,@testCase.fakeLoad,...
        @testCase.fakeGetLastRowWithExtremeElementValue,...
        @testCase.fakeSubplot,@testCase.fakePlot3D,@testCase.fakeSet,...
        @testCase.fakeAxis,@testCase.fakeXLabel,@testCase.fakeYLabel,...
        @testCase.fakeZLabel);
    end
  end
  
  methods (Test)
    function testGetsSolALastPtWithPredator1MaxForNEqualTo3(testCase)
      rowIndexStart = (testCase.tf+1)/2;
      testCase.verifyGotSolPtWithPredator1MaxForNEqualTo3(...
        testCase.sol1Filename,rowIndexStart,...
        'Не получена последняя точка решения A с максимумом первого хищника');
    end
    
    function testGetsSolALastPtWithPredator1MaxForNEqualTo4(testCase)
      rowIndexStart = (testCase.tf+1)/2;
      testCase.verifyGotSolPtWithPredator1MaxForNEqualTo4(...
        testCase.sol1Filename,rowIndexStart,...
        'Не получена последняя точка решения A с максимумом первого хищника');
    end
    
    function testGetsSolAPreLastPtWithPredator1MaxForNEqualTo3(testCase)
      rowIndexStart = testCase.solAIndexOfLastPtWithPredator1Max;
      testCase.verifyGotSolPtWithPredator1MaxForNEqualTo3(...
        testCase.sol1Filename,rowIndexStart,...
        'Не получена предпоследняя точка решения A с максимумом первого хищника');
    end
    
    function testGetsSolAPreLastPtWithPredator1MaxForNEqualTo4(testCase)
      rowIndexStart = testCase.solAIndexOfLastPtWithPredator1Max;
      testCase.verifyGotSolPtWithPredator1MaxForNEqualTo4(...
        testCase.sol1Filename,rowIndexStart,...
        'Не получена предпоследняя точка решения A с максимумом первого хищника');
    end
    
    function testGetsForNEqualTo3SolALastPtWithPredator1MinBeforePreLastPtWithPredator1Max(testCase)
      rowIndexStart = testCase.solAIndexOfPreLastPtWithPredator1Max;
      testCase.verifyGotSolPtWithPredator1MinForNEqualTo3(...
        testCase.sol1Filename,rowIndexStart,...
        'Не получена последняя точка решения A с минимумом первого хищника, предшествующая предпоследней точке максимума первого хищника');
    end
    
    function testGetsForNEqualTo4SolALastPtWithPredator1MinBeforePreLastPtWithPredator1Max(testCase)
      rowIndexStart = testCase.solAIndexOfPreLastPtWithPredator1Max;
      testCase.verifyGotSolPtWithPredator1MinForNEqualTo4(...
        testCase.sol1Filename,rowIndexStart,...
        'Не получена последняя точка решения A с минимумом первого хищника, предшествующая предпоследней точке максимума первого хищника');
    end  
    
    function testGetsSolBLastPtWithPredator1MaxForNEqualTo3(testCase)
      rowIndexStart = testCase.tf+1;
      testCase.verifyGotSolPtWithPredator1MaxForNEqualTo3(...
        testCase.sol2Filename,rowIndexStart,...
        'Не получена последняя точка решения B с максимумом первого хищника');
    end
    
    function testGetsSolBLastPtWithPredator1MaxForNEqualTo4(testCase)
      rowIndexStart = testCase.tf+1;
      testCase.verifyGotSolPtWithPredator1MaxForNEqualTo4(...
        testCase.sol2Filename,rowIndexStart,...
        'Не получена последняя точка решения B с максимумом первого хищника');
    end
    
    function testGetsSolBPreLastPtWithPredator1MaxForNEqualTo3(testCase)
      rowIndexStart = testCase.solBIndexOfLastPtWithPredator1Max;
      testCase.verifyGotSolPtWithPredator1MaxForNEqualTo3(...
        testCase.sol2Filename,rowIndexStart,...
        'Не получена предпоследняя точка решения B с максимумом первого хищника');
    end
    
    function testGetsSolBPreLastPtWithPredator1MaxForNEqualTo4(testCase)
      rowIndexStart = testCase.solBIndexOfLastPtWithPredator1Max;
      testCase.verifyGotSolPtWithPredator1MaxForNEqualTo4(...
        testCase.sol2Filename,rowIndexStart,...
        'Не получена предпоследняя точка решения B с максимумом первого хищника');
    end
    
    function testGetsForNEqualTo3SolBLastPtWithPredator1MinBeforePreLastPtWithPredator1Max(...
        testCase)
      rowIndexStart = testCase.solBIndexOfPreLastPtWithPredator1Max;
      testCase.verifyGotSolPtWithPredator1MinForNEqualTo3(...
        testCase.sol2Filename,rowIndexStart,...
        'Не получена последняя точка решения B с минимумом первого хищника, предшествующая предпоследней точке максимума первого хищника');
    end
    
    function testGetsForNEqualTo4SolBLastPtWithPredator1MinBeforePreLastPtWithPredator1Max(...
        testCase)
      rowIndexStart = testCase.solBIndexOfPreLastPtWithPredator1Max;
      testCase.verifyGotSolPtWithPredator1MinForNEqualTo4(...
        testCase.sol2Filename,rowIndexStart,...
        'Не получена последняя точка решения B с минимумом первого хищника, предшествующая предпоследней точке максимума первого хищника');
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
    
    function testPlotsSolAPredator1PartWhenSolATimesAreAlignedWithSolBTimes(...
        testCase)
      pos = 1;
      predatorNo = 1;
      testCase.verifySolAPredatorPlottedWhenSolATimesAreAlignedWithSolBTimes(...
        pos,predatorNo,testCase.tf,testCase.tf,...
        'Не построен график 1-го хищника для решения A, когда времена решения A совпадают с временами решения B');
    end
    
    function testPlotsSolAPredator1PartWhenSolAPlotPartEndsInTheVeryEnd(...
        testCase)
      pos = 1;
      predatorNo = 1;
      solATF = 6*testCase.gap-1;
      solBTF = testCase.tf;
      testCase.verifySolAPredatorPlottedWhenSolATimesAreAlignedWithSolBTimes(...
        pos,predatorNo,solATF,solBTF,...
        'Не построен график 1-го хищника для решения A, когда конец выводимых частей решений совпадает с концом самих решений');
    end
    
    function testPlotsSolAPredator1PartWhenSolATimesAreNotAlignedWithSolBTimes(...
        testCase)
      pos = 1;
      predatorNo = 1;
      testCase.verifySolAPredatorPlottedWhenSolATimesAreNotAlignedWithSolBTimes(...
        pos,predatorNo,...
        'Не построен график 1-го хищника для решения A, когда времена решения A не совпадают с временами решения B');
    end
    
    function testPlotsSolBPredator1Part(testCase)
      pos = 2;
      predatorNo = 1;
      testCase.verifySolBPredatorPlotted(pos,predatorNo,testCase.tf,...
        testCase.tf,'Не построен график 1-го хищника для решения B');
    end
    
    function testPlotsSolAPredator2PartWhenSolATimesAreAlignedWithSolBTimes(testCase)            
      pos = 3;
      predatorNo = 2;
      testCase.verifySolAPredatorPlottedWhenSolATimesAreAlignedWithSolBTimes(...
        pos,predatorNo,testCase.tf,testCase.tf,...
        'Не построен график 2-го хищника для решения A, когда времена решения A совпадают с временами решения B');
    end
    
    function testPlotsSolAPredator2PartWhenSolAPlotPartEndsInTheVeryEnd(...
        testCase)
      pos = 1;
      predatorNo = 1;
      solATF = 6*testCase.gap-1;
      solBTF = testCase.tf;
      testCase.verifySolAPredatorPlottedWhenSolATimesAreAlignedWithSolBTimes(...
        pos,predatorNo,solATF,solBTF,...
        'Не построен график 2-го хищника для решения A, когда конец выводимых частей решений совпадает с концом самих решений');
    end
    
    function testPlotsSolAPredator2PartWhenSolATimesAreNotAlignedWithSolBTimes(testCase)            
      pos = 3;
      predatorNo = 2;
      testCase.verifySolAPredatorPlottedWhenSolATimesAreNotAlignedWithSolBTimes(...
        pos,predatorNo,...
        'Не построен график 2-го хищника для решения A, когда времена решения A не совпадают с временами решения B');
    end
    
    function testPlotsSolBPredator2Part(testCase)
      pos = 4;
      predatorNo = 2;
      testCase.verifySolBPredatorPlotted(pos,predatorNo,testCase.tf,...
        testCase.tf,'Не построен график 2-го хищника для решения B');
    end
    
    function testSolutionAFirstPredatorPlotFitsInLimits(testCase)    
      handle = 1;      
      ZMin = testCase.gap*testCase.nspecies+2;
      ZMax = 3*testCase.gap*testCase.nspecies+2;
      testCase.verifyPlotFittedInLimits(handle,ZMin,ZMax,...
        'График 1-го хищника для решения A не помещается в границах рисунка');
    end
    
    function testSolutionBFirstPredatorPlotFitsInLimits(testCase)      
      handle = 2;
      ZMin = 5*testCase.gap*testCase.nspecies+2;
      ZMax = 9*testCase.gap*testCase.nspecies+2;
      testCase.verifyPlotFittedInLimits(handle,ZMin,ZMax,...
        'График 1-го хищника для решения B не помещается в границах рисунка');
    end
    
    function testSolutionASecondPredatorPlotFitsInLimits(testCase)
      handle = 3;
      ZMin = testCase.gap*testCase.nspecies+3;
      ZMax = 3*testCase.gap*testCase.nspecies+3;
      testCase.verifyPlotFittedInLimits(handle,ZMin,ZMax,...
        'График 2-го хищника для решения A не помещается в границах рисунка');
    end
    
    function testSolutionBSecondPredatorPlotFitsInLimits(testCase)
      handle = 4;
      ZMin = 5*testCase.gap*testCase.nspecies+3;
      ZMax = 9*testCase.gap*testCase.nspecies+3;
      testCase.verifyPlotFittedInLimits(handle,ZMin,ZMax,...
        'График 2-го хищника для решения B не помещается в границах рисунка');
    end
    
    function testAllPlotsAreInSameZLimits(testCase)      
      testCase.setupAlignedSolutionsOfSameLengthToLoadForNEqualTo3();            
      testCase.act();
      firstArgsPassedInToAxis = testCase.argsPassedInToAxis(1);
      expNSameZLimAxis = 4;
      testCase.verifyEqual(length(find(arrayfun(...
        @(a) a.lims(5) == firstArgsPassedInToAxis.lims(5)...
          && a.lims(6) == firstArgsPassedInToAxis.lims(6),...
        testCase.argsPassedInToAxis))),expNSameZLimAxis,...
        'Графики построены в разных пределах по высоте');
    end
    
    function testPlot1LastYTickIsNearestIntegerLessThanOrEqualToLastTime(...
        testCase)
      pos = 1;
      testCase.verifyLastYTickIsNearestIntegerLessThanOrEqualToLastTime(...
        pos);
    end
    
    function testPlot2LastYTickIsNearestIntegerLessThanOrEqualToLastTime(...
        testCase)
      pos = 2;
      testCase.verifyLastYTickIsNearestIntegerLessThanOrEqualToLastTime(...
        pos);
    end
    
    function testPlot3LastYTickIsNearestIntegerLessThanOrEqualToLastTime(...
        testCase)
      pos = 3;
      testCase.verifyLastYTickIsNearestIntegerLessThanOrEqualToLastTime(...
        pos);
    end
    
    function testPlot4LastYTickIsNearestIntegerLessThanOrEqualToLastTime(...
        testCase)
      pos = 4;
      testCase.verifyLastYTickIsNearestIntegerLessThanOrEqualToLastTime(...
        pos);
    end
  end
  
end

