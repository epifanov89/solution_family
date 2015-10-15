classdef DoPlotCombinedFamSolPhaseTrajectoriesTest < ...
    IsPassedInFunctionCalledTestHelper
  
  properties
    passedInCurrentDirName
    passedInLoad
    passedInGetLastRowWithExtremeElementValue
    passedInPlot3
    passedInHold
    passedInLabel
    passedInXLabel
    passedInYLabel
    passedInZLabel
    passedInGCA
    passedInSet
  end
  
  methods (TestMethodSetup)
    function setup(testCase)
      setup@IsPassedInFunctionCalledTestHelper(testCase);
    end
  end
  
  methods (Access = protected)
    function fakeFcnToPassIn(testCase,currentDirName,load,...
        getLastRowWithExtremeElementValue,plot3,hold,label,xlabel,...
        ylabel,zlabel,gca,set)
      fakeFcnToPassIn@IsPassedInFunctionCalledTestHelper(testCase);
      testCase.passedInCurrentDirName = currentDirName;
      testCase.passedInLoad = load;
      testCase.passedInGetLastRowWithExtremeElementValue = ...
        getLastRowWithExtremeElementValue;
      testCase.passedInPlot3 = plot3;
      testCase.passedInHold = hold;
      testCase.passedInLabel = label;
      testCase.passedInXLabel = xlabel;
      testCase.passedInYLabel = ylabel;
      testCase.passedInZLabel = zlabel;
      testCase.passedInGCA = gca;
      testCase.passedInSet = set;
    end
  end
  
  methods (Test)
    function testPassesRightParamsToPassedInFunction(testCase)
      doPlotCombinedFamSolPhaseTrajectories(@testCase.fakeFcnToPassIn);
      testCase.assertPassedInFunctionCalled();
      testCase.verifyEqual(testCase.passedInCurrentDirName,...
        @currentDirName,...
        'Передана неправильная функция получения имени текущей папки');
      testCase.verifyEqual(testCase.passedInLoad,@load,...
        'Передана неправильная функция загрузки переменных');
      testCase.verifyEqual(...
        testCase.passedInGetLastRowWithExtremeElementValue,...
        @getLastRowWithExtremeElementValue,...
        'Передана неправильная функция получения последней строки матрицы с экстремальным значением элемента в столбце с переданным индексом');
      testCase.verifyEqual(testCase.passedInPlot3,@plot3,...
        'Передана неправильная функция построения трехмерных графиков');
      testCase.verifyEqual(testCase.passedInHold,@hold,...
        'Передана неправильная функция удержания рисунка для построения на одном рисунке нескольких графиков');
      testCase.verifyEqual(testCase.passedInLabel,@label,...
        'Передана неправильная функция создания подписей к графикам');
      testCase.verifyEqual(testCase.passedInXLabel,@xlabel,...
        'Передана неправильная функция создания подписи оси Ox');
      testCase.verifyEqual(testCase.passedInYLabel,@ylabel,...
        'Передана неправильная функция создания подписи оси Oy');
      testCase.verifyEqual(testCase.passedInZLabel,@zlabel,...
        'Передана неправильная функция создания подписи оси Oz');
      testCase.verifyEqual(testCase.passedInGCA,@gca,...
        'Передана неправильная функция получения текущих осей');
      testCase.verifyEqual(testCase.passedInSet,@set,...
        'Передана неправильная функция установки свойств графики');
    end
  end
  
end

