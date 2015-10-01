classdef DoSolveTillSteadyTest < matlab.unittest.TestCase
  %DOSOLVETILLSTEADYTEST Summary of this class goes here
  %   Detailed explanation goes here
  
  properties
    isPassedInFunctionCalled
    passedInSolNo
    passedInTF
    passedInGetFilename
    passedInGetFileDir
    passedInExists
    passedInGetInitialDataToSolveTillSteady
    passedInLoad
    passedInSave
    passedInGetParams
    passedInSolver
    passedInGetFirstPointWithExtremeVarValues
    passedInGetLastRow
    passedInGetPeriod
    passedInGetResultsFilepath
    passedInGetSolutionTillMaxPredatorDensities
  end
  
  methods
    function fakeFcnToPassIn(testCase,solno,tf,getFilename,...
        getFileDir,exists,getInitialDataToSolveTillSteady,...
        load,save,getParams,solver,getFirstPointWithExtremeVarValues,...
        getLastRow,getPeriod,getResultsFilepath,...
        getSolutionTillMaxPredatorDensities)
      testCase.isPassedInFunctionCalled = true;
      testCase.passedInSolNo = solno;
      testCase.passedInTF = tf;
      testCase.passedInGetFilename = getFilename;
      testCase.passedInGetFileDir = getFileDir;
      testCase.passedInExists = exists;
      testCase.passedInGetInitialDataToSolveTillSteady = ...
        getInitialDataToSolveTillSteady;
      testCase.passedInLoad = load;
      testCase.passedInSave = save;
      testCase.passedInGetParams = getParams;
      testCase.passedInSolver = solver;
      testCase.passedInGetFirstPointWithExtremeVarValues = ...
        getFirstPointWithExtremeVarValues;
      testCase.passedInGetLastRow = getLastRow;
      testCase.passedInGetPeriod = getPeriod;
      testCase.passedInGetResultsFilepath = getResultsFilepath;
      testCase.passedInGetSolutionTillMaxPredatorDensities = ...
        getSolutionTillMaxPredatorDensities;
    end
  end
  
  methods (Test)
    function testPassesProperParamsToPassedInFunction(testCase)
      solno = 1;
      tf = 50;
      testCase.isPassedInFunctionCalled = false;
      doSolveTillSteady(solno,tf,@testCase.fakeFcnToPassIn);
      testCase.assertTrue(testCase.isPassedInFunctionCalled,...
        'Переданная функция не вызвана');
      testCase.verifyEqual(testCase.passedInSolNo,solno,...
        'Передан неправильный номер решения');
      testCase.verifyEqual(testCase.passedInTF,tf,...
        'Передан неправильный момент конца интервала интегрирования по времени');
      testCase.verifyEqual(testCase.passedInGetFilename,@mfilename,...
        'Передана неправильная функция получения имени файла');
      testCase.verifyEqual(testCase.passedInGetFileDir,@getFileDir,...
        'Передана неправильная функция получения пути к папке, содержащей файл');
      testCase.verifyEqual(testCase.passedInExists,@exist,...
        'Передана неправильная функция проверки существования файла/переменной');
      testCase.verifyEqual(...
        testCase.passedInGetInitialDataToSolveTillSteady,...
        @getInitialDataToSolveTillSteady,...
        'Передана неправильная функция получения начальных данных для решения до установления');
      testCase.verifyEqual(testCase.passedInLoad,@load,...
        'Передана неправильная функция загрузки переменных из файла');
      testCase.verifyEqual(testCase.passedInSave,@save,...
        'Передана неправильная функция сохранения переменных в файл');
      testCase.verifyEqual(testCase.passedInGetParams,...
        @predatorPrey2x1Params,'Переданы неправильные параметры');
      testCase.verifyEqual(testCase.passedInSolver,@myode4,...
        'Передан неправильный решатель');
      testCase.verifyEqual(...
        testCase.passedInGetFirstPointWithExtremeVarValues,...
        @getFirstPointWithExtremeVarValues,...
        'Передана неправильная функция получения первой точки с экстремальными значениями переменных с переданными индексами');
      testCase.verifyEqual(testCase.passedInGetLastRow,@getLastRow,...
        'Передана неправильная функция получения последней строки матрицы');
      testCase.verifyEqual(testCase.passedInGetPeriod,@getPeriod,...
        'Передана неправильная функция нахождения периода');
      testCase.verifyEqual(testCase.passedInGetResultsFilepath,...
        @getResultsFilepath,...
        'Передана неправильная функция получения пути к файлу результатов');
      testCase.verifyEqual(...
        testCase.passedInGetSolutionTillMaxPredatorDensities,...
        @getSolutionTillMaxPredatorDensities,...
        'Передана неправильная функция получения решения до максимальных плотностей популяций хищников');
    end
  end
  
end

