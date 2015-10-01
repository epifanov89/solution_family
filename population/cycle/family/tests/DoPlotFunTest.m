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
        '���������� ������� �� �������');
      testCase.verifyEqual(testCase.closePassedInToPassedInFunction,...
        @close,'�������� ������������ ������� ���������� ���� ��������');
      testCase.verifyEqual(testCase.axesPassedInToPassedInFunction,...
        @axes,'�������� ������������ ������� �������� ����');
      testCase.verifyEqual(testCase.fplotPassedInToPassedInFunction,...
        @fplot,'�������� ������������ ������� ���������� �������');
      testCase.verifyEqual(testCase.xlabelPassedInToPassedInFunction,...
        @xlabel,...
        '�������� ������������ ������� �������� ������� ��� �������');
      testCase.verifyEqual(testCase.ylabelPassedInToPassedInFunction,...
        @ylabel,...
        '�������� ������������ ������� �������� ������� ��� �������');
      testCase.verifyEqual(testCase.setPassedInToPassedInFunction,...
        @set,'�������� ������������ ������� ��������� ������� �������');
      testCase.verifyEqual(testCase.funPassedInToPassedInFunction,fun,...
        '�������� ������������ �������, ������ ������� ��������� ���������');    
      testCase.verifyEqual(testCase.xlabelStrPassedInToPassedInFunction,...
        xlabelStr,...
        '�������� ������������ ������� ��� �������'); 
      testCase.verifyEqual(testCase.ylabelStrPassedInToPassedInFunction,...
        ylabelStr,...
        '�������� ������������ ������� ��� �������'); 
      testCase.verifyEqual(testCase.fontSizePassedInToPassedInFunction,...
        fontSize,...
        '������� ������������ ������ ������'); 
      testCase.verifyEqual(testCase.vararginPassedInToPassedInFunction,...
        {xtick,ytick},'�������� ������������ ������� ��� ����'); 
    end
  end
  
end

