function c = contains( arr,item )

if iscellstr(arr)
  comparator = @strcmp;
else
  comparator = @isequal;
end

c = ~isempty(getArrayIndices(@(i) comparator(i,item),arr,1));
end

