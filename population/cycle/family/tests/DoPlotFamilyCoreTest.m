classdef DoPlotFamilyCoreTest < MFilenameAndGetFileDirnameTestBase...
    & LoadFamilyTestHelper & SubplotTestHelper...
    & MultiplePlotsOnSameFigureMultipleFiguresTestHelper
  
  properties
    nfamily
    nsolpt
    nStandaloneSol
    nSolForTrajectoryPlot
    namesPassedInToDir
    listingsToReturnFromDir    
    argsPassedInToGetLastRowWithExtremeElementValue
    varsToReturnFromGetLastRowWithExtremeElementValue
    argsPassedInToGetSolutionPartForTrajectoryPlot
    solutionPartsForTrajectoryPlot
    getSolutionPartForTrajectoryPlotCallNo
    plottedPoints
  end
  
  methods (TestMethodSetup)
    function setup(testCase)
      setup@LoadFamilyTestHelper(testCase);
      setup@MultiplePlotsOnSameFigureMultipleFiguresTestHelper(testCase);
      testCase.nfamily = 2;
      testCase.nsolpt = 10;
      testCase.nStandaloneSol = 2;
      testCase.nSolForTrajectoryPlot = 2;
      testCase.dirname = 'dir\';
      testCase.solutionPartsForTrajectoryPlot = {};
      testCase.getSolutionPartForTrajectoryPlotCallNo = 1;
      testCase.plottedPoints = {};     
    end
  end
  
  methods (Access = private)    
    function setupFamiliesForNEqualTo1(testCase)
      nvar = 3;
      testCase.setupFamilies(nvar);
    end
    
    function setupFamiliesForNEqualTo2(testCase)
      nvar = 6;
      testCase.setupFamilies(nvar);
    end        
    
    function setupFamilies(testCase,nvar)
      familyNo = 1;
      familyFirstPredatorMortality = 1.1;
      setupFamilySolutions();
      
      familyNo = 2;
      familyFirstPredatorMortality = 1.2;
      setupFamilySolutions();
      
      function setupFamilySolutions()
        testCase.setupFamilyOf2Solutions(familyNo,...
          familyFirstPredatorMortality,nvar);
      end
    end
    
    function setupFamilyOf2Solutions(testCase,familyNo,...
        firstPredatorMortality,nvar)
      nsol = 2;
      solsToPlotVarValOffset = ...
        testCase.nfamily*(nsol+testCase.nStandaloneSol)-1;
      
      files = testCase.setupFamilySolutions(firstPredatorMortality,...
        familyNo,nvar,solsToPlotVarValOffset);
        
      testCase.setupStandaloneSolutionsAndDirListing(files,...
        firstPredatorMortality,familyNo,nsol,nvar,solsToPlotVarValOffset);
    end
    
    function files = setupFamilySolutions(testCase,...
        firstPredatorMortality,familyNo,nvar,solsToPlotVarValOffset)
      nsol = 2;
      files = [];
      
      solNo = 0;    
      filename = '0.mat';
      filepath = sprintf(...
        'dir\\solution_results\\families\\p=1+0.5sin(2 pi x)\\l2=%.1f\\0.mat',...
        firstPredatorMortality);
      files = testCase.setupSolution(files,filename,filepath,familyNo,...
        nsol,solNo,nvar,solsToPlotVarValOffset);
      
      solNo = 1;
      filename = '1.mat';
      filepath = sprintf(...
        'dir\\solution_results\\families\\p=1+0.5sin(2 pi x)\\l2=%.1f\\1.mat',...
        firstPredatorMortality);
      files = testCase.setupSolution(files,filename,filepath,familyNo,...
        nsol,solNo,nvar,solsToPlotVarValOffset);
    end
    
    function setupStandaloneSolutionsAndDirListing(testCase,...
        files,firstPredatorMortality,familyNo,nsol,nvar,...
        solsToPlotVarValOffset)
      testCase.setupStandaloneSolutions(firstPredatorMortality,familyNo,...
        nsol,nvar,solsToPlotVarValOffset);
      
      testCase.setupDirListing(firstPredatorMortality,files);
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
    
    function listing = setupSolution(testCase,listing,filename,filepath,...
        familyNo,nsol,solNo,nvar,solsToPlotVarValOffset)
      file = struct; 
      file.name = filename;
      file.isdir = false;
      
      listing = [listing,file];

      nSolPartForTrajectoryPlotRow = 2;
      rowIndexOffset = nsol*(familyNo-1)+solNo;
      solOffset = rowIndexOffset+testCase.nStandaloneSol*(familyNo-1);
      
      varsToLoad = struct;
      varsToLoad.filename = filepath;
      vars = struct;
      npt = 10;
      w(1:npt,1:nvar) = solOffset;      
      vars.w = w;
      varsToLoad.vars = vars;
      testCase.varsToLoad = [testCase.varsToLoad,varsToLoad];

      vars = struct;
      vars.sol = w;      
      varValOffset = ...
        solsToPlotVarValOffset+nvar*(solOffset+testCase.nSolForTrajectoryPlot*nSolPartForTrajectoryPlotRow*(familyNo-1));
      vars.row = varValOffset:varValOffset+nvar-1;
      vars.rowIndex = -rowIndexOffset;
      testCase.varsToReturnFromGetLastRowWithExtremeElementValue = ...
        [testCase.varsToReturnFromGetLastRowWithExtremeElementValue,vars];
    end

    function setupStandaloneSolutionsForNEqualTo1(testCase)
      firstPredatorMortality = 1.1;
      familyNo = 1;
      setupFamilyStandaloneSolutions();
      firstPredatorMortality = 1.2;
      familyNo = 2;
      setupFamilyStandaloneSolutions();
      
      function setupFamilyStandaloneSolutions()
        nsol = 0;
        nvar = 3;
        solsToPlotVarValOffset = 0;
        testCase.setupStandaloneSolutions(firstPredatorMortality,...
          familyNo,nsol,nvar,solsToPlotVarValOffset);
      end
    end

    function setupStandaloneSolutions(testCase,firstPredatorMortality,...
        familyNo,nsol,nvar,solsToPlotVarValOffset)   
      standaloneSolutionsOffset = ...
        nsol*familyNo+testCase.nStandaloneSol*(familyNo-1);
      nSolPartForTrajectoryPlotRow = 2;
      standaloneSolsToPlotVarValOffset = ...
        solsToPlotVarValOffset+(testCase.nSolForTrajectoryPlot*nSolPartForTrajectoryPlotRow*(familyNo-1)+standaloneSolutionsOffset)*nvar;
      
      sol = standaloneSolutionsOffset;
      setupZeroOnePredatorSolution(sprintf(...
          'dir\\solution_results\\families\\p=1+0.5sin(2 pi x)\\l2=%.1f\\zeroFirstPredator.mat',...
          firstPredatorMortality),sol,...
        standaloneSolsToPlotVarValOffset:standaloneSolsToPlotVarValOffset+nvar-1);
      sol = standaloneSolutionsOffset+1;
      setupZeroOnePredatorSolution(sprintf(...
          'dir\\solution_results\\families\\p=1+0.5sin(2 pi x)\\l2=%.1f\\zeroSecondPredator.mat',...
          firstPredatorMortality),sol,...
        standaloneSolsToPlotVarValOffset+nvar:standaloneSolsToPlotVarValOffset+2*nvar-1);     
      
      firstSolutionPartForTrajectoryPlot(1,:) = ...
        standaloneSolsToPlotVarValOffset+2*nvar:standaloneSolsToPlotVarValOffset+3*nvar-1;
      firstSolutionPartForTrajectoryPlot(2,:) = ...
        standaloneSolsToPlotVarValOffset+3*nvar:standaloneSolsToPlotVarValOffset+4*nvar-1;
      secondSolutionPartForTrajectoryPlot(1,:) = ...
        standaloneSolsToPlotVarValOffset+4*nvar:standaloneSolsToPlotVarValOffset+5*nvar-1;
      secondSolutionPartForTrajectoryPlot(2,:) = ...
        standaloneSolsToPlotVarValOffset+5*nvar:standaloneSolsToPlotVarValOffset+6*nvar-1;
      
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
    
    function verifyGotDirListing(testCase,firstPredatorMortality,msg)
      testCase.dirname = 'dir\';
      testCase.namesPassedInToDir = {};
      testCase.setupFamiliesForNEqualTo1();
      testCase.act();
      testCase.verifyContains(testCase.namesPassedInToDir,...
        sprintf('dir\\solution_results\\families\\p=1+0.5sin(2 pi x)\\l2=%.1f\\*.mat',...
          firstPredatorMortality),msg);
    end
    
    function verifyErrorIfThereAreNoFilesToLoadFrom(testCase,file)
      testCase.setupStandaloneSolutionsForNEqualTo1();
      
      name = ...
        'dir\solution_results\families\p=1+0.5sin(2 pi x)\l2=1.1\*.mat';
      
      listing = struct;
      listing.name = name;
      listing.files = file;
      testCase.listingsToReturnFromDir = listing;
      testCase.verifyErrorNotAllFilesExist(...
        'Не выброшено исключение, несмотря на то что нет файлов для загрузки');
    end
    
    function verifyErrorIfSomeFilesAreMissing(testCase,file1,file2)
      testCase.setupStandaloneSolutionsForNEqualTo1();
            
      listing = struct;
      listing.name = ...
        'dir\solution_results\families\p=1+0.5sin(2 pi x)\l2=1.1\*.mat';
      listing.files = [file1,file2];
      testCase.listingsToReturnFromDir = listing;
      testCase.verifyErrorNotAllFilesExist(...
        'Не выброшено исключение, несмотря на то что некоторые файлы отсутствуют');
    end
    
    function verifyErrorNotAllFilesExist(testCase,msg)
      testCase.verifyError(@testCase.act,...
        'plotFamily:AllFilesMustExist',msg);
    end
    
    function verifyDidNotLoadFromForeignFiles(testCase,...
        familyInQuestionNo,familyInQuestionFirstPredatorMortality,...
        otherFamilyNo,otherFamilyFirstPredatorMortality,msg)
      nvar = 3;
      solsToPlotVarValOffset = 0;
      files = testCase.setupFamilySolutions(...
        familyInQuestionFirstPredatorMortality,familyInQuestionNo,nvar,...
        solsToPlotVarValOffset);
      
      nsol = 2;         
      testCase.setupStandaloneSolutions(...
        familyInQuestionFirstPredatorMortality,familyInQuestionNo,...
        nsol,nvar,solsToPlotVarValOffset);
      
      foreignFile = struct;
      foreignFile.name = 'foreign_file.mat';
      foreignFile.isdir = false;      
      files = [files,foreignFile];
      
      testCase.setupDirListing(familyInQuestionFirstPredatorMortality,...
        files);
      
      testCase.setupFamilyOf2Solutions(otherFamilyNo,...
        otherFamilyFirstPredatorMortality,nvar);
      
      testCase.act();
      testCase.verifyFalse(contains(testCase.filenamesPassedInToLoad,...
          sprintf('dir\\solution_results\\families\\p=1+0.5sin(2 pi x)\\l2=%.1f\\foreign_file.mat',...
            familyInQuestionFirstPredatorMortality)),msg);
    end
    
    function verifyGotSolution0LastPointWithMaxPredatorDensitiesForNEqualTo1(...
        testCase,solVarsVal,msgStart)
      colIndex = 3;
      testCase.verifyGotSolutionLastPointWithMaxPredatorDensitiesForNEqualTo1(...
        solVarsVal,colIndex,msgStart);
    end
    
    function verifyGotSolution0LastPointWithMaxPredatorDensitiesForNEqualTo2(...
        testCase,solVarsVal,msgStart)
      colIndex = 6;
      testCase.verifyGotSolutionLastPointWithMaxPredatorDensitiesForNEqualTo2(...
        solVarsVal,colIndex,msgStart);
    end
    
    function verifyGotSolution1LastPointWithMaxPredatorDensitiesForNEqualTo1(...
        testCase,solVarsVal,msgStart)
      colIndex = 2;
      testCase.verifyGotSolutionLastPointWithMaxPredatorDensitiesForNEqualTo1(...
        solVarsVal,colIndex,msgStart);
    end
        
    function verifyGotSolution1LastPointWithMaxPredatorDensitiesForNEqualTo2(...
        testCase,solVarsVal,msgStart)
      colIndex = 4;
      testCase.verifyGotSolutionLastPointWithMaxPredatorDensitiesForNEqualTo2(...
        solVarsVal,colIndex,msgStart);
    end
    
    function verifyGotSolutionLastPointWithMaxPredatorDensitiesForNEqualTo1(...
        testCase,solVarsVal,colIndex,msgStart)
      N = 1;
      nvar = 3;
      testCase.verifyGotSolutionLastPointWithMaxPredatorDensities(N,...
        nvar,colIndex,solVarsVal,msgStart);
    end
    
    function verifyGotSolutionLastPointWithMaxPredatorDensitiesForNEqualTo2(...
        testCase,solVarsVal,colIndex,msgStart)
      N = 2;
      nvar = 6;
      testCase.verifyGotSolutionLastPointWithMaxPredatorDensities(N,...
        nvar,colIndex,solVarsVal,msgStart);
    end
    
    function verifyGotSolutionLastPointWithMaxPredatorDensities(...
        testCase,N,nvar,colIndex,solVarsVal,msgStart)   
      testCase.setupFamilies(nvar);
      
      testCase.act();
      
      args = struct;
      args.solution(1:testCase.nsolpt,1:nvar) = solVarsVal;
      args.colIndex = colIndex;
      args.extremeValueKind = 'max';
      msg = testCase.getMsg(msgStart,N);
      testCase.verifyContains(...
        testCase.argsPassedInToGetLastRowWithExtremeElementValue,args,msg);
    end
    
    function verifyGotSolutionPartForTrajectoryPlot(testCase,solVarsVal,...
        pointIndex,msg)      
      nsol = 11;
      nvar = 3;
      
      familyNo = 1;
      familyFirstPredatorMortality = 1.1;
      setupFamilySolutions();
      
      familyNo = 2;
      familyFirstPredatorMortality = 1.2;
      setupFamilySolutions();
      
      testCase.act();
      
      args = struct;      
      nvar = 3;
      npt = 10;
      sol(1:npt,1:nvar) = solVarsVal;
      args.sol = sol;
      args.pointIndex = pointIndex;
      
      testCase.verifyContains(...
        testCase.argsPassedInToGetSolutionPartForTrajectoryPlot,args,msg);
      
      function setupFamilySolutions()
        files = [];
        
        nsol = 11;
        solsToPlotVarValOffset = testCase.nfamily*(nsol+testCase.nStandaloneSol)-1;
        
        filename = '0.mat';
        filepath = ...
          sprintf(...
            'dir\\solution_results\\families\\p=1+0.5sin(2 pi x)\\l2=%.1f\\0.mat',...
            familyFirstPredatorMortality);
        solNo = 0;              
        setupSolution();

        filename = '10.mat';
        filepath = ...
          sprintf(...
            'dir\\solution_results\\families\\p=1+0.5sin(2 pi x)\\l2=%.1f\\10.mat',...
            familyFirstPredatorMortality);
        solNo = 10;              
        setupSolution();

        filename = '1.mat';
        filepath = ...
          sprintf(...
            'dir\\solution_results\\families\\p=1+0.5sin(2 pi x)\\l2=%.1f\\1.mat',...
            familyFirstPredatorMortality);
        solNo = 1;  
        setupSolution();
        
        filename = '2.mat';
        filepath = ...
          sprintf(...
            'dir\\solution_results\\families\\p=1+0.5sin(2 pi x)\\l2=%.1f\\2.mat',...
            familyFirstPredatorMortality);
        solNo = 2;  
        setupSolution();
        
        filename = '3.mat';
        filepath = ...
          sprintf(...
            'dir\\solution_results\\families\\p=1+0.5sin(2 pi x)\\l2=%.1f\\3.mat',...
            familyFirstPredatorMortality);
        solNo = 3;  
        setupSolution();
        
        filename = '4.mat';
        filepath = ...
          sprintf(...
            'dir\\solution_results\\families\\p=1+0.5sin(2 pi x)\\l2=%.1f\\4.mat',...
            familyFirstPredatorMortality);
        solNo = 4;  
        setupSolution();
        
        filename = '5.mat';
        filepath = ...
          sprintf(...
            'dir\\solution_results\\families\\p=1+0.5sin(2 pi x)\\l2=%.1f\\5.mat',...
            familyFirstPredatorMortality);
        solNo = 5;  
        setupSolution();
        
        filename = '6.mat';
        filepath = ...
          sprintf(...
            'dir\\solution_results\\families\\p=1+0.5sin(2 pi x)\\l2=%.1f\\6.mat',...
            familyFirstPredatorMortality);
        solNo = 6;  
        setupSolution();
        
        filename = '7.mat';
        filepath = ...
          sprintf(...
            'dir\\solution_results\\families\\p=1+0.5sin(2 pi x)\\l2=%.1f\\7.mat',...
            familyFirstPredatorMortality);
        solNo = 7;  
        setupSolution();
        
        filename = '8.mat';
        filepath = ...
          sprintf(...
            'dir\\solution_results\\families\\p=1+0.5sin(2 pi x)\\l2=%.1f\\8.mat',...
            familyFirstPredatorMortality);
        solNo = 8;  
        setupSolution();
        
        filename = '9.mat';
        filepath = ...
          sprintf(...
            'dir\\solution_results\\families\\p=1+0.5sin(2 pi x)\\l2=%.1f\\9.mat',...
            familyFirstPredatorMortality);
        solNo = 9;  
        setupSolution();
                
        testCase.setupStandaloneSolutionsAndDirListing(files,...
          familyFirstPredatorMortality,familyNo,nsol,nvar,...
          solsToPlotVarValOffset);
        
        function setupSolution()
          files = testCase.setupSolution(files,filename,filepath,...
            familyNo,nsol,solNo,nvar,solsToPlotVarValOffset);
        end
      end
    end
    
    function verifyGotMaxSecondPredatorDensityForNEqualTo1(testCase,sol,...
        msgStart)
      colIndex = 3;
      testCase.verifyGotMaxPredatorDensityForNEqualTo1(sol,colIndex,...
        msgStart);
    end
    
    function verifyGotMaxSecondPredatorDensityForNEqualTo2(testCase,sol,...
        msgStart)
      colIndex = 6;
      testCase.verifyGotMaxPredatorDensityForNEqualTo2(sol,colIndex,...
        msgStart);
    end
    
    function verifyGotMaxFirstPredatorDensityForNEqualTo1(testCase,sol,...
        msgStart)
      colIndex = 2;
      testCase.verifyGotMaxPredatorDensityForNEqualTo1(sol,colIndex,...
        msgStart);
    end
    
    function verifyGotMaxFirstPredatorDensityForNEqualTo2(testCase,sol,...
        msgStart)
      colIndex = 4;
      testCase.verifyGotMaxPredatorDensityForNEqualTo2(sol,colIndex,...
        msgStart);
    end
    
    function verifyGotMaxPredatorDensityForNEqualTo1(testCase,sol,...
        colIndex,msgStart)
      N = 1;
      nvar = 3;
      testCase.verifyGotMaxNonZeroPredatorDensity(sol,N,nvar,...
        colIndex,msgStart);
    end
    
    function verifyGotMaxPredatorDensityForNEqualTo2(testCase,sol,...
        colIndex,msgStart)
      N = 2;
      nvar = 6;
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
      testCase.verifyTrue(contains(...
        testCase.argsPassedInToGetLastRowWithExtremeElementValue,args),...
        msg);
    end
    
    function verifyPlottedOnFirstSubplot(~,verifyFun)
      pos = 1;
      handle = 55;
      verifyFun(pos,handle);
    end
    
    function verifyPlottedOnSecondSubplot(~,verifyFun)
      pos = 2;
      handle = 56;
      verifyFun(pos,handle);
    end
    
    function verifyLinePlottedForNEqualTo1(testCase,pos,handle,line,...
        msgStart)
      N = 1;
      testCase.setupFamiliesForNEqualTo1();      
      testCase.verifyLinePlotted(pos,handle,N,line,msgStart);
    end
    
    function verifyLinePlottedForNEqualTo2(testCase,pos,handle,line,...
        msgStart)
      N = 2;
      testCase.setupFamiliesForNEqualTo2();
      testCase.verifyLinePlotted(pos,handle,N,line,msgStart);
    end
    
    function verifyPointPlottedForNEqualTo1(testCase,pos,handle,pt,...
        msgStart)
      N = 1;
      testCase.setupFamiliesForNEqualTo1();      
      testCase.verifyPointPlotted(pos,handle,N,pt,msgStart);
    end
      
    function verifyPointPlottedForNEqualTo2(testCase,pos,handle,pt,...
        msgStart)
      N = 2;
      testCase.setupFamiliesForNEqualTo2();      
      testCase.verifyPointPlotted(pos,handle,N,pt,msgStart);
    end
    
    function str = getMsg(~,msgStart,N)
      str = sprintf('%s при N = %d',msgStart,N);
    end
    
    function verifyDidNotOverwritePlots(testCase,pos,handle,msg)
      testCase.setupFamiliesForNEqualTo1();
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
      testCase.setupFamiliesForNEqualTo1();
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
      testCase.verifyContains(testCase.plottedPoints,pt,msg);
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
        @testCase.fakeGCA,@testCase.fakeSet);
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
      testCase.setupFamiliesForNEqualTo1();
      testCase.verifyGotMFilename();
    end
    
    function testGetsFileDirname(testCase)
      testCase.setupFamiliesForNEqualTo1();
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
    
    function testThrowsExceptionIfThereAreOnlyFolders(testCase)
      folder = struct;
      folder.name = '0.mat';
      folder.isdir = true;
      testCase.verifyErrorIfThereAreNoFilesToLoadFrom(folder);
    end
    
    function testThrowsExceptionIfThereAreOnlyForeignFiles(testCase)        
      foreignFile = struct;
      foreignFile.name = 'foreign_file.mat';
      foreignFile.isdir = false;
      testCase.verifyErrorIfThereAreNoFilesToLoadFrom(foreignFile);
    end
    
    function testThrowsExceptionIfFilesInTheMiddleAreMissing(testCase)
      file1 = struct;
      file1.name = '0.mat';
      file1.isdir = false;
      
      file2 = struct;
      file2.name = '2.mat';
      file2.isdir = false;
      
      testCase.verifyErrorIfSomeFilesAreMissing(file1,file2);                 
    end
    
    function testThrowsExceptionIfFilesAtStartAreMissing(testCase)
      file1 = struct;
      file1.name = '2.mat';
      file1.isdir = false;
      
      file2 = struct;
      file2.name = '3.mat';
      file2.isdir = false;
      
      testCase.verifyErrorIfSomeFilesAreMissing(file1,file2);            
    end
    
    function testDoesNotAttemptToLoadFromFolders(testCase)      
      firstPredatorMortality = 1.1;
      familyNo = 1;      
      nvar = 3;
      solsToPlotVarValOffset = 0;
      files = testCase.setupFamilySolutions(firstPredatorMortality,...
        familyNo,nvar,solsToPlotVarValOffset);
      
      nsol = 2;  
      testCase.setupStandaloneSolutions(firstPredatorMortality,familyNo,...
        nsol,nvar,solsToPlotVarValOffset);
      
      folder = struct;
      folder.name = '2.mat';
      folder.isdir = true;
      files = [files,folder];

      testCase.setupDirListing(firstPredatorMortality,files);
      
      firstPredatorMortality = 1.2;
      familyNo = 2; 
      
      testCase.setupFamilyOf2Solutions(familyNo,firstPredatorMortality,...
        nvar);
      
      testCase.act();      
      testCase.verifyFalse(contains(...
          testCase.filenamesPassedInToLoad,...
          'dir\solution_results\families\p=1+0.5sin(2 pi x)\l2=1.1\2.mat'),...
        'Попытка загрузить решение из папки');
    end
    
    function testDoesNotLoadFromForeignFilesOfFirstFamilyFolder(testCase)     
      familyInQuestionNo = 1;         
      familyInQuestionFirstPredatorMortality = 1.1;
      otherFamilyNo = 2;         
      otherFamilyFirstPredatorMortality = 1.2;
      testCase.verifyDidNotLoadFromForeignFiles(familyInQuestionNo,...
        familyInQuestionFirstPredatorMortality,otherFamilyNo,...
        otherFamilyFirstPredatorMortality,...
        'Загружены данные из неправильного файла папки первого семейства');
    end
    
    function testDoesNotLoadFromForeignFilesOfSecondFamilyFolder(testCase)     
      familyInQuestionNo = 2;         
      familyInQuestionFirstPredatorMortality = 1.2;
      otherFamilyNo = 1;         
      otherFamilyFirstPredatorMortality = 1.1;
      testCase.verifyDidNotLoadFromForeignFiles(familyInQuestionNo,...
        familyInQuestionFirstPredatorMortality,otherFamilyNo,...
        otherFamilyFirstPredatorMortality,...
        'Загружены данные из неправильного файла папки второго семейства');
    end
    
    function testGetsForNEqualTo1Family1Solution0LastPointWithMaxPredatorDensities(testCase)
      solVarsVal = 0;
      testCase.verifyGotSolution0LastPointWithMaxPredatorDensitiesForNEqualTo1(...
        solVarsVal,...
        'Не получена последняя точка первого решения первого семейства с максимумом хищников');
    end
    
    function testGetsForNEqualTo2Family1Solution0LastPointWithMaxPredatorDensities(testCase)       
      solVarsVal = 0;
      testCase.verifyGotSolution0LastPointWithMaxPredatorDensitiesForNEqualTo2(...
        solVarsVal,...
        'Не получена последняя точка первого решения первого семейства с максимумом хищников');
    end
    
    function testGetsForNEqualTo1Family1Solution1LastPointWithMaxPredatorDensities(testCase)      
      solVarsVal = 1;
      testCase.verifyGotSolution1LastPointWithMaxPredatorDensitiesForNEqualTo1(...
        solVarsVal,...
        'Не получена последняя точка второго решения первого семейства с максимумом хищников');
    end
    
    function testGetsForNEqualTo2Family1Solution1LastPointWithMaxPredatorDensities(testCase)
      solVarsVal = 1;
      testCase.verifyGotSolution1LastPointWithMaxPredatorDensitiesForNEqualTo2(...
        solVarsVal,...
        'Не получена последняя точка второго решения первого семейства с максимумом хищников');
    end
    
    function testGetsForNEqualTo1Family2Solution0LastPointWithMaxPredatorDensities(testCase)
      solVarsVal = 4;
      testCase.verifyGotSolution0LastPointWithMaxPredatorDensitiesForNEqualTo1(...
        solVarsVal,...
        'Не получена последняя точка первого решения второго семейства с максимумом хищников');
    end
    
    function testGetsForNEqualTo2Family2Solution0LastPointWithMaxPredatorDensities(testCase)
      solVarsVal = 4;
      testCase.verifyGotSolution0LastPointWithMaxPredatorDensitiesForNEqualTo2(...
        solVarsVal,...
        'Не получена последняя точка первого решения второго семейства с максимумом хищников');
    end
    
    function testGetsForNEqualTo1Family2Solution1LastPointWithMaxPredatorDensities(testCase)
      solVarsVal = 5;
      testCase.verifyGotSolution1LastPointWithMaxPredatorDensitiesForNEqualTo1(...
        solVarsVal,...
        'Не получена последняя точка второго решения второго семейства с максимумом хищников');
    end
    
    function testGetsForNEqualTo2Family2Solution1LastPointWithMaxPredatorDensities(testCase)
      solVarsVal = 5;
      testCase.verifyGotSolution1LastPointWithMaxPredatorDensitiesForNEqualTo2(...
        solVarsVal,...
        'Не получена последняя точка второго решения второго семейства с максимумом хищников');
    end
    
    function testThrowsExceptionForInconsistentGrids(testCase)
      testCase.setupStandaloneSolutionsForNEqualTo1();
      
      listing = struct;
      listing.name = ...
        'dir\solution_results\families\p=1+0.5sin(2 pi x)\l2=1.1\*.mat';
      file1 = struct;
      sol0Name = '0.mat';
      file1.name = sol0Name;
      file1.isdir = false;
      file2 = struct;
      sol1Name = '1.mat';
      file2.name = sol1Name;
      file2.isdir = false;
      
      listing.files = [file1,file2];
      testCase.listingsToReturnFromDir = listing;
            
      varsToLoad = struct;
      varsToLoad.filename = ...
        'dir\solution_results\families\p=1+0.5sin(2 pi x)\l2=1.1\0.mat';
      vars = struct;
      npt = 10;
      nvarForNEqualTo1 = 3;
      w = zeros(npt,nvarForNEqualTo1);
      vars.w = w;
      varsToLoad.vars = vars;
      testCase.varsToLoad = [testCase.varsToLoad,varsToLoad];
      
      vars = struct;
      vars.sol = w;
      vars.row = zeros(1,nvarForNEqualTo1);
      vars.rowIndex = [];
      testCase.varsToReturnFromGetLastRowWithExtremeElementValue = ...
        [testCase.varsToReturnFromGetLastRowWithExtremeElementValue,vars];
      
      varsToLoad = struct;
      varsToLoad.filename = ...
        'dir\solution_results\families\p=1+0.5sin(2 pi x)\l2=1.1\1.mat';
      vars = struct;
      nvarForNEqualTo2 = 6;
      w = zeros(npt,nvarForNEqualTo2);
      vars.w = w;
      varsToLoad.vars = vars;
      testCase.varsToLoad = [testCase.varsToLoad,varsToLoad];
      
      vars = struct;
      vars.sol = w;
      vars.row = zeros(1,nvarForNEqualTo1);
      vars.rowIndex = [];
      testCase.varsToReturnFromGetLastRowWithExtremeElementValue = ...
        [testCase.varsToReturnFromGetLastRowWithExtremeElementValue,vars];
      testCase.verifyError(@testCase.act,...
        'plotFamily:GridsMustBeConsistent',...
        'Не выброшено исключение, несмотря на то что для разных решений семейства разные сетки');
    end
    
    function testGetsPartOfFamily1SecondSolutionForTrajectoryPlot(testCase)
      solVarsVal = 1;
      pointIndex = -1;
      testCase.verifyGotSolutionPartForTrajectoryPlot(solVarsVal,...
        pointIndex,...
        'Не получена часть первого решения первого семейства для вывода траектории');
    end
    
    function testGetsPartOfFamily1SolutionBeforeLastForTrajectoryPlot(...
        testCase)      
      solVarsVal = 9;
      pointIndex = -9;
      testCase.verifyGotSolutionPartForTrajectoryPlot(solVarsVal,...
        pointIndex,...
        'Не получена часть второго решения первого семейства для вывода траектории');
    end
    
    function testGetsPartOfFamily2SolutionBeforeLastForTrajectoryPlot(testCase)
      solVarsVal = 22;
      pointIndex = -20;
      testCase.verifyGotSolutionPartForTrajectoryPlot(solVarsVal,...
        pointIndex,...
        'Не получена часть второго решения второго семейства для вывода траектории');
    end
    
    function testGetsFamily1MaxSecondPredatorDensityForNEqualTo1(testCase)
      sol = 2;
      testCase.verifyGotMaxSecondPredatorDensityForNEqualTo1(sol,...
        'Для решения первого семейства с нулевым первым хищником не получен максимум второго хищника');
    end
    
    function testGetsFamily1MaxSecondPredatorDensityForNEqualTo2(testCase)      
      sol = 2;
      testCase.verifyGotMaxSecondPredatorDensityForNEqualTo2(sol,...
        'Для решения первого семейства с нулевым первым хищником не получен максимум второго хищника');
    end
    
    function testGetsFamily1MaxFirstPredatorDensityForNEqualTo1(testCase)
      sol = 3;
      testCase.verifyGotMaxFirstPredatorDensityForNEqualTo1(sol,...
        'Для решения первого семейства с нулевым вторым хищником не получен максимум первого хищника');
    end
    
    function testGetsFamily1MaxFirstPredatorDensityForNEqualTo2(testCase)      
      sol = 3;
      testCase.verifyGotMaxFirstPredatorDensityForNEqualTo2(sol,...
        'Для решения первого семейства с нулевым вторым хищником не получен максимум первого хищника');
    end
    
    function testGetsFamily2MaxSecondPredatorDensityForNEqualTo1(testCase)
      sol = 6;
      testCase.verifyGotMaxSecondPredatorDensityForNEqualTo1(sol,...
        'Для решения второго семейства с нулевым первым хищником не получен максимум второго хищника');
    end
    
    function testGetsFamily2MaxSecondPredatorDensityForNEqualTo2(testCase)
      sol = 6;
      testCase.verifyGotMaxSecondPredatorDensityForNEqualTo2(sol,...
        'Для решения второго семейства с нулевым первым хищником не получен максимум второго хищника');
    end
    
    function testGetsFamily2MaxFirstPredatorDensityForNEqualTo1(testCase)
      sol = 7;
      testCase.verifyGotMaxFirstPredatorDensityForNEqualTo1(sol,...
        'Для решения второго семейства с нулевым вторым хищником не получен максимум первого хищника');
    end
    
    function testGetsFamily2MaxFirstPredatorDensityForNEqualTo2(testCase)
      sol = 7;
      testCase.verifyGotMaxFirstPredatorDensityForNEqualTo2(sol,...
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

    function testPlotsFamily1MaxPredatorDensitiesForNEqualTo1(testCase)
      expLine = [ 8  9
                 11 12];
      testCase.verifyPlottedOnFirstSubplot(...
        @(pos,handle) testCase.verifyLinePlottedForNEqualTo1(pos,...
          handle,expLine,...
          'Не выведены максимумы хищников для решений первого семейства'));
    end
    
    function testPlotsFamily1MaxPredatorDensitiesForNEqualTo2(testCase)      
      expLine = [10 12
                 16 18];
      testCase.verifyPlottedOnFirstSubplot(...
        @(pos,handle) testCase.verifyLinePlottedForNEqualTo2(pos,...
          handle,expLine,...
          'Не выведены максимумы хищников для решений первого семейства'));
    end
    
    function testPlotsFamily2MaxPredatorDensitiesForNEqualTo1(testCase)
      expLine = [32 33
                 35 36];
      testCase.verifyPlottedOnSecondSubplot(...
        @(pos,handle) testCase.verifyLinePlottedForNEqualTo1(pos,...
          handle,expLine,...
          'Не выведены максимумы хищников для решений второго семейства'));
    end
    
    function testPlotsFamily2MaxPredatorDensitiesForNEqualTo2(testCase)
      expLine = [58 60
                 64 66];
      testCase.verifyPlottedOnSecondSubplot(...
        @(pos,handle) testCase.verifyLinePlottedForNEqualTo2(pos,...
          handle,expLine,...
          'Не выведены максимумы хищников для решений второго семейства'));
    end
    
    function testPlotsForNEqualTo1Family1MaxSecondPredatorForZeroFirstPredator(testCase)
      expPoint = [14 15];      
      testCase.verifyPlottedOnFirstSubplot(...
        @(pos,handle) testCase.verifyPointPlottedForNEqualTo1(pos,...
          handle,expPoint,...
          'Не выведена максимальная плотность второго хищника для первого семейства'));
    end
    
    function testPlotsForNEqualTo2Family1MaxSecondPredatorForZeroFirstPredator(testCase)
      expPoint = [22 24];
      testCase.verifyPlottedOnFirstSubplot(...
        @(pos,handle) testCase.verifyPointPlottedForNEqualTo2(pos,...
          handle,expPoint,...
          'Не выведена максимальная плотность второго хищника для первого семейства'));
    end
    
    function testPlotsForNEqualTo1Family1MaxFirstPredatorForZeroSecondPredator(testCase)
      expPoint = [17 18];
      testCase.verifyPlottedOnFirstSubplot(...
        @(pos,handle) testCase.verifyPointPlottedForNEqualTo1(pos,...
          handle,expPoint,...
          'Не выведена максимальная плотность первого хищника для первого семейства'));
    end
    
    function testPlotsForNEqualTo2Family1MaxFirstPredatorForZeroSecondPredator(testCase)
      expPoint = [28 30];
      testCase.verifyPlottedOnFirstSubplot(...
        @(pos,handle) testCase.verifyPointPlottedForNEqualTo2(pos,...
          handle,expPoint,...
          'Не выведена максимальная плотность первого хищника для первого семейства'));
    end
    
    function testPlotsForNEqualTo1Family2MaxSecondPredatorForZeroFirstPredator(testCase)
      expPoint = [38 39];      
      testCase.verifyPlottedOnSecondSubplot(...
        @(pos,handle) testCase.verifyPointPlottedForNEqualTo1(pos,...
          handle,expPoint,...
          'Не выведена максимальная плотность второго хищника для второго семейства'));
    end
    
    function testPlotsForNEqualTo2Family2MaxSecondPredatorForZeroFirstPredator(testCase)
      expPoint = [70 72];      
      testCase.verifyPlottedOnSecondSubplot(...
        @(pos,handle) testCase.verifyPointPlottedForNEqualTo2(pos,...
          handle,expPoint,...
          'Не выведена максимальная плотность второго хищника для второго семейства'));
    end
    
    function testPlotsForNEqualTo1Family2MaxFirstPredatorForZeroSecondPredator(testCase)
      expPoint = [41 42];      
      testCase.verifyPlottedOnSecondSubplot(...
        @(pos,handle) testCase.verifyPointPlottedForNEqualTo1(pos,...
          handle,expPoint,...
          'Не выведена максимальная плотность первого хищника для второго семейства'));
    end
    
    function testPlotsForNEqualTo2Family2MaxFirstPredatorForZeroSecondPredator(testCase)
      expPoint = [76 78];      
      testCase.verifyPlottedOnSecondSubplot(...
        @(pos,handle) testCase.verifyPointPlottedForNEqualTo2(pos,...
          handle,expPoint,...
          'Не выведена максимальная плотность первого хищника для второго семейства'));
    end
    
    function testPlotsFamily1FirstSolutionTrajectoryForNEqualTo1(testCase)
      expLine = [20 21
                 23 24];
      testCase.verifyPlottedOnFirstSubplot(...
        @(pos,handle) testCase.verifyLinePlottedForNEqualTo1(pos,...
          handle,expLine,...
          'Не выведена первая траектория установления хищников для первого семейства'));
    end
    
    function testPlotsFamily1FirstSolutionTrajectoryForNEqualTo2(testCase)
      expLine = [34 36
                 40 42];
      testCase.verifyPlottedOnFirstSubplot(...
        @(pos,handle) testCase.verifyLinePlottedForNEqualTo2(pos,...
          handle,expLine,...
          'Не выведена первая траектория установления хищников для первого семейства'));
    end
    
    function testPlotsFamily1SecondSolutionTrajectoryForNEqualTo1(testCase)
      expLine = [26 27
                 29 30];
      testCase.verifyPlottedOnFirstSubplot(...
        @(pos,handle) testCase.verifyLinePlottedForNEqualTo1(pos,...
          handle,expLine,...
          'Не выведена вторая траектория установления хищников для первого семейства'));
    end
    
    function testPlotsFamily1SecondSolutionTrajectoryForNEqualTo2(testCase)
      expLine = [46 48
                 52 54];
      testCase.verifyPlottedOnFirstSubplot(...
        @(pos,handle) testCase.verifyLinePlottedForNEqualTo2(pos,...
          handle,expLine,...
          'Не выведена вторая траектория установления хищников для первого семейства'));
    end
    
    function testPlotsFamily2FirstSolutionTrajectoryForNEqualTo1(testCase)
      expLine = [44 45
                 47 48];
      testCase.verifyPlottedOnSecondSubplot(...
        @(pos,handle) testCase.verifyLinePlottedForNEqualTo1(pos,...
          handle,expLine,...
          'Не выведена первая траектория установления хищников для второго семейства'));
    end
    
    function testPlotsFamily2FirstSolutionTrajectoryForNEqualTo2(testCase)
      expLine = [82 84
                 88 90];
      testCase.verifyPlottedOnSecondSubplot(...
        @(pos,handle) testCase.verifyLinePlottedForNEqualTo2(pos,...
          handle,expLine,...
          'Не выведена первая траектория установления хищников для второго семейства'));
    end
    
%     function testPlotsFamily2SecondSolutionLastPointForNEqualTo1(testCase)
%       expLine = [50 51
%                  53 54];
%       testCase.verifyPlottedOnSecondSubplot(...
%         @(pos,handle) testCase.verifyPointPlottedForNEqualTo1(pos,...
%           handle,expLine,...
%           'Не выведено второе решение для второго семейства, которое является равновесием'));
%     end
    
%     function testPlotsFamily2SecondSolutionLastPointForNEqualTo2(testCase)
%       expLine = [ 94  96
%                  100 102];
%       testCase.verifyPlottedOnSecondSubplot(...
%         @(pos,handle) testCase.verifyPointPlottedForNEqualTo2(pos,...
%           handle,expLine,...
%           'Не выведено второе решение для второго семейства, которое является равновесием'));
%     end
    
    function testDoesNotOverwriteFamily1Plots(testCase)
      testCase.setupFamiliesForNEqualTo1();
      pos = 1;
      handle = 55;
      testCase.verifyDidNotOverwritePlots(pos,handle,...
        'Некоторые графики первого семейства затираются следующими');
    end
    
    function testDoesNotOverwriteFamily2Plots(testCase)
      testCase.setupFamiliesForNEqualTo1();
      pos = 2;
      handle = 56;
      testCase.verifyDidNotOverwritePlots(pos,handle,...
        'Некоторые графики второго семейства затираются следующими');
    end
  end
  
end

