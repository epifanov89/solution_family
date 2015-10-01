function c = contains( arr,item )

if iscell(arr)
  each = @cellfun;
  
  if ischar(item)
    comparator = @strcmp;
  else
    comparator = @isequal;
  end
else
  each = @arrayfun;
  comparator = @isequal;
end

c = ~isempty(find(each(@(i) comparator(i,item),arr),1));
end

