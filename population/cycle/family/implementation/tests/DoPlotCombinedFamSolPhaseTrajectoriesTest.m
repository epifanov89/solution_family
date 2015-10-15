classdef DoPlotCombinedFamSolPhaseTrajectoriesTest < ...
    IsPassedInFunctionCalledTestHelper
  
  properties
    passedInCurrentDirName
    passedInLoad
    passedInGetLastRowWithExtremeElementValue
    passedInPlot3
    passedInHold
    passedInLabel
    passedInXLabel
    passedInYLabel
    passedInZLabel
    passedInGCA
    passedInSet
  end
  
  methods (TestMethodSetup)
    function setup(testCase)
      setup@IsPassedInFunctionCalledTestHelper(testCase);
    end
  end
  
  methods (Access = protected)
    function fakeFcnToPassIn(testCase,currentDirName,load,...
        getLastRowWithExtremeElementValue,plot3,hold,label,xlabel,...
        ylabel,zlabel,gca,set)
      fakeFcnToPassIn@IsPassedInFunctionCalledTestHelper(testCase);
      testCase.passedInCurrentDirName = currentDirName;
      testCase.passedInLoad = load;
      testCase.passedInGetLastRowWithExtremeElementValue = ...
        getLastRowWithExtremeElementValue;
      testCase.passedInPlot3 = plot3;
      testCase.passedInHold = hold;
      testCase.passedInLabel = label;
      testCase.passedInXLabel = xlabel;
      testCase.passedInYLabel = ylabel;
      testCase.passedInZLabel = zlabel;
      testCase.passedInGCA = gca;
      testCase.passedInSet = set;
    end
  end
  
  methods (Test)
    function testPassesRightParamsToPassedInFunction(testCase)
      doPlotCombinedFamSolPhaseTrajectories(@testCase.fakeFcnToPassIn);
      testCase.assertPassedInFunctionCalled();
      testCase.verifyEqual(testCase.passedInCurrentDirName,...
        @currentDirName,...
        '�������� ������������ ������� ��������� ����� ������� �����');
      testCase.verifyEqual(testCase.passedInLoad,@load,...
        '�������� ������������ ������� �������� ����������');
      testCase.verifyEqual(...
        testCase.passedInGetLastRowWithExtremeElementValue,...
        @getLastRowWithExtremeElementValue,...
        '�������� ������������ ������� ��������� ��������� ������ ������� � ������������� ��������� �������� � ������� � ���������� ��������');
      testCase.verifyEqual(testCase.passedInPlot3,@plot3,...
        '�������� ������������ ������� ���������� ���������� ��������');
      testCase.verifyEqual(testCase.passedInHold,@hold,...
        '�������� ������������ ������� ��������� ������� ��� ���������� �� ����� ������� ���������� ��������');
      testCase.verifyEqual(testCase.passedInLabel,@label,...
        '�������� ������������ ������� �������� �������� � ��������');
      testCase.verifyEqual(testCase.passedInXLabel,@xlabel,...
        '�������� ������������ ������� �������� ������� ��� Ox');
      testCase.verifyEqual(testCase.passedInYLabel,@ylabel,...
        '�������� ������������ ������� �������� ������� ��� Oy');
      testCase.verifyEqual(testCase.passedInZLabel,@zlabel,...
        '�������� ������������ ������� �������� ������� ��� Oz');
      testCase.verifyEqual(testCase.passedInGCA,@gca,...
        '�������� ������������ ������� ��������� ������� ����');
      testCase.verifyEqual(testCase.passedInSet,@set,...
        '�������� ������������ ������� ��������� ������� �������');
    end
  end
  
end

