classdef DoFindAndSavePointWithMaxPredatorDensitiesTest < matlab.unittest.TestCase
  %DOFINDANDSAVEPOINTWITHMAXPREDATORDENSITIESTEST Summary of this class goes here
  %   Detailed explanation goes here
  
  properties
    isPassedInFunctionCalled
    passedInResultsFilename
    passedInSecondPredatorDiffusionCoeff
    passedInGetFilename
    passedInGetFileDir
    passedInGetDirpath
    passedInGetResultsFilepath
    passedInExists
    passedInLoad
    passedInSave
    passedInGetParams
    passedInFigure
    passedInSolver
    passedInPeriod
    passedInGetFirstPointWithExtremeVarValues
  end
  
  methods
    function fakeFcnToPassIn(testCase,resultsFilename,...
        secondPredatorDiffusionCoeff,getFilename,...
        getFileDir,getDirpath,getResultsFilepath,exists,load,save,...
        getParams,figure,solver,getFirstPointWithExtremeVarValues)
      testCase.isPassedInFunctionCalled = true;
      testCase.passedInResultsFilename = resultsFilename;
      testCase.passedInSecondPredatorDiffusionCoeff = secondPredatorDiffusionCoeff;
      testCase.passedInGetFilename = getFilename;
      testCase.passedInGetFileDir = getFileDir;
      testCase.passedInGetDirpath = getDirpath;
      testCase.passedInGetResultsFilepath = getResultsFilepath;
      testCase.passedInExists = exists;
      testCase.passedInLoad = load;
      testCase.passedInSave = save;
      testCase.passedInGetParams = getParams;
      testCase.passedInFigure = figure;
      testCase.passedInSolver = solver;
      testCase.passedInGetFirstPointWithExtremeVarValues = ...
        getFirstPointWithExtremeVarValues;
    end
  end
  
  methods (Test)
    function testPassesProperParamsToPassedInFunction(testCase)
      resultsFilename = 'results_filename';
      secondPredatorDiffusionCoeff = 0.2;
      testCase.isPassedInFunctionCalled = false;
      doFindAndSavePointWithMaxPredatorDensities(...
        @testCase.fakeFcnToPassIn,resultsFilename,...
        secondPredatorDiffusionCoeff);
      testCase.assertTrue(testCase.isPassedInFunctionCalled,...
        'Переданная функция не вызвана');
      testCase.verifyEqual(testCase.passedInResultsFilename,resultsFilename,...
        'Передано неправильное имя файла результатов');
      testCase.verifyEqual(...
        testCase.passedInSecondPredatorDiffusionCoeff,...
        secondPredatorDiffusionCoeff,...
        'Передано неправильное значение коэффициента диффузии второй популяции хищников');
      testCase.verifyEqual(testCase.passedInGetFilename,@mfilename,...
        'Передана неправильная функция получения имени файла');
      testCase.verifyEqual(testCase.passedInGetFileDir,@getFileDir,...
        'Передана неправильная функция получения пути к папке, содержащей файл');
      testCase.verifyEqual(testCase.passedInGetDirpath,@getDirpath,...
        'Передана неправильная функция получения пути к папке с результатами');
      testCase.verifyEqual(...
        testCase.passedInGetResultsFilepath,...
        @getResultsFilepath,...
        'Передана неправильная функция получения пути к файлу результатов');
      testCase.verifyEqual(testCase.passedInExists,@exist,...
        'Передана неправильная функция проверки существования файла/переменной');      
      testCase.verifyEqual(testCase.passedInLoad,@load,...
        'Передана неправильная функция загрузки переменных из файла');
      testCase.verifyEqual(testCase.passedInSave,@saveStruct,...
        'Передана неправильная функция сохранения переменных в файл');
      testCase.verifyEqual(testCase.passedInGetParams,...
        @predatorPrey2x1Params,'Переданы неправильные параметры');
      testCase.verifyEqual(testCase.passedInFigure,@figure,...
        'Передана неправильная функция создания нового окна');
      testCase.verifyEqual(testCase.passedInSolver,@myode4,...
        'Передан неправильный решатель');
      testCase.verifyEqual(...
        testCase.passedInGetFirstPointWithExtremeVarValues,...
        @getFirstPointWithExtremeVarValues,...
        'Передана неправильная функция нахождения первой точки с экстремальными значениями переменных с переданными индексами');
    end
  end
  
end

