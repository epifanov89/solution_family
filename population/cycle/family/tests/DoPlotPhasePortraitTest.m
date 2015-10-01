classdef DoPlotPhasePortraitTest < matlab.unittest.TestCase
  
  properties
    isPassedInFunctionCalled
    passedInClose
    passedInCurrentDirName
    passedInLoad
    passedInSubplot
    passedInHold
    passedInPlot
    passedInLabel
    passedInXLabel
    passedInYLabel
    passedInGCA
    passedInSet
  end
  
  methods
    function fakeFcnToPassIn(testCase,close,currentDirName,load,subplot,...
        hold,plot,label,xlabel,ylabel,gca,set)
      testCase.isPassedInFunctionCalled = true;
      testCase.passedInClose = close;
      testCase.passedInCurrentDirName = currentDirName;
      testCase.passedInLoad = load;
      testCase.passedInSubplot = subplot;
      testCase.passedInHold = hold;
      testCase.passedInPlot = plot;
      testCase.passedInLabel = label;
      testCase.passedInXLabel = xlabel;
      testCase.passedInYLabel = ylabel;
      testCase.passedInGCA = gca;
      testCase.passedInSet = set;
    end
  end
  
  methods (Test)
    function testPassesParamsToPassedInFunction(testCase)
      testCase.isPassedInFunctionCalled = false;
      doPlotPhasePortrait(@testCase.fakeFcnToPassIn);
      testCase.assertTrue(testCase.isPassedInFunctionCalled,...
        'Переданная функция не вызвана');
      testCase.verifyEqual(testCase.passedInClose,@close,...
        'Передана неправильная функция закрытия окон рисунков');
      testCase.verifyEqual(testCase.passedInCurrentDirName,...
        @currentDirName,...
        'Передана неправильная функция получения имени текущей папки');
      testCase.verifyEqual(testCase.passedInLoad,@load,...
        'Передана неправильная функция загрузки переменных из файла');
      testCase.verifyEqual(testCase.passedInSubplot,@subplot,...
        'Передана неправильная функция создания области окна рисунка');
      testCase.verifyEqual(testCase.passedInHold,@hold,...
        'Передана неправильная функция удержания рисунка');
      testCase.verifyEqual(testCase.passedInPlot,@plot,...
        'Передана неправильная функция создания графиков');
      testCase.verifyEqual(testCase.passedInLabel,@label,...
        'Передана неправильная функция создания подписей графиков');
      testCase.verifyEqual(testCase.passedInXLabel,@xlabel,...
        'Передана неправильная функция создания подписи оси абсцисс');
      testCase.verifyEqual(testCase.passedInYLabel,@ylabel,...
        'Передана неправильная функция создания подписи оси ординат');
      testCase.verifyEqual(testCase.passedInGCA,@gca,...
        'Передана неправильная функция получения указателя текущих осей');
      testCase.verifyEqual(testCase.passedInSet,@set,...
        'Передана неправильная функция установки свойств графики');
    end
  end
  
end

