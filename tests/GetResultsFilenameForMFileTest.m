classdef GetResultsFilenameForMFileTest < matlab.unittest.TestCase
  
  methods (Test)
    function testReturnsResultsFilenameForMFile(testCase)
      filepath = getResultsFilenameForMFile('base\path\filename','dir\');
      testCase.verifyEqual(filepath,'base\path\dir\filename.mat',...
        'Передан неправильный путь к файлу с кодом');
    end
  end
  
end

