classdef DoSolveAllTest < matlab.unittest.TestCase
  
  properties
    isPassedInFunctionCalled
    passedInPreyDiffusionCoeff
    passedInSecondPredatorDiffusionCoeff
    passedInFirstPredatorMortality
    passedInResourceDeviation
    passedInN
    passedInTSpan
    passedInSolver
    passedInNSol
    passedInFamilyName
    passedInCurrentDirName
    passedInExist
    passedInSolveOne
  end
  
  methods
    function fakeFcnToPassIn(testCase,preyDiffusionCoeff,...
        secondPredatorDiffusionCoeff,firstPredatorMortality,...
        resourceDeviation,N,tspan,solver,nsol,familyName,currentDirName,...
        exist,solveOne)
      testCase.isPassedInFunctionCalled = true;
      testCase.passedInPreyDiffusionCoeff = preyDiffusionCoeff;
      testCase.passedInSecondPredatorDiffusionCoeff = ...
        secondPredatorDiffusionCoeff;
      testCase.passedInFirstPredatorMortality = firstPredatorMortality;
      testCase.passedInResourceDeviation = resourceDeviation;
      testCase.passedInN = N;
      testCase.passedInTSpan = tspan;
      testCase.passedInSolver = solver;
      testCase.passedInNSol = nsol;
      testCase.passedInFamilyName = familyName;
      testCase.passedInCurrentDirName = currentDirName;
      testCase.passedInExist = exist;
      testCase.passedInSolveOne = solveOne;
    end
  end
  
  methods (Test)
    function testPassesParamsToPassedInFunction(testCase)
      testCase.isPassedInFunctionCalled = false;
      preyDiffusionCoeff = 0.2;
      secondPredatorDiffusionCoeff = 0.24;
      firstPredatorMortality = 1;
      resourceDeviation = 0.2;
      N = 24;
      tspan = 0:0.002:100;
      solver = @myode4;
      nsol = 10;
      familyName = 'family';
      doSolveAll(@testCase.fakeFcnToPassIn,preyDiffusionCoeff,...
        secondPredatorDiffusionCoeff,firstPredatorMortality,...
        resourceDeviation,N,tspan,solver,nsol,familyName);
      testCase.assertTrue(testCase.isPassedInFunctionCalled,...
        'Не вызвана переданная функция');
      testCase.verifyEqual(testCase.passedInPreyDiffusionCoeff,...
        preyDiffusionCoeff,...
        'Передан неправильный коэффициент диффузии жертвы');
      testCase.verifyEqual(...
        testCase.passedInSecondPredatorDiffusionCoeff,...
        secondPredatorDiffusionCoeff,...
        'Передан неправильный коэффициент диффузии второго хищника');
      testCase.verifyEqual(...
        testCase.passedInFirstPredatorMortality,...
        firstPredatorMortality,...
        'Передан неправильный коэффициент смертности первого хищника');
      testCase.verifyEqual(testCase.passedInResourceDeviation,...
        resourceDeviation,...
        'Передана неправильная амплитуда функции ресурса');
      testCase.verifyEqual(testCase.passedInN,N,...
        'Передано неправильное число точек сетки');
      testCase.verifyEqual(testCase.passedInTSpan,tspan,...
        'Передан неправильный интервал интегрирования по времени');
      testCase.verifyEqual(testCase.passedInSolver,solver,...
        'Передан неправильный решатель');
      testCase.verifyEqual(testCase.passedInNSol,nsol,...
        'Передано неправильное число решений семейства');
      testCase.verifyEqual(testCase.passedInFamilyName,familyName,...
        'Передано неправильное имя семейства');
      testCase.verifyEqual(testCase.passedInCurrentDirName,...
        @currentDirName,...
        'Передана неправильная функция получения имени текущей папки');
      testCase.verifyEqual(testCase.passedInExist,@exist,...
        'Передана неправильная функция проверки существования файла');
      testCase.verifyEqual(testCase.passedInSolveOne,@solveOne,...
        'Передана неправильная функция нахождения одного решения');
    end
  end
  
end

