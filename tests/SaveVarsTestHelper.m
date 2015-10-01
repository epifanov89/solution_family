classdef SaveVarsTestHelper < matlab.unittest.TestCase
  
  properties (SetAccess = private, GetAccess = protected)
    argsPassedInToSaveArr
  end
  
  methods (Access = protected)
    function fakeSave(testCase,filename,vars)
      sameFilenameArgsIndices = find(...
        arrayfun(@(args) strcmp(args.filename,filename),...
        testCase.argsPassedInToSaveArr));
      if isempty(sameFilenameArgsIndices)
        argsInfo = struct;
        argsInfo.filename = filename;
        argsInfo.vars = vars;
        
        testCase.argsPassedInToSaveArr = ...
          [testCase.argsPassedInToSaveArr,argsInfo];
      else
        argsInfo = testCase.argsPassedInToSaveArr(...
          sameFilenameArgsIndices(1));
        argsInfo.vars = [argsInfo.vars,vars];
      end
    end
  end
  
end

