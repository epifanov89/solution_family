classdef LoadTestHelper < TestHelperBase
  
  properties (GetAccess = protected,SetAccess = protected)
    argsPassedInToLoad
    varsToLoad
  end
  
  methods (Access = protected)    
    function vars = fakeLoad(testCase,filename,varargin)      
      args = testCase.argsPassedInToLoad(arrayfun(...
        @(l) strcmp(l.filename,filename),testCase.argsPassedInToLoad));
      
      if ~isempty(args)
        args.varnames = [args.varnames,varargin];
      else
        args = struct;
        args.filename = filename;
        args.varnames = varargin;
        testCase.argsPassedInToLoad = args;
      end
      
      vars = testCase.varsToLoad;
    end
    
    function verifySolutionLoaded(testCase,filename,varnames)
      testCase.act();
      args = struct;
      args.filename = filename;
      args.varnames = varnames;
      testCase.verifyContainsItem(testCase.argsPassedInToLoad,args,...
        '�� ��������� ���������� �� �����');
    end
  end
  
end

