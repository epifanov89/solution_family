classdef GetCurrentDirNameTest < matlab.unittest.TestCase
  
  properties
    passedInMFilename
    passedInGetFileDirname
    dirname
  end
  
  methods
    function dirname = fakeFcnToPassIn(testCase,mfilename,getFileDirname)
      testCase.passedInMFilename = mfilename;
      testCase.passedInGetFileDirname = getFileDirname;
      dirname = testCase.dirname;
    end
    
    function dirname = act(testCase)
      dirname = getCurrentDirName(@testCase.fakeFcnToPassIn);
    end
  end
  
  methods (Test)
    function testPassesMFilenameToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(testCase.passedInMFilename,@mfilename,...
        '�������� ������������ ������� ��������� ����� ����� � �����');
    end
    
    function testPassesGetFileDirnameToPassedInFunction(testCase)
      testCase.act();
      testCase.verifyEqual(testCase.passedInGetFileDirname,...
        @getFileDirname,...
        '�������� ������������ ������� ��������� ����� ����� ����� � �����');
    end
    
    function testReturnsDirname(testCase)
      testCase.dirname = 'dirname';
      dir = testCase.act();
      testCase.verifyEqual(dir,testCase.dirname,...
        '�� ���������� ��� �����');
    end
  end
  
end

