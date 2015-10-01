classdef DoSaveStructTest < matlab.unittest.TestCase
  
  properties
    filename
    S
    isAppend
    argsPassedInToSave
  end
  
  methods (TestMethodSetup)
    function setup(testCase)
      testCase.filename = 'filename';
      testCase.S = struct;
    end
  end
  
  methods
    function fakeSave(testCase,filename,varargin)
      args = struct;
      args.filename = filename;
      args.vars = varargin;
      testCase.argsPassedInToSave = args;
    end
    
    function act(testCase)
      doSaveStruct(@testCase.fakeSave,testCase.filename,...
        testCase.S,testCase.isAppend);
    end
  end
  
  methods (Test)
    function testAppendsVarsToFile(testCase)
      testCase.isAppend = true;
      testCase.act();
      testCase.verifyTrue(...
        strcmp(testCase.argsPassedInToSave.filename,testCase.filename)...
        && strcmp(testCase.argsPassedInToSave.vars{1},'-struct')...
        && strcmp(testCase.argsPassedInToSave.vars{3},'-append'),...
        'Поля структуры не добавлены в файл');
    end
    
    function testOverwritesFileIfAppendIsFalse(testCase)
      testCase.isAppend = false;
      testCase.act();
      testCase.verifyTrue(...
        strcmp(testCase.argsPassedInToSave.filename,testCase.filename)...
        && strcmp(testCase.argsPassedInToSave.vars{1},'-struct')...
        && length(testCase.argsPassedInToSave.vars) == 2,...
        'Файл не перезаписан');
    end
  end
  
end

