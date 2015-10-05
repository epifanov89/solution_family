function ind = getArrayIndices( func,arr )

ind = find(getArrayIndexMask(func,arr));
end

