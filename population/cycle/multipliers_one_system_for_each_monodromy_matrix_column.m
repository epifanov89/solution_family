function [rho,computation_time] = multipliers_one_system_for_each_monodromy_matrix_column( f, linearized_system, solver, tspan, w0, nvar, filepath, fixed_var_index, fixed_var_value, options, outputopts, plot_first_only)
%MULTIPLIERS_ONE_SYSTEM_FOR_EACH_MONODROMY_MATRIX_COLUMN Находит 
%мультипликаторы как собственные значения матрицы монодромии,
%построенной с помощью решения системы для каждого ее столбца
%   Для вычисления каждого столбца матрицы монодромии решается
%   задача Коши для системы, составленной из уравнений исходной системы 
%   плюс уравнения в вариациях, где в качестве начальных данных для 
%   уравнений в вариациях берется очередной единичный орт

  if exist(filepath,'file')
    load(filepath,'C','calculated_monodromy_matrix_column_number','computation_time');
  end
  
  if ~exist('C','var')
    C = zeros(nvar);
  end
  
  if ~exist('calculated_monodromy_matrix_column_number','var')
    calculated_monodromy_matrix_column_number = 0;
  end
  
  if ~exist('computation_time','var')
    computation_time = 0;
  end
  
  msg = sprintf('Расчет мультипликаторов: %d%%%%',round(calculated_monodromy_matrix_column_number*100/nvar));
  fprintf(msg);
  reverseStr = repmat(sprintf('\b'), 1, length(msg)-1);
  
  options = odeset(options,'Events',@events);
  
  err = false;
  
  figure
  
  tic
  for col_index = calculated_monodromy_matrix_column_number+1:nvar
    w0_new = zeros(1, 2 * nvar);
    w0_new(1:nvar) = w0;
    w0_new(nvar + col_index) = 1;
    if strcmp(func2str(solver),'myode4')
      fprintf('\n');
    end
    if col_index > 1 && nargin >= 12 && plot_first_only || nargin < 11
      [t,wres,~,~,te] = solver(@united_system, tspan, w0_new, options);
    else      
      [t,wres,~,~,te] = solver(@united_system, tspan, w0_new, odeset(options,outputopts));
    end
    if strcmp(func2str(solver),'myode4')
      fprintf('\b');
    end
    
    if length(te) < 2
      err = true;
      break;
    end
    
    if strcmp(func2str(solver),'myode4')
      tspan2 = 0:(tspan(2)-tspan(1))/100:tspan(end);
      wprev = wres(end-1,:);

      fprintf('\n');
      if col_index > 1 && nargin >= 12 && plot_first_only || nargin < 11
        [t,wres,~,~,te2] = solver(@united_system, tspan2, wprev, options);
      else      
        [t,wres,~,~,te2] = solver(@united_system, tspan2, wprev, odeset(options,outputopts));
      end
      fprintf('\b');

      if isempty(te2)
        err = true;
        break;
      end
    end
    
    C(:, col_index) = wres(end, nvar + 1:2 * nvar);
    
    elapsedTime = toc;
    computation_time = computation_time+round(elapsedTime);      
    
    calculated_monodromy_matrix_column_number = calculated_monodromy_matrix_column_number+1;
    
    % Сохранение промежуточных результатов расчета матрицы монодромии
    save(filepath,'C','calculated_monodromy_matrix_column_number','computation_time');
    msg = sprintf('Расчет мультипликаторов: %d%%%%',round(calculated_monodromy_matrix_column_number*100/nvar));
    fprintf([reverseStr, msg]);
    reverseStr = repmat(sprintf('\b'), 1, length(msg)-1);
    
    if col_index ~= nvar
      tic
    end
  end
  fprintf('\n\n');
  
  if ~err
    rho = sort(eig(C),'descend');
    delete(filepath);
  else
    rho = [];
  end
  
  function dwdt = united_system( t, w )
    dwdt = zeros(2 * nvar, 1);
    dwdt(1:nvar) = f( t, w );
    dwdt(nvar + 1:2 * nvar) = linearized_system( t, w, 1 );% * w(nvar + 1:2 * nvar);
    %J = system_jacobian( t, w, 1 );
    %for row_index = 1:N * species_total_cnt
    %  sum = 0;
    %  for term_index = 1:N * species_total_cnt
    %    sum = sum + J(row_index, term_index) * w(N * species_total_cnt + term_index);
    %  end
    %  dwdt(N * species_total_cnt + row_index) = sum;
    %end
  end

  function [value,isterminal,direction] = events(~,y)
    value = y(fixed_var_index)-fixed_var_value;
    isterminal = 1;
    direction = -1;  
  end
end

