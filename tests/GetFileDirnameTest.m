classdef GetFileDirnameTest < matlab.unittest.TestCase
  
  methods (Test)
    function returnsFileDir(testCase)
      filename = 'C:\Users\Андрей\Documents\MATLAB\getFileDirname.mat';
      actDir = getFileDirname(filename);
      expDir = 'C:\Users\Андрей\Documents\';
      testCase.verifyEqual(actDir,expDir,...
        'Возвращен неправильный путь к родительской папке');
    end
  end
  
end

