function point = doGetPoincareMapLastPointCore(...
  getPoincareMapLastPointIndex,getInterpValue,w,...
  fixedVarIndex,fixedVarValue)

sz = size(w);
pt = getPoincareMapLastPointIndex(w(:,fixedVarIndex),...
  fixedVarValue,sz(1));

nvar = sz(2);

point = zeros(1,nvar);

for varIndex = 1:nvar
  point(varIndex) = getInterpValue(w(:,fixedVarIndex),w(:,varIndex),...
    fixedVarValue,pt);
end
end

