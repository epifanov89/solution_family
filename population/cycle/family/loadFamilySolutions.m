function solutions = loadFamilySolutions( familyName,varargin )

solutions = doLoadFamilySolutions(@doLoadFamilySolutionsCore,...
  familyName,varargin{:});
end

