classdef DoCalculateEigsTest < IsPassedInFunctionCalledTestHelper
  
  properties
    filename
    passedInParentDirName
    passedInLoad
    passedInGetSystem
    passedInEig
    passedInDisp
    passedInFilename
  end
  
  methods (TestMethodSetup)
    function setup(testCase)
      setup@IsPassedInFunctionCalledTestHelper(testCase);
    end
  end
  
  methods (Access = protected)
    function fakeFcnToPassIn(testCase,parentDirName,load,getSystem,eig,...
        disp,filename)
      fakeFcnToPassIn@IsPassedInFunctionCalledTestHelper(testCase);
      testCase.passedInParentDirName = parentDirName;
      testCase.passedInLoad = load;
      testCase.passedInGetSystem = getSystem;
      testCase.passedInEig = eig;
      testCase.passedInDisp = disp;
      testCase.passedInFilename = filename;
    end
    
    function act(testCase)
      doCalculateEigs(@testCase.fakeFcnToPassIn,testCase.filename);
    end
  end
  
  methods (Test)
    function testRightParamsPassedToPassedInFunction(testCase)
      testCase.filename = 'file.mat';
      testCase.act();
      testCase.assertPassedInFunctionCalled();
      testCase.verifyEqual(testCase.passedInParentDirName,...
        @currentDirName,...
        '�������� ������������ ������� ��������� ����� ������������ �����');
      testCase.verifyEqual(testCase.passedInLoad,@load,...
        '�������� ������������ ������� �������� ���������� �� �����');
      testCase.verifyEqual(testCase.passedInGetSystem,...
        @predatorPrey2x1Params,...
        '�������� ������������ ������� ��������� ������ ������ �������');
      testCase.verifyEqual(testCase.passedInEig,@eig,...
        '�������� ������������ ������� ���������� ��');
      testCase.verifyEqual(testCase.passedInDisp,@disp,...
        '�������� ������������ ������� ������ ��������');
      testCase.verifyEqual(testCase.passedInFilename,testCase.filename,...
        '�������� ������������ ��� �����');
    end
  end
  
end

