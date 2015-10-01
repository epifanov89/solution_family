classdef DoCalculateMultipliersAndSolveOnPeriodTest < matlab.unittest.TestCase
  %DOCALCULATEMULTIPLIERSANDSOLVEONPERIODTEST Summary of this class goes here
  %   Detailed explanation goes here
  
  properties
    isPassedInFunctionCalled
    passedInSolNo
    passedInGetFilename
    passedInGetFileDir
    passedInGetResultsFilepathForMFile
    passedInGetResultsFilepath
    passedInExists
    passedInLoad
    passedInSave
    passedInGetParams
    passedInCalculateMultipliers
    passedInSolver    
    passedInFigure
    passedInPrint
    passedInDisplay
  end
  
  methods
    function fakeFcnToPassIn(testCase,solno,getFilename,...
        getFileDir,getResultsFilepathForMFile,getResultsFilepath,exists,...
        load,save,getParams,calculateMultipliers,solver,fig,print,disp)
      testCase.isPassedInFunctionCalled = true;
      testCase.passedInSolNo = solno;
      testCase.passedInGetFilename = getFilename;
      testCase.passedInGetFileDir = getFileDir;
      testCase.passedInGetResultsFilepathForMFile = ...
        getResultsFilepathForMFile;
      testCase.passedInGetResultsFilepath = getResultsFilepath;    
      testCase.passedInExists = exists;
      testCase.passedInLoad = load;
      testCase.passedInSave = save;
      testCase.passedInGetParams = getParams;
      testCase.passedInCalculateMultipliers = calculateMultipliers;
      testCase.passedInSolver = solver;
      testCase.passedInFigure = fig;
      testCase.passedInPrint = print;
      testCase.passedInDisplay = disp;
    end
  end
  
  methods (Test)
    function testPassesProperParamsToPassedInFunctionCore(testCase)
      solno = 1;
      testCase.isPassedInFunctionCalled = false;
      doCalculateMultipliersAndSolveOnPeriod(solno,...
        @testCase.fakeFcnToPassIn);
      testCase.assertTrue(testCase.isPassedInFunctionCalled,...
        'Переданная функция не вызвана');
      testCase.verifyEqual(testCase.passedInSolNo,solno,...
        'Передан неправильный номер решения');
      testCase.verifyEqual(testCase.passedInGetFilename,@mfilename,...
        'Передана неправильная функция получения имени файла');
      testCase.verifyEqual(testCase.passedInGetFileDir,@getFileDir,...
        'Передана неправильная функция получения пути к папке, содержащей файл');
      testCase.verifyEqual(...
        testCase.passedInGetResultsFilepathForMFile,...
        @getResultsFilepathForMFile,...
        'Передана неправильная функция получения пути к файлу результатов для текущего файла с кодом');      
      testCase.verifyEqual(testCase.passedInGetResultsFilepath,...
        @getResultsFilepath,...
        'Передана неправильная функция получения пути к файлу результатов');
      testCase.verifyEqual(testCase.passedInExists,@exist,...
        'Передана неправильная функция проверки существования файла/переменной');
      testCase.verifyEqual(testCase.passedInLoad,@load,...
        'Передана неправильная функция загрузки переменных из файла');
      testCase.verifyEqual(testCase.passedInSave,@save,...
        'Передана неправильная функция сохранения переменных в файл');
      testCase.verifyEqual(testCase.passedInGetParams,...
        @predatorPrey2x1Params,'Переданы неправильные параметры');
      testCase.verifyEqual(testCase.passedInCalculateMultipliers,...
        @multipliers_one_system_for_each_monodromy_matrix_column,...
        'Передана неправильная функция расчета мультипликаторов');
      testCase.verifyEqual(testCase.passedInSolver,@myode4,...
        'Передан неправильный решатель');
      testCase.verifyEqual(testCase.passedInFigure,@figure,...
        'Передана неправильная функция содания нового окна');
      testCase.verifyEqual(testCase.passedInPrint,@fprintf,...
        'Передана неправильная функция печати');
      testCase.verifyEqual(testCase.passedInDisplay,@display,...
        'Передана неправильная функция печати');
    end
  end
  
end

