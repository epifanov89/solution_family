function lastPointIndex = getPoincareMapLastPointIndex( vec,...
  fixedVarValue,ptstart )

lastPointIndex = ptstart;
lastPointIndex = lastPointIndex-1;
while sign(vec(lastPointIndex)-fixedVarValue) == ...
    sign(vec(lastPointIndex+1)-fixedVarValue)
  lastPointIndex = lastPointIndex-1;
end
end

