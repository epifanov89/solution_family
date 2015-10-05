function ind = getArrayItemIndices( item,arr )

ind = getArrayIndices(@(i) isequal(i,item),arr);
end

