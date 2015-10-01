function solutions = doLoadFamilySolutionsCore( currentDirName,dir,...
  load,familyName,varargin )

curDirName = currentDirName();
solutionResultsDirname = strcat(curDirName,'solution_results\');
listing = dir(strcat(solutionResultsDirname,familyName,'_*.mat'));

% Отбрасываем папки
files = listing(arrayfun(@(entry) ~entry.isdir,listing));

solutions = [];

if ~isempty(files)
  filenames = {files(:).name};

  % Выбираем только файлы с результатами решений семейства
  escapedFamilyName = regexptranslate('escape',familyName);
  [tokens,matches] = regexp(filenames,...
    strcat(escapedFamilyName,'_(\d+).mat'),'tokens','match');

  ntoken = length(tokens);
  numTokens = zeros(1,ntoken);
  for tokenIndex = 1:ntoken
    token = tokens{tokenIndex};
    if ~isempty(token)
      numTokens(tokenIndex) = str2double(token{1});
    end
  end
  
  [~,sortedIndices] = sort(numTokens);
  
  sortedMatches = matches(sortedIndices);
  
  matchIndex = 1;
  while matchIndex <= length(sortedMatches)
    match = sortedMatches{matchIndex};
    if ~isempty(match)
      solutions = [solutions,load(strcat(solutionResultsDirname,...
        match{1}),varargin{:})];
    end
    matchIndex = matchIndex+1;
  end
end
end

