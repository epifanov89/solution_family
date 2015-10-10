classdef DoPlotFamilyTest < matlab.unittest.TestCase
  
  properties
    passedInGetMFilename
    passedInGetFileDirname
    passedInDir
    passedInLoadVars
    passedInGetLastRowWithExtremeElementValue
    passedInGetSolutionPartForTrajectoryPlot
    passedInSubplot
    passedInPlot
    passedInHold
    passedInLabel
    passedInXLabel
    passedInYLabel
    passedInSet
  end
  
  methods
    function fakeFcnToPassIn(testCase,getMFilename,...
        getFileDirname,dir,loadVars,getLastRowWithExtremeElementValue,...
        getSolutionPartForTrajectoryPlot,subplot,plot,hold,label,...
        xlabel,ylabel,set)
      testCase.passedInGetMFilename = getMFilename;
      testCase.passedInGetFileDirname = getFileDirname;
      testCase.passedInDir = dir;
      testCase.passedInLoadVars = loadVars;
      testCase.passedInGetLastRowWithExtremeElementValue = ...
        getLastRowWithExtremeElementValue;
      testCase.passedInGetSolutionPartForTrajectoryPlot = ...
        getSolutionPartForTrajectoryPlot;
      testCase.passedInSubplot = subplot;
      testCase.passedInPlot = plot;
      testCase.passedInHold = hold;
      testCase.passedInLabel = label;
      testCase.passedInXLabel = xlabel;
      testCase.passedInYLabel = ylabel;
      testCase.passedInSet = set;
    end
    
    function act(testCase)
      doPlotFamily(@testCase.fakeFcnToPassIn);
    end
  end
  
  methods (Test)
    function testPassesMFilenameToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(testCase.passedInGetMFilename,@mfilename,...
        '�������� ������������ ������� ��������� ����� �����');
    end
    
    function testPassesGetFileDirToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(testCase.passedInGetFileDirname,...
        @getFileDirname,...
        '�������� ������������ ������� ��������� ����� �����, ���������� ����');
    end
        
    function testPassesDirToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(testCase.passedInDir,@dir,...
        '�������� ������������ ������� ��������� ����������� �����');
    end
    
    function testPassesLoadToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(testCase.passedInLoadVars,...
        @load,...
        '�������� ������������ ������ �������� ���������� �� �����');
    end
    
    function testPassesGetLastRowWithExtremeElementValueToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(...
        testCase.passedInGetLastRowWithExtremeElementValue,...
        @getLastRowWithExtremeElementValue,...
        '�������� ������������ ������� ��������� ��������� ������ ������� � ������������� ��������� �������� � ������� � ���������� ��������');
    end
    
    function testPassesGetSolutionForTrajectoryPlotToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(...
        testCase.passedInGetSolutionPartForTrajectoryPlot,...
        @getSolutionTillMinFirstPredatorDensity,...
        '�������� ������������ ������� ��������� ����� ������� ��� ������ ��� ����������');
    end
       
    function testPassesSubplotToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(...
        testCase.passedInSubplot,@subplot,...
        '�������� ������������ ������� �������� ������� �������');
    end 
    
    function testPassesPlotToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(...
        testCase.passedInPlot,@plot,...
        '�������� ������������ ������� ���������� �������');
    end    
    
    function testPassesHoldToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(...
        testCase.passedInHold,@hold,...
        '�������� ������������ ������� ��������� ������������ ���������');
    end
    
    function testPassesLabelToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(...
        testCase.passedInLabel,@label,...
        '�������� ������������ ������� �������� �������� � ������');
    end
    
    function testPassesXLabelToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(...
        testCase.passedInXLabel,@xlabel,...
        '�������� ������������ ������� �������� ������� ��� �������');
    end
    
    function testPassesYLabelToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(...
        testCase.passedInYLabel,@ylabel,...
        '�������� ������������ ������� �������� ������� ��� �������');
    end
    
    function testPassesSetToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(...
        testCase.passedInSet,@set,...
        '�������� ������������ ������� ��������� ������� ������������ ���������');
    end
  end
  
end

