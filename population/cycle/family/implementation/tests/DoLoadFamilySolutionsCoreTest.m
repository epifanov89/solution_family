classdef DoLoadFamilySolutionsCoreTest < matlab.unittest.TestCase & ...
    FakeCurrentDirNameHelper & LoadFamilyTestHelper
  
  properties    
    namePassedInToDir
    listing
    familyName
    varsToLoadForFamily
  end
  
  methods (TestMethodSetup)
    function setup(testCase)
      setup@LoadFamilyTestHelper(testCase);
      testCase.familyName = 'family_p=1+0,5sin(2 pi x)\';
    end
  end
  
  methods (Access = private)
    function setupSimpleFamilyName(testCase)
      testCase.familyName = 'family\';
    end
  end
  
  methods
    function listing = fakeDir(testCase,name)
      testCase.namePassedInToDir = name;
      listing = testCase.listing;
    end
  end
  
  methods (Access = protected)
    function solutions = act(testCase)
      solutions = doLoadFamilySolutionsCore(...
        @testCase.fakeCurrentDirName,@testCase.fakeDir,...
        @testCase.fakeLoad,testCase.familyName,...
        testCase.varsToLoadForFamily);
    end
  end
  
  methods (Test)
    function testGetsDirListing(testCase)      
      testCase.setupSimpleFamilyName();
      testCase.dirname = 'dir\';
      testCase.act();
      testCase.verifyEqual(testCase.namePassedInToDir,...
        'dir\solution_results\family\*.mat',...
        'Не получены имена файлов с решениями семейства');
    end
    
    function testDoesNotAttemptToLoadFromFolders(testCase)
      testCase.setupSimpleFamilyName();
      
      folder = struct;
      folder.name = '0.mat';
      folder.isdir = false;
      file = struct;
      file.name = '1.mat';
      file.isdir = true;
      testCase.listing = [folder,file];
            
      loadedVars = struct;
      loadedVars.filename = 'solution_results\family\0.mat';
      vars = struct;
      t = zeros(1,20);
      vars.t = t;
      loadedVars.vars = vars;
      
      testCase.varsToLoad = [testCase.varsToLoad,loadedVars];
      
      testCase.varsToLoadForFamily = 't';
      
      testCase.act();      
      testCase.verifyTrue(isempty(find(strcmp(...
        testCase.filenamesPassedInToLoad,...
        'solution_results\family\1.mat'),1)),...
        'Попытка загрузить решение из папки');
    end
    
    function testDoesNotLoadFromForeignFiles(testCase)      
      testCase.setupSimpleFamilyName();
      
      foreignFile = struct;
      foreignFile.name = 'foreign_file.mat';
      foreignFile.isdir = false;
      familyFile = struct;
      familyFile.name = '0.mat';
      familyFile.isdir = false;
      testCase.listing = [foreignFile,familyFile];
      
      loadedVars = struct;
      loadedVars.filename = 'solution_results\family\0.mat';
      vars = struct;
      t = zeros(1,20);
      vars.t = t;
      loadedVars.vars = vars;
      
      testCase.varsToLoad = [testCase.varsToLoad,loadedVars];
      
      testCase.varsToLoadForFamily = 't';
      
      testCase.act();
      testCase.verifyTrue(isempty(find(strcmp(...
        testCase.filenamesPassedInToLoad,...
        'solution_results\foreign_file.mat'),1)),...
        'Загружены данные из неправильного файла');
    end

    function testReturnsLoadedSolutionsInRightOrder(testCase)    
      testCase.familyName = 'family_p=1+0,5sin(2 pi x)\';
      
      file2 = struct;
      file2.name = '2.mat';
      file2.isdir = false;
      file10 = struct;
      file10.name = '10.mat';
      file10.isdir = false;
      testCase.listing = [file10,file2];
      
      loadedVars = struct;
      loadedVars.filename = ...
        'solution_results\family_p=1+0,5sin(2 pi x)\2.mat';
      vars = struct;
      npt = 20;
      t2 = zeros(1,npt);
      vars.t = t2;
      loadedVars.vars = vars;
      
      testCase.varsToLoad = [testCase.varsToLoad,loadedVars];
      
      loadedVars.filename = ...
        'solution_results\family_p=1+0,5sin(2 pi x)\10.mat';
      t10 = ones(1,npt);
      vars.t = t10;
      loadedVars.vars = vars;
      
      testCase.varsToLoad = [testCase.varsToLoad,loadedVars];
      
      testCase.varsToLoadForFamily = 't';
      
      solutions = testCase.act();
      sol2 = struct;
      sol2.t = t2;
      sol10 = struct;
      sol10.t = t10;
      testCase.verifyEqual(solutions,[sol2,sol10],...
        'Загруженные решения не возвращены в правильном порядке');
    end
  end
  
end

