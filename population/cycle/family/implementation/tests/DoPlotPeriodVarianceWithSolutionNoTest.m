classdef DoPlotPeriodVarianceWithSolutionNoTest < matlab.unittest.TestCase
  
  properties
    isPassedInFunctionCalled
    passedInFamilyNames    
    passedInLoadFamilySolutions
    passedInGetPeriod
    passedInAxes
    passedInHold
    passedInPlot
    passedInLabel
    passedInSet
    passedInXLabel
    passedInYLabel
  end
  
  methods
    function fakeFcnToPassIn(testCase,familyNames,loadFamilySolutions,...
        getPeriod,axes,hold,plot,label,set,xlabel,ylabel)
      testCase.isPassedInFunctionCalled = true;
      testCase.passedInFamilyNames = familyNames;
      testCase.passedInLoadFamilySolutions = loadFamilySolutions;
      testCase.passedInGetPeriod = getPeriod;
      testCase.passedInAxes = axes;
      testCase.passedInHold = hold;
      testCase.passedInPlot = plot;
      testCase.passedInLabel = label;
      testCase.passedInSet = set;
      testCase.passedInXLabel = xlabel;
      testCase.passedInYLabel = ylabel;
    end
  end
  
  methods (Test)
    function testPassesArgsToPassedInFunction(testCase)
      testCase.isPassedInFunctionCalled = false;
      familyNames = {'family1','family2'};
      doPlotPeriodVarianceWithSolutionNo(@testCase.fakeFcnToPassIn,...
        familyNames);
      testCase.assertTrue(testCase.isPassedInFunctionCalled,...
        '���������� ������� �� �������');
      testCase.verifyEqual(testCase.passedInFamilyNames,familyNames,...
        '�������� ������������ ����� ��������');
      testCase.verifyEqual(testCase.passedInLoadFamilySolutions,...
        @loadFamilySolutions,...
        '�������� ������������ ������� �������� ������� ���������');
      testCase.verifyEqual(testCase.passedInGetPeriod,@getPeriod,...
        '�������� ������������ ������� ���������� ������� �������');
      testCase.verifyEqual(testCase.passedInAxes,@axes,...
        '�������� ������������ ������� �������� ����');
      testCase.verifyEqual(testCase.passedInHold,@hold,...
        '�������� ������������ ������� ��������� �������');
      testCase.verifyEqual(testCase.passedInPlot,@plot,...
        '�������� ������������ ������� ���������� ��������');
      testCase.verifyEqual(testCase.passedInLabel,@label,...
        '�������� ������������ ������� �������� �������� � ������');
      testCase.verifyEqual(testCase.passedInSet,@set,...
        '�������� ������������ ������� ��������� ������� �������');
      testCase.verifyEqual(testCase.passedInXLabel,@xlabel,...
        '�������� ������������ ������� �������� ������� ��� �������');
      testCase.verifyEqual(testCase.passedInYLabel,@ylabel,...
        '�������� ������������ ������� �������� ������� ��� �������');
    end
  end
  
end

