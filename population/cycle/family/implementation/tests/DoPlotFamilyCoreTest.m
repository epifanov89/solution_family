classdef DoPlotFamilyCoreTest < MFilenameAndGetFileDirnameTestBase...
    & LoadFamilyTestHelper...
    & MultiplePlotsOnSameFigureSingleFigureTestHelper
  
  properties
    nfamsol
    nsolpt
    nStandaloneSol
    nSolForTrajectoryPlot
    nSolPartForTrajectoryPlotRow
    namesPassedInToDir
    listingsToReturnFromDir    
    argsPassedInToGetLastRowWithExtremeElementValue
    argsPassedInToGetSolutionPartForTrajectoryPlot
    solutionPartsForTrajectoryPlot
    getSolutionPartForTrajectoryPlotCallNo
    plottedPoints
  end
  
  methods (TestMethodSetup)
    function setup(testCase)
      setup@LoadFamilyTestHelper(testCase);
      setup@MultiplePlotsOnSameFigureSingleFigureTestHelper(testCase);
      testCase.nfamsol = 7;
      testCase.nsolpt = 10;
      testCase.nStandaloneSol = 2;
      testCase.nSolForTrajectoryPlot = 3;
      testCase.nSolPartForTrajectoryPlotRow = 2;
      testCase.dirname = 'dir\';
      testCase.solutionPartsForTrajectoryPlot = {};
      testCase.getSolutionPartForTrajectoryPlotCallNo = 1;
      testCase.plottedPoints = {};     
    end
  end
  
  methods (Access = private)     
    function setupFamilyForNEqualTo2(testCase)
      nvar = 6;
      testCase.setupFamily(nvar);
    end
    
    function setupFamilyForNEqualTo3(testCase)
      nvar = 9;
      testCase.setupFamily(nvar);
    end
    
    function setupFamily(testCase,nvar)
      firstPredatorMortality = 1.1;
      files = testCase.setupFamilySolutions(firstPredatorMortality,nvar);
      testCase.setupStandaloneSolutionsAndDirListing(files,...
        firstPredatorMortality,nvar);
    end
    
    function files = setupFamilySolutions(testCase,...
        firstPredatorMortality,nvar)
      files = [];      

      filename = '0.mat';
      filepath = sprintf(...
        'dir\\solution_results\\families\\p=1+0.5sin(2 pi x)\\l2=%.1f\\0.mat',...
        firstPredatorMortality);
      solNo = 0;
      setupSolution();

      filename = '1.mat';
      filepath = sprintf(...
        'dir\\solution_results\\families\\p=1+0.5sin(2 pi x)\\l2=%.1f\\1.mat',...
        firstPredatorMortality);
      solNo = 1;
      setupSolution();

      filename = '6.mat';
      filepath = sprintf(...
        'dir\\solution_results\\families\\p=1+0.5sin(2 pi x)\\l2=%.1f\\6.mat',...
        firstPredatorMortality);
      solNo = 6;                      
      setupSolution();

      filename = '2.mat';
      filepath = sprintf(...
        'dir\\solution_results\\families\\p=1+0.5sin(2 pi x)\\l2=%.1f\\2.mat',...
        firstPredatorMortality);
      solNo = 2; 
      setupSolution();

      filename = '3.mat';
      filepath = sprintf(...
        'dir\\solution_results\\families\\p=1+0.5sin(2 pi x)\\l2=%.1f\\3.mat',...
        firstPredatorMortality);
      solNo = 3;  
      setupSolution();

      filename = '4.mat';
      filepath = sprintf(...
        'dir\\solution_results\\families\\p=1+0.5sin(2 pi x)\\l2=%.1f\\4.mat',...
        firstPredatorMortality);
      solNo = 4;  
      setupSolution();
      
      filename = '5.mat';
      filepath = sprintf(...
        'dir\\solution_results\\families\\p=1+0.5sin(2 pi x)\\l2=%.1f\\5.mat',...
        firstPredatorMortality);
      solNo = 5;  
      setupSolution();

      function setupSolution()          
        files = testCase.setupSol(files,filename,filepath,...
          solNo,nvar);
      end
    end
    
    function listing = setupSol(testCase,listing,filename,filepath,...
        solNo,nvar)
      file = struct; 
      file.name = filename;
      file.isdir = false;
      
      listing = [listing,file];

      sol = zeros(testCase.nsolpt,nvar);
      solVarValOffset = testCase.getNFamSolsVar(solNo,nvar);
      for row = 1:testCase.nsolpt
        sol(row,:) = ...
          solVarValOffset+(row-1)*nvar+1:solVarValOffset+row*nvar;
      end
      
      varsToLoad = struct;
      varsToLoad.filename = filepath;
      vars = struct;
      vars.w = sol;
      varsToLoad.vars = vars;
      testCase.varsToLoad = [testCase.varsToLoad,varsToLoad];

      vars = struct;
      vars.sol = sol;      
      maxPredatorsPtVarValOffset = solVarValOffset+testCase.nsolpt*nvar;
      maxPredatorsPtLastVarVal = maxPredatorsPtVarValOffset+nvar;
      vars.row = maxPredatorsPtVarValOffset+1:maxPredatorsPtLastVarVal;
      vars.rowIndex = maxPredatorsPtLastVarVal+1;
      testCase.varsToReturnFromGetLastRowWithExtremeElementValue = ...
        [testCase.varsToReturnFromGetLastRowWithExtremeElementValue,vars];
    end

    function setupStandaloneSolutionsAndDirListing(testCase,...
        files,firstPredatorMortality,nvar)
      testCase.setupStandaloneSolutions(firstPredatorMortality,nvar);      
      testCase.setupDirListing(firstPredatorMortality,files);
    end
    
    function setupStandaloneSolutionsForNEqualTo2(testCase)
      firstPredatorMortality = 1.1;
      nvar = 6;
      testCase.setupStandaloneSolutions(firstPredatorMortality,nvar);
    end
    
    function setupStandaloneSolutions(testCase,firstPredatorMortality,nvar)
      standaloneSolutionsOffset = ...
        testCase.getNFamSolsVar(testCase.nfamsol,nvar)+1;
      
      sol = standaloneSolutionsOffset;
      maxSecondPredatorPtLastVarVal = standaloneSolutionsOffset+nvar;
      setupZeroOnePredatorSolution(sprintf(...
          'dir\\solution_results\\families\\p=1+0.5sin(2 pi x)\\l2=%.1f\\zeroFirstPredator.mat',...
          firstPredatorMortality),sol,...
        standaloneSolutionsOffset+1:maxSecondPredatorPtLastVarVal);
      sol = maxSecondPredatorPtLastVarVal+1;
      maxFirstPredatorPtLastVarVal = sol+nvar;
      setupZeroOnePredatorSolution(sprintf(...
          'dir\\solution_results\\families\\p=1+0.5sin(2 pi x)\\l2=%.1f\\zeroSecondPredator.mat',...
          firstPredatorMortality),sol,sol+1:maxFirstPredatorPtLastVarVal);     
      
      offset = maxFirstPredatorPtLastVarVal;
      for solPartNo = 1:testCase.nSolForTrajectoryPlot
        solPartForTrajectoryPlot = ...
          zeros(testCase.nSolPartForTrajectoryPlotRow,nvar);
        for row = 1:testCase.nSolPartForTrajectoryPlotRow
          solPartRowLastVarVal = offset+nvar;
          solPartForTrajectoryPlot(row,:) = offset+1:solPartRowLastVarVal;
          offset = solPartRowLastVarVal;
        end
        testCase.solutionPartsForTrajectoryPlot = ...
          [testCase.solutionPartsForTrajectoryPlot,...
            solPartForTrajectoryPlot];
      end
       
      function setupZeroOnePredatorSolution(filename,sol,...
          pointWithMaxPredatorDensities)
        varsToLoad = struct;
        varsToLoad.filename = filename;
        vars = struct;
        vars.w = sol;
        varsToLoad.vars = vars;
        testCase.varsToLoad = [testCase.varsToLoad,varsToLoad];      

        vars = struct;
        vars.sol = sol;
        vars.row = pointWithMaxPredatorDensities;
        vars.rowIndex = [];
        testCase.varsToReturnFromGetLastRowWithExtremeElementValue = ...
          [testCase.varsToReturnFromGetLastRowWithExtremeElementValue,vars];
      end      
    end
    
    function setupDirListing(testCase,firstPredatorMortality,files)
      listing = struct;      
      listing.name = sprintf(...
        'dir\\solution_results\\families\\p=1+0.5sin(2 pi x)\\l2=%.1f\\*.mat',...
        firstPredatorMortality);
      listing.files = files;
      testCase.listingsToReturnFromDir = ...
        [testCase.listingsToReturnFromDir,listing];
    end
        
    function offset = getZeroSecondPredatorSolsVarOffset(testCase,nvar)
      offset = testCase.getZeroFirstPredatorSolsVarOffset(nvar)+nvar+1;
    end
    
    function offset = getZeroFirstPredatorSolsVarOffset(testCase,nvar)
      offset = testCase.getNFamSolsVar(testCase.nfamsol,nvar)+1;
    end
    
    function nsolvar = getNFamSolsVar(testCase,nsol,nvar)
      nsolvar = nsol*testCase.getNFamSolVar(nvar);
    end
    
    function nsolvar = getNFamSolVar(testCase,nvar)
      nsolvar = (testCase.nsolpt+1)*nvar+1;
    end
    
    function nsolvar = getNStandaloneSolVar(testCase,nvar)
      nsolvar = testCase.nStandaloneSol*(1+nvar)+testCase.nSolForTrajectoryPlot*testCase.nSolPartForTrajectoryPlotRow*nvar;
    end
    
    function verifyGotDirListing(testCase,firstPredatorMortality,msg)
      testCase.dirname = 'dir\';
      testCase.namesPassedInToDir = {};
      testCase.setupFamilyForNEqualTo2();
      testCase.act();
      testCase.verifyContainsItem(testCase.namesPassedInToDir,...
        sprintf('dir\\solution_results\\families\\p=1+0.5sin(2 pi x)\\l2=%.1f\\*.mat',...
          firstPredatorMortality),msg);
    end
    
    function verifyGotSolution0LastPointWithMaxPredatorDensitiesForNEqualTo2(...
        testCase,solNo,msgStart)
      colIndex = 6;
      testCase.verifyGotSolutionLastPointWithMaxPredatorDensitiesForNEqualTo2(...
        solNo,colIndex,msgStart);
    end
    
    function verifyGotSolution0LastPointWithMaxPredatorDensitiesForNEqualTo3(...
        testCase,solNo,msgStart)
      colIndex = 8;
      testCase.verifyGotSolutionLastPointWithMaxPredatorDensitiesForNEqualTo3(...
        solNo,colIndex,msgStart);
    end
    
    function verifyGotSolution1LastPointWithMaxPredatorDensitiesForNEqualTo2(...
        testCase,solNo,msgStart)
      colIndex = 4;
      testCase.verifyGotSolutionLastPointWithMaxPredatorDensitiesForNEqualTo2(...
        solNo,colIndex,msgStart);
    end
        
    function verifyGotSolution1LastPointWithMaxPredatorDensitiesForNEqualTo3(...
        testCase,solNo,msgStart)
      colIndex = 5;
      testCase.verifyGotSolutionLastPointWithMaxPredatorDensitiesForNEqualTo3(...
        solNo,colIndex,msgStart);
    end
    
    function verifyGotSolutionLastPointWithMaxPredatorDensitiesForNEqualTo2(...
        testCase,solNo,colIndex,msgStart)
      N = 2;
      nvar = 6;
      testCase.verifyGotSolutionLastPointWithMaxPredatorDensities(N,...
        nvar,colIndex,solNo,msgStart);
    end
    
    function verifyGotSolutionLastPointWithMaxPredatorDensitiesForNEqualTo3(...
        testCase,solNo,colIndex,msgStart)
      N = 3;
      nvar = 9;
      testCase.verifyGotSolutionLastPointWithMaxPredatorDensities(N,...
        nvar,colIndex,solNo,msgStart);
    end
    
    function verifyGotSolutionLastPointWithMaxPredatorDensities(...
        testCase,N,nvar,colIndex,solNo,msgStart)   
      testCase.setupFamily(nvar);
      
      testCase.act();
      
      args = struct;
      varValOffset = testCase.getNFamSolsVar(solNo,nvar);
      sol = zeros(testCase.nsolpt,nvar);
      for row = 1:testCase.nsolpt
        sol(row,:) = varValOffset+(row-1)*nvar+1:varValOffset+row*nvar;
      end
      args.solution = sol;
      args.colIndex = colIndex;
      args.extremeValueKind = 'max';
      msg = testCase.getMsg(msgStart,N);
      testCase.verifyContainsItem(...
        testCase.argsPassedInToGetLastRowWithExtremeElementValue,args,msg);
    end
    
    function verifyGotSolutionPartForTrajectoryPlot(testCase,...
        solNo,msg)      
      testCase.setupFamilyForNEqualTo2();
      
      testCase.act();
      
      args = struct;    
      nvar = 6;
      varValOffset = testCase.getNFamSolsVar(solNo,nvar);
      sol = zeros(testCase.nsolpt,nvar);
      for row = 1:testCase.nsolpt
        sol(row,:) = varValOffset+(row-1)*nvar+1:varValOffset+row*nvar;
      end
      args.sol = sol;
      args.pointIndex = varValOffset+testCase.getNFamSolVar(nvar);
      
      testCase.verifyContainsItem(...
        testCase.argsPassedInToGetSolutionPartForTrajectoryPlot,args,msg);
    end
    
    function verifyGotMaxSecondPredatorDensityForNEqualTo2(testCase,...
        msgStart)
      nvar = 6;
      sol = testCase.getZeroFirstPredatorSolsVarOffset(nvar);
      colIndex = 6;
      testCase.verifyGotMaxPredatorDensityForNEqualTo2(sol,colIndex,...
        msgStart);
    end
    
    function verifyGotMaxSecondPredatorDensityForNEqualTo3(testCase,...
        msgStart)
      nvar = 9;
      sol = testCase.getZeroFirstPredatorSolsVarOffset(nvar);
      colIndex = 8;
      testCase.verifyGotMaxPredatorDensityForNEqualTo3(sol,colIndex,...
        msgStart);
    end
    
    function verifyGotMaxFirstPredatorDensityForNEqualTo2(testCase,...
        msgStart)
      nvar = 6;
      sol = testCase.getZeroSecondPredatorSolsVarOffset(nvar);
      colIndex = 4;
      testCase.verifyGotMaxPredatorDensityForNEqualTo2(sol,colIndex,...
        msgStart);
    end
    
    function verifyGotMaxFirstPredatorDensityForNEqualTo3(testCase,...
        msgStart)
      nvar = 9;
      sol = testCase.getZeroSecondPredatorSolsVarOffset(nvar);
      colIndex = 5;
      testCase.verifyGotMaxPredatorDensityForNEqualTo3(sol,colIndex,...
        msgStart);
    end
    
    function verifyGotMaxPredatorDensityForNEqualTo2(testCase,sol,...
        colIndex,msgStart)
      N = 2;
      nvar = 6;
      testCase.verifyGotMaxNonZeroPredatorDensity(sol,N,nvar,colIndex,...
        msgStart);
    end
    
    function verifyGotMaxPredatorDensityForNEqualTo3(testCase,sol,...
        colIndex,msgStart)
      N = 3;
      nvar = 9;
      testCase.verifyGotMaxNonZeroPredatorDensity(sol,N,nvar,colIndex,...
        msgStart);
    end
    
    function verifyGotMaxNonZeroPredatorDensity(testCase,sol,N,nvar,...
        colIndex,msgStart)
      testCase.setupFamily(nvar);
      testCase.act();   
      
      args.solution = sol;
      args.colIndex = colIndex;
      args.extremeValueKind = 'max';
      msg = testCase.getMsg(msgStart,N);
      testCase.verifyContainsItem(...
        testCase.argsPassedInToGetLastRowWithExtremeElementValue,args,msg);
    end
    
    function line = getMaxPredatorsLineForNEqualTo2(testCase)
      [nvar,firstPredatorCenterPointVarIndex,...
          secondPredatorCenterPointVarIndex] = ...
        testCase.getVarNumberAndIndicesForNEqualTo2();
      line = testCase.getMaxPredatorsLine(nvar,...
        firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
    end
    
    function line = getMaxPredatorsLineForNEqualTo3(testCase)
      [nvar,firstPredatorCenterPointVarIndex,...
          secondPredatorCenterPointVarIndex] = ...
        testCase.getVarNumberAndIndicesForNEqualTo3();
      line = testCase.getMaxPredatorsLine(nvar,...
        firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
    end
    
    function line = getMaxPredatorsLine(testCase,nvar,...
        firstPredatorCenterPointVarIndex,secondPredatorCenterPointVarIndex)   
      ndim = 2;
      line = zeros(testCase.nfamsol,ndim);
      for row = 1:testCase.nfamsol
        offset = row*testCase.nsolpt*nvar+(row-1)*(nvar+1);
        line(row,1) = offset+firstPredatorCenterPointVarIndex;
        line(row,2) = offset+secondPredatorCenterPointVarIndex;
      end
    end
    
    function pt = getStandaloneSolMaxSecondPredatorPtForNEqualTo2(...
        testCase)
      [nvar,firstPredatorCenterPointVarIndex,...
          secondPredatorCenterPointVarIndex] = ...
        testCase.getVarNumberAndIndicesForNEqualTo2();
      pt = testCase.getStandaloneSolMaxSecondPredatorPt(nvar,...
        firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
    end
    
    function pt = getStandaloneSolMaxSecondPredatorPtForNEqualTo3(testCase)
      [nvar,firstPredatorCenterPointVarIndex,...
          secondPredatorCenterPointVarIndex] = ...
        testCase.getVarNumberAndIndicesForNEqualTo3();
      pt = testCase.getStandaloneSolMaxSecondPredatorPt(nvar,...
        firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
    end
    
    function pt = getStandaloneSolMaxSecondPredatorPt(testCase,nvar,...
        firstPredatorCenterPointVarIndex,secondPredatorCenterPointVarIndex)
      standaloneSolNo = 0;
      pt = testCase.getStandaloneSolMaxNonZeroPredatorPt(...
        standaloneSolNo,nvar,firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
    end
       
    function pt = getStandaloneSolMaxFirstPredatorPtForNEqualTo2(...
        testCase)
      [nvar,firstPredatorCenterPointVarIndex,...
          secondPredatorCenterPointVarIndex] = ...
        testCase.getVarNumberAndIndicesForNEqualTo2();
      pt = testCase.getStandaloneSolMaxFirstPredatorPt(nvar,...
        firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
    end
    
    function pt = getStandaloneSolMaxFirstPredatorPtForNEqualTo3(...
        testCase)
      [nvar,firstPredatorCenterPointVarIndex,...
          secondPredatorCenterPointVarIndex] = ...
        testCase.getVarNumberAndIndicesForNEqualTo3();
      pt = testCase.getStandaloneSolMaxFirstPredatorPt(nvar,...
        firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
    end
    
    function pt = getStandaloneSolMaxFirstPredatorPt(testCase,...
        nvar,firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex)
      standaloneSolNo = 1;
      pt = testCase.getStandaloneSolMaxNonZeroPredatorPt(...
        standaloneSolNo,nvar,firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
    end 
    
    function pt = getStandaloneSolMaxNonZeroPredatorPt(testCase,...
        standaloneSolNo,nvar,firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex)
      maxSecondPredatorPt = ...
        testCase.nfamsol*testCase.getNFamSolVar(nvar)+...
        standaloneSolNo*(nvar+1)+1;
      pt = [maxSecondPredatorPt+firstPredatorCenterPointVarIndex,...
            maxSecondPredatorPt+secondPredatorCenterPointVarIndex];
    end
    
    function line = getFirstSolPartForTrajectoryPlot(testCase,nvar,...
        firstPredatorCenterPointVarIndex,secondPredatorCenterPointVarIndex)
      solPartNo = 0;
      line = testCase.getSolPartForTrajectoryPlot(solPartNo,nvar,...
        firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
    end
    
    function line = getSecondSolPartForTrajectoryPlotForNEqualTo2(testCase)
      [nvar,firstPredatorCenterPointVarIndex,...
          secondPredatorCenterPointVarIndex] = ...
        testCase.getVarNumberAndIndicesForNEqualTo2();
      line = testCase.getSecondSolPartForTrajectoryPlot(nvar,...
        firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
    end
    
    function line = getSecondSolPartForTrajectoryPlotForNEqualTo3(testCase)
      [nvar,firstPredatorCenterPointVarIndex,...
          secondPredatorCenterPointVarIndex] = ...
        testCase.getVarNumberAndIndicesForNEqualTo3();
      line = testCase.getSecondSolPartForTrajectoryPlot(nvar,...
        firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
    end
    
    function line = getSecondSolPartForTrajectoryPlot(testCase,nvar,...
        firstPredatorCenterPointVarIndex,secondPredatorCenterPointVarIndex)
      solPartNo = 1;
      line = testCase.getSolPartForTrajectoryPlot(solPartNo,nvar,...
        firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
    end
    
    function line = getThirdSolPartForTrajectoryPlotForNEqualTo2(testCase)
      [nvar,firstPredatorCenterPointVarIndex,...
          secondPredatorCenterPointVarIndex] = ...
        testCase.getVarNumberAndIndicesForNEqualTo2();
      line = testCase.getThirdSolPartForTrajectoryPlot(nvar,...
        firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
    end
    
    function line = getThirdSolPartForTrajectoryPlotForNEqualTo3(testCase)
      [nvar,firstPredatorCenterPointVarIndex,...
          secondPredatorCenterPointVarIndex] = ...
        testCase.getVarNumberAndIndicesForNEqualTo3();
      line = testCase.getThirdSolPartForTrajectoryPlot(nvar,...
        firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
    end
    
    function line = getThirdSolPartForTrajectoryPlot(testCase,nvar,...
        firstPredatorCenterPointVarIndex,secondPredatorCenterPointVarIndex)
      solPartNo = 2;
      line = testCase.getSolPartForTrajectoryPlot(solPartNo,nvar,...
        firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
    end
    
    function line = getSolPartForTrajectoryPlot(testCase,solPartNo,nvar,...
        firstPredatorCenterPointVarIndex,secondPredatorCenterPointVarIndex)      
      ndim = 2;
      line = zeros(testCase.nSolPartForTrajectoryPlotRow,ndim);
      solPartOffset = testCase.nfamsol*testCase.getNFamSolVar(nvar)+...
        testCase.nStandaloneSol*(nvar+1)+...
        solPartNo*testCase.nSolPartForTrajectoryPlotRow*nvar;
      for row = 1:testCase.nSolPartForTrajectoryPlotRow
        offset = solPartOffset+(row-1)*nvar;
        line(row,1) = offset+firstPredatorCenterPointVarIndex;
        line(row,2) = offset+secondPredatorCenterPointVarIndex;
      end
    end
    
    function [nvar,firstPredatorCenterPointVarIndex,...
          secondPredatorCenterPointVarIndex] = ...
        getVarNumberAndIndicesForNEqualTo2(~)
      nvar = 6;
      firstPredatorCenterPointVarIndex = 4;
      secondPredatorCenterPointVarIndex = 6;
    end
    
    function [nvar,firstPredatorCenterPointVarIndex,...
          secondPredatorCenterPointVarIndex] = ...
        getVarNumberAndIndicesForNEqualTo3(~)
      nvar = 9;
      firstPredatorCenterPointVarIndex = 5;
      secondPredatorCenterPointVarIndex = 8;
    end
    
    function verifyLinePlottedForNEqualTo2(testCase,line,...
        msgStart)
      N = 2;
      testCase.setupFamilyForNEqualTo2();
      testCase.verifyLinePlotted(N,line,msgStart);
    end
    
    function verifyLinePlottedForNEqualTo3(testCase,line,...
        msgStart)
      N = 3;
      testCase.setupFamilyForNEqualTo3();
      testCase.verifyLinePlotted(N,line,msgStart);
    end
        
    function verifyPointPlottedForNEqualTo2(testCase,pt,...
        msgStart)
      N = 2;
      testCase.setupFamilyForNEqualTo2(); 
      testCase.verifyPointPlotted(N,pt,msgStart);
    end
      
    function verifyPointPlottedForNEqualTo3(testCase,pt,...
        msgStart)
      N = 3;
      testCase.setupFamilyForNEqualTo3();   
      testCase.verifyPointPlotted(N,pt,msgStart);
    end
        
    function files = fakeDir(testCase,name)
      testCase.namesPassedInToDir = [testCase.namesPassedInToDir,name];      
      listing = getArrayItems(@(l) strcmp(l.name,name),...
        testCase.listingsToReturnFromDir);
      files = listing.files;
    end

    function [row,rowIndex] = fakeGetLastRowWithExtremeElementValue(...
        testCase,sol,colIndex,extremeValueKind)      
      argsInfo = struct;
      argsInfo.solution = sol;
      argsInfo.colIndex = colIndex;
      argsInfo.extremeValueKind = extremeValueKind;
      testCase.argsPassedInToGetLastRowWithExtremeElementValue = ...
        [testCase.argsPassedInToGetLastRowWithExtremeElementValue,argsInfo];

      vars = testCase.varsToReturnFromGetLastRowWithExtremeElementValue(...
        arrayfun(@(v) isequal(v.sol,sol),...
          testCase.varsToReturnFromGetLastRowWithExtremeElementValue));

      if isfield(vars,'row')
        row = vars.row;
      else
        row = [];
      end
      
      if isfield(vars,'rowIndex')
        rowIndex = vars.rowIndex;
      else
        rowIndex = [];
      end
    end

    function solPart = fakeGetSolutionPartForTrajectoryPlot(testCase,...
        sol,pointIndex)
      args = struct;
      args.sol = sol;
      args.pointIndex = pointIndex;
      testCase.argsPassedInToGetSolutionPartForTrajectoryPlot = ...
        [testCase.argsPassedInToGetSolutionPartForTrajectoryPlot,args];
      solPart = testCase.solutionPartsForTrajectoryPlot{...
        testCase.getSolutionPartForTrajectoryPlotCallNo};
      testCase.getSolutionPartForTrajectoryPlotCallNo = ...
        testCase.getSolutionPartForTrajectoryPlotCallNo+1;
    end
  end 
   
  methods (Access = protected)    
    function verifyLinePlotted(testCase,N,line,msgStart)
      msg = testCase.getMsg(msgStart,N);
      verifyLinePlotted@MultiplePlotsOnSameFigureSingleFigureTestHelper(...
        testCase,line,msg);
    end
    
    function verifyPointPlotted(testCase,N,pt,msgStart)   
      testCase.act();
      msg = testCase.getMsg(msgStart,N);
      testCase.verifyContainsItem(testCase.plottedPoints,pt,msg);
    end
    
    function processPointPlot(testCase,pt)
      testCase.plottedPoints = [testCase.plottedPoints,pt];
    end
    
    function act(testCase)
      doPlotFamilyCore(@testCase.fakeMFilename,...
        @testCase.fakeGetFileDirname,@testCase.fakeDir,...
        @testCase.fakeLoad,...
        @testCase.fakeGetLastRowWithExtremeElementValue,...
        @testCase.fakeGetSolutionPartForTrajectoryPlot,...
        @testCase.fakePlot,@testCase.fakeHold,@testCase.fakeLabel,...
        @testCase.fakeXLabel,@testCase.fakeYLabel,@testCase.fakeGCA,...
        @testCase.fakeSet);
    end
  end
  
  methods (Test)
    function testGetsMFilename(testCase)
      testCase.setupFamilyForNEqualTo2();
      testCase.verifyGotMFilename();
    end
    
    function testGetsFileDirname(testCase)
      testCase.setupFamilyForNEqualTo2();
      testCase.verifyGotFileDirname();
    end
    
    function testGetsDirListing(testCase)
      firstPredatorMortality = 1.1;
      testCase.verifyGotDirListing(firstPredatorMortality,...
        'Не получены имена файлов с решениями семейства');
    end
    
    function testDoesNotLoadFromForeignFiles(testCase) 
      firstPredatorMortality = 1.1;
      nvar = 3;
      files = testCase.setupFamilySolutions(firstPredatorMortality,nvar);
            
      testCase.setupStandaloneSolutions(firstPredatorMortality,nvar);
      
      foreignFile = struct;
      foreignFile.name = 'foreign_file.mat';
      foreignFile.isdir = false;      
      files = [files,foreignFile];
      
      testCase.setupDirListing(firstPredatorMortality,files);
            
      testCase.act();
      testCase.verifyDoesNotContainItem(...
        testCase.filenamesPassedInToLoad,...
        'dir\\solution_results\\families\\p=1+0.5sin(2 pi x)\\l2=1.1\\foreign_file.mat',...
        'Загружены данные из неправильного файла');      
    end
    
    function testGetsForNEqualTo2Solution0LastPointWithMaxPredatorDensities(testCase)
      solNo = 0;
      testCase.verifyGotSolution0LastPointWithMaxPredatorDensitiesForNEqualTo2(...
        solNo,...
        'Не получена последняя точка первого решения семейства с максимумом хищников');
    end
    
    function testGetsForNEqualTo3Solution0LastPointWithMaxPredatorDensities(testCase)
      solNo = 0;
      testCase.verifyGotSolution0LastPointWithMaxPredatorDensitiesForNEqualTo3(...
        solNo,...
        'Не получена последняя точка первого решения семейства с максимумом хищников');
    end
    
    function testGetsForNEqualTo2Solution1LastPointWithMaxPredatorDensities(testCase)      
      solNo = 1;
      testCase.verifyGotSolution1LastPointWithMaxPredatorDensitiesForNEqualTo2(...
        solNo,...
        'Не получена последняя точка второго решения семейства с максимумом хищников');
    end
    
    function testGetsForNEqualTo3Solution1LastPointWithMaxPredatorDensities(testCase)
      solNo = 1;
      testCase.verifyGotSolution1LastPointWithMaxPredatorDensitiesForNEqualTo3(...
        solNo,...
        'Не получена последняя точка второго решения семейства с максимумом хищников');
    end
    
    function testGetsPartOfSecondSolutionForTrajectoryPlot(testCase)
      solNo = 1;
      testCase.verifyGotSolutionPartForTrajectoryPlot(solNo,...
        'Не получена часть первого решения семейства для вывода траектории');
    end
    
    function testGetsPartOfCentralSolForTrajectoryPlot(testCase)
      solNo = 3;
      testCase.verifyGotSolutionPartForTrajectoryPlot(solNo,...
        'Не получена часть среднего решения семейства для вывода траектории');
    end
    
    function testGetsPartOfSolutionBeforeLastForTrajectoryPlot(...
        testCase)
      solNo = 5;
      testCase.verifyGotSolutionPartForTrajectoryPlot(solNo,...
        'Не получена часть второго решения семейства для вывода траектории');
    end
    
    function testGetsMaxSecondPredatorDensityForNEqualTo2(testCase)
      testCase.verifyGotMaxSecondPredatorDensityForNEqualTo2(...
        'Для решения семейства с нулевым первым хищником не получен максимум второго хищника');
    end
    
    function testGetsMaxSecondPredatorDensityForNEqualTo3(testCase)      
      testCase.verifyGotMaxSecondPredatorDensityForNEqualTo3(...
        'Для решения семейства с нулевым первым хищником не получен максимум второго хищника');
    end
    
    function testGetsMaxFirstPredatorDensityForNEqualTo2(testCase)
      testCase.verifyGotMaxFirstPredatorDensityForNEqualTo2(...
        'Для решения семейства с нулевым вторым хищником не получен максимум первого хищника');
    end
    
    function testGetsMaxFirstPredatorDensityForNEqualTo3(testCase)      
      testCase.verifyGotMaxFirstPredatorDensityForNEqualTo3(...
        'Для решения семейства с нулевым вторым хищником не получен максимум первого хищника');
    end

    function testPlotsMaxPredatorDensitiesForNEqualTo2(testCase)
      expLine = testCase.getMaxPredatorsLineForNEqualTo2();
      testCase.verifyLinePlottedForNEqualTo2(expLine,...
        'Не выведены максимумы хищников для решений семейства');
    end
    
    function testPlotsMaxPredatorDensitiesForNEqualTo3(testCase)
      expLine = testCase.getMaxPredatorsLineForNEqualTo3();
      testCase.verifyLinePlottedForNEqualTo3(expLine,...
        'Не выведены максимумы хищников для решений семейства');
    end
    
    function testPlotsForNEqualTo2MaxSecondPredatorForZeroFirstPredator(testCase)
      expPoint = ...
        testCase.getStandaloneSolMaxSecondPredatorPtForNEqualTo2();
      testCase.verifyPointPlottedForNEqualTo2(expPoint,...
        'Не выведена максимальная плотность второго хищника');
    end
    
    function testPlotsForNEqualTo3MaxSecondPredatorForZeroFirstPredator(testCase)
      expPoint = ...
        testCase.getStandaloneSolMaxSecondPredatorPtForNEqualTo3();
      testCase.verifyPointPlottedForNEqualTo3(expPoint,...
        'Не выведена максимальная плотность второго хищника');
    end
    
    function testPlotsForNEqualTo2MaxFirstPredatorForZeroSecondPredator(testCase)
      expPoint = ...
        testCase.getStandaloneSolMaxFirstPredatorPtForNEqualTo2();
      testCase.verifyPointPlottedForNEqualTo2(expPoint,...
        'Не выведена максимальная плотность первого хищника');
    end
    
    function testPlotsForNEqualTo3MaxFirstPredatorForZeroSecondPredator(testCase)
      expPoint = ...
        testCase.getStandaloneSolMaxFirstPredatorPtForNEqualTo3();
      testCase.verifyPointPlottedForNEqualTo3(expPoint,...
        'Не выведена максимальная плотность первого хищника');
    end
    
    function testPlotsFirstSolutionTrajectoryForNEqualTo2(testCase)
      nvar = 6;
      firstPredatorCenterPointVarIndex = 4;
      secondPredatorCenterPointVarIndex = 6;
      expLine = testCase.getFirstSolPartForTrajectoryPlot(nvar,...
        firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
      testCase.verifyLinePlottedForNEqualTo2(expLine,...
        'Не выведена первая траектория установления хищников');
    end
    
    function testPlotsFirstSolutionTrajectoryForNEqualTo3(testCase)
      nvar = 9;
      firstPredatorCenterPointVarIndex = 5;
      secondPredatorCenterPointVarIndex = 8;
      expLine = testCase.getFirstSolPartForTrajectoryPlot(nvar,...
        firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
      testCase.verifyLinePlottedForNEqualTo3(expLine,...
        'Не выведена первая траектория установления хищников');
    end
    
    function testPlotsSecondSolutionTrajectoryForNEqualTo2(testCase)
      expLine = testCase.getSecondSolPartForTrajectoryPlotForNEqualTo2();
      testCase.verifyLinePlottedForNEqualTo2(expLine,...
        'Не выведена вторая траектория установления хищников');
    end
    
    function testPlotsSecondSolutionTrajectoryForNEqualTo3(testCase)
      expLine = testCase.getSecondSolPartForTrajectoryPlotForNEqualTo3();
      testCase.verifyLinePlottedForNEqualTo3(expLine,...
        'Не выведена вторая траектория установления хищников');
    end
    
    function testPlotsThirdSolutionTrajectoryForNEqualTo2(testCase)
      expLine = testCase.getThirdSolPartForTrajectoryPlotForNEqualTo2();
      testCase.verifyLinePlottedForNEqualTo2(expLine,...
        'Не выведена третья траектория установления хищников');
    end
    
    function testPlotsThirdSolutionTrajectoryForNEqualTo3(testCase)
      expLine = testCase.getThirdSolPartForTrajectoryPlotForNEqualTo3();
      testCase.verifyLinePlottedForNEqualTo3(expLine,...
        'Не выведена третья траектория установления хищников');
    end
    
    function testDoesNotOverwritePlots(testCase)
      testCase.setupFamilyForNEqualTo2();
      testCase.act(); 
      
      msg = 'Некоторые графики затираются следующими';
      
      callInfo = struct;
      callInfo.fcn = 'hold';
      args = struct;
      args.arg = 'on';
      callInfo.args = args;
      holdOnCallIndices = getArrayItemIndices(callInfo,...
        testCase.callSequence);
      testCase.assertFalse(isempty(holdOnCallIndices),msg);
      
      callInfo.fcn = 'plot';
      callInfo.args = struct;
      plotCallIndices = getArrayItemIndices(callInfo,...
        testCase.callSequence);
      plotBeforeHoldOnIndices = find(...
        plotCallIndices < holdOnCallIndices(1));
      testCase.assertLessThanOrEqual(length(plotBeforeHoldOnIndices),1,...
        msg);
      
      callInfo.fcn = 'hold';
      args = struct;
      args.arg = 'off';
      callInfo.args = args;
      holdOffCallIndices = getArrayItemIndices(callInfo,...
        testCase.callSequence);
      holdOffBeforeLastPlotCallIndices = find(...
        holdOffCallIndices < plotCallIndices(end),1);
      testCase.verifyTrue(isempty(holdOffBeforeLastPlotCallIndices),msg);
    end
  end
  
end

