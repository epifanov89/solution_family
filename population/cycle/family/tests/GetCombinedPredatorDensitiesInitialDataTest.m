classdef GetCombinedPredatorDensitiesInitialDataTest < matlab.unittest.TestCase
  %GETCOMBINEDPREDATORDENSITIESINITIALDATA Summary of this class goes here
  %   Detailed explanation goes here
  
  properties
    paramPassedInToGetFilename
    filename
    paramPassedInToGetFileDir
    dir
    solno
    nsol
    isGetFinalSolutionFilepathCalled
    dirPassedInToGetFinalSolutionFilepath
    filenamePassedInToGetFinalSolutionFilepath
    finalSolutionFilepath
    existent    
    loadedVars
    varsToReturnFromLoad
  end
  
  methods (TestMethodSetup)
    function setup(testCase)
      testCase.solno = 4;
      testCase.nsol = 10;
      testCase.finalSolutionFilepath = 'final_solution_filename';
      testCase.existent = struct;
      testCase.loadedVars = struct;
      testCase.varsToReturnFromLoad = struct;
      testCase.varsToReturnFromLoad.maxPredatorDensitiesPoint = ...
        [1 2 1 2 1 0 0 0 0 0 1 2 1 2 1];
    end
  end
  
  methods
    function filename = fakeGetFilename(testCase,param)
      testCase.paramPassedInToGetFilename = param;
      filename = testCase.filename;
    end
    
    function dir = fakeGetFileDir(testCase,param)
      testCase.paramPassedInToGetFileDir = param;
      dir = testCase.dir;
    end
    
    function filepath = fakeGetFinalSolutionFilepath(testCase,dir,filename)
      testCase.isGetFinalSolutionFilepathCalled = true;
      testCase.dirPassedInToGetFinalSolutionFilepath = dir;
      testCase.filenamePassedInToGetFinalSolutionFilepath = filename;
      filepath = testCase.finalSolutionFilepath;
    end
    
    function exists = fakeExist(testCase,name,kind)
      exists = ~isempty(find(strcmp(testCase.existent.(kind),name),1));
    end
    
    function S = fakeLoad(testCase,filename,varargin)
      if ~isfield(testCase.loadedVars,filename)
        testCase.loadedVars.(filename) = varargin;
      else
        testCase.loadedVars.(filename) = ...
          [testCase.loadedVars.(filename),varargin];
      end
      S = testCase.varsToReturnFromLoad;
    end
    
    function w0 = act(testCase)
      w0 = getCombinedPredatorDensitiesInitialData(@testCase.fakeGetFilename,...
        @testCase.fakeGetFileDir,...
        @testCase.fakeGetFinalSolutionFilepath,...
        @testCase.fakeExist,@testCase.fakeLoad,...
        testCase.solno,testCase.nsol);
    end
  end
  
  methods (Test)
    function testGetsFilename(testCase)
      testCase.existent.('file') = testCase.finalSolutionFilepath;
      testCase.act();
      testCase.verifyEqual(testCase.paramPassedInToGetFilename,...
        'fullpath','Не получено имя файла');
    end
    
    function testGetsFileDir(testCase)
      testCase.filename = 'filename';
      testCase.existent.('file') = testCase.finalSolutionFilepath;
      testCase.act();
      testCase.verifyEqual(testCase.paramPassedInToGetFileDir,...
        testCase.filename,'Не получен путь к папке, содержащей файл');
    end
    
    function testGetsFinalSolutionFilepath(testCase)
      testCase.dir = 'dir\';
      testCase.existent.('file') = testCase.finalSolutionFilepath;
      testCase.act();
      testCase.assertTrue(...
        testCase.isGetFinalSolutionFilepathCalled,...
        'Не получен путь к файлу с окончательными результатами решения');
      testCase.verifyEqual(...
        testCase.dirPassedInToGetFinalSolutionFilepath,...
        testCase.dir,...
        'Передан неправильный путь к папке, содержащей файл с кодом');
      testCase.verifyFalse(isempty(strfind(...
        testCase.filenamePassedInToGetFinalSolutionFilepath,'0')),...
        'Имя файла окончательных результатов решения не содержит ноль');
    end
    
    function testThrowsExceptionIfFinalSolutionFileDoesNotExist(testCase)
      testCase.existent.('file') = [];
      testCase.verifyError(@() testCase.act(),...
        'getCombinedPredatorDensitiesInitialData:FileMustExist',...
        'Не существует файл с максимальной плотностью второй популяции хищников при нулевой первой популяции хищников');
    end
    
    function testLoadsPointWithMaxSecondPredatorForZeroFirstPredator(testCase)      
      testCase.existent.('file') = testCase.finalSolutionFilepath;
      testCase.act();
      testCase.assertTrue(isfield(testCase.loadedVars,...
        testCase.finalSolutionFilepath),...
        'Не загружена точка с максимальными плотностями популяций хищников');
      testCase.verifyFalse(isempty(find(strcmp(...
        testCase.loadedVars.(testCase.finalSolutionFilepath),...
        'maxPredatorDensitiesPoint'),1)),...
        'Не загружена точка с максимальными плотностями популяций хищников');
    end
    
    function testProperlyCombinesPredatorDensities(testCase)
      testCase.existent.('file') = testCase.finalSolutionFilepath;
      actInitialData = testCase.act();
      expInitialData = [1 2 1 2 1 0.4 0.8 0.4 0.8 0.4 0.6 1.2 0.6 1.2 0.6];
      testCase.verifyEqual(actInitialData,expInitialData,...
        'Плотности популяций хищников возвращенных начальных данных не являются комбинацией максимальных плотностей второй популяции хищников при нулевой первой популяции хищников');
    end
  end
  
end

