classdef PoincareMapTestHelper < handle
  
  properties (GetAccess = protected, SetAccess = protected)
    pointIndicesToReturnFromGetPoincareMapLastPointIndex
    vqToReturnFromGetInterpValue
  end
  
  methods (Access = protected)
    function pointIndex = fakeGetPoincareMapLastPointIndex(testCase,...
        vec,fixedVarValue,ptstart)
      args = testCase.pointIndicesToReturnFromGetPoincareMapLastPointIndex(...
        arrayfun(@(p) isequal(p.vec,vec)...
          && p.fixedVarValue == fixedVarValue && p.ptstart == ptstart,...
          testCase.pointIndicesToReturnFromGetPoincareMapLastPointIndex));
      pointIndex = args.pointIndex;
    end
    
    function vq = fakeGetInterpValue(testCase,x,v,fixedVarValue,pt)
      args = testCase.vqToReturnFromGetInterpValue(arrayfun(...
        @(vq) isequal(vq.x,x) && isequal(vq.v,v)...
          && vq.fixedVarValue == fixedVarValue && vq.pt == pt,...
          testCase.vqToReturnFromGetInterpValue));
      vq = args.vq;
    end
  end
  
end

