function multiplicators_poincare_section_method_test()
%MULTIPLICATORS_POINCARE_SECTION_METHOD_TEST Тестирование метода вычисления
%мультипликаторов с помощью секущей плоскости отображения Пуанкаре
%   Detailed explanation goes here
clear all; close all; clc

% Признак совершившегося установления. 
% Присвойте ему true, чтобы рассчитать мультипликаторы
steady = true;

filepath = get_intermediate_results_file_path(mfilename('fullpath'));

% Шаг интегрирования по времени
tstep = 0.001;
% Длина временного интервала интегрирования до установления
tlast = 30;
% Временной интервал интегрирования до установления
tspan = 0:tstep:tlast;

% Величина, обратная постоянной функции ресурса
beta = 1;

% Число популяций жертв
nprey = 1;
% Число популяций хищников
npredator = 2;

nspecies = nprey + npredator;

% Коэффициенты собственного роста / смертности популяций
mu = [3; -1; -0.8];
% Коэффициенты хищничества
species_interaction_coeffs_matrix = [0   -1 -1
                                     2.5  0  0
                                     2    0  0];

first_phas_var_index = 1;
second_phas_var_index = 2;

% Номер переменной, которая фигурирует в уравнении секущей плоскости
% отображения Пуанкаре
fixed_var_index = 1;
% Значение этой переменной в уравнении 
% секущей плоскости отображения Пуанкаре
fixed_var_value = 0.4;
                                   
if ~exist(filepath,'file')
  % Начальные данные
  w0 = zeros(1, nspecies);
  w0(1) = 1;
  w0(2) = 0.6;
  w0(3) = 0.6;
else
  load(filepath,'w0','wpoincareend');
  if steady
    load(filepath,'T');
  end
end

if ~steady
  figure
  [t,w,tpoincare,wpoincare] = ...
      myode4(@f, tspan, w0,... 
             odeset('OutputFcn', @odephas2, 'OutputSel', [first_phas_var_index,second_phas_var_index]),...
             fixed_var_index, fixed_var_value);

  w0 = w(end,:);
  if (wpoincare(end,second_phas_var_index) > wpoincare(end-1,second_phas_var_index))
    wpoincareend = wpoincare(end,:);
  else
    wpoincareend = wpoincare(end-1,:);
  end
  
  isperiodic = is_solution_periodic();

  save(filepath,'w0','wpoincareend');
  
  if isperiodic
    fprintf('Решение периодическое\n');
    % Находим период
    T = tpoincare(end) - tpoincare(end - 2);
    % И сохраняем его значение в файл
    save(filepath,'T','-append');
  else
    fprintf('Решение не периодическое\n');
  end

  for i = 1:nspecies
    figure
    plot(t,w(:, i));
  end
else  
  M = monodromy_matrix_one_system_for_each_column(@f, @g, @myode4, 0:tstep:T, wpoincareend, nspecies,...
                   odeset('NonNegative',1:nspecies), odeset('OutputFcn',@odephas2,'OutputSel',[first_phas_var_index,second_phas_var_index]));
  rho = eig(M);
  fprintf('Мультипликаторы:\n');
  for rho_index = 1:length(rho)
    disp(rho(rho_index));
  end
  fprintf('\n\n');
  
  tic
  M = monodromy_matrix_poincare_section_method(@f, @myode4, tspan, wpoincareend, nspecies, fixed_var_index, fixed_var_value,...
                 odeset('NonNegative',1:nspecies), odeset('OutputFcn',@odephas2,'OutputSel',[first_phas_var_index,second_phas_var_index]));
  rho = eig(M);
  elapsedTime = toc;
  fprintf('Мультипликаторы:\n');
  for rho_index = 1:length(rho)
    disp(rho(rho_index));
  end
  fprintf('\nВычисление мультипликаторов завершено за %d секунд\n',round(elapsedTime));
end

  % -----------------------------------------------------------------------
  % Nested functions. Problem parameters provided by the outer function.
  %
  
  % Определяет, является ли решение периодическим
  function periodic = is_solution_periodic()
    sz = size(ypoincare);
    npoints = sz(1);    
    % Кратность цикла
    cycle_multiplicity = 2;
    if npoints <= cycle_multiplicity
      periodic = false;
    else
      periodic = true;
      poincare_point_index = npoints;
      eps = 1e-2;
      
      while poincare_point_index > cycle_multiplicity && periodic
        point1 = ypoincare(poincare_point_index, :);
        point2 = ypoincare(poincare_point_index - cycle_multiplicity, :);
        if euclidian_norm(point1, point2) >= eps
          periodic = false;
        end
        poincare_point_index = poincare_point_index - cycle_multiplicity;
      end
    end
  end
  
  function status = poincare_map_iteration( t, w, flag )  
    global w_prev t_prev
    
    if ~strcmp(flag, 'init') && ~strcmp(flag, 'done')
      tf = t(1, end);
      wf = w(:, end);
    
      sz = size(w_prev);
      
      if sz(2) == 1 && sign(wf(fixed_var_index) - fixed_var_value) ~= sign(w_prev(fixed_var_index) - fixed_var_value)
        w_asterisk = zeros(1, nspecies);
        w_asterisk(fixed_var_index) = fixed_var_value;
        for var_index = 1:nspecies
          if var_index ~= fixed_var_index
            w_asterisk(var_index) = wf(var_index) - (wf(var_index) - w_prev(var_index)) * (wf(fixed_var_index) - fixed_var_value) / (wf(fixed_var_index) - w_prev(fixed_var_index));
          end
        end

        t_asterisk = tf - (tf - t_prev) * (wf(fixed_var_index) - fixed_var_value) / (wf(fixed_var_index) - w_prev(fixed_var_index));

        sz_poincare = size(poincare_points);
        npoincare = sz_poincare(1);
        if npoincare ~= 0     
          poincare_times = [poincare_times, t_asterisk];
          poincare_points(npoincare + 1, :) = w_asterisk;
        else
          poincare_times(1) = t_asterisk;
          poincare_points(1, :) = w_asterisk;
        end
      end
      
      w_prev = wf;
      t_prev = tf;
    end    
    
    if ~strcmp(flag, 'done')
      sz = size(w);
      w_phas = zeros(2, sz(2));
      w_phas(1, :) = w(1, :);
      w_phas(2, :) = w(3, :);
    else
      w_phas = w;
    end
    status = odephas2(t, w_phas, flag);
  end
  % -----------------------------------------------------------------------
  
  function dwdt = f( ~, w )
    dwdt = zeros(nspecies, 1);
      
    f0 = 1 - beta * w(1);
    dwdt(1) = mu(1) * w(1) ^ 2 * f0 + species_interaction_coeffs_matrix(1, 2) * w(1) * w(2) + species_interaction_coeffs_matrix(1, 3) * w(1) * w(3);
    dwdt(2) = mu(2) * w(2) + species_interaction_coeffs_matrix(2, 1) * w(1) * w(2);
    dwdt(3) = mu(3) * w(3) + species_interaction_coeffs_matrix(3, 1) * w(1) * w(3);
  end
  % -----------------------------------------------------------------------
  
  function J = g( ~, w )
    J(1, 1) = mu(1) * (2 * w(1) - 3 * beta * w(1) ^ 2) + species_interaction_coeffs_matrix(1, 2) * w(2) + species_interaction_coeffs_matrix(1, 3) * w(3);
    J(1, 2) = species_interaction_coeffs_matrix(1, 2) * w(1);
    J(1, 3) = species_interaction_coeffs_matrix(1, 3) * w(1);
    
    J(2, 1) = species_interaction_coeffs_matrix(2, 1) * w(2);
    J(2, 2) = mu(2) + species_interaction_coeffs_matrix(2, 1) * w(1);
    J(2, 3) = 0;
    
    J(3, 1) = species_interaction_coeffs_matrix(3, 1) * w(3);
    J(3, 2) = 0;
    J(3, 3) = mu(3) + species_interaction_coeffs_matrix(3, 1) * w(1);
  end
  % -----------------------------------------------------------------------
  
  %function dwdt = g( ~, w, basis_vector_index )
  %  dwdt(1) = (2 * w(1) - 3 * beta * w(1)^2 + species_interaction_coeffs_matrix(1, 3) * w(3)) * w(basis_vector_index * nspecies + 1) + species_interaction_coeffs_matrix(1, 3) * w(1) * w((basis_vector_index + 1) * nspecies);    
  %  dwdt(2) = (2 * w(2) - 3 * beta * w(2)^2 + species_interaction_coeffs_matrix(2, 3) * w(3)) * w(basis_vector_index * nspecies + 2) + species_interaction_coeffs_matrix(2, 3) * w(2) * w((basis_vector_index + 1) * nspecies);    
  %  dwdt(3) = species_interaction_coeffs_matrix(3, 1) * w(3) * (w(basis_vector_index * nspecies + 1) + w(basis_vector_index * nspecies + 2)) + (mu(3) + species_interaction_coeffs_matrix(3, 1) * w(1) + species_interaction_coeffs_matrix(3, 2) * w(2)) * w((basis_vector_index + 1) * nspecies);
  %end
  % -----------------------------------------------------------------------

end