classdef DoGetCombinedPredatorDensitiesInitialDataTest < matlab.unittest.TestCase
  
  properties
    zeroFirstPredatorSolutionResultsInitialData
    nsol
    solno
    passedInZeroFirstPredatorSolutionResultsFilename
    passedInNSol
    passedInSolNo
    passedInCurrentDirName
    passedInLoad
    passedInGetLastRowWithExtremeElementValue
    
    initialData
  end
  
  methods (TestMethodSetup)
    function setup(testCase)
      testCase.zeroFirstPredatorSolutionResultsInitialData = ...
        'zero_first_predator_filename';
      testCase.nsol = 10;
      testCase.solno = 4;
    end
  end
  
  methods
    function ic = fakeFcnToPassIn(testCase,...
        zeroFirstPredatorSolutionResultsFilename,nsol,solno,...
        currentDirName,load,getLastRowWithExtremeElementValue)
      testCase.passedInZeroFirstPredatorSolutionResultsFilename = ...
        zeroFirstPredatorSolutionResultsFilename;
      testCase.passedInNSol = nsol;
      testCase.passedInSolNo = solno;
      testCase.passedInCurrentDirName = currentDirName;
      testCase.passedInLoad = load;
      testCase.passedInGetLastRowWithExtremeElementValue = ...
        getLastRowWithExtremeElementValue;
      ic = testCase.initialData;
    end
    
    function ic = act(testCase)
      ic = doGetCombinedPredatorDensitiesInitialData(...
        @testCase.fakeFcnToPassIn,...
        testCase.zeroFirstPredatorSolutionResultsInitialData,...
        testCase.nsol,testCase.solno);
    end
  end
  
  methods (Test)
    function testPassesZeroFirstPredatorSolutionResultsFilenameToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(...
        testCase.passedInZeroFirstPredatorSolutionResultsFilename,...
        testCase.zeroFirstPredatorSolutionResultsInitialData,...
        '�������� ������������ ��� ����� � ������������ ������� ��� ������� ��������� ������ ��������� ��������');
    end
    
    function testPassesNSolToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(testCase.passedInNSol,testCase.nsol,...
        '�������� ������������ ����� �������');
    end
    
    function testPassesSolNoToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(testCase.passedInSolNo,testCase.solno,...
        '������� ������������ ����� �������');
    end
    
    function testPassesCurrentDirNameToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(testCase.passedInCurrentDirName,...
        @currentDirName,...
        '�������� ������������ ������� ��������� ����� ����� ����� � �����');
    end
    
    function testPassesLoadToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(testCase.passedInLoad,@load,...
        '�������� ������������ ������� �������� ���������� �� �����');
    end
    
    function testPassesGetLastRowWithExtremeElementValueToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(...
        testCase.passedInGetLastRowWithExtremeElementValue,...
        @getLastRowWithExtremeElementValue,...
        '�������� ������������ ������� ��������� ��������� ������ � ������������ ��������� ������� � ���������� ��������');
    end
    
    function testReturnsInitialData(testCase)
      testCase.initialData = [1 1];
      actInitialData = testCase.act();
      expInitialData = testCase.initialData;
      testCase.verifyEqual(actInitialData,expInitialData,...
        '���������� ������������ ��������� ������');
    end
  end
  
end

