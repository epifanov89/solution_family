classdef DoPlotPeriodVarianceWithSolutionNoTest < matlab.unittest.TestCase
  
  properties
    isPassedInFunctionCalled
    passedInFamilyNames    
    passedInLoadFamilySolutions
    passedInGetPeriod
    passedInAxes
    passedInHold
    passedInPlot
    passedInLabel
    passedInSet
    passedInXLabel
    passedInYLabel
  end
  
  methods
    function fakeFcnToPassIn(testCase,familyNames,loadFamilySolutions,...
        getPeriod,axes,hold,plot,label,set,xlabel,ylabel)
      testCase.isPassedInFunctionCalled = true;
      testCase.passedInFamilyNames = familyNames;
      testCase.passedInLoadFamilySolutions = loadFamilySolutions;
      testCase.passedInGetPeriod = getPeriod;
      testCase.passedInAxes = axes;
      testCase.passedInHold = hold;
      testCase.passedInPlot = plot;
      testCase.passedInLabel = label;
      testCase.passedInSet = set;
      testCase.passedInXLabel = xlabel;
      testCase.passedInYLabel = ylabel;
    end
  end
  
  methods (Test)
    function testPassesArgsToPassedInFunction(testCase)
      testCase.isPassedInFunctionCalled = false;
      familyNames = {'family1','family2'};
      doPlotPeriodVarianceWithSolutionNo(@testCase.fakeFcnToPassIn,...
        familyNames);
      testCase.assertTrue(testCase.isPassedInFunctionCalled,...
        'Переданная функция не вызвана');
      testCase.verifyEqual(testCase.passedInFamilyNames,familyNames,...
        'Переданы неправильные имена семейств');
      testCase.verifyEqual(testCase.passedInLoadFamilySolutions,...
        @loadFamilySolutions,...
        'Передана неправильная функция загрузки решений семейства');
      testCase.verifyEqual(testCase.passedInGetPeriod,@getPeriod,...
        'Передана неправильная функция нахождения периода решения');
      testCase.verifyEqual(testCase.passedInAxes,@axes,...
        'Передана неправильная функция создания осей');
      testCase.verifyEqual(testCase.passedInHold,@hold,...
        'Передана неправильная функция удержания рисунка');
      testCase.verifyEqual(testCase.passedInPlot,@plot,...
        'Передана неправильная функция построения графиков');
      testCase.verifyEqual(testCase.passedInLabel,@label,...
        'Передана неправильная функция создания подписей к линиям');
      testCase.verifyEqual(testCase.passedInSet,@set,...
        'Передана неправильная функция установки свойств графики');
      testCase.verifyEqual(testCase.passedInXLabel,@xlabel,...
        'Передана неправильная функция создания подписи оси абсцисс');
      testCase.verifyEqual(testCase.passedInYLabel,@ylabel,...
        'Передана неправильная функция создания подписи оси ординат');
    end
  end
  
end

