classdef DoSolveAndSaveResultsTest < matlab.unittest.TestCase
  
  properties
    isPassedInFunctionCalled
    passedInSolNo
    passedInTF
    passedInGetFilename
    passedInGetFileDir
    passedInGetResultsFilepath
    passedInExists
    passedInGetZeroFirstPredatorInitialData
    passedInGetCombinedPredatorDensitiesInitialData
    passedInLoad
    passedInSave
    passedInGetParams
    passedInSolver
    passedInGetLastRow
    passedInGetPeriod
  end
  
  methods
    function fakeFcnToPassIn(testCase,solno,tf,getFilename,...
        getFileDir,getResultsFilepath,exists,...
        getZeroFirstPredatorInitialData,...
        getCombinedPredatorDensitiesInitialData,load,save,getParams,...
        solver,getLastRow,getPeriod)
      testCase.isPassedInFunctionCalled = true;
      testCase.passedInSolNo = solno;
      testCase.passedInTF = tf;
      testCase.passedInGetFilename = getFilename;
      testCase.passedInGetFileDir = getFileDir;
      testCase.passedInGetResultsFilepath = ...
        getResultsFilepath;
      testCase.passedInExists = exists;
      testCase.passedInGetZeroFirstPredatorInitialData = ...
        getZeroFirstPredatorInitialData;
      testCase.passedInGetCombinedPredatorDensitiesInitialData = ...
        getCombinedPredatorDensitiesInitialData;
      testCase.passedInLoad = load;
      testCase.passedInSave = save;
      testCase.passedInGetParams = getParams;
      testCase.passedInSolver = solver;
      testCase.passedInGetLastRow = getLastRow;
      testCase.passedInGetPeriod = getPeriod;
    end
  end
  
  methods (Test)
    function testPassesProperParamsToPassedInFunction(testCase)
      solno = 1;
      tf = 50;
      testCase.isPassedInFunctionCalled = false;
      doSolveAndSaveResults(solno,tf,@testCase.fakeFcnToPassIn);
      testCase.assertTrue(testCase.isPassedInFunctionCalled,...
        'Функция doSolveAndSaveResultsCore() не вызвана');
      testCase.verifyEqual(testCase.passedInSolNo,solno,...
        'Передан неправильный номер решения');
      testCase.verifyEqual(testCase.passedInTF,tf,...
        'Передан неправильный конечный момент интервала интегрирования по времени');
      testCase.verifyEqual(testCase.passedInGetFilename,@mfilename,...
        'Передана неправильная функция получения имени файла');
      testCase.verifyEqual(testCase.passedInGetFileDir,@getFileDir,...
        'Передана неправильная функция получения пути к папке, содержащей файл');
      testCase.verifyEqual(testCase.passedInGetResultsFilepath,...
        @getResultsFilepath,...
        'Передана неправильная функция получения пути к файлу с промежуточными результатами решения');
      testCase.verifyEqual(testCase.passedInExists,@exist,...
        'Передана неправильная функция проверки существования файла/переменной');
      testCase.verifyEqual(...
        testCase.passedInGetZeroFirstPredatorInitialData,...
        @getZeroFirstPredatorInitialData,...
        'Передана неправильная функция получения начальных данных с нулевой плотностью первой популяции хищников');
      testCase.verifyEqual(...
        testCase.passedInGetCombinedPredatorDensitiesInitialData,...
        @getCombinedPredatorDensitiesInitialData,...
        'Передана неправильная функция получения начальных данных с линейной комбинацией плотностей популяций хищников');
      testCase.verifyEqual(testCase.passedInLoad,@load,...
        'Передана неправильная функция загрузки переменных из файла');
      testCase.verifyEqual(testCase.passedInSave,@save,...
        'Передана неправильная функция сохранения переменных в файл');
      testCase.verifyEqual(testCase.passedInGetParams,...
        @predatorPrey2x1Params,'Переданы неправильные параметры');
      testCase.verifyEqual(testCase.passedInSolver,@myode4,...
        'Передан неправильный решатель');
      testCase.verifyEqual(testCase.passedInGetLastRow,@getLastRow,...
        'Передана неправильная функция получения последней строки матрицы');
      testCase.verifyEqual(testCase.passedInGetPeriod,@getPeriod,...
        'Передана неправильная функция нахождения периода');
    end
  end
  
end

