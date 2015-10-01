classdef DoPlotFamilyTest < matlab.unittest.TestCase
  
  properties
    familyName
    passedInFamilyName
    passedInGetMFilename
    passedInGetFileDirname
    passedInDir
    passedInLoadVars
    passedInGetLastRowWithExtremeElementValue
    passedInGetSolutionPartForTrajectoryPlot
    passedInPlot
    passedInHold
    passedInLabel
    passedInXLabel
    passedInYLabel
    passedInGCA
    passedInSet
  end
  
  methods
    function fakeFcnToPassIn(testCase,familyName,getMFilename,...
        getFileDirname,dir,loadVars,getLastRowWithExtremeElementValue,...
        getSolutionPartForTrajectoryPlot,plot,hold,label,...
        xlabel,ylabel,gca,set)
      testCase.passedInFamilyName = familyName;
      testCase.passedInGetMFilename = getMFilename;
      testCase.passedInGetFileDirname = getFileDirname;
      testCase.passedInDir = dir;
      testCase.passedInLoadVars = loadVars;
      testCase.passedInGetLastRowWithExtremeElementValue = ...
        getLastRowWithExtremeElementValue;
      testCase.passedInGetSolutionPartForTrajectoryPlot = ...
        getSolutionPartForTrajectoryPlot;
      testCase.passedInPlot = plot;
      testCase.passedInHold = hold;
      testCase.passedInLabel = label;
      testCase.passedInXLabel = xlabel;
      testCase.passedInYLabel = ylabel;
      testCase.passedInGCA = gca;
      testCase.passedInSet = set;
    end
    
    function act(testCase)
      doPlotFamily(@testCase.fakeFcnToPassIn,testCase.familyName);
    end
  end
  
  methods (Test)
    function testPassesFamilyNameToPassedInFunction(testCase)
      testCase.familyName = 'family';
      testCase.act();
      testCase.verifyEqual(testCase.passedInFamilyName,...
        testCase.familyName,'Передано неправильное имя семейства');
    end
    
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
    
    function testPassesGCAToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(...
        testCase.passedInGCA,@gca,...
        'Передана неправильная функция получения указателя графического контекста');
    end
    
    function testPassesSetToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(...
        testCase.passedInSet,@set,...
        'Передана неправильная функция установки свойств графического контекста');
    end
  end
  
end

