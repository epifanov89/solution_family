classdef GetFileDirnameTest < matlab.unittest.TestCase
  
  methods (Test)
    function returnsFileDir(testCase)
      filename = 'C:\Users\������\Documents\MATLAB\getFileDirname.mat';
      actDir = getFileDirname(filename);
      expDir = 'C:\Users\������\Documents\';
      testCase.verifyEqual(actDir,expDir,...
        '��������� ������������ ���� � ������������ �����');
    end
  end
  
end

