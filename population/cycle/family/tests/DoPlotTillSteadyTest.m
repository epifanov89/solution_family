classdef DoPlotTillSteadyTest < matlab.unittest.TestCase
  
  properties
    resultsFilename
    tstart
    tspan
    XAxisGap
    passedInResultsFilename
    passedInTStart
    passedInTSpan
    passedInXAxisGap
    passedInCurrentDirName
    passedInLoad
    passedInPlot
    passedInXLabel
    passedInYLabel
    passedInFigure
    passedInGCA
    passedInSet
  end
  
  methods
    function fakeFcnToPassIn(testCase,resultsFilename,tstart,tspan,...
        XAxisGap,currentDirName,load,plot,xlabel,ylabel,figure,gca,set)
      testCase.passedInResultsFilename = resultsFilename;
      testCase.passedInTStart = tstart;
      testCase.passedInTSpan = tspan;
      testCase.passedInXAxisGap = XAxisGap;
      testCase.passedInCurrentDirName = currentDirName;
      testCase.passedInLoad = load;
      testCase.passedInPlot = plot;
      testCase.passedInXLabel = xlabel;
      testCase.passedInYLabel = ylabel;
      testCase.passedInFigure = figure;
      testCase.passedInGCA = gca;
      testCase.passedInSet = set;
    end
    
    function act(testCase)
      doPlotTillSteady(@testCase.fakeFcnToPassIn,...
        testCase.resultsFilename,testCase.tstart,testCase.tspan,...
        testCase.XAxisGap);
    end
  end
  
  methods (Test)
    function testPassesResultsFilenameToPassedInFunction(testCase)
      testCase.resultsFilename = 'filename';
      testCase.act();
      testCase.verifyEqual(testCase.passedInResultsFilename,...
        testCase.resultsFilename,...
        'Передано неправильное имя файла результатов');
    end
    
    function testPassesTStartToPassedInFunction(testCase)
      testCase.tstart = 200;
      testCase.act();
      testCase.verifyEqual(testCase.passedInTStart,...
        testCase.tstart,...
        'Передано неправильное начальное время вывода установившейся части графика');
    end
    
    function testPassesTSpanToPassedInFunction(testCase)
      testCase.tspan = 100;
      testCase.act();
      testCase.verifyEqual(testCase.passedInTSpan,...
        testCase.tspan,...
        'Передана неправильная ширина установившейся части графика');
    end
    
    function testPassesXAxisGapToPassedInFunction(testCase)
      testCase.XAxisGap = 50;
      testCase.act();
      testCase.verifyEqual(testCase.passedInXAxisGap,...
        testCase.XAxisGap,...
        'Передана неправильная ширина промежутка между частями графика');
    end
    
    function testPassesMFilenameToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(testCase.passedInCurrentDirName,...
        @currentDirName,...
        'Передана неправильная функция получения имени текущей папки');
    end
    
    function testPassesLoadToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(testCase.passedInLoad,@load,...
        'Передана неправильная функция загрузки переменных из файла');
    end
    
    function testPassesPlotToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(testCase.passedInPlot,@plot,...
        'Передана неправильная функция построения графика');
    end
    
    function testPassesXLabelToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(testCase.passedInXLabel,@xlabel,...
        'Передана неправильная функция создания подписи оси абсцисс');
    end
    
    function testPassesYLabelToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(testCase.passedInYLabel,@ylabel,...
        'Передана неправильная функция создания подписи оси ординат');
    end
    
    function testPassesFigureToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(testCase.passedInFigure,@figure,...
        'Передана неправильная функция создания нового окна');
    end
    
    function testPassesGCAToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(testCase.passedInGCA,@gca,...
        'Передана неправильная функция получения указателя графического контекста');
    end
    
    function testPassesSetToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(testCase.passedInSet,@set,...
        'Передана неправильная функция установки свойств графического контекста');
    end
  end
  
end

