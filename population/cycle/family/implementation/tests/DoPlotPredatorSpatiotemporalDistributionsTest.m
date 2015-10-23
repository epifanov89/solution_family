classdef DoPlotPredatorSpatiotemporalDistributionsTest < matlab.unittest.TestCase
  
  properties
    isPassedInFunctionCalled
    passedInCurrentDirName
    passedInLoad
    passedInGetLastRowWithExtremeElementValue
    passedInSubplot
    passedInPlot3D
    passedInSet
    passedInAxis
    passedInXLabel
    passedInYLabel
    passedInZLabel
  end
  
  methods
    function fakeFcnToPassIn(testCase,currentDirName,load,...
        getLastRowWithExtremeElementValue,subplot,plot3D,set,axis,...
        xlabel,ylabel,zlabel)
      testCase.isPassedInFunctionCalled = true;
      testCase.passedInCurrentDirName = currentDirName;
      testCase.passedInLoad = load;
      testCase.passedInGetLastRowWithExtremeElementValue = ...
        getLastRowWithExtremeElementValue;
      testCase.passedInSubplot = subplot;
      testCase.passedInPlot3D = plot3D;
      testCase.passedInSet = set;
      testCase.passedInAxis = axis;
      testCase.passedInXLabel = xlabel;
      testCase.passedInYLabel = ylabel;
      testCase.passedInZLabel = zlabel;
    end
    
    function act(testCase)
      doPlotPredatorSpatiotemporalDistributions(@testCase.fakeFcnToPassIn);
    end
  end
  
  methods (Test)
    function testPassesParamsToPassedInFunction(testCase)
      testCase.isPassedInFunctionCalled = false;
      testCase.act();
      testCase.assertTrue(testCase.isPassedInFunctionCalled,...
        'Не вызвана переданная функция');
      testCase.verifyEqual(testCase.passedInCurrentDirName,...
        @currentDirName,...
        'Передана неправильная функция получения имени текущей папки');
      testCase.verifyEqual(testCase.passedInLoad,...
        @load,...
        'Передана неправильная функция загрузки переменных из файла');
      testCase.verifyEqual(...
        testCase.passedInGetLastRowWithExtremeElementValue,...
        @getLastRowWithExtremeElementValue,...
        'Передана неправильная функция получения последней строки матрицы с экстремальным значением элемента в столбце с переданным индексом');      
      testCase.verifyEqual(testCase.passedInSubplot,@subplot,...
        'Передана неправильная функция создания области окна рисунка');
      testCase.verifyEqual(testCase.passedInPlot3D,@mesh,...
        'Передана неправильная функция изображения 3D-графика');
      testCase.verifyEqual(testCase.passedInSet,@set,...
        'Передана неправильная функция установки свойств графического контекста');
      testCase.verifyEqual(testCase.passedInAxis,@axis,...
        'Передана неправильная функция установки отображаемых размеров');
      testCase.verifyEqual(testCase.passedInXLabel,@xlabel,...
        'Передана неправильная функция создания подписи оси Ox');
      testCase.verifyEqual(testCase.passedInYLabel,@ylabel,...
        'Передана неправильная функция создания подписи оси Oy');
      testCase.verifyEqual(testCase.passedInZLabel,@zlabel,...
        'Передана неправильная функция создания подписи оси Oz');
    end
  end
  
end

