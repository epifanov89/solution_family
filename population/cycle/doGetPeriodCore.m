function period = doGetPeriodCore( getPoincareMapPrevPointIndex,...
  getInterpValue,t,w,fixedVarIndex,fixedVarValue )

pt = length(t);
pt = getPoincareMapPrevPointIndex(w(:,fixedVarIndex),...
  fixedVarValue,pt);

tintersect(1) = getInterpValue(w(:,fixedVarIndex),t,fixedVarValue,pt);

pt = getPoincareMapPrevPointIndex(w(:,fixedVarIndex),...
  fixedVarValue,pt);

pt = getPoincareMapPrevPointIndex(w(:,fixedVarIndex),...
  fixedVarValue,pt);

tintersect(2) = getInterpValue(w(:,fixedVarIndex),t,fixedVarValue,pt);

period = tintersect(1)-tintersect(2);
end

