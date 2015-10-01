function T = getPeriod( t,w,fixedVarIndex,fixedVarValue )

T = doGetPeriod(@doGetPeriodCore,t,w,fixedVarIndex,fixedVarValue);
end

