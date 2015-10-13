classdef DoLoadFamilySolutionsTest < matlab.unittest.TestCase
  
  properties
    isPassedInFunctionCalled
    nPassedInArgs
    passedInCurrentDirName
    passedInDir
    passedInLoad
    passedInFamilyName
    passedInVarsToLoad
    solutions
  end
  
  methods
    function solutions = fakeFcnToPassIn(testCase,currentDirName,dir,...
        load,familyName,varargin)
      testCase.isPassedInFunctionCalled = true;
      if nargin >= 5
        testCase.passedInCurrentDirName = currentDirName;
        testCase.passedInDir = dir;
        testCase.passedInLoad = load;
        testCase.passedInFamilyName = familyName;
        testCase.passedInVarsToLoad = varargin;
      end
      solutions = testCase.solutions;
    end
  end
  
  methods (Test)
    function testPassesArgsToPassedInFunction(testCase)
      testCase.isPassedInFunctionCalled = false;
      familyName = 'family';
      varsToLoad = {'t','w'};
      sol = struct;
      npt = 20;
      sol.t = zeros(1,npt);
      sol.w = zeros(npt,15);
      testCase.solutions = sol;
      actSolutions = doLoadFamilySolutions(@testCase.fakeFcnToPassIn,...
        familyName,varsToLoad{:});
      testCase.assertTrue(testCase.isPassedInFunctionCalled,...
        '���������� ������� �� �������');
      testCase.verifyEqual(testCase.passedInCurrentDirName,...
        @currentDirName,...
        '�������� ������������ ������� ��������� ����� ������� �����');
      testCase.verifyEqual(testCase.passedInDir,@dir,...
        '�������� ������������ ������� ��������� ������ ����������� �����');
      testCase.verifyEqual(testCase.passedInLoad,@load,...
        '�������� ������������ ������� �������� ���������� �� �����');
      testCase.verifyEqual(testCase.passedInFamilyName,familyName,...
        '�������� ������������ ��� ���������');
      testCase.verifyEqual(testCase.passedInVarsToLoad,varsToLoad,...
        '�������� ������������ ����� ����������� ����������');
      testCase.verifyEqual(actSolutions,testCase.solutions,...
        '�� ���������� �������');
    end
  end
  
end

