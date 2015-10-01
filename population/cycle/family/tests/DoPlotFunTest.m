classdef DoPlotFunTest < matlab.unittest.TestCase
  
  properties
    isPassedInFunctionCalled
    closePassedInToPassedInFunction
    axesPassedInToPassedInFunction
    fplotPassedInToPassedInFunction
    xlabelPassedInToPassedInFunction
    ylabelPassedInToPassedInFunction
    setPassedInToPassedInFunction
    funPassedInToPassedInFunction
    xlabelStrPassedInToPassedInFunction
    ylabelStrPassedInToPassedInFunction
    fontSizePassedInToPassedInFunction
    vararginPassedInToPassedInFunction
  end
  
  methods
    function fakeFcnToPassIn(testCase,close,axes,fplot,xlabel,ylabel,set,fun,...
        xlabelStr,ylabelStr,fontSize,varargin)
      testCase.isPassedInFunctionCalled = true;
      testCase.closePassedInToPassedInFunction = close;
      testCase.axesPassedInToPassedInFunction = axes;
      testCase.fplotPassedInToPassedInFunction = fplot;
      testCase.xlabelPassedInToPassedInFunction = xlabel;
      testCase.ylabelPassedInToPassedInFunction = ylabel;
      testCase.setPassedInToPassedInFunction = set;
      testCase.funPassedInToPassedInFunction = fun;
      testCase.xlabelStrPassedInToPassedInFunction = xlabelStr;
      testCase.ylabelStrPassedInToPassedInFunction = ylabelStr;
      testCase.fontSizePassedInToPassedInFunction = fontSize;
      testCase.vararginPassedInToPassedInFunction = varargin;   
    end
  end
  
  methods (Test)
    function testPassesParamsToPassedInFunctionWhenXTickAndYTickArePassed(testCase)
      testCase.isPassedInFunctionCalled = false;
      fun = @() {};
      xlabelStr = 'x';
      ylabelStr = 'y';
      xtick = [0 0.5 1];
      ytick = [0.8 1 1.2];
      fontSize = 24;
      doPlotFun(@testCase.fakeFcnToPassIn,fun,xlabelStr,ylabelStr,...
        fontSize,xtick,ytick);
      testCase.assertTrue(testCase.isPassedInFunctionCalled,...
        'Переданная функция не вызвана');
      testCase.verifyEqual(testCase.closePassedInToPassedInFunction,...
        @close,'Передана неправильная функция закрывания окон рисунков');
      testCase.verifyEqual(testCase.axesPassedInToPassedInFunction,...
        @axes,'Передана неправильная функция создания осей');
      testCase.verifyEqual(testCase.fplotPassedInToPassedInFunction,...
        @fplot,'Передана неправильная функция построения графика');
      testCase.verifyEqual(testCase.xlabelPassedInToPassedInFunction,...
        @xlabel,...
        'Передана неправильная функция создания подписи оси абсцисс');
      testCase.verifyEqual(testCase.ylabelPassedInToPassedInFunction,...
        @ylabel,...
        'Передана неправильная функция создания подписи оси ординат');
      testCase.verifyEqual(testCase.setPassedInToPassedInFunction,...
        @set,'Передана неправильная функция установки свойств графики');
      testCase.verifyEqual(testCase.funPassedInToPassedInFunction,fun,...
        'Передана неправильная функция, график которой требуется построить');    
      testCase.verifyEqual(testCase.xlabelStrPassedInToPassedInFunction,...
        xlabelStr,...
        'Передана неправильная подпись оси абсцисс'); 
      testCase.verifyEqual(testCase.ylabelStrPassedInToPassedInFunction,...
        ylabelStr,...
        'Передана неправильная подпись оси ординат'); 
      testCase.verifyEqual(testCase.fontSizePassedInToPassedInFunction,...
        fontSize,...
        'Передан неправильный размер шрифта'); 
      testCase.verifyEqual(testCase.vararginPassedInToPassedInFunction,...
        {xtick,ytick},'Переданы неправильные отметки для осей'); 
    end
  end
  
end

