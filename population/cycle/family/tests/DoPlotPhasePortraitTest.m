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
        '���������� ������� �� �������');
      testCase.verifyEqual(testCase.passedInClose,@close,...
        '�������� ������������ ������� �������� ���� ��������');
      testCase.verifyEqual(testCase.passedInCurrentDirName,...
        @currentDirName,...
        '�������� ������������ ������� ��������� ����� ������� �����');
      testCase.verifyEqual(testCase.passedInLoad,@load,...
        '�������� ������������ ������� �������� ���������� �� �����');
      testCase.verifyEqual(testCase.passedInSubplot,@subplot,...
        '�������� ������������ ������� �������� ������� ���� �������');
      testCase.verifyEqual(testCase.passedInHold,@hold,...
        '�������� ������������ ������� ��������� �������');
      testCase.verifyEqual(testCase.passedInPlot,@plot,...
        '�������� ������������ ������� �������� ��������');
      testCase.verifyEqual(testCase.passedInLabel,@label,...
        '�������� ������������ ������� �������� �������� ��������');
      testCase.verifyEqual(testCase.passedInXLabel,@xlabel,...
        '�������� ������������ ������� �������� ������� ��� �������');
      testCase.verifyEqual(testCase.passedInYLabel,@ylabel,...
        '�������� ������������ ������� �������� ������� ��� �������');
      testCase.verifyEqual(testCase.passedInGCA,@gca,...
        '�������� ������������ ������� ��������� ��������� ������� ����');
      testCase.verifyEqual(testCase.passedInSet,@set,...
        '�������� ������������ ������� ��������� ������� �������');
    end
  end
  
end

