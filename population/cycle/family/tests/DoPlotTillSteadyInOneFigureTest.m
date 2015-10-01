classdef DoPlotTillSteadyInOneFigureTest < ...
    IsPassedInFunctionCalledTestHelper
  
  properties
    resultsFilenamePassedInToPassedInFunction
    tstartPassedInToPassedInFunction
    tspanPassedInToPassedInFunction
    currentDirNamePassedInToPassedInFunction
    loadPassedInToPassedInFunction
    plotPassedInToPassedInFunction
    holdPassedInToPassedInFunction
    labelPassedInToPassedInFunction
    xlabelPassedInToPassedInFunction    
    gcaPassedInToPassedInFunction
    setPassedInToPassedInFunction
  end
    
  methods (TestMethodSetup)
    function setup(testCase)
      setup@IsPassedInFunctionCalledTestHelper(testCase);
    end
  end
  
  methods (Access = protected)
    function fakeFcnToPassIn(testCase,resultsFilename,tstart,tspan,...
        currentDirName,load,plot,hold,label,xlabel,gca,set)
      fakeFcnToPassIn@IsPassedInFunctionCalledTestHelper(testCase);
      testCase.resultsFilenamePassedInToPassedInFunction = resultsFilename;
      testCase.tstartPassedInToPassedInFunction = tstart;
      testCase.tspanPassedInToPassedInFunction = tspan;
      testCase.currentDirNamePassedInToPassedInFunction = currentDirName;
      testCase.loadPassedInToPassedInFunction = load;
      testCase.plotPassedInToPassedInFunction = plot;
      testCase.holdPassedInToPassedInFunction = hold;
      testCase.labelPassedInToPassedInFunction = label;
      testCase.xlabelPassedInToPassedInFunction = xlabel;      
      testCase.gcaPassedInToPassedInFunction = gca;
      testCase.setPassedInToPassedInFunction = set;
    end
  end
  
  methods (Test)
    function testPassesRightParamsToPassedInFunction(testCase)
      resultsFilename = 0;
      tstart = 1;
      tspan = 2;
      doPlotTillSteadyInOneFigure(@testCase.fakeFcnToPassIn,...
        resultsFilename,tstart,tspan);
      testCase.assertPassedInFunctionCalled();
      testCase.verifyEqual(...
        testCase.resultsFilenamePassedInToPassedInFunction,...
        resultsFilename,'Передано неправильное имя файла результатов');
      testCase.verifyEqual(testCase.tstartPassedInToPassedInFunction,...
        tstart,'Передано неправильное время начала вывода графика');
      testCase.verifyEqual(testCase.tspanPassedInToPassedInFunction,...
        tspan,'Передан неправильный промежуток вывода графика');
      testCase.verifyEqual(...
        testCase.currentDirNamePassedInToPassedInFunction,...
        @currentDirName,...
        'Передана неправильная функция получения имени текущей папки');
      testCase.verifyEqual(...
        testCase.loadPassedInToPassedInFunction,@load,...
        'Передана неправильная функция загрузки переменных из файла');
      testCase.verifyEqual(...
        testCase.plotPassedInToPassedInFunction,@plot,...
        'Передана неправильная функция построения графиков');
      testCase.verifyEqual(...
        testCase.holdPassedInToPassedInFunction,@hold,...
        'Передана неправильная функция удержания рисунка');
      testCase.verifyEqual(...
        testCase.labelPassedInToPassedInFunction,@label,...
        'Передана неправильная функция создания метки линии');
      testCase.verifyEqual(...
        testCase.xlabelPassedInToPassedInFunction,@xlabel,...
        'Передана неправильная функция создания метки оси абсцисс');      
      testCase.verifyEqual(...
        testCase.gcaPassedInToPassedInFunction,@gca,...
        'Передана неправильная функция получения текущих осей');
      testCase.verifyEqual(...
        testCase.setPassedInToPassedInFunction,@set,...
        'Передана неправильная функция установки свойств графики');
    end
  end
  
end

