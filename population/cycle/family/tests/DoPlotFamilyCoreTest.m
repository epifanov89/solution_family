classdef DoPlotFamilyCoreTest < MFilenameAndGetFileDirnameTestBase...
    & LoadFamilyTestHelper & SubplotTestHelper...
    & MultiplePlotsOnSameFigureMultipleFiguresTestHelper
  
  properties
    nfam
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
      setup@MultiplePlotsOnSameFigureMultipleFiguresTestHelper(testCase);
      testCase.nfam = 2;
      testCase.nfamsol = 6;
      testCase.nsolpt = 10;
      testCase.nStandaloneSol = 2;
      testCase.nSolForTrajectoryPlot = 2;
      testCase.nSolPartForTrajectoryPlotRow = 2;
      testCase.dirname = 'dir\';
      testCase.solutionPartsForTrajectoryPlot = {};
      testCase.getSolutionPartForTrajectoryPlotCallNo = 1;
      testCase.plottedPoints = {};     
    end
  end
  
  methods (Access = private)     
    function setupFamiliesForNEqualTo2(testCase)
      nvar = 6;
      testCase.setupFamilies(nvar);
    end
    
    function setupFamiliesForNEqualTo3(testCase)
      nvar = 9;
      testCase.setupFamilies(nvar);
    end
    
    function setupFamilies(testCase,nvar)
      famNo = 0;
      firstPredatorMortality = 1.1;
      setupFamilyOf6Sols();
      
      famNo = 1;
      firstPredatorMortality = 1.2;
      setupFamilyOf6Sols();
      
      function setupFamilyOf6Sols()
        testCase.setupFamily(famNo,firstPredatorMortality,nvar);
      end
    end
    
    function setupFamily(testCase,famNo,firstPredatorMortality,nvar)
      files = testCase.setupFamilySolutions(famNo,...
        firstPredatorMortality,nvar);
      testCase.setupStandaloneSolutionsAndDirListing(files,famNo,...
        firstPredatorMortality,nvar);
    end
    
    function files = setupFamilySolutions(testCase,famNo,...
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

      filename = '5.mat';
      filepath = sprintf(...
        'dir\\solution_results\\families\\p=1+0.5sin(2 pi x)\\l2=%.1f\\5.mat',...
        firstPredatorMortality);
      solNo = 5;                      
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

      function setupSolution()          
        files = testCase.setupSol(files,filename,filepath,famNo,...
          solNo,nvar);
      end
    end
    
    function listing = setupSol(testCase,listing,filename,filepath,...
        famNo,solNo,nvar)
      file = struct; 
      file.name = filename;
      file.isdir = false;
      
      listing = [listing,file];

      sol = zeros(testCase.nsolpt,nvar);
      nprevsol = famNo*testCase.nfamsol+solNo;
      solVarValOffset = testCase.getNFamSolsVar(nprevsol,nvar)+...
        testCase.getNStandaloneSolVar(famNo,nvar);
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
        files,famNo,firstPredatorMortality,nvar)
      testCase.setupStandaloneSolutions(famNo,firstPredatorMortality,nvar);      
      testCase.setupDirListing(firstPredatorMortality,files);
    end
    
    function setupStandaloneSolutionsForNEqualTo2(testCase)
      firstPredatorMortality = 1.1;
      famNo = 1;
      setupFamilyStandaloneSolutions();
      firstPredatorMortality = 1.2;
      famNo = 2;
      setupFamilyStandaloneSolutions();
      
      function setupFamilyStandaloneSolutions()
        nvar = 6;
        testCase.setupStandaloneSolutions(famNo,firstPredatorMortality,...
          nvar);
      end
    end
    
    function setupStandaloneSolutions(testCase,famNo,...
        firstPredatorMortality,nvar)
      nprevfamsol = (famNo+1)*testCase.nfamsol;
      standaloneSolutionsOffset = ...
        testCase.getNFamSolsVar(nprevfamsol,nvar)+...
        testCase.getNStandaloneSolVar(famNo,nvar)+1;
      
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
      
      solPart1Row1LastVarVal = maxFirstPredatorPtLastVarVal+nvar;
      firstSolutionPartForTrajectoryPlot(1,:) = ...
        maxFirstPredatorPtLastVarVal+1:solPart1Row1LastVarVal;
      solPart1Row2LastVarVal = solPart1Row1LastVarVal+nvar;
      firstSolutionPartForTrajectoryPlot(2,:) = ...
        solPart1Row1LastVarVal+1:solPart1Row2LastVarVal;
      solPart2Row1LastVarVal = solPart1Row2LastVarVal+nvar;
      secondSolutionPartForTrajectoryPlot(1,:) = ...
        solPart1Row2LastVarVal+1:solPart2Row1LastVarVal;
      secondSolutionPartForTrajectoryPlot(2,:) = ...
        solPart2Row1LastVarVal+1:solPart2Row1LastVarVal+nvar;
      
      testCase.solutionPartsForTrajectoryPlot = ...
        [testCase.solutionPartsForTrajectoryPlot,...
          firstSolutionPartForTrajectoryPlot];
      testCase.solutionPartsForTrajectoryPlot = ...
        [testCase.solutionPartsForTrajectoryPlot,...
          secondSolutionPartForTrajectoryPlot];
       
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
    
    function offset = getFamSolVarOffset(testCase,famNo,solNo,nvar)
      offset = testCase.getNFamsVar(famNo,nvar)+...
        testCase.getNFamSolsVar(solNo,nvar);
    end
    
    function offset = getZeroSecondPredatorSolsVarOffset(testCase,famNo,...
        nvar)
      offset = testCase.getZeroFirstPredatorSolsVarOffset(famNo,nvar)+...
        nvar+1;
    end
    
    function offset = getZeroFirstPredatorSolsVarOffset(testCase,famNo,...
        nvar)
      offset = testCase.getNFamsVar(famNo,nvar)+...
        testCase.getNFamSolsVar(testCase.nfamsol,nvar)+1;
    end
    
    function nsolvar = getNFamsVar(testCase,nfam,nvar)
      nsol = nfam*testCase.nfamsol;
      nsolvar = testCase.getNFamSolsVar(nsol,nvar)+...
        testCase.getNStandaloneSolVar(nfam,nvar);
    end
    
    function nsolvar = getNFamSolsVar(testCase,nsol,nvar)
      nsolvar = nsol*testCase.getNFamSolVar(nvar);
    end
    
    function nsolvar = getNFamSolVar(testCase,nvar)
      nsolvar = (testCase.nsolpt+1)*nvar+1;
    end
    
    function nsolvar = getNStandaloneSolVar(testCase,nfam,nvar)
      nsolvar = nfam*(testCase.nStandaloneSol*(1+nvar)+testCase.nSolForTrajectoryPlot*testCase.nSolPartForTrajectoryPlotRow*nvar);
    end
    
    function verifyGotDirListing(testCase,firstPredatorMortality,msg)
      testCase.dirname = 'dir\';
      testCase.namesPassedInToDir = {};
      testCase.setupFamiliesForNEqualTo2();
      testCase.act();
      testCase.verifyContainsItem(testCase.namesPassedInToDir,...
        sprintf('dir\\solution_results\\families\\p=1+0.5sin(2 pi x)\\l2=%.1f\\*.mat',...
          firstPredatorMortality),msg);
    end
    
    function verifyDidNotLoadFromForeignFiles(testCase,...
        famInQuestionNo,famInQuestionFirstPredatorMortality,...
        otherFamilyNo,otherFamilyFirstPredatorMortality,msg)
      nvar = 3;
      files = testCase.setupFamilySolutions(famInQuestionNo,...
        famInQuestionFirstPredatorMortality,nvar);
            
      testCase.setupStandaloneSolutions(famInQuestionNo,...
        famInQuestionFirstPredatorMortality,nvar);
      
      foreignFile = struct;
      foreignFile.name = 'foreign_file.mat';
      foreignFile.isdir = false;      
      files = [files,foreignFile];
      
      testCase.setupDirListing(famInQuestionFirstPredatorMortality,...
        files);
      
      testCase.setupFamily(otherFamilyNo,...
        otherFamilyFirstPredatorMortality,nvar);
      
      testCase.act();
      testCase.verifyDoesNotContainItem(...
        testCase.filenamesPassedInToLoad,sprintf(...
        'dir\\solution_results\\families\\p=1+0.5sin(2 pi x)\\l2=%.1f\\foreign_file.mat',...
          famInQuestionFirstPredatorMortality),msg);
    end
    
    function verifyGotSolution0LastPointWithMaxPredatorDensitiesForNEqualTo2(...
        testCase,famNo,solNo,msgStart)
      colIndex = 6;
      testCase.verifyGotSolutionLastPointWithMaxPredatorDensitiesForNEqualTo2(...
        famNo,solNo,colIndex,msgStart);
    end
    
    function verifyGotSolution0LastPointWithMaxPredatorDensitiesForNEqualTo3(...
        testCase,famNo,solNo,msgStart)
      colIndex = 8;
      testCase.verifyGotSolutionLastPointWithMaxPredatorDensitiesForNEqualTo3(...
        famNo,solNo,colIndex,msgStart);
    end
    
    function verifyGotSolution1LastPointWithMaxPredatorDensitiesForNEqualTo2(...
        testCase,famNo,solNo,msgStart)
      colIndex = 4;
      testCase.verifyGotSolutionLastPointWithMaxPredatorDensitiesForNEqualTo2(...
        famNo,solNo,colIndex,msgStart);
    end
        
    function verifyGotSolution1LastPointWithMaxPredatorDensitiesForNEqualTo3(...
        testCase,famNo,solNo,msgStart)
      colIndex = 5;
      testCase.verifyGotSolutionLastPointWithMaxPredatorDensitiesForNEqualTo3(...
        famNo,solNo,colIndex,msgStart);
    end
    
    function verifyGotSolutionLastPointWithMaxPredatorDensitiesForNEqualTo2(...
        testCase,famNo,solNo,colIndex,msgStart)
      N = 2;
      nvar = 6;
      testCase.verifyGotSolutionLastPointWithMaxPredatorDensities(N,...
        nvar,colIndex,famNo,solNo,msgStart);
    end
    
    function verifyGotSolutionLastPointWithMaxPredatorDensitiesForNEqualTo3(...
        testCase,famNo,solNo,colIndex,msgStart)
      N = 3;
      nvar = 9;
      testCase.verifyGotSolutionLastPointWithMaxPredatorDensities(N,...
        nvar,colIndex,famNo,solNo,msgStart);
    end
    
    function verifyGotSolutionLastPointWithMaxPredatorDensities(...
        testCase,N,nvar,colIndex,famNo,solNo,msgStart)   
      testCase.setupFamilies(nvar);
      
      testCase.act();
      
      args = struct;
      varValOffset = testCase.getFamSolVarOffset(famNo,solNo,nvar);
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
    
    function verifyGotSolutionPartForTrajectoryPlot(testCase,famNo,...
        solNo,msg)      
      testCase.setupFamiliesForNEqualTo2();
      
      testCase.act();
      
      args = struct;    
      nvar = 6;
      varValOffset = testCase.getFamSolVarOffset(famNo,solNo,nvar);
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
        famNo,msgStart)
      nvar = 6;
      sol = testCase.getZeroFirstPredatorSolsVarOffset(famNo,nvar);
      colIndex = 6;
      testCase.verifyGotMaxPredatorDensityForNEqualTo2(sol,colIndex,...
        msgStart);
    end
    
    function verifyGotMaxSecondPredatorDensityForNEqualTo3(testCase,...
        famNo,msgStart)
      nvar = 9;
      sol = testCase.getZeroFirstPredatorSolsVarOffset(famNo,nvar);
      colIndex = 8;
      testCase.verifyGotMaxPredatorDensityForNEqualTo3(sol,colIndex,...
        msgStart);
    end
    
    function verifyGotMaxFirstPredatorDensityForNEqualTo2(testCase,...
        famNo,msgStart)
      nvar = 6;
      sol = testCase.getZeroSecondPredatorSolsVarOffset(famNo,nvar);
      colIndex = 4;
      testCase.verifyGotMaxPredatorDensityForNEqualTo2(sol,colIndex,...
        msgStart);
    end
    
    function verifyGotMaxFirstPredatorDensityForNEqualTo3(testCase,...
        famNo,msgStart)
      nvar = 9;
      sol = testCase.getZeroSecondPredatorSolsVarOffset(famNo,nvar);
      colIndex = 5;
      testCase.verifyGotMaxPredatorDensityForNEqualTo3(sol,colIndex,...
        msgStart);
    end
    
    function verifyGotMaxPredatorDensityForNEqualTo2(testCase,sol,...
        colIndex,msgStart)
      N = 2;
      nvar = 6;
      testCase.verifyGotMaxNonZeroPredatorDensity(sol,N,nvar,...
        colIndex,msgStart);
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
      testCase.setupFamilies(nvar);
      testCase.act();   
      
      args.solution = sol;
      args.colIndex = colIndex;
      args.extremeValueKind = 'max';
      msg = testCase.getMsg(msgStart,N);
      testCase.verifyContainsItem(...
        testCase.argsPassedInToGetLastRowWithExtremeElementValue,args,msg);
    end
    
    function line = getMaxPredatorsLineForNEqualTo2(testCase,famNo)
      [nvar,firstPredatorCenterPointVarIndex,...
          secondPredatorCenterPointVarIndex] = ...
        testCase.getVarNumberAndIndicesForNEqualTo2();
      line = testCase.getMaxPredatorsLine(famNo,nvar,...
        firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
    end
    
    function line = getMaxPredatorsLineForNEqualTo3(testCase,famNo)
      [nvar,firstPredatorCenterPointVarIndex,...
          secondPredatorCenterPointVarIndex] = ...
        testCase.getVarNumberAndIndicesForNEqualTo3();
      line = testCase.getMaxPredatorsLine(famNo,nvar,...
        firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
    end
    
    function line = getMaxPredatorsLine(testCase,famNo,nvar,...
        firstPredatorCenterPointVarIndex,secondPredatorCenterPointVarIndex)   
      ndim = 2;
      line = zeros(testCase.nfamsol,ndim);
      nPrevFamsTotalVar = testCase.getNFamsVar(famNo,nvar);
      for row = 1:testCase.nfamsol
        offset = nPrevFamsTotalVar+row*testCase.nsolpt*nvar+(row-1)*(nvar+1);
        line(row,1) = offset+firstPredatorCenterPointVarIndex;
        line(row,2) = offset+secondPredatorCenterPointVarIndex;
      end
    end
    
    function pt = getStandaloneSolMaxSecondPredatorPtForNEqualTo2(...
        testCase,famNo)
      [nvar,firstPredatorCenterPointVarIndex,...
          secondPredatorCenterPointVarIndex] = ...
        testCase.getVarNumberAndIndicesForNEqualTo2();
      pt = testCase.getStandaloneSolMaxSecondPredatorPt(famNo,...
        nvar,firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
    end
    
    function pt = getStandaloneSolMaxSecondPredatorPtForNEqualTo3(...
        testCase,famNo)
      [nvar,firstPredatorCenterPointVarIndex,...
          secondPredatorCenterPointVarIndex] = ...
        testCase.getVarNumberAndIndicesForNEqualTo3();
      pt = testCase.getStandaloneSolMaxSecondPredatorPt(famNo,...
        nvar,firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
    end
    
    function pt = getStandaloneSolMaxSecondPredatorPt(testCase,famNo,...
        nvar,firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex)
      standaloneSolNo = 0;
      pt = testCase.getStandaloneSolMaxNonZeroPredatorPt(famNo,...
        standaloneSolNo,nvar,firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
    end
       
    function pt = getStandaloneSolMaxFirstPredatorPtForNEqualTo2(...
        testCase,famNo)
      [nvar,firstPredatorCenterPointVarIndex,...
          secondPredatorCenterPointVarIndex] = ...
        testCase.getVarNumberAndIndicesForNEqualTo2();
      pt = testCase.getStandaloneSolMaxFirstPredatorPt(famNo,...
        nvar,firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
    end
    
    function pt = getStandaloneSolMaxFirstPredatorPtForNEqualTo3(...
        testCase,famNo)
      [nvar,firstPredatorCenterPointVarIndex,...
          secondPredatorCenterPointVarIndex] = ...
        testCase.getVarNumberAndIndicesForNEqualTo3();
      pt = testCase.getStandaloneSolMaxFirstPredatorPt(famNo,...
        nvar,firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
    end
    
    function pt = getStandaloneSolMaxFirstPredatorPt(testCase,famNo,...
        nvar,firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex)
      standaloneSolNo = 1;
      pt = testCase.getStandaloneSolMaxNonZeroPredatorPt(famNo,...
        standaloneSolNo,nvar,firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
    end 
    
    function pt = getStandaloneSolMaxNonZeroPredatorPt(testCase,famNo,...
        standaloneSolNo,nvar,firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex)
      maxSecondPredatorPt = ...
        testCase.getNFamsVar(famNo,nvar)+...
        testCase.nfamsol*testCase.getNFamSolVar(nvar)+...
        standaloneSolNo*(nvar+1)+1;
      pt = [maxSecondPredatorPt+firstPredatorCenterPointVarIndex,...
            maxSecondPredatorPt+secondPredatorCenterPointVarIndex];
    end
    
    function line = getFirstSolPartForTrajectoryPlot(testCase,famNo,...
        nvar,firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex)
      solPartNo = 1;
      line = testCase.getSolPartForTrajectoryPlot(famNo,solPartNo,nvar,...
        firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
    end
    
    function line = getSecondSolPartForTrajectoryPlotForNEqualTo2(...
        testCase,famNo)
      [nvar,firstPredatorCenterPointVarIndex,...
          secondPredatorCenterPointVarIndex] = ...
        testCase.getVarNumberAndIndicesForNEqualTo2();
      line = testCase.getSecondSolPartForTrajectoryPlot(famNo,...
        nvar,firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
    end
    
    function line = getSecondSolPartForTrajectoryPlotForNEqualTo3(...
        testCase,famNo)
      [nvar,firstPredatorCenterPointVarIndex,...
          secondPredatorCenterPointVarIndex] = ...
        testCase.getVarNumberAndIndicesForNEqualTo3();
      line = testCase.getSecondSolPartForTrajectoryPlot(famNo,...
        nvar,firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
    end
    
    function line = getSecondSolPartForTrajectoryPlot(testCase,famNo,...
        nvar,firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex)
      solPartNo = 0;
      line = testCase.getSolPartForTrajectoryPlot(famNo,solPartNo,nvar,...
        firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
    end
    
    function line = getSolPartForTrajectoryPlot(testCase,famNo,...
        solPartNo,nvar,firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex)      
      ndim = 2;
      line = zeros(testCase.nSolPartForTrajectoryPlotRow,ndim);
      solPartOffset = testCase.getNFamsVar(famNo,nvar)+...
        testCase.nfamsol*testCase.getNFamSolVar(nvar)+...
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
    
    function pt = getFamily2FirstSolLastPt(testCase,nvar,...
        firstPredatorCenterPointVarIndex,secondPredatorCenterPointVarIndex)
      famNo = 1;
      offset = testCase.getNFamsVar(famNo,nvar)+...
        testCase.getNFamSolVar(nvar)+(testCase.nsolpt-1)*nvar;
      pt = [offset+firstPredatorCenterPointVarIndex,...
        offset+secondPredatorCenterPointVarIndex];
    end
    
    function verifyLinePlottedOnFirstSubplotForNEqualTo2(testCase,...
        expLine,msg)
      testCase.verifyPlottedOnFirstSubplot(...
        @(pos) testCase.verifyLinePlottedForNEqualTo2(pos,expLine,msg));
    end
    
    function verifyLinePlottedOnFirstSubplotForNEqualTo3(testCase,...
        expLine,msg)
      testCase.verifyPlottedOnFirstSubplot(...
        @(pos) testCase.verifyLinePlottedForNEqualTo3(pos,expLine,msg));
    end
    
    function verifyLinePlottedOnSecondSubplotForNEqualTo2(testCase,...
        expLine,msg)
      testCase.verifyPlottedOnSecondSubplot(...
        @(pos) testCase.verifyLinePlottedForNEqualTo2(pos,expLine,msg));
    end
    
    function verifyLinePlottedOnSecondSubplotForNEqualTo3(testCase,...
        expLine,msg)
      testCase.verifyPlottedOnSecondSubplot(...
        @(pos) testCase.verifyLinePlottedForNEqualTo3(pos,expLine,msg));
    end
    
    function verifyPointPlottedOnFirstSubplotForNEqualTo2(testCase,...
        expPt,msg)
      testCase.verifyPlottedOnFirstSubplot(...
        @(pos) testCase.verifyPointPlottedForNEqualTo2(pos,expPt,msg));
    end
    
    function verifyPointPlottedOnFirstSubplotForNEqualTo3(testCase,...
        expPt,msg)
      testCase.verifyPlottedOnFirstSubplot(...
        @(pos) testCase.verifyPointPlottedForNEqualTo3(pos,expPt,msg));
    end
    
    function verifyPointPlottedOnSecondSubplotForNEqualTo2(testCase,...
        expPt,msg)
      testCase.verifyPlottedOnSecondSubplot(...
        @(pos) testCase.verifyPointPlottedForNEqualTo2(pos,expPt,msg));
    end
    
    function verifyPointPlottedOnSecondSubplotForNEqualTo3(testCase,...
        expPt,msg)
      testCase.verifyPlottedOnSecondSubplot(...
        @(pos) testCase.verifyPointPlottedForNEqualTo3(pos,expPt,msg));
    end
    
    function verifyPlottedOnFirstSubplot(~,verifyFun)
      pos = 1;
      verifyFun(pos);
    end
    
    function verifyPlottedOnSecondSubplot(~,verifyFun)
      pos = 2;
      verifyFun(pos);
    end
    
    function verifyLinePlottedForNEqualTo2(testCase,pos,line,...
        msgStart)
      N = 2;
      testCase.setupFamiliesForNEqualTo2();
      nvar = 6;
      handle = testCase.getAxesHandle(nvar,pos);
      testCase.verifyLinePlotted(pos,handle,N,line,msgStart);
    end
    
    function verifyLinePlottedForNEqualTo3(testCase,pos,line,...
        msgStart)
      N = 3;
      testCase.setupFamiliesForNEqualTo3();
      nvar = 9;
      handle = testCase.getAxesHandle(nvar,pos);
      testCase.verifyLinePlotted(pos,handle,N,line,msgStart);
    end
    
    function h = getAxesHandle(testCase,nvar,pos)
      h = testCase.nfamsol*testCase.getNFamsVar(testCase.nfam,nvar)+pos;
    end
    
    function verifyPointPlottedForNEqualTo2(testCase,pos,pt,...
        msgStart)
      N = 2;
      testCase.setupFamiliesForNEqualTo2();  
      nvar = 6;
      handle = testCase.getAxesHandle(nvar,pos);
      testCase.verifyPointPlotted(pos,handle,N,pt,msgStart);
    end
      
    function verifyPointPlottedForNEqualTo3(testCase,pos,pt,...
        msgStart)
      N = 3;
      testCase.setupFamiliesForNEqualTo3();   
      nvar = 9;
      handle = testCase.getAxesHandle(nvar,pos);
      testCase.verifyPointPlotted(pos,handle,N,pt,msgStart);
    end
    
    function verifyDidNotOverwritePlots(testCase,nvar,pos,msg)
      testCase.setupFamiliesForNEqualTo2();
      handle = testCase.getAxesHandle(nvar,pos);
      testCase.setupSubplot(pos,handle);
      testCase.act(); 
      
      callInfo = struct;
      callInfo.fcn = 'hold';
      args = struct;
      args.handle = handle;
      args.arg = 'on';
      callInfo.args = args;
      holdOnCallIndices = getArrayItemIndices(...
        callInfo,testCase.callSequence);
      testCase.assertFalse(isempty(holdOnCallIndices),msg);
      
      callInfo.fcn = 'plot';
      args = struct;
      args.handle = handle;
      callInfo.args = args;
      plotCallIndices = getArrayItemIndices(...
        callInfo,testCase.callSequence);
      plotBeforeHoldOnIndices = find(plotCallIndices < holdOnCallIndices(1));
      testCase.assertLessThanOrEqual(length(plotBeforeHoldOnIndices),1,...
        msg);
      
      callInfo.fcn = 'hold';
      args = struct;
      args.arg = 'off';
      callInfo.args = args;
      holdOffCallIndices = getArrayItemIndices(...
        callInfo,testCase.callSequence);
      holdOffBeforeLastPlotCallIndices = find(...
        holdOffCallIndices < plotCallIndices(end),1);
      testCase.verifyTrue(isempty(holdOffBeforeLastPlotCallIndices),msg);
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
    function verifySubplotCalled(testCase,pos,msg)
      testCase.setupFamiliesForNEqualTo2();
      nrow = 1;
      ncol = 2;
      verifySubplotCalled@SubplotTestHelper(testCase,nrow,ncol,pos,msg);
    end
    
    function verifyLinePlotted(testCase,pos,handle,N,line,msgStart)
      testCase.setupSubplot(pos,handle);
      msg = testCase.getMsg(msgStart,N);
      verifyLinePlotted@MultiplePlotsOnSameFigureMultipleFiguresTestHelper(...
        testCase,handle,line,msg);
    end
    
    function verifyPointPlotted(testCase,pos,handle,N,data,msgStart)
      testCase.setupSubplot(pos,handle);      
      testCase.act();
      pt = struct;
      pt.handle = handle;
      pt.data = data;
      msg = testCase.getMsg(msgStart,N);
      testCase.verifyContainsItem(testCase.plottedPoints,pt,msg);
    end
    
    function processPointPlot(testCase,handle,data)
      pt = struct;
      pt.handle = handle;
      pt.data = data;
      testCase.plottedPoints = [testCase.plottedPoints,pt];
    end
    
    function act(testCase)
      doPlotFamilyCore(@testCase.fakeMFilename,...
        @testCase.fakeGetFileDirname,@testCase.fakeDir,...
        @testCase.fakeLoad,...
        @testCase.fakeGetLastRowWithExtremeElementValue,...
        @testCase.fakeGetSolutionPartForTrajectoryPlot,...
        @testCase.fakeSubplot,@testCase.fakePlot,@testCase.fakeHold,...
        @testCase.fakeLabel,@testCase.fakeXLabel,@testCase.fakeYLabel,...
        @testCase.fakeSet);
    end
  end
  
  methods (Access = private)
    function setupSubplot(testCase,pos,handle)
      axes = struct;
      axes.pos = pos;
      axes.handle = handle;
      testCase.axesHandlesToReturnFromSubplot = axes;
    end
  end
  
  methods (Test)
    function testGetsMFilename(testCase)
      testCase.setupFamiliesForNEqualTo2();
      testCase.verifyGotMFilename();
    end
    
    function testGetsFileDirname(testCase)
      testCase.setupFamiliesForNEqualTo2();
      testCase.verifyGotFileDirname();
    end
    
    function testGetsFamily1DirListing(testCase)
      firstPredatorMortality = 1.1;
      testCase.verifyGotDirListing(firstPredatorMortality,...
        'Не получены имена файлов с решениями первого семейства');
    end
    
    function testGetsFamily2DirListing(testCase)
      firstPredatorMortality = 1.2;
      testCase.verifyGotDirListing(firstPredatorMortality,...
        'Не получены имена файлов с решениями второго семейства');
    end
    
    function testDoesNotLoadFromForeignFilesOfFirstFamilyFolder(testCase)     
      famInQuestionNo = 1;         
      famInQuestionFirstPredatorMortality = 1.1;
      otherFamilyNo = 2;         
      otherFamilyFirstPredatorMortality = 1.2;
      testCase.verifyDidNotLoadFromForeignFiles(famInQuestionNo,...
        famInQuestionFirstPredatorMortality,otherFamilyNo,...
        otherFamilyFirstPredatorMortality,...
        'Загружены данные из неправильного файла папки первого семейства');
    end
    
    function testDoesNotLoadFromForeignFilesOfSecondFamilyFolder(testCase)     
      famInQuestionNo = 2;         
      famInQuestionFirstPredatorMortality = 1.2;
      otherFamilyNo = 1;         
      otherFamilyFirstPredatorMortality = 1.1;
      testCase.verifyDidNotLoadFromForeignFiles(famInQuestionNo,...
        famInQuestionFirstPredatorMortality,otherFamilyNo,...
        otherFamilyFirstPredatorMortality,...
        'Загружены данные из неправильного файла папки второго семейства');
    end
    
    function testGetsForNEqualTo2Family1Solution0LastPointWithMaxPredatorDensities(testCase)
      famNo = 0;
      solNo = 0;
      testCase.verifyGotSolution0LastPointWithMaxPredatorDensitiesForNEqualTo2(...
        famNo,solNo,...
        'Не получена последняя точка первого решения первого семейства с максимумом хищников');
    end
    
    function testGetsForNEqualTo3Family1Solution0LastPointWithMaxPredatorDensities(testCase)
      famNo = 0;
      solNo = 0;
      testCase.verifyGotSolution0LastPointWithMaxPredatorDensitiesForNEqualTo3(...
        famNo,solNo,...
        'Не получена последняя точка первого решения первого семейства с максимумом хищников');
    end
    
    function testGetsForNEqualTo2Family1Solution1LastPointWithMaxPredatorDensities(testCase)      
      famNo = 0;
      solNo = 1;
      testCase.verifyGotSolution1LastPointWithMaxPredatorDensitiesForNEqualTo2(...
        famNo,solNo,...
        'Не получена последняя точка второго решения первого семейства с максимумом хищников');
    end
    
    function testGetsForNEqualTo3Family1Solution1LastPointWithMaxPredatorDensities(testCase)
      famNo = 0;
      solNo = 1;
      testCase.verifyGotSolution1LastPointWithMaxPredatorDensitiesForNEqualTo3(...
        famNo,solNo,...
        'Не получена последняя точка второго решения первого семейства с максимумом хищников');
    end
    
    function testGetsForNEqualTo2Family2Solution0LastPointWithMaxPredatorDensities(testCase)
      famNo = 1;
      solNo = 0;
      testCase.verifyGotSolution0LastPointWithMaxPredatorDensitiesForNEqualTo2(...
        famNo,solNo,...
        'Не получена последняя точка первого решения второго семейства с максимумом хищников');
    end
    
    function testGetsForNEqualTo3Family2Solution0LastPointWithMaxPredatorDensities(testCase)
      famNo = 1;
      solNo = 0;
      testCase.verifyGotSolution0LastPointWithMaxPredatorDensitiesForNEqualTo3(...
        famNo,solNo,...
        'Не получена последняя точка первого решения второго семейства с максимумом хищников');
    end
    
    function testGetsForNEqualTo2Family2Solution1LastPointWithMaxPredatorDensities(testCase)
      famNo = 1;
      solNo = 1;
      testCase.verifyGotSolution1LastPointWithMaxPredatorDensitiesForNEqualTo2(...
        famNo,solNo,...
        'Не получена последняя точка второго решения второго семейства с максимумом хищников');
    end
    
    function testGetsForNEqualTo3Family2Solution1LastPointWithMaxPredatorDensities(testCase)
      famNo = 1;
      solNo = 1;
      testCase.verifyGotSolution1LastPointWithMaxPredatorDensitiesForNEqualTo3(...
        famNo,solNo,...
        'Не получена последняя точка второго решения второго семейства с максимумом хищников');
    end
    
    function testGetsPartOfFamily1SecondSolutionForTrajectoryPlot(testCase)
      famNo = 0;
      solNo = 1;
      testCase.verifyGotSolutionPartForTrajectoryPlot(famNo,solNo,...
        'Не получена часть первого решения первого семейства для вывода траектории');
    end
    
    function testGetsPartOfFamily1SolutionBeforeLastForTrajectoryPlot(...
        testCase)
      famNo = 0;
      solNo = 4;
      testCase.verifyGotSolutionPartForTrajectoryPlot(famNo,solNo,...
        'Не получена часть второго решения первого семейства для вывода траектории');
    end
    
    function testGetsPartOfFamily2SolutionBeforeLastForTrajectoryPlot(testCase)      
      famNo = 1;
      solNo = 4;
      testCase.verifyGotSolutionPartForTrajectoryPlot(famNo,solNo,...
        'Не получена часть второго решения второго семейства для вывода траектории');
    end
    
    function testGetsFamily1MaxSecondPredatorDensityForNEqualTo2(testCase)
      famNo = 0;
      testCase.verifyGotMaxSecondPredatorDensityForNEqualTo2(famNo,...
        'Для решения первого семейства с нулевым первым хищником не получен максимум второго хищника');
    end
    
    function testGetsFamily1MaxSecondPredatorDensityForNEqualTo3(testCase)      
      famNo = 0;
      testCase.verifyGotMaxSecondPredatorDensityForNEqualTo3(famNo,...
        'Для решения первого семейства с нулевым первым хищником не получен максимум второго хищника');
    end
    
    function testGetsFamily1MaxFirstPredatorDensityForNEqualTo2(testCase)
      famNo = 0;
      testCase.verifyGotMaxFirstPredatorDensityForNEqualTo2(famNo,...
        'Для решения первого семейства с нулевым вторым хищником не получен максимум первого хищника');
    end
    
    function testGetsFamily1MaxFirstPredatorDensityForNEqualTo3(testCase)      
      famNo = 0;
      testCase.verifyGotMaxFirstPredatorDensityForNEqualTo3(famNo,...
        'Для решения первого семейства с нулевым вторым хищником не получен максимум первого хищника');
    end
    
    function testGetsFamily2MaxSecondPredatorDensityForNEqualTo2(testCase)
      famNo = 1;
      testCase.verifyGotMaxSecondPredatorDensityForNEqualTo2(famNo,...
        'Для решения второго семейства с нулевым первым хищником не получен максимум второго хищника');
    end
    
    function testGetsFamily2MaxSecondPredatorDensityForNEqualTo3(testCase)
      famNo = 1;
      testCase.verifyGotMaxSecondPredatorDensityForNEqualTo3(famNo,...
        'Для решения второго семейства с нулевым первым хищником не получен максимум второго хищника');
    end
    
    function testGetsFamily2MaxFirstPredatorDensityForNEqualTo2(testCase)
      famNo = 1;
      testCase.verifyGotMaxFirstPredatorDensityForNEqualTo2(famNo,...
        'Для решения второго семейства с нулевым вторым хищником не получен максимум первого хищника');
    end
    
    function testGetsFamily2MaxFirstPredatorDensityForNEqualTo3(testCase)
      famNo = 1;
      testCase.verifyGotMaxFirstPredatorDensityForNEqualTo3(famNo,...
        'Для решения второго семейства с нулевым вторым хищником не получен максимум первого хищника');
    end
    
    function testCreatesFirstSubplot(testCase)
      pos = 1;
      testCase.verifySubplotCalled(pos,'Не создана первая область окна');
    end
    
    function testCreatesSecondSubplot(testCase)
      pos = 2;
      testCase.verifySubplotCalled(pos,'Не создана вторая область окна');
    end

    function testPlotsFamily1MaxPredatorDensitiesForNEqualTo2(testCase)
      famNo = 0;
      expLine = testCase.getMaxPredatorsLineForNEqualTo2(famNo);
      testCase.verifyLinePlottedOnFirstSubplotForNEqualTo2(expLine,...
        'Не выведены максимумы хищников для решений первого семейства');
    end
    
    function testPlotsFamily1MaxPredatorDensitiesForNEqualTo3(testCase)
      famNo = 0;
      expLine = testCase.getMaxPredatorsLineForNEqualTo3(famNo);
      testCase.verifyLinePlottedOnFirstSubplotForNEqualTo3(expLine,...
        'Не выведены максимумы хищников для решений первого семейства');
    end
    
    function testPlotsFamily2MaxPredatorDensitiesForNEqualTo2(testCase)
      famNo = 1;
      expLine = testCase.getMaxPredatorsLineForNEqualTo2(famNo);
      testCase.verifyLinePlottedOnSecondSubplotForNEqualTo2(expLine,...
        'Не выведены максимумы хищников для решений второго семейства');
    end
    
    function testPlotsFamily2MaxPredatorDensitiesForNEqualTo3(testCase)
      famNo = 1;
      expLine = testCase.getMaxPredatorsLineForNEqualTo3(famNo);
      testCase.verifyLinePlottedOnSecondSubplotForNEqualTo3(expLine,...
        'Не выведены максимумы хищников для решений второго семейства');
    end
    
    function testPlotsForNEqualTo2Family1MaxSecondPredatorForZeroFirstPredator(testCase)
      famNo = 0;
      expPoint = ...
        testCase.getStandaloneSolMaxSecondPredatorPtForNEqualTo2(famNo);
      testCase.verifyPointPlottedOnFirstSubplotForNEqualTo2(expPoint,...
        'Не выведена максимальная плотность второго хищника для первого семейства');
    end
    
    function testPlotsForNEqualTo3Family1MaxSecondPredatorForZeroFirstPredator(testCase)
      famNo = 0;
      expPoint = ...
        testCase.getStandaloneSolMaxSecondPredatorPtForNEqualTo3(famNo);
      testCase.verifyPointPlottedOnFirstSubplotForNEqualTo3(expPoint,...
        'Не выведена максимальная плотность второго хищника для первого семейства');
    end
    
    function testPlotsForNEqualTo2Family1MaxFirstPredatorForZeroSecondPredator(testCase)
      famNo = 0;
      expPoint = ...
        testCase.getStandaloneSolMaxFirstPredatorPtForNEqualTo2(famNo);
      testCase.verifyPointPlottedOnFirstSubplotForNEqualTo2(expPoint,...
        'Не выведена максимальная плотность первого хищника для первого семейства');
    end
    
    function testPlotsForNEqualTo3Family1MaxFirstPredatorForZeroSecondPredator(testCase)
      famNo = 0;
      expPoint = ...
        testCase.getStandaloneSolMaxFirstPredatorPtForNEqualTo3(famNo);
      testCase.verifyPointPlottedOnFirstSubplotForNEqualTo3(expPoint,...
        'Не выведена максимальная плотность первого хищника для первого семейства');
    end
    
    function testPlotsForNEqualTo2Family2MaxSecondPredatorForZeroFirstPredator(testCase)
      famNo = 1;
      expPoint = ...
        testCase.getStandaloneSolMaxSecondPredatorPtForNEqualTo2(famNo);
      testCase.verifyPointPlottedOnSecondSubplotForNEqualTo2(expPoint,...
        'Не выведена максимальная плотность второго хищника для второго семейства');
    end
    
    function testPlotsForNEqualTo3Family2MaxSecondPredatorForZeroFirstPredator(testCase)
      famNo = 1;
      expPoint = ...
        testCase.getStandaloneSolMaxSecondPredatorPtForNEqualTo3(famNo);
      testCase.verifyPointPlottedOnSecondSubplotForNEqualTo3(expPoint,...
        'Не выведена максимальная плотность второго хищника для второго семейства');
    end
    
    function testPlotsForNEqualTo2Family2MaxFirstPredatorForZeroSecondPredator(testCase)
      famNo = 1;
      expPoint = ...
        testCase.getStandaloneSolMaxFirstPredatorPtForNEqualTo2(famNo);
      testCase.verifyPointPlottedOnSecondSubplotForNEqualTo2(expPoint,...
        'Не выведена максимальная плотность первого хищника для второго семейства');
    end
    
    function testPlotsForNEqualTo3Family2MaxFirstPredatorForZeroSecondPredator(testCase)
      famNo = 1;
      expPoint = ...
        testCase.getStandaloneSolMaxFirstPredatorPtForNEqualTo3(famNo);
      testCase.verifyPointPlottedOnSecondSubplotForNEqualTo3(expPoint,...
        'Не выведена максимальная плотность первого хищника для второго семейства');
    end
    
    function testPlotsFamily1FirstSolutionTrajectoryForNEqualTo2(testCase)
      famNo = 0;
      nvar = 6;
      firstPredatorCenterPointVarIndex = 4;
      secondPredatorCenterPointVarIndex = 6;
      expLine = testCase.getFirstSolPartForTrajectoryPlot(famNo,nvar,...
        firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
      testCase.verifyLinePlottedOnFirstSubplotForNEqualTo2(expLine,...
        'Не выведена первая траектория установления хищников для первого семейства');
    end
    
    function testPlotsFamily1FirstSolutionTrajectoryForNEqualTo3(testCase)
      famNo = 0;
      nvar = 9;
      firstPredatorCenterPointVarIndex = 5;
      secondPredatorCenterPointVarIndex = 8;
      expLine = testCase.getFirstSolPartForTrajectoryPlot(famNo,nvar,...
        firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
      testCase.verifyLinePlottedOnFirstSubplotForNEqualTo3(expLine,...
        'Не выведена первая траектория установления хищников для первого семейства');
    end
    
    function testPlotsFamily1SecondSolutionTrajectoryForNEqualTo2(testCase)
      famNo = 0;
      expLine = testCase.getSecondSolPartForTrajectoryPlotForNEqualTo2(...
        famNo);
      testCase.verifyLinePlottedOnFirstSubplotForNEqualTo2(expLine,...
        'Не выведена вторая траектория установления хищников для первого семейства');
    end
    
    function testPlotsFamily1SecondSolutionTrajectoryForNEqualTo3(testCase)
      famNo = 0;
      expLine = testCase.getSecondSolPartForTrajectoryPlotForNEqualTo3(...
        famNo);
      testCase.verifyLinePlottedOnFirstSubplotForNEqualTo3(expLine,...
        'Не выведена вторая траектория установления хищников для первого семейства');
    end
    
    function testPlotsFamily2SecondSolutionTrajectoryForNEqualTo2(testCase)
      famNo = 1;
      expLine = testCase.getSecondSolPartForTrajectoryPlotForNEqualTo2(...
        famNo);
      testCase.verifyLinePlottedOnSecondSubplotForNEqualTo2(expLine,...
        'Не выведена вторая траектория установления хищников для второго семейства');
    end
    
    function testPlotsFamily2SecondSolutionTrajectoryForNEqualTo3(testCase)
      famNo = 1;
      expLine = testCase.getSecondSolPartForTrajectoryPlotForNEqualTo3(...
        famNo);
      testCase.verifyLinePlottedOnSecondSubplotForNEqualTo3(expLine,...
        'Не выведена вторая траектория установления хищников для второго семейства');
    end
    
    function testPlotsFamily2FirstSolutionLastPointForNEqualTo2(testCase)
      [nvar,firstPredatorCenterPointVarIndex,...
          secondPredatorCenterPointVarIndex] = ...
        testCase.getVarNumberAndIndicesForNEqualTo2();
      expPt = testCase.getFamily2FirstSolLastPt(nvar,...
        firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
      testCase.verifyPointPlottedOnSecondSubplotForNEqualTo2(expPt,...
        'Не выведено второе решение для второго семейства, которое является равновесием');
    end
    
    function testPlotsFamily2FirstSolutionLastPointForNEqualTo3(testCase)
      [nvar,firstPredatorCenterPointVarIndex,...
          secondPredatorCenterPointVarIndex] = ...
        testCase.getVarNumberAndIndicesForNEqualTo3();
      expPt = testCase.getFamily2FirstSolLastPt(nvar,...
        firstPredatorCenterPointVarIndex,...
        secondPredatorCenterPointVarIndex);
      testCase.verifyPointPlottedOnSecondSubplotForNEqualTo3(expPt,...
        'Не выведено второе решение для второго семейства, которое является равновесием');
    end
    
    function testDoesNotOverwriteFamily1Plots(testCase)
      nvar = 3;
      pos = 1;      
      testCase.verifyDidNotOverwritePlots(nvar,pos,...
        'Некоторые графики первого семейства затираются следующими');
    end
    
    function testDoesNotOverwriteFamily2Plots(testCase)
      nvar = 3;
      pos = 2;
      testCase.verifyDidNotOverwritePlots(nvar,pos,...
        'Некоторые графики второго семейства затираются следующими');
    end
  end
  
end

