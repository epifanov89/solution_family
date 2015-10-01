function ix = findCell( cellArr,predicate )
%FINDCELL Summary of this function goes here
%   Detailed explanation goes here

ix = [];
for paramno = 1:length(cellArr)
  if predicate(cellArr{paramno})
    ix = [ix,paramno];
  end
end

end

