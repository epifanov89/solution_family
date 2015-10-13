classdef DoSolveAndFindPoincareMapTest < matlab.unittest.TestCase
  
  properties
    passedInSolutionResultsFilename
    passedInPreyDiffusionCoeff
    passedInSecondPredatorDiffusionCoeff
    passedInResourceDeviation
    passedInN
    passedInTF
    passedInGetInitialData
    passedInCurrentDirName
    passedInExists    
    passedInLoad
    passedInMakeDir
    passedInSave
    passedInGetParams
    passedInSolver
  end
  
  methods
    function fakeFcnToPassIn(testCase,solutionResultsFilename,...
        preyDiffusionCoeff,secondPredatorDiffusionCoeff,...
        resourceDeviation,N,tf,getInitialData,currentDirName,exists,...
        load,makeDir,save,getParams,solver)
      testCase.passedInSolutionResultsFilename = solutionResultsFilename;
      testCase.passedInPreyDiffusionCoeff = preyDiffusionCoeff;
      testCase.passedInSecondPredatorDiffusionCoeff = ...
        secondPredatorDiffusionCoeff;      
      testCase.passedInResourceDeviation = resourceDeviation;
      testCase.passedInN = N;
      testCase.passedInTF = tf;
      testCase.passedInGetInitialData = getInitialData;
      testCase.passedInCurrentDirName = currentDirName;
      testCase.passedInExists = exists;      
      testCase.passedInLoad = load;
      testCase.passedInMakeDir = makeDir;
      testCase.passedInSave = save;
      testCase.passedInGetParams = getParams;
      testCase.passedInSolver = solver;
    end
  end
  
  methods (Test)
    function testPassesProperParamsToPassedInFunction(testCase)
      solutionResultsFilename = 'solution_results_filename';
      preyDiffusionCoeff = 0.2;
      secondPredatorDiffusionCoeff = 0.24;
      resourceDeviation = 0.2;
      N = 24;
      tf = 50;
      getInitialData = @() {};
      doSolveAndFindPoincareMap(@testCase.fakeFcnToPassIn,...
        solutionResultsFilename,preyDiffusionCoeff,...
        secondPredatorDiffusionCoeff,resourceDeviation,N,tf,...
        getInitialData);
      testCase.verifyEqual(testCase.passedInSolutionResultsFilename,...
        solutionResultsFilename,...
        'Передано неправильное имя файла результатов решения');
      testCase.verifyEqual(testCase.passedInPreyDiffusionCoeff,...
        preyDiffusionCoeff,...
        'Передано неправильное значение коэффициента диффузии жертвы');
      testCase.verifyEqual(...
        testCase.passedInSecondPredatorDiffusionCoeff,...
        secondPredatorDiffusionCoeff,...
        'Передано неправильное значение коэффициента диффузии второго хищника');
      testCase.verifyEqual(testCase.passedInResourceDeviation,...
        resourceDeviation,...
        'Передана неправильная амплитуда функции ресурса');
      testCase.verifyEqual(testCase.passedInN,N,...
        'Передано неправильное число точек сетки');
      testCase.verifyEqual(testCase.passedInTF,tf,...
        'Передан неправильный конечный момент интервала интегрирования по времени');
      testCase.verifyEqual(...
        testCase.passedInGetInitialData,...
        getInitialData,...
        'Передана неправильная функция получения начальных данных для решения до установления');
      testCase.verifyEqual(testCase.passedInCurrentDirName,@currentDirName,...
        'Передана неправильная функция получения имени текущей папки');
      testCase.verifyEqual(testCase.passedInExists,@exist,...
        'Передана неправильная функция проверки существования файла/переменной');      
      testCase.verifyEqual(testCase.passedInLoad,@load,...
        'Передана неправильная функция загрузки переменных из файла');
      testCase.verifyEqual(testCase.passedInMakeDir,@mkdir,...
        'Передана неправильная функция создания папки');
      testCase.verifyEqual(testCase.passedInSave,@saveStruct,...
        'Передана неправильная функция сохранения переменных в файл');
      testCase.verifyEqual(testCase.passedInGetParams,...
        @predatorPrey2x1Params,'Переданы неправильные параметры');
      testCase.verifyEqual(testCase.passedInSolver,@myode4,...
        'Передан неправильный решатель');
    end
  end
  
end

