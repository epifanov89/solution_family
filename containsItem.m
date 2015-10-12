function c = containsItem( arr,item )

if iscellstr(arr)
  comparator = @strcmp;
else
  comparator = @isequal;
end

c = contains(@(i) comparator(i,item),arr);
end

