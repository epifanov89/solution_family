classdef DoPlotFamilyTest < matlab.unittest.TestCase
  
  properties
    passedInGetMFilename
    passedInGetFileDirname
    passedInDir
    passedInLoadVars
    passedInGetLastRowWithExtremeElementValue
    passedInGetSolutionPartForTrajectoryPlot
    passedInSubplot
    passedInPlot
    passedInHold
    passedInLabel
    passedInXLabel
    passedInYLabel
    passedInSet
  end
  
  methods
    function fakeFcnToPassIn(testCase,getMFilename,...
        getFileDirname,dir,loadVars,getLastRowWithExtremeElementValue,...
        getSolutionPartForTrajectoryPlot,subplot,plot,hold,label,...
        xlabel,ylabel,set)
      testCase.passedInGetMFilename = getMFilename;
      testCase.passedInGetFileDirname = getFileDirname;
      testCase.passedInDir = dir;
      testCase.passedInLoadVars = loadVars;
      testCase.passedInGetLastRowWithExtremeElementValue = ...
        getLastRowWithExtremeElementValue;
      testCase.passedInGetSolutionPartForTrajectoryPlot = ...
        getSolutionPartForTrajectoryPlot;
      testCase.passedInSubplot = subplot;
      testCase.passedInPlot = plot;
      testCase.passedInHold = hold;
      testCase.passedInLabel = label;
      testCase.passedInXLabel = xlabel;
      testCase.passedInYLabel = ylabel;
      testCase.passedInSet = set;
    end
    
    function act(testCase)
      doPlotFamily(@testCase.fakeFcnToPassIn);
    end
  end
  
  methods (Test)
    function testPassesMFilenameToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(testCase.passedInGetMFilename,@mfilename,...
        'Передана неправильная функция получения имени файла');
    end
    
    function testPassesGetFileDirToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(testCase.passedInGetFileDirname,...
        @getFileDirname,...
        'Передана неправильная функция получения имени папки, содержащей файл');
    end
        
    function testPassesDirToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(testCase.passedInDir,@dir,...
        'Передана неправильная функция получения содержимого папки');
    end
    
    function testPassesLoadToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(testCase.passedInLoadVars,...
        @load,...
        'Передана неправильная фунция загрузки переменных из файла');
    end
    
    function testPassesGetLastRowWithExtremeElementValueToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(...
        testCase.passedInGetLastRowWithExtremeElementValue,...
        @getLastRowWithExtremeElementValue,...
        'Передана неправильная функция получения последней строки матрицы с экстремальным значением элемента в столбце с переданным индексом');
    end
    
    function testPassesGetSolutionForTrajectoryPlotToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(...
        testCase.passedInGetSolutionPartForTrajectoryPlot,...
        @getSolutionTillMinFirstPredatorDensity,...
        'Передана неправильная функция получения части решения для вывода его траектории');
    end
       
    function testPassesSubplotToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(...
        testCase.passedInSubplot,@subplot,...
        'Передана неправильная функция создания области рисунка');
    end 
    
    function testPassesPlotToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(...
        testCase.passedInPlot,@plot,...
        'Передана неправильная функция построения графика');
    end    
    
    function testPassesHoldToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(...
        testCase.passedInHold,@hold,...
        'Передана неправильная функция удержания графического контекста');
    end
    
    function testPassesLabelToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(...
        testCase.passedInLabel,@label,...
        'Передана неправильная функция создания подписей к линиям');
    end
    
    function testPassesXLabelToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(...
        testCase.passedInXLabel,@xlabel,...
        'Передана неправильная функция создания подписи оси абсцисс');
    end
    
    function testPassesYLabelToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(...
        testCase.passedInYLabel,@ylabel,...
        'Передана неправильная функция создания подписи оси ординат');
    end
    
    function testPassesSetToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(...
        testCase.passedInSet,@set,...
        'Передана неправильная функция установки свойств графического контекста');
    end
  end
  
end

