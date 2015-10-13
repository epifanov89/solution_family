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
        resultsFilename,'�������� ������������ ��� ����� �����������');
      testCase.verifyEqual(testCase.tstartPassedInToPassedInFunction,...
        tstart,'�������� ������������ ����� ������ ������ �������');
      testCase.verifyEqual(testCase.tspanPassedInToPassedInFunction,...
        tspan,'������� ������������ ���������� ������ �������');
      testCase.verifyEqual(...
        testCase.currentDirNamePassedInToPassedInFunction,...
        @currentDirName,...
        '�������� ������������ ������� ��������� ����� ������� �����');
      testCase.verifyEqual(...
        testCase.loadPassedInToPassedInFunction,@load,...
        '�������� ������������ ������� �������� ���������� �� �����');
      testCase.verifyEqual(...
        testCase.plotPassedInToPassedInFunction,@plot,...
        '�������� ������������ ������� ���������� ��������');
      testCase.verifyEqual(...
        testCase.holdPassedInToPassedInFunction,@hold,...
        '�������� ������������ ������� ��������� �������');
      testCase.verifyEqual(...
        testCase.labelPassedInToPassedInFunction,@label,...
        '�������� ������������ ������� �������� ����� �����');
      testCase.verifyEqual(...
        testCase.xlabelPassedInToPassedInFunction,@xlabel,...
        '�������� ������������ ������� �������� ����� ��� �������');      
      testCase.verifyEqual(...
        testCase.gcaPassedInToPassedInFunction,@gca,...
        '�������� ������������ ������� ��������� ������� ����');
      testCase.verifyEqual(...
        testCase.setPassedInToPassedInFunction,@set,...
        '�������� ������������ ������� ��������� ������� �������');
    end
  end
  
end

