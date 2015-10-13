classdef DoGetCurrentDirNameTest < matlab.unittest.TestCase
  
  properties
    argPassedInToMFilename
    mfilename
    filenamePassedInToGetFileDirname
    dirname
  end
  
  methods
    function p = fakeMFilename(testCase,arg)
      testCase.argPassedInToMFilename = arg;
      p = testCase.mfilename;
    end
    
    function dirname = fakeGetFileDirname(testCase,filename)
      testCase.filenamePassedInToGetFileDirname = filename;
      dirname = testCase.dirname;
    end
    
    function dirname = act(testCase)
      dirname = doGetCurrentDirName(@testCase.fakeMFilename,...
        @testCase.fakeGetFileDirname);
    end
  end
  
  methods (Test)
    function testGetsMFilename(testCase)
      testCase.act();
      testCase.verifyEqual(testCase.argPassedInToMFilename,...
        'fullpath','�� �������� ��� ����� � �����');
    end
    
    function testGetsFileDirname(testCase)
      testCase.mfilename = 'mfilename';
      testCase.act();
      testCase.verifyEqual(testCase.filenamePassedInToGetFileDirname,...
        testCase.mfilename,'�� �������� ��� ����� ����� � �����');
    end
    
    function testReturnsDirname(testCase)
      testCase.dirname = 'dirname';
      dir = testCase.act();
      testCase.verifyEqual(dir,testCase.dirname,...
        '�� ���������� ��� ����� ����� � �����');
    end
  end
  
end

