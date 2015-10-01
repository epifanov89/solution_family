function pt = getPoincareMapLastPoint( w,fixedVarIndex,fixedVarValue )

pt = doGetPoincareMapLastPoint(@doGetPoincareMapLastPointCore,...
  w,fixedVarIndex,fixedVarValue);
end

