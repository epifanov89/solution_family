function T = doGetPeriod( doGetPeriodCore,t,w,fixedVarIndex,fixedVarValue)

T = doGetPeriodCore(@getPoincareMapLastPointIndex,@getInterpValue,t,w,...
  fixedVarIndex,fixedVarValue);
end

