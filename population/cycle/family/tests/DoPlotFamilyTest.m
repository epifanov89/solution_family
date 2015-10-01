classdef DoPlotFamilyTest < matlab.unittest.TestCase
  
  properties
    familyName
    passedInFamilyName
    passedInGetMFilename
    passedInGetFileDirname
    passedInDir
    passedInLoadVars
    passedInGetLastRowWithExtremeElementValue
    passedInGetSolutionPartForTrajectoryPlot
    passedInPlot
    passedInHold
    passedInLabel
    passedInXLabel
    passedInYLabel
    passedInGCA
    passedInSet
  end
  
  methods
    function fakeFcnToPassIn(testCase,familyName,getMFilename,...
        getFileDirname,dir,loadVars,getLastRowWithExtremeElementValue,...
        getSolutionPartForTrajectoryPlot,plot,hold,label,...
        xlabel,ylabel,gca,set)
      testCase.passedInFamilyName = familyName;
      testCase.passedInGetMFilename = getMFilename;
      testCase.passedInGetFileDirname = getFileDirname;
      testCase.passedInDir = dir;
      testCase.passedInLoadVars = loadVars;
      testCase.passedInGetLastRowWithExtremeElementValue = ...
        getLastRowWithExtremeElementValue;
      testCase.passedInGetSolutionPartForTrajectoryPlot = ...
        getSolutionPartForTrajectoryPlot;
      testCase.passedInPlot = plot;
      testCase.passedInHold = hold;
      testCase.passedInLabel = label;
      testCase.passedInXLabel = xlabel;
      testCase.passedInYLabel = ylabel;
      testCase.passedInGCA = gca;
      testCase.passedInSet = set;
    end
    
    function act(testCase)
      doPlotFamily(@testCase.fakeFcnToPassIn,testCase.familyName);
    end
  end
  
  methods (Test)
    function testPassesFamilyNameToPassedInFunction(testCase)
      testCase.familyName = 'family';
      testCase.act();
      testCase.verifyEqual(testCase.passedInFamilyName,...
        testCase.familyName,'�������� ������������ ��� ���������');
    end
    
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
    
    function testPassesGCAToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(...
        testCase.passedInGCA,@gca,...
        '�������� ������������ ������� ��������� ��������� ������������ ���������');
    end
    
    function testPassesSetToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(...
        testCase.passedInSet,@set,...
        '�������� ������������ ������� ��������� ������� ������������ ���������');
    end
  end
  
end

