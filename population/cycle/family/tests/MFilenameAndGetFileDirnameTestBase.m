classdef MFilenameAndGetFileDirnameTestBase < matlab.unittest.TestCase
  
  properties (GetAccess = private,SetAccess = private)
    argPassedInToMFilename    
    filenamePassedInToGetFileDirname
  end
  
  properties (GetAccess = protected,SetAccess = protected)
    mfilename
    dirname
  end
  
  methods
    function mfilename = fakeMFilename(testCase,arg)
      testCase.argPassedInToMFilename = arg;
      mfilename = testCase.mfilename;
    end
    
    function dirname = fakeGetFileDirname(testCase,filename)
      testCase.filenamePassedInToGetFileDirname = filename;
      dirname = testCase.dirname;
    end
  end
  
  methods (Access = protected)
    function act(~)
    end
    
    function verifyGotMFilename(testCase)
      testCase.act();
      testCase.verifyEqual(testCase.argPassedInToMFilename,'fullpath',...
        'Не получено имя файла с кодом');
    end
    
    function verifyGotFileDirname(testCase)
      testCase.mfilename = 'mfilename';
      testCase.act();
      testCase.verifyEqual(testCase.filenamePassedInToGetFileDirname,...
        testCase.mfilename,...
        'Не получено имя папки файла с кодом');
    end
  end
  
end

