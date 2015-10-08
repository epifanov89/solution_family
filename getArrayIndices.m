function ind = getArrayIndices( func,arr,forEmptinessCheck )

if nargin == 2
  ind = find(getArrayIndexMask(func,arr));
elseif nargin == 3
  ind = find(getArrayIndexMask(func,arr),forEmptinessCheck);
end
end

