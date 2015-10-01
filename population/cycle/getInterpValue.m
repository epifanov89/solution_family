function vq = getInterpValue( x,v,fixedVarValue,pt )

vq = interp1([x(pt+1),x(pt)],[v(pt+1),v(pt)],fixedVarValue);
end

