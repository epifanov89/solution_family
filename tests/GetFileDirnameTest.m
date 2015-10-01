classdef GetFileDirnameTest < matlab.unittest.TestCase
  
  methods (Test)
    function returnsFileDir(testCase)
      filename = 'C:\Users\Андрей\Documents\MATLAB\getFileDirname.mat';
      actDir = getFileDirname(filename);
      expDir = 'C:\Users\Андрей\Documents\MATLAB\';
      testCase.verifyEqual(actDir,expDir,'Возвращен неправильный путь к папке, содержащей файл');
    end
  end
  
end

