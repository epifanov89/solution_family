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
        '�� ������� ���������� �������');
      testCase.verifyEqual(testCase.passedInCurrentDirName,...
        @currentDirName,...
        '�������� ������������ ������� ��������� ����� ������� �����');
      testCase.verifyEqual(testCase.passedInLoad,...
        @load,...
        '�������� ������������ ������� �������� ���������� �� �����');
      testCase.verifyEqual(...
        testCase.passedInGetLastRowWithExtremeElementValue,...
        @getLastRowWithExtremeElementValue,...
        '�������� ������������ ������� ��������� ��������� ������ ������� � ������������� ��������� �������� � ������� � ���������� ��������');      
      testCase.verifyEqual(testCase.passedInSubplot,@subplot,...
        '�������� ������������ ������� �������� ������� ���� �������');
      testCase.verifyEqual(testCase.passedInPlot3D,@mesh,...
        '�������� ������������ ������� ����������� 3D-�������');
      testCase.verifyEqual(testCase.passedInSet,@set,...
        '�������� ������������ ������� ��������� ������� ������������ ���������');
      testCase.verifyEqual(testCase.passedInAxis,@axis,...
        '�������� ������������ ������� ��������� ������������ ��������');
      testCase.verifyEqual(testCase.passedInXLabel,@xlabel,...
        '�������� ������������ ������� �������� ������� ��� Ox');
      testCase.verifyEqual(testCase.passedInYLabel,@ylabel,...
        '�������� ������������ ������� �������� ������� ��� Oy');
      testCase.verifyEqual(testCase.passedInZLabel,@zlabel,...
        '�������� ������������ ������� �������� ������� ��� Oz');
    end
  end
  
end

