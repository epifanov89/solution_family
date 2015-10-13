classdef DoPlotFunCoreTest < PlotTestHelperBase
  
  properties
    fun
    xlabel
    ylabel
    xtick
    ytick
    fontSize
    isFPlotCalled
    funPassedInToFPlot
    limitsPassedInToFPlot  
    strPassedInToXLabel
    fontSizePassedInToXLabel
    strPassedInToYLabel
    fontSizePassedInToYLabel
    isSetCalled
    setProperties
  end
  
  methods (TestMethodSetup)
    function setup(testCase)
      testCase.setProperties = struct;
    end
  end
  
  methods     
    function h = fakeAxes(~)
      h = 1;
    end
    
    function fakeFPlot(testCase,~,fun,limits,~)
      testCase.isFPlotCalled = true;
      testCase.funPassedInToFPlot = fun;
      testCase.limitsPassedInToFPlot = limits;
    end
  end
    
  methods (Access = protected)
    function fakeXLabel(testCase,~,str,varargin) 
      testCase.strPassedInToXLabel = str;
      
      keyIndices = find(cellfun(@(var) strcmp(var,'FontSize'),varargin));
      if ~isempty(keyIndices)
        keyIndex = keyIndices(1);
        testCase.fontSizePassedInToXLabel = varargin{keyIndex+1};     
      end
    end
    
    function fakeYLabel(testCase,~,str,varargin)
      testCase.strPassedInToYLabel = str;
      
      keyIndices = find(cellfun(@(var) strcmp(var,'FontSize'),varargin));
      if ~isempty(keyIndices)
        keyIndex = keyIndices(1);
        testCase.fontSizePassedInToYLabel = varargin{keyIndex+1};     
      end
    end
    
    function fakeSet(testCase,~,varargin)
      varIndex = 1;
      nvarargin = length(varargin);
      while varIndex < nvarargin
        key = varargin{varIndex};        
        testCase.setProperties.(key) = varargin{varIndex+1};
        varIndex = varIndex+2;
      end
    end
  end
  
  methods (Access = protected)
    function act(testCase)
      doPlotFunCore(@testCase.fakeClose,@testCase.fakeAxes,@testCase.fakeFPlot,...
        @testCase.fakeXLabel,@testCase.fakeYLabel,@testCase.fakeSet,...
        testCase.fun,testCase.xlabel,testCase.ylabel,...
        testCase.fontSize,'XTick',testCase.xtick,'YTick',testCase.ytick);
    end
  end
  
  methods (Test)    
    function testClosesAll(testCase)
      testClosesAll@PlotTestHelperBase(testCase);
    end
    
    function testPlotsFun(testCase)
      testCase.isFPlotCalled = false;
      testCase.fun = @() {};
      testCase.act();
      testCase.assertTrue(testCase.isFPlotCalled,...
        'Не построен график переданной функции');
      testCase.assertEqual(testCase.funPassedInToFPlot,...
        testCase.fun,'Не построен график переданной функции');
      testCase.verifyEqual(testCase.limitsPassedInToFPlot,...
        [0 1],'Не построен график переданной функции');
    end       
    
    function testLabelsXAxis(testCase)
      testCase.xlabel = 'x';
      testCase.act();
      testCase.verifyEqual(testCase.strPassedInToXLabel,testCase.xlabel,...
        'Выведена неправильная метка оси абсцисс');
    end
    
    function testLabelsYAxis(testCase)
      testCase.ylabel = 'y';
      testCase.act();
      testCase.verifyEqual(testCase.strPassedInToYLabel,testCase.ylabel,...
        'Выведена неправильная метка оси ординат');
    end
    
    function testOutputsXTicksIfTheyArePassedIn(testCase)
      testCase.xtick = [0 0.5 1];
      testCase.act();
      testCase.verifyEqual(testCase.setProperties.XTick,testCase.xtick,...
        'Выведены неправильные отметки на оси абсцисс');
    end
    
    function testOutputsYTicksIfTheyArePassedIn(testCase)
      testCase.ytick = [0.8 1 1.2];
      testCase.act();
      testCase.verifyEqual(testCase.setProperties.YTick,testCase.ytick,...
        'Выведены неправильные отметки на оси ординат');
    end
    
    function testPassesFontSizeToSet(testCase)
      testCase.fontSize = 24;
      testCase.act();
      testCase.verifyEqual(testCase.setProperties.FontSize,...
        testCase.fontSize,...
        'Размер шрифта не передан в функцию установки свойств графики');
    end
    
    function testLabelsXAxisWithPassedInFontSize(testCase)
      testCase.fontSize = 24;
      testCase.act();
      testCase.verifyEqual(testCase.fontSizePassedInToXLabel,...
        testCase.fontSize,...
        'Подпись оси абсцисс выведена шрифтом неправильного размера');
    end
    
    function testLabelsYAxisWithPassedInFontSize(testCase)
      testCase.fontSize = 24;
      testCase.act();
      testCase.verifyEqual(testCase.fontSizePassedInToYLabel,...
        testCase.fontSize,...
        'Подпись оси ординат выведена шрифтом неправильного размера');
    end
  end
  
end

