function solutions = doLoadFamilySolutionsCore( currentDirName,dir,...
  load,familyName,varargin )

curDirName = currentDirName();
solutionResultsDirname = strcat(curDirName,'solution_results\');
famDirName = strcat(solutionResultsDirname,familyName);
listing = dir(strcat(famDirName,'*.mat'));

% Отбрасываем папки
files = listing(arrayfun(@(entry) ~entry.isdir,listing));

solutions = [];

if ~isempty(files)
  filenames = {files(:).name};

  % Выбираем только файлы с результатами решений семейства
  [tokens,matches] = regexp(filenames,'(\d+).mat','tokens','match');

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
      solutions = [solutions,...
        load(strcat(famDirName,match{1}),varargin{:})];
    end
    matchIndex = matchIndex+1;
  end
end
end

