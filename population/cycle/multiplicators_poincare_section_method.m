function [rho,computation_time] = multiplicators_poincare_section_method( f, solver, tspan, w0, nvar, filepath, fixed_var_index, fixed_var_value, eps, options, outputopts, interp_method )
%MULTIPLICATORS_POINCARE_SECTION_METHOD Вычисляет мультипликаторы как 
%собственные значения матрицы монодромии, построенной с помощью численного
%находождения частных производных в неподвижной точке отображения Пуанкаре
%   Detailed explanation goes here

  if exist(filepath,'file')
    load(filepath,'C','calculated_monodromy_matrix_column_number','computation_time');
  end
  
  if ~exist('C','var')
    C = zeros(nvar-1);
  end
  
  if ~exist('calculated_monodromy_matrix_column_number','var')
    calculated_monodromy_matrix_column_number = 0;
  end
  
  if ~exist('computation_time','var')
    computation_time = 0;
  end
  
  if nargin < 12
    interp_method = 'linear';
  end
    
  msg = sprintf('Расчет мультипликаторов: %d%%%%',round(calculated_monodromy_matrix_column_number*100/(nvar-1)));
  fprintf(msg);
  reverseStr = repmat(sprintf('\b'), 1, length(msg)-1);
  options = odeset(odeset(options,outputopts),'Events',@events);
  
  err = false;
  
  if calculated_monodromy_matrix_column_number >= fixed_var_index
    start_index = calculated_monodromy_matrix_column_number+2;
  else
    start_index = calculated_monodromy_matrix_column_number+1;
  end
  
  figure  
  
  tic  
  for col = start_index:nvar
    if col ~= fixed_var_index
      w0new = w0;
      w0new(col) = w0new(col)+eps;
      if func2str(solver) == 'myode4'
        fprintf('\n');
      end
      [~,wres,~,~,te] = solver(f,tspan,w0new,options);
      if func2str(solver) == 'myode4'
        fprintf('\b');
      end
      
      if length(te) < 2
        err = true;
        break;
      end
      
      if strcmp(func2str(solver),'myode4')
        fprintf('\n');
        [~,wres,~,~,te2] = solver(f,0:(tspan(2)-tspan(1))/100:tspan(end),wres(end-2,:),options);
        fprintf('\b');

        if isempty(te2)
          err = true;
          break;
        end
      end
      
      if col > fixed_var_index
        colout = col-1;
      else
        colout = col;
      end
      
      for row = 1:nvar
        if row ~= fixed_var_index
          wintersect = interp1([wres(end,fixed_var_index),wres(end-1,fixed_var_index),wres(end-2,fixed_var_index),wres(end-3,fixed_var_index)],[wres(end,row),wres(end-1,row),wres(end-2,row),wres(end-3,row)],fixed_var_value,interp_method);
          %wintersect = wres(end,row) - (wres(end,row)-wres(end-1,row))*(wres(end,fixed_var_index)-fixed_var_value)/(wres(end,fixed_var_index)-wres(end-1,fixed_var_index));
          if row > fixed_var_index
            rowout = row-1;
          else
            rowout = row;
          end
          C(rowout,colout) = (wintersect-w0(row))/eps;
        end
      end
      
      elapsedTime = toc;
      computation_time = computation_time+round(elapsedTime);      
      
      calculated_monodromy_matrix_column_number = calculated_monodromy_matrix_column_number+1;
      
      msg = sprintf('Расчет мультипликаторов: %d%%%%',round(calculated_monodromy_matrix_column_number*100/(nvar-1)));
      fprintf([reverseStr, msg]);
      reverseStr = repmat(sprintf('\b'), 1, length(msg)-1);
      
      % Сохранение промежуточных результатов расчета матрицы монодромии
      save(filepath,'C','calculated_monodromy_matrix_column_number','computation_time');
      
      if col ~= nvar
        tic
      end
    end
  end
  fprintf('\n\n');
  
  if ~err    
    rho = sort(eig(C),'descend');
    delete(filepath);
  else
    rho = [];
  end
  
  function [value,isterminal,direction] = events(~,y)
    value = y(fixed_var_index)-fixed_var_value;
    isterminal = 1;
    direction = -1;  
  end
end

