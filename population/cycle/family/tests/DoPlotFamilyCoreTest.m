classdef DoPlotFamilyCoreTest < MFilenameAndGetFileDirnameTestBase...
    & MultipleLoadTestHelper & MultiplePlotsOnSameFigureTestHelper
  
  properties
    namePassedInToDir
    listingsToReturnFromDir
    filenamesPassedInToLoad
    argsPassedInToGetLastRowWithExtremeElementValue
    varsToReturnFromGetLastRowWithExtremeElementValue
    argsPassedInToGetSolutionPartForTrajectoryPlot
    solutionPartsForTrajectoryPlot
    getSolutionPartForTrajectoryPlotCallNo
    plottedPoints
  end
  
  methods (TestMethodSetup)
    function setup(testCase)
      setup@MultiplePlotsOnSameFigureTestHelper(testCase);
      testCase.dirname = 'dir\';
      testCase.filenamesPassedInToLoad = {};
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
      
      files = testCase.setupFamilyFirstSolution(firstPredatorMortality,...
        familyNo,nsol,nvar);
      
      solNo = 1;
      filename = '1.mat';
      filepath = sprintf(...
        'dir\\solution_results\\families\\p=1+0.5sin(2 pi x)\\l2=%.1f\\1.mat',...
        firstPredatorMortality);
      files = testCase.setupSolution(files,filename,filepath,familyNo,...
        nsol,solNo,nvar);
      
      testCase.setupStandaloneSolutionsAndDirListing(files,...
        firstPredatorMortality,familyNo,nsol,nvar);
    end
        
    function files = setupFamilyFirstSolution(testCase,...
        firstPredatorMortality,familyNo,nsol,nvar)
      files = [];
      solNo = 0;    
      filename = '0.mat';
      filepath = sprintf(...
        'dir\\solution_results\\families\\p=1+0.5sin(2 pi x)\\l2=%.1f\\0.mat',...
        firstPredatorMortality);
      files = testCase.setupSolution(files,filename,filepath,familyNo,...
        nsol,solNo,nvar);
    end
    
    function setupStandaloneSolutionsAndDirListing(testCase,...
        files,firstPredatorMortality,familyNo,nsol,nvar)
      standaloneSolutionsOffset = nsol*familyNo;
      testCase.setupStandaloneSolutions(firstPredatorMortality,...
        standaloneSolutionsOffset,nsol,nvar);
      
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
        familyNo,nsol,solNo,nvar)
      file = struct; 
      file.name = filename;
      file.isdir = false;
      
      listing = [listing,file];

      varsToLoad = struct;
      varsToLoad.filename = filepath;
      vars = struct;
      npt = 10;
      w(1:npt,1:nvar) = solNo;
      vars.w = w;
      varsToLoad.vars = vars;
      testCase.varsToLoad = [testCase.varsToLoad,varsToLoad];

      vars = struct;
      vars.sol = w;
      familyOffset = nsol*(familyNo-1);
      solOffset = familyOffset+solNo;
      vars.row = nvar*solOffset+1:nvar*(solOffset+1);
      vars.rowIndex = -solOffset;
      testCase.varsToReturnFromGetLastRowWithExtremeElementValue = ...
        [testCase.varsToReturnFromGetLastRowWithExtremeElementValue,vars];
    end

    function setupStandaloneSolutionsForNEqualTo1(testCase)
      nsol = 0;
      nvar = 3;
      family1FirstPredatorMortality = 1.1;
      family1No = 1;
      testCase.setupStandaloneSolutions(family1FirstPredatorMortality,...
        family1No,nsol,nvar);
      family2FirstPredatorMortality = 1.2;
      family2No = 2;
      testCase.setupStandaloneSolutions(family2FirstPredatorMortality,...
        family2No,nsol,nvar);
    end

    function setupStandaloneSolutions(testCase,firstPredatorMortality,...
        standaloneSolutionsOffset,nsol,nvar)
      sol = nsol;
      setupZeroOnePredatorSolution(sprintf(...
          'dir\\solution_results\\families\\p=1+0.5sin(2 pi x)\\l2=%.1f\\zeroFirstPredator.mat',...
          firstPredatorMortality),sol,...
        nvar*standaloneSolutionsOffset+1:nvar*(standaloneSolutionsOffset+1));
      sol = nsol+1;
      setupZeroOnePredatorSolution(...
        sprintf(...
          'dir\\solution_results\\families\\p=1+0.5sin(2 pi x)\\l2=%.1f\\zeroSecondPredator.mat',...
          firstPredatorMortality),sol,...
        nvar*(standaloneSolutionsOffset+1)+1:nvar*(standaloneSolutionsOffset+2));     
      
      firstSolutionPartForTrajectoryPlot(1,:) = ...
        nvar*(standaloneSolutionsOffset+2)+1:nvar*(standaloneSolutionsOffset+3);
      firstSolutionPartForTrajectoryPlot(2,:) = ...
        nvar*(standaloneSolutionsOffset+3)+1:nvar*(standaloneSolutionsOffset+4);
      secondSolutionPartForTrajectoryPlot(1,:) = ...
        nvar*(standaloneSolutionsOffset+4)+1:nvar*(standaloneSolutionsOffset+5);
      secondSolutionPartForTrajectoryPlot(2,:) = ...
        nvar*(standaloneSolutionsOffset+5)+1:nvar*(standaloneSolutionsOffset+6);
      
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
    
    function verifyErrorIfThereAreNoFilesToLoadFrom(testCase,file)
      testCase.setupStandaloneSolutionsForNEqualTo1();
      
      name = ...
        'dir\solution_results\families\p=1+0.5sin(2 pi x)\l2=1.1\*.mat';
      
      listing = struct;
      listing.name = name;
      listing.files = file;
      testCase.listingsToReturnFromDir = listing;
      testCase.verifyErrorNotAllFilesExist(...
        '�� ��������� ����������, �������� �� �� ��� ��� ������ ��� ��������');
    end
    
    function verifyErrorNotAllFilesExist(testCase,msg)
      testCase.verifyError(@testCase.act,...
        'plotFamily:AllFilesMustExist',msg);
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
      npt = 10;
      sol(1:npt,1:nvar) = solVarsVal;
      args.solution = sol;
      args.colIndex = colIndex;
      args.extremeVarValue = 'max';
      msg = testCase.getMsg(msgStart,N);
      testCase.verifyFalse(contains(...
        testCase.argsPassedInToGetLastRowWithExtremeElementValue,args),...
        msg);
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
        files = testCase.setupFamilyFirstSolution(...
          familyFirstPredatorMortality,familyNo,nsol,nvar);

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
        
        nsol = 11;
        testCase.setupStandaloneSolutionsAndDirListing(files,...
          familyFirstPredatorMortality,familyNo,nsol,nvar);
        
        function setupSolution()
          files = testCase.setupSolution(files,filename,filepath,...
            familyNo,nsol,solNo,nvar);
        end
      end
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
    
    function verifyLinePlottedForNEqualTo1(testCase,line,msgStart)
      N = 1;
      testCase.setupFamiliesForNEqualTo1();      
      testCase.verifyLinePlotted(N,line,msgStart);
    end
    
    function verifyLinePlottedForNEqualTo2(testCase,line,msgStart)
      N = 2;
      testCase.setupFamiliesForNEqualTo2();
      testCase.verifyLinePlotted(N,line,msgStart);
    end
    
    function verifyPointPlottedForNEqualTo1(testCase,pt,msgStart)
      N = 1;
      testCase.setupFamiliesForNEqualTo1();      
      testCase.verifyPointPlotted(N,pt,msgStart);
    end
      
    function verifyPointPlottedForNEqualTo2(testCase,pt,msgStart)
      N = 2;
      testCase.setupFamiliesForNEqualTo2();      
      testCase.verifyPointPlotted(N,pt,msgStart);
    end
    
    function str = getMsg(~,msgStart,N)
      str = sprintf('%s ��� N = %d',msgStart,N);
    end
    
    function files = fakeDir(testCase,name)
      testCase.namePassedInToDir = name;      
      listing = getArrayItem(testCase.listingsToReturnFromDir,...
        @(l) strcmp(l.name,name));
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
      verifyLinePlotted@MultiplePlotsOnSameFigureTestHelper(testCase,...
        line,msg);
    end
    
    function verifyPointPlotted(testCase,N,pt,msgStart)
      msg = testCase.getMsg(msgStart,N);
      verifyPointPlotted@MultiplePlotsOnSameFigureTestHelper(testCase,...
        pt,msg);
    end
    
    function vars = fakeLoad(testCase,filename,varargin)      
      testCase.filenamesPassedInToLoad = ...
        [testCase.filenamesPassedInToLoad,filename];
      vars = fakeLoad@MultipleLoadTestHelper(testCase,filename,varargin);
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
        @testCase.fakePlot,@testCase.fakeHold,...
        @testCase.fakeLabel,@testCase.fakeXLabel,@testCase.fakeYLabel,...
        @testCase.fakeGCA,@testCase.fakeSet);
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
    
    function testGetsDirListing(testCase)
      testCase.dirname = 'dir\';
      testCase.setupFamiliesForNEqualTo1();
      testCase.act();
      testCase.verifyEqual(testCase.namePassedInToDir,...
        'dir\solution_results\families\p=1+0.5sin(2 pi x)\l2=1.1\*.mat',...
        '�� �������� ����� ������ � ��������� ���������');
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
    
    function testThrowsExceptionIfSomeFilesAreMissing(testCase)
      testCase.setupStandaloneSolutionsForNEqualTo1();
            
      listing = struct;
      listing.name = ...
        'dir\solution_results\families\p=1+0.5sin(2 pi x)\l2=1.1\*.mat';
      file1 = struct;
      file1.name = '0.mat';
      file1.isdir = false;
      file2 = struct;
      file2.name = '2.mat';
      file2.isdir = false;
      listing.files = [file1,file2];
      testCase.listingsToReturnFromDir = listing;
      testCase.assertError(@testCase.act,...
        'plotFamily:AllFilesMustExist',...
        '�� ��������� ����������, �������� �� �� ��� ��������� ����� �����������');
                 
      file1 = struct;
      file1.name = '2.mat';
      file1.isdir = false;
      file2 = struct;
      file2.name = '3.mat';
      file2.isdir = false;
      testCase.listingsToReturnFromDir.files = [file1,file2];
   
      testCase.verifyError(@testCase.act,...
        'plotFamily:AllFilesMustExist',...
        '�� ��������� ����������, �������� �� �� ��� ��������� ����� �����������');
    end
    
    function testDoesNotAttemptToLoadFromFolders(testCase)      
      firstPredatorMortality = 1.1;
      familyNo = 1;
      nsol = 2;  
      nvar = 3;
      files = testCase.setupFamilyFirstSolution(firstPredatorMortality,...
        familyNo,nsol,nvar);
         
      solNo = 1;
      filename = '1.mat';
      filepath = ...
        'dir\solution_results\families\p=1+0.5sin(2 pi x)\l2=1.1\1.mat';
      files = testCase.setupSolution(files,filename,filepath,familyNo,...
        nsol,solNo,nvar);
      
      standaloneSolutionsOffset = nsol*familyNo;
      testCase.setupStandaloneSolutions(firstPredatorMortality,...
        standaloneSolutionsOffset,nsol,nvar);
      
      folder = struct;
      folder.name = '2.mat';
      folder.isdir = true;
      files = [files,folder];

      testCase.setupDirListing(firstPredatorMortality,files);
      
      testCase.act();      
      testCase.verifyFalse(contains(...
          testCase.filenamesPassedInToLoad,...
          'dir\solution_results\families\p=1+0.5sin(2 pi x)\l2=1.1\2.mat'),...
        '������� ��������� ������� �� �����');
    end
    
    function testDoesNotLoadFromForeignFiles(testCase)      
      firstPredatorMortality = 1.1;
      familyNo = 1;            
      nsol = 2;   
      nvar = 3;
      files = testCase.setupFamilyFirstSolution(firstPredatorMortality,...
        familyNo,nsol,nvar);
      
      solNo = 1;
      filename = '1.mat';
      filepath = ...
        'dir\solution_results\families\p=1+0.5sin(2 pi x)\l2=1.1\1.mat';
      files = testCase.setupSolution(files,filename,filepath,familyNo,...
        nsol,solNo,nvar);
      
      standaloneSolutionsOffset = nsol*familyNo;
      testCase.setupStandaloneSolutions(firstPredatorMortality,...
        standaloneSolutionsOffset,nsol,nvar);
      
      foreignFile = struct;
      foreignFile.name = 'foreign_file.mat';
      foreignFile.isdir = false;      
      files = [files,foreignFile];
      
      testCase.setupDirListing(firstPredatorMortality,files);
      
      testCase.act();
      testCase.verifyFalse(contains(testCase.filenamesPassedInToLoad,...
          'dir\solution_results\families\p=1+0.5sin(2 pi x)\l2=1.1\foreign_file.mat'),...
        '��������� ������ �� ������������� �����');
    end
    
    function testGetsSolution0LastPointWithMaxPredatorDensitiesForNEqualTo1(testCase)
      solVarsVal = 0;
      colIndex = 3;
      testCase.verifyGotSolutionLastPointWithMaxPredatorDensitiesForNEqualTo1(...
        solVarsVal,colIndex,...
        '�� �������� ��������� ����� ������� ������� � ������������� ����������� ��������� �������� � ����������� ����� ������');
    end
    
    function testGetsSolution0LastPointWithMaxPredatorDensitiesForNEqualTo2(testCase)       
      solVarsVal = 0;
      colIndex = 6;
      testCase.verifyGotSolutionLastPointWithMaxPredatorDensitiesForNEqualTo2(...
        solVarsVal,colIndex,...
        '�� �������� ��������� ����� ������� ������� � ������������� ����������� ��������� �������� � ����������� ����� ������');
    end
    
    function testGetsSolution1LastPointWithMaxPredatorDensitiesForNEqualTo1(testCase)      
      solVarsVal = 1;
      colIndex = 2;
      testCase.verifyGotSolutionLastPointWithMaxPredatorDensitiesForNEqualTo1(...
        solVarsVal,colIndex,...
        '�� �������� ��������� ����� ������� ������� � ������������� ����������� ��������� �������� � ����������� ����� ������');
    end
    
    function testGetsSolution1LastPointWithMaxPredatorDensitiesForNEqualTo2(testCase)
      solVarsVal = 1;
      colIndex = 4;
      testCase.verifyGotSolutionLastPointWithMaxPredatorDensitiesForNEqualTo2(...
        solVarsVal,colIndex,...
        '�� �������� ��������� ����� ������� ������� � ������������� ����������� ��������� �������� � ����������� ����� ������');
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
        '�� ��������� ����������, �������� �� �� ��� ��� ������ ������� ��������� ������ �����');
    end
    
    function testGetsPartOfFamilySecondSolutionForTrajectoryPlot(testCase)
      solVarsVal = 1;
      pointIndex = -1;
      testCase.verifyGotSolutionPartForTrajectoryPlot(solVarsVal,...
        pointIndex,...
        '�� �������� ����� ������� ������� ��� ������ ����������');
    end
    
    function testGetsPartOfFamilySolutionBeforeLastForTrajectoryPlot(testCase)      
      solVarsVal = 9;
      pointIndex = -9;
      testCase.verifyGotSolutionPartForTrajectoryPlot(solVarsVal,...
        pointIndex,...
        '�� �������� ����� ������� ������� ��� ������ ����������');
    end
    
    function testGetsMaxSecondPredatorDensityForNEqualTo1(testCase)      
      sol = 2;
      colIndex = 3;
      testCase.verifyGotMaxPredatorDensityForNEqualTo1(sol,colIndex,...
        '��� ������� � ������� ������ ���������� �������� �� �������� ������������ ��������� ������ ��������� �������� � ����������� ����� ������');
    end
    
    function testGetsMaxSecondPredatorDensityForNEqualTo2(testCase)      
      sol = 2;
      colIndex = 6;
      testCase.verifyGotMaxPredatorDensityForNEqualTo2(sol,colIndex,...
        '��� ������� � ������� ������ ���������� �������� �� �������� ������������ ��������� ������ ��������� �������� � ����������� ����� ������');
    end
    
    function testGetsMaxFirstPredatorDensityForNEqualTo1(testCase)
      sol = 3;
      colIndex = 2;
      testCase.verifyGotMaxPredatorDensityForNEqualTo1(sol,colIndex,...
        '��� ������� � ������� ������ ���������� �������� �� �������� ������������ ��������� ������ ��������� �������� � ����������� ����� ������');
    end
    
    function testGetsMaxFirstPredatorDensityForNEqualTo2(testCase)      
      sol = 3;
      colIndex = 4;
      testCase.verifyGotMaxPredatorDensityForNEqualTo2(sol,colIndex,...
        '��� ������� � ������� ������ ���������� �������� �� �������� ������������ ��������� ������ ��������� �������� � ����������� ����� ������');
    end
    
%     function testPlotsAllOnSameNewlyCreatedFigure(testCase)
%       testCase.setupFamiliesForNEqualTo1();
%       testCase.act();
%       figureCallIndices = find(arrayfun(@(call) strcmp(call.fcn,'figure'),...
%         testCase.callSequence));
%       plotCallIndices = find(arrayfun(@(call) strcmp(call.fcn,'plot'),...
%         testCase.callSequence));
%       testCase.assertFalse(isempty(figureCallIndices),...
%         '�� ������� ����� ���� �������');
%       testCase.verifyTrue(isempty(find(...
%         plotCallIndices < figureCallIndices,1)),...
%         '�� ��� ������� �������� �� ����� �������');
%     end
    
    function testPlotsFamilyMaxPredatorDensitiesForNEqualTo1(testCase)
      expLine = [2 3
                 5 6];
      testCase.verifyLinePlottedForNEqualTo1(expLine,...
        '�� �������� ��������� �������� � ����������� ����� ������ ��� ������� ���������');
    end
    
    function testPlotsFamilyMaxPredatorDensitiesForNEqualTo2(testCase)      
      expLine = [ 4  6
                 10 12];
      testCase.verifyLinePlottedForNEqualTo2(expLine,...
        '�� �������� ��������� �������� � ����������� ����� ������ ��� ������� ���������');
    end
    
    function testPlotsMaxSecondPredatorForZeroFirstPredatorForNEqualTo1(testCase)
      expPoint = [8 9];
      testCase.verifyPointPlottedForNEqualTo1(expPoint,...
        '�� �������� ������������ ��������� ������ ��������� �������� � ����������� ����� ������');
    end
    
    function testPlotsMaxSecondPredatorForZeroFirstPredatorForNEqualTo2(testCase)
      expPoint = [16 18];
      testCase.verifyPointPlottedForNEqualTo2(expPoint,...
        '�� �������� ������������ ��������� ������ ��������� �������� � ����������� ����� ������');
    end
    
    function testPlotsMaxFirstPredatorForZeroSecondPredatorForNEqualTo1(testCase)
      expPoint = [11 12];
      testCase.verifyPointPlottedForNEqualTo1(expPoint,...
        '�� �������� ������������ ��������� ������ ��������� �������� � ����������� ����� ������');
    end
    
    function testPlotsMaxFirstPredatorForZeroSecondPredatorForNEqualTo2(testCase)
      expPoint = [22 24];
      testCase.verifyPointPlottedForNEqualTo2(expPoint,...
        '�� �������� ������������ ��������� ������ ��������� �������� � ����������� ����� ������');
    end
    
    function testPlotsFirstSolutionTrajectoryForNEqualTo1(testCase)
      expLine = [14 15
                 17 18];
      testCase.verifyLinePlottedForNEqualTo1(expLine,...
        '�� �������� ������ ���������� ������������ �������� � ����������� ����� ������');
    end
    
    function testPlotsFirstSolutionTrajectoryForNEqualTo2(testCase)
      expLine = [28 30
                 34 36];
      testCase.verifyLinePlottedForNEqualTo2(expLine,...
        '�� �������� ������ ���������� ������������ �������� � ����������� ����� ������');
    end
    
    function testPlotsSecondSolutionTrajectoryForNEqualTo1(testCase)
      expLine = [20 21
                 23 24];
      testCase.verifyLinePlottedForNEqualTo1(expLine,...
        '�� �������� ������ ���������� ������������ �������� � ����������� ����� ������');
    end
    
    function testPlotsSecondSolutionTrajectoryForNEqualTo2(testCase)
      expLine = [40 42
                 46 48];
      testCase.verifyLinePlottedForNEqualTo2(expLine,...
        '�� �������� ������ ���������� ������������ �������� � ����������� ����� ������');
    end
    
    function testDoesNotOverwritePlots(testCase)
      testCase.setupFamiliesForNEqualTo1();
      testCase.act();
      holdOnCallIndices = find(arrayfun(@(call) strcmp(call.fcn,'hold') ...
        && strcmp(call.args.arg,'on'),testCase.callSequence));
      testCase.assertFalse(isempty(holdOnCallIndices),...
        '��������� ������� ���������� ����������');
      plotCallIndices = find(...
        arrayfun(@(call) strcmp(call.fcn,'plot'),...
        testCase.callSequence));
      plotBeforeHoldOnIndices = find(plotCallIndices < holdOnCallIndices(1));
      testCase.assertLessThanOrEqual(length(plotBeforeHoldOnIndices),1,...
        '��������� ������� ���������� ����������');
      holdOffCallIndices = find(arrayfun(...
        @(call) strcmp(call.fcn,'hold') && strcmp(call.args.arg,'off'),...
        testCase.callSequence));
      holdOffBeforeLastPlotCallIndices = find(...
        holdOffCallIndices < plotCallIndices(end),1);
      testCase.verifyTrue(isempty(holdOffBeforeLastPlotCallIndices),...
        '��������� ������� ���������� ����������');
    end
  end
  
end

