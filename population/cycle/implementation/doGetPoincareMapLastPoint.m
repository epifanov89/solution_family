function pt = doGetPoincareMapLastPoint( doGetPoincareMapLastPointCore,...
  w,fixedVarIndex,fixedVarValue )

pt = doGetPoincareMapLastPointCore(@getPoincareMapLastPointIndex,...
  @getInterpValue,w,fixedVarIndex,fixedVarValue);
end

