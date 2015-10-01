classdef GetResultsFilenameForMFileTest < matlab.unittest.TestCase
  
  methods (Test)
    function testReturnsResultsFilenameForMFile(testCase)
      filepath = getResultsFilenameForMFile('base\path\filename','dir\');
      testCase.verifyEqual(filepath,'base\path\dir\filename.mat',...
        '������� ������������ ���� � ����� � �����');
    end
  end
  
end

