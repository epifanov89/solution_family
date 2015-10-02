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
      testCase.filenamesPassedInToLoad = {};
      testCase.solutionPartsForTrajectoryPlot = {};
      testCase.getSolutionPartForTrajectoryPlotCallNo = 1;
      testCase.plottedPoints = {};     
    end
  end
  
  methods (Access = private)    
    function setupFamiliesOf2SolutionsForNEqualTo1(testCase)
      nsol = 2;
      nvar = 3;
      testCase.setupFamilies(nsol,nvar);
    end
    
    function setupFamiliesOf2SolutionsForNEqualTo2(testCase)
      nsol = 2;
      nvar = 6;
      testCase.setupFamilies(nsol,nvar);
    end
    
    function setupFamiliesOf11SolutionsForNEqualTo1(testCase)
      nvar = 3;
      testCase.setupFamiliesOf11Solutions(nvar);
    end
    
    function setupFamiliesOf11Solutions(testCase,nvar)
      nsol = 11;
      
      family1No = 1;
      family1FirstPredatorMortality = 1.1;
      testCase.setupFamilyOf11Solutions(family1No,...
        family1FirstPredatorMortality,nsol,nvar);
      
      family2No = 2;
      family2FirstPredatorMortality = 1.2;
      testCase.setupFamilyOf11Solutions(family2No,...
        family2FirstPredatorMortality,nsol,nvar);
    end
    
    function setupFamilyOf11Solutions(testCase,familyNo,...
        firstPredatorMortality,nsol,nvar)  
      familyDirName = sprintf(...
        '%ssolution_results\\families\\p=1+0.5sin(2 pi x)\\l2=%.1f\\',...
        testCase.dirname,firstPredatorMortality);
      
      files = [];
      
      solNo = 0;
      files = testCase.setupSolution(files,familyDirName,familyNo,nsol,...
        solNo,nvar);
      
      solNo = 10;      
      files = testCase.setupSolution(files,familyDirName,familyNo,nsol,...
        solNo,nvar);
      
      nsol = 11;
      testCase.setupRegularSolutionsAndDirListing(nsol-2,files,...
        familyDirName,familyNo,nsol,nvar);
    end
    
    function setupFamilies(testCase,nsol,nvar)
      family1No = 1;
      family1FirstPredatorMortality = 1.1;
      testCase.setupFamilySolutions(family1No,...
        family1FirstPredatorMortality,nsol,nvar);
      
      family2No = 2;
      family2FirstPredatorMortality = 1.2;
      testCase.setupFamilySolutions(family2No,...
        family2FirstPredatorMortality,nsol,nvar);
    end
    
    function setupFamilySolutions(testCase,familyNo,...
        firstPredatorMortality,nsol,nvar)
      familyDirName = sprintf(...
        '%ssolution_results\\families\\p=1+0.5sin(2 pi x)\\l2=%.1f\\',...
        testCase.dirname,firstPredatorMortality);
            
      files = [];
      
      solNo = 0;      
      files = testCase.setupSolution(files,familyDirName,familyNo,nsol,...
        solNo,nvar);
      
      testCase.setupRegularSolutionsAndDirListing(nsol-1,files,...
        familyDirName,familyNo,nsol,nvar);
    end
    
    function setupRegularSolutionsAndDirListing(testCase,solNoFinish,...
        files,familyDirName,familyNo,nsol,nvar)
      files = testCase.setupRegularSolutions(solNoFinish,files,...
        familyDirName,familyNo,nsol,nvar);
      testCase.setupDirListing(familyDirName,files);
    end
    
    function files = setupRegularSolutions(testCase,solNoFinish,files,...
        familyDirName,familyNo,nsol,nvar)
      for solNo = 1:solNoFinish
        files = testCase.setupSolution(files,familyDirName,familyNo,...
          nsol,solNo,nvar);
      end
      
      standaloneSolutionsOffset = nsol*familyNo;
      testCase.setupStandaloneSolutions(familyDirName,...
        standaloneSolutionsOffset,nsol,nvar);
    end
    
    function setupDirListing(testCase,dirname,files)
      listing = struct;      
      listing.name = strcat(dirname,'*.mat');
      listing.files = files;
      testCase.listingsToReturnFromDir = ...
        [testCase.listingsToReturnFromDir,listing];
    end
    
    function listing = setupSolution(testCase,listing,familyDirName,...
        familyNo,nsol,solNo,nvar)
      file = struct;
      filename = sprintf('%d.mat',solNo);      
      file.name = filename;
      file.isdir = false;
      
      listing = [listing,file];

      varsToLoad = struct;
      varsToLoad.filename = strcat(familyDirName,filename);
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
      familyDirNameStart = ...
        'solution_results\families\p=1+0.5sin(2 pi x)\l2=';
      family1FirstPredatorMortality = 1.1;
      family1DirName = sprintf('%s%d\\',familyDirNameStart,...
        family1FirstPredatorMortality);
      family1No = 1;
      testCase.setupStandaloneSolutions(family1DirName,family1No,...
        nsol,nvar);
      family2FirstPredatorMortality = 1.2;
      family2DirName = sprintf('%s%d\\',familyDirNameStart,...
        family2FirstPredatorMortality);
      family2No = 2;
      testCase.setupStandaloneSolutions(family2DirName,family2No,...
        nsol,nvar);
    end

    function setupStandaloneSolutions(testCase,familyDirName,...
        standaloneSolutionsOffset,nsol,nvar)
      sol = nsol;
      setupZeroOnePredatorSolution(...
        strcat(familyDirName,'zeroFirstPredator.mat'),sol,...
        nvar*standaloneSolutionsOffset+1:nvar*(standaloneSolutionsOffset+1));
      sol = nsol+1;
      setupZeroOnePredatorSolution(...
        strcat(familyDirName,'zeroSecondPredator.mat'),sol,...
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
      nsol = 2;
      testCase.setupFamilies(nsol,nvar);
      
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
      testCase.setupFamiliesOf11SolutionsForNEqualTo1();
      
      testCase.act();
      
      args = struct;      
      nvar = 3;
      npt = 10;
      sol(1:npt,1:nvar) = solVarsVal;
      args.sol = sol;
      args.pointIndex = pointIndex;
      
      testCase.verifyContains(...
        testCase.argsPassedInToGetSolutionPartForTrajectoryPlot,args,msg);
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
      nsol = 2;
      testCase.setupFamilies(nsol,nvar);
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
      testCase.setupFamiliesOf2SolutionsForNEqualTo1();      
      testCase.verifyLinePlotted(N,line,msgStart);
    end
    
    function verifyLinePlottedForNEqualTo2(testCase,line,msgStart)
      N = 2;
      testCase.setupFamiliesOf2SolutionsForNEqualTo2();
      testCase.verifyLinePlotted(N,line,msgStart);
    end
    
    function verifyPointPlottedForNEqualTo1(testCase,pt,msgStart)
      N = 1;
      testCase.setupFamiliesOf2SolutionsForNEqualTo1();      
      testCase.verifyPointPlotted(N,pt,msgStart);
    end
      
    function verifyPointPlottedForNEqualTo2(testCase,pt,msgStart)
      N = 2;
      testCase.setupFamiliesOf2SolutionsForNEqualTo2();      
      testCase.verifyPointPlotted(N,pt,msgStart);
    end
    
    function str = getMsg(~,msgStart,N)
      str = sprintf('%s при N = %d',msgStart,N);
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
      testCase.setupFamiliesOf2SolutionsForNEqualTo1();
      testCase.verifyGotMFilename();
    end
    
    function testGetsFileDirname(testCase)
      testCase.setupFamiliesOf2SolutionsForNEqualTo1();
      testCase.verifyGotFileDirname();
    end
    
    function testGetsDirListing(testCase)
      testCase.dirname = 'dir\';
      testCase.setupFamiliesOf2SolutionsForNEqualTo1();
      testCase.act();
      testCase.verifyEqual(testCase.namePassedInToDir,...
        'dir\solution_results\families\p=1+0.5sin(2 pi x)\l2=1.1\*.mat',...
        'Не получены имена файлов с решениями семейства');
    end
    
    function testThrowsExceptionIfThereAreNoFilesToLoadFrom(testCase)
      testCase.setupStandaloneSolutionsForNEqualTo1();
      
      name = 'solution_results\families\p=1+0.5sin(2 pi x)\l2=1.1\*.mat';
      
      listing = struct;
      listing.name = name;
      folder = struct;
      folder.name = '0.mat';
      folder.isdir = true;
      listing.files = folder;
      testCase.listingsToReturnFromDir = listing;
      testErrorNotAllFilesExist(@testCase.assertError);
      
      foreignFile = struct;
      foreignFile.name = 'foreign_file.mat';
      foreignFile.isdir = false;
      testCase.listingsToReturnFromDir.files = foreignFile;
      testErrorNotAllFilesExist(@testCase.verifyError);
      
      function testErrorNotAllFilesExist(testErrFcn)
        testErrFcn(@testCase.act,...
          'plotFamily:AllFilesMustExist',...
          'Не выброшено исключение, несмотря на то что нет файлов для загрузки');
      end
    end
    
    function testThrowsExceptionIfSomeFilesAreMissing(testCase)
      testCase.setupStandaloneSolutionsForNEqualTo1();
      
      fileDirName = 'solution_results\families\p=1+0.5sin(2 pi x)\l2=1.1\';
      
      listing = struct;
      listing.name = strcat(fileDirName,'*.mat');
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
        'Не выброшено исключение, несмотря на то что некоторые файлы отсутствуют');
                 
      file1 = struct;
      file1.name = '2.mat';
      file1.isdir = false;
      file2 = struct;
      file2.name = '3.mat';
      file2.isdir = false;
      testCase.listingsToReturnFromDir.files = [file1,file2];
      
      varsToLoad = struct;
      varsToLoad.filename = strcat(fileDirName,'2.mat');
      vars = struct;
      vars.w = [1 2 1 2 1];
      varsToLoad.vars = vars;
      testCase.varsToLoad = [testCase.varsToLoad,varsToLoad];
      
      varsToLoad = struct;
      varsToLoad.filename = strcat(fileDirName,'3.mat');
      vars = struct;
      vars.w = [2 3 2 3 2];
      varsToLoad.vars = vars;
      testCase.varsToLoad = [testCase.varsToLoad,varsToLoad];      
      
      testCase.verifyError(@testCase.act,...
        'plotFamily:AllFilesMustExist',...
        'Не выброшено исключение, несмотря на то что некоторые файлы отсутствуют');
    end
    
    function testDoesNotAttemptToLoadFromFolders(testCase)      
      familyDirName = ...
        'solution_results\families\p=1+0.5sin(2 pi x)\l2=1.1\';
      
      files = [];
      familyNo = 1;
      nsol = 2;
      solNo = 0;      
      nvar = 3;
      files = testCase.setupSolution(files,familyDirName,familyNo,nsol,...
        solNo,nvar);
         
      files = testCase.setupRegularSolutions(nsol-1,files,familyDirName,...
        familyNo,nsol,nvar);
      
      folder = struct;
      folder.name = '2.mat';
      folder.isdir = true;
      files = [files,folder];

      testCase.setupDirListing(familyDirName,files);
      
      testCase.act();      
      testCase.verifyFalse(contains(...
          testCase.filenamesPassedInToLoad,...
          strcat(familyDirName,'2.mat')),...
        'Попытка загрузить решение из папки');
    end
    
    function testDoesNotLoadFromForeignFiles(testCase)
      familyDirName = ...
        'solution_results\families\p=1+0.5sin(2 pi x)\l2=1.1\';
      
      files = [];
      familyNo = 1;            
      nsol = 2;
      solNo = 0;      
      nvar = 3;
      files = testCase.setupSolution(files,familyDirName,familyNo,nsol,...
        solNo,nvar);
      
      files = testCase.setupRegularSolutions(nsol-1,files,familyDirName,...
        familyNo,nsol,nvar);
      
      foreignFile = struct;
      foreignFile.name = 'foreign_file.mat';
      foreignFile.isdir = false;      
      files = [files,foreignFile];
      
      testCase.setupDirListing(familyDirName,files);
      
      testCase.act();
      testCase.verifyTrue(isempty(find(strcmp(...
        testCase.filenamesPassedInToLoad,...
        strcat(familyDirName,'foreign_file.mat')),1)),...
        'Загружены данные из неправильного файла');
    end
    
    function testGetsSolution0LastPointWithMaxPredatorDensitiesForNEqualTo1(testCase)
      solVarsVal = 0;
      colIndex = 3;
      testCase.verifyGotSolutionLastPointWithMaxPredatorDensitiesForNEqualTo1(...
        solVarsVal,colIndex,...
        'Не получена последняя точка первого решения с максимальными плотностями популяций хищников в центральной точке ареала');
    end
    
    function testGetsSolution0LastPointWithMaxPredatorDensitiesForNEqualTo2(testCase)       
      solVarsVal = 0;
      colIndex = 6;
      testCase.verifyGotSolutionLastPointWithMaxPredatorDensitiesForNEqualTo2(...
        solVarsVal,colIndex,...
        'Не получена последняя точка первого решения с максимальными плотностями популяций хищников в центральной точке ареала');
    end
    
    function testGetsSolution1LastPointWithMaxPredatorDensitiesForNEqualTo1(testCase)      
      solVarsVal = 1;
      colIndex = 2;
      testCase.verifyGotSolutionLastPointWithMaxPredatorDensitiesForNEqualTo1(...
        solVarsVal,colIndex,...
        'Не получена последняя точка второго решения с максимальными плотностями популяций хищников в центральной точке ареала');
    end
    
    function testGetsSolution1LastPointWithMaxPredatorDensitiesForNEqualTo2(testCase)
      solVarsVal = 1;
      colIndex = 4;
      testCase.verifyGotSolutionLastPointWithMaxPredatorDensitiesForNEqualTo2(...
        solVarsVal,colIndex,...
        'Не получена последняя точка второго решения с максимальными плотностями популяций хищников в центральной точке ареала');
    end
    
    function testThrowsExceptionForInconsistentGrids(testCase)
      testCase.setupStandaloneSolutionsForNEqualTo1();
      familyDirName = ...
        'solution_results\families\p=1+0.5sin(2 pi x)\l2=1.1\';
      
      listing = struct;
      listing.name = strcat(familyDirName,'*.mat');
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
      varsToLoad.filename = strcat(familyDirName,sol0Name);
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
      varsToLoad.filename = strcat(familyDirName,sol1Name);
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
    
    function testGetsPartOfFamilySecondSolutionForTrajectoryPlot(testCase)
      solVarsVal = 1;
      pointIndex = -1;
      testCase.verifyGotSolutionPartForTrajectoryPlot(solVarsVal,...
        pointIndex,...
        'Не получена часть первого решения для вывода траектории');
    end
    
    function testGetsPartOfFamilySolutionBeforeLastForTrajectoryPlot(testCase)      
      solVarsVal = 9;
      pointIndex = -9;
      testCase.verifyGotSolutionPartForTrajectoryPlot(solVarsVal,...
        pointIndex,...
        'Не получена часть второго решения для вывода траектории');
    end
    
    function testGetsMaxSecondPredatorDensityForNEqualTo1(testCase)      
      sol = 2;
      colIndex = 3;
      testCase.verifyGotMaxPredatorDensityForNEqualTo1(sol,colIndex,...
        'Для решения с нулевой первой популяцией хищников не получены максимальные плотности второй популяции хищников в центральной точке ареала');
    end
    
    function testGetsMaxSecondPredatorDensityForNEqualTo2(testCase)      
      sol = 2;
      colIndex = 6;
      testCase.verifyGotMaxPredatorDensityForNEqualTo2(sol,colIndex,...
        'Для решения с нулевой первой популяцией хищников не получены максимальные плотности второй популяции хищников в центральной точке ареала');
    end
    
    function testGetsMaxFirstPredatorDensityForNEqualTo1(testCase)
      sol = 3;
      colIndex = 2;
      testCase.verifyGotMaxPredatorDensityForNEqualTo1(sol,colIndex,...
        'Для решения с нулевой второй популяцией хищников не получены максимальные плотности первой популяции хищников в центральной точке ареала');
    end
    
    function testGetsMaxFirstPredatorDensityForNEqualTo2(testCase)      
      sol = 3;
      colIndex = 4;
      testCase.verifyGotMaxPredatorDensityForNEqualTo2(sol,colIndex,...
        'Для решения с нулевой второй популяцией хищников не получены максимальные плотности первой популяции хищников в центральной точке ареала');
    end
    
%     function testPlotsAllOnSameNewlyCreatedFigure(testCase)
%       testCase.setupFamiliesOf2SolutionsForNEqualTo1();
%       testCase.act();
%       figureCallIndices = find(arrayfun(@(call) strcmp(call.fcn,'figure'),...
%         testCase.callSequence));
%       plotCallIndices = find(arrayfun(@(call) strcmp(call.fcn,'plot'),...
%         testCase.callSequence));
%       testCase.assertFalse(isempty(figureCallIndices),...
%         'Не создано новое окно рисунка');
%       testCase.verifyTrue(isempty(find(...
%         plotCallIndices < figureCallIndices,1)),...
%         'Не все графики выведены на одном рисунке');
%     end
    
    function testPlotsFamilyMaxPredatorDensitiesForNEqualTo1(testCase)
      expLine = [2 3
                 5 6];
      testCase.verifyLinePlottedForNEqualTo1(expLine,...
        'Не выведены максимумы хищников в центральной точке ареала для решений семейства');
    end
    
    function testPlotsFamilyMaxPredatorDensitiesForNEqualTo2(testCase)      
      expLine = [ 4  6
                 10 12];
      testCase.verifyLinePlottedForNEqualTo2(expLine,...
        'Не выведены максимумы хищников в центральной точке ареала для решений семейства');
    end
    
    function testPlotsMaxSecondPredatorForZeroFirstPredatorForNEqualTo1(testCase)
      expPoint = [8 9];
      testCase.verifyPointPlottedForNEqualTo1(expPoint,...
        'Не выведена максимальная плотность второй популяции хищников в центральной точке ареала');
    end
    
    function testPlotsMaxSecondPredatorForZeroFirstPredatorForNEqualTo2(testCase)
      expPoint = [16 18];
      testCase.verifyPointPlottedForNEqualTo2(expPoint,...
        'Не выведена максимальная плотность второй популяции хищников в центральной точке ареала');
    end
    
    function testPlotsMaxFirstPredatorForZeroSecondPredatorForNEqualTo1(testCase)
      expPoint = [11 12];
      testCase.verifyPointPlottedForNEqualTo1(expPoint,...
        'Не выведена максимальная плотность первой популяции хищников в центральной точке ареала');
    end
    
    function testPlotsMaxFirstPredatorForZeroSecondPredatorForNEqualTo2(testCase)
      expPoint = [22 24];
      testCase.verifyPointPlottedForNEqualTo2(expPoint,...
        'Не выведена максимальная плотность первой популяции хищников в центральной точке ареала');
    end
    
    function testPlotsFirstSolutionTrajectoryForNEqualTo1(testCase)
      expLine = [14 15
                 17 18];
      testCase.verifyLinePlottedForNEqualTo1(expLine,...
        'Не выведена первая траектория установления хищников в центральной точке ареала');
    end
    
    function testPlotsFirstSolutionTrajectoryForNEqualTo2(testCase)
      expLine = [28 30
                 34 36];
      testCase.verifyLinePlottedForNEqualTo2(expLine,...
        'Не выведена первая траектория установления хищников в центральной точке ареала');
    end
    
    function testPlotsSecondSolutionTrajectoryForNEqualTo1(testCase)
      expLine = [20 21
                 23 24];
      testCase.verifyLinePlottedForNEqualTo1(expLine,...
        'Не выведена вторая траектория установления хищников в центральной точке ареала');
    end
    
    function testPlotsSecondSolutionTrajectoryForNEqualTo2(testCase)
      expLine = [40 42
                 46 48];
      testCase.verifyLinePlottedForNEqualTo2(expLine,...
        'Не выведена вторая траектория установления хищников в центральной точке ареала');
    end
    
    function testDoesNotOverwritePlots(testCase)
      testCase.setupFamiliesOf2SolutionsForNEqualTo1();
      testCase.act();
      holdOnCallIndices = find(arrayfun(@(call) strcmp(call.fcn,'hold') ...
        && strcmp(call.args.arg,'on'),testCase.callSequence));
      testCase.assertFalse(isempty(holdOnCallIndices),...
        'Некоторые графики затираются следующими');
      plotCallIndices = find(...
        arrayfun(@(call) strcmp(call.fcn,'plot'),...
        testCase.callSequence));
      plotBeforeHoldOnIndices = find(plotCallIndices < holdOnCallIndices(1));
      testCase.assertLessThanOrEqual(length(plotBeforeHoldOnIndices),1,...
        'Некоторые графики затираются следующими');
      holdOffCallIndices = find(arrayfun(...
        @(call) strcmp(call.fcn,'hold') && strcmp(call.args.arg,'off'),...
        testCase.callSequence));
      holdOffBeforeLastPlotCallIndices = find(...
        holdOffCallIndices < plotCallIndices(end),1);
      testCase.verifyTrue(isempty(holdOffBeforeLastPlotCallIndices),...
        'Некоторые графики затираются следующими');
    end
  end
  
end

