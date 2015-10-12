function c = contains( func,arr )

c = ~isempty(getArrayIndices(func,arr,1));
end

