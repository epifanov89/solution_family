function multiplicators_poincare_section_method_PDE_test()
%MULTIPLICATORS_POINCARE_SECTION_METHOD_PDE_TEST Решение
%модели одной популяции жертв и одной популяции хищников 
%с ростом жертв, пропорциональным квадрату плотности популяции
clear all; close all; clc

% Признак совершившегося установления. 
% Присвойте ему true, чтобы рассчитать мультипликаторы
steady = true;

path = mfilename('fullpath');

intermediate_results_file_path = get_intermediate_results_file_path_for_m_file_at_path(path);

% Длина кольца
L = 1;
% Число точек сетки
N = 6;
% Шаг сетки
h = L / N;

% Вектор координат точек сетки
X = zeros(N + 1, 1);
for pt = 1:N + 1
  X(pt) = (pt - 1) * h;
end


% Шаг интегрирования по времени для метода с постоянным шагом
tstep = 0.002;
% Длина временного интервала интегрирования до установления
tlast = 50;
% Временной интервал интегрирования до установления
tspan = 0:tstep:tlast;

% Число популяций жертв
nprey = 1;
% Число популяций хищников
npredator = 1;
nspecies = nprey + npredator;

nvar = nspecies * N;

% Коэффициенты собственного роста / смертности
% популяций
growth = [3; -1];
% Коэффициенты поисковой активности
search_activity = [0.1; 0];
% Коэффициенты диффузии
diffusion_coeffs = [0.2; 0.3];
% Коэффициенты направленной миграции
taxis_coeffs_matrix = [0 0
                       0.4 0];
% Коэффициенты хищничества
species_interaction_coeffs_matrix = [0 -1
                                     2.5  0];

% Индекс средней точки разбиения
center_point_index = fix((N+1)/2);

% Индексы переменных, отвечающих плотностям популяций в средней
% точке ареала
prey_center_point_var_index = center_point_index;
predator_center_point_var_index = N+center_point_index;

% Номера переменных проективной плоскости для фазовых траекторий
first_phas_var_index = prey_center_point_var_index;
second_phas_var_index = predator_center_point_var_index;


% Номер переменной, которая фигурирует в уравнении секущей плоскости
% отображения Пуанкаре
fixed_var_index = prey_center_point_var_index;
% Значение этой переменной в уравнении 
% секущей плоскости отображения Пуанкаре
fixed_var_value = 0.5;

% Вычисляем интегралы от функции, обратной к функции ресурса, на каждом
% шаге сетки
inverse_carrying_capacity_integral_array = compute_integrals();

figure
fplot(@carrying_capacity,[0 L]);
xlabel('x');
ylabel('P(x)');
title('Carrying capacity');


if ~exist(intermediate_results_file_path,'file')
  w0 = zeros(1,nvar);
  for pt = 1:N
    w0(pt) = u10((pt-1)*h);
    w0(N+pt) = u20((pt-1)*h);
  end
else
  load(intermediate_results_file_path,'w0','wpoincareend','T');
end

eps = 1e-2;

dir_separator_indexes = strfind(path,'\');
last_dir_separator_index = dir_separator_indexes(end);
curfiledir = substr(path,0,last_dir_separator_index);
final_results_file_path = get_intermediate_results_file_path_for_m_file_at_dir_with_name(curfiledir,sprintf('multiplicators_test_N=%d_tau=%4.3f_poincare_eps=%f',N,tstep,eps));

solve(w0,intermediate_results_file_path,final_results_file_path,eps);


  % -----------------------------------------------------------------------
  % Nested functions. Problem parameters provided by the outer function.
  %
  
  function solve(w0,intermediate_results_file_path,final_results_file_path,eps)
    if ~steady
      % Сначала просто решаем систему до некоторого момента времени
      figure
      [t,w,tpoincare,wpoincare,~] = ...
          myode4(@f,tspan,w0,...
                 odeset('NonNegative',1:nvar,...
                        'OutputFcn',@odephas2,...
                        'OutputSel',[first_phas_var_index,...
                                     second_phas_var_index]),...
                 fixed_var_index,fixed_var_value);

      w0 = w(end,:);
      wpoincareend = wpoincare(end,:);
      % Находим разницу между последними двумя временами пересечения 
      % секущей плоскости отображения Пуанкаре 
      % (для периодического решения это будет период)
      T = tpoincare(end)-tpoincare(end-2);      
      
      save(intermediate_results_file_path,'w0','wpoincareend','T');

      plot_spatiotemporal_distributions(t,w);
      
      u = w(:,prey_center_point_var_index);
      v = w(:,predator_center_point_var_index);

      figure
      hold on
      h1 = plot(t,u);
      label(h1,'1','location','center');
      h2 = plot(t,v);
      label(h2,'2','location','center');
      xlabel('t');
      ylabel('u, v','rot',0);
      hold off
    else
      multiplicators = multiplicators_poincare_section_method(...
          @f, @myode4, 0:tstep:T, wpoincareend, nvar,...
          intermediate_results_file_path,...
          fixed_var_index,fixed_var_value,eps,...
          odeset('NonNegative',1:nvar),...
          odeset('OutputFcn',@odephas2,...
                 'OutputSel',[first_phas_var_index,...
                              second_phas_var_index]));
                            
      if ~isempty(multiplicators)
        fprintf('Мультипликаторы:\n\n');
        for multiplicator_index = 1:length(multiplicators)
          disp(multiplicators(multiplicator_index));
        end

        save(final_results_file_path,'multiplicators');
      end

      % Решаем систему на времени, кратном предполагаемому периоду, 
      % для построения графика пространственно-временного распределения, 
      % а также для нахождения максимальных плотностей популяций хищников
      figure
      [t,w] = myode4(@f,0:tstep:2*T,w0,...
                     odeset('NonNegative',1:nvar,...
                            'OutputFcn',@odephas2,...
                            'OutputSel',[first_phas_var_index,...
                                         second_phas_var_index]));
  
      plot_spatiotemporal_distributions(t,w);
    end
  end
  % -----------------------------------------------------------------------
  
  % Возвращает значения всех переменных, 
  % соответствующие максимуму переменной с переданным номером
  function wmax = get_max_point_densities(w, varindex)
    nspeciesofinterest = length(idxSpecies);

    % Сначала двигаемся, пока значения плотностей в точке не начнут расти.    
    grows = false;    
    timept = 2;
    
    while ~grows
      wprev = w(timept-1,:);
      for species = 1:nspeciesofinterest
        if w(timept,varindex) >= wprev(varindex)
          grows = true;
        end        
      end      
      timept = timept+1;
    end
    
    % Теперь двигаемся, пока значения плотностей не начнут убывать. 
    % Это будет означать, что мы достигли максимума.
    sz = size(w);
    
    while timept <= sz(1) && grows
      wmax = w(timept-1,:);
      
      for species = 1:nspeciesofinterest
        if w(timept,varindex) < wmax(varindex)
          grows = false;
          break;
        end
      end
      
      timept = timept+1;
    end
  end
  % -----------------------------------------------------------------------
  
  function plot_spatial_distributions(w0)
    % Plot of the initial conditions        
    w01 = zeros(N + 1, nspecies);
    for i = 1:nspecies
      w01(1:N, i) = w0((i - 1) * N + 1:i * N);
      w01(N + 1, i) = w01(1, i);
    end

    plot(x, w01)    
    xlabel('\xi')
    ylabel('u(\xi, 0)')
    title('Initial distributions')
  end
  % -----------------------------------------------------------------------
  
  function rho = calculate_multiplicators(w,tspan,solver,options,outputopts)
    fprintf('\n');
    tic
    rho = monodromy_matrix_poincare_section_method(@f,solver,tspan,w,nvar,...
                                                 filepath,...
                                                 fixed_var_index,...
                                                 fixed_var_value,...
                                                 options,outputopts);
    elapsedTime = toc;
    fprintf('\nВычисление мультипликаторов завершено за %d секунд\n',round(elapsedTime));
  end

  % -----------------------------------------------------------------------
  
  function inverse_carrying_capacity_integral_array = compute_integrals()
    inverse_carrying_capacity_integral_array = zeros(1, N);

    for point_index = 1:N
      % Рассчитываем координату текущей точки сетки
      xcur = (point_index - 1) * h;
      % Рассмотрим текущую точку основной сетки
      % Рассмотрим две соседние с ней точки вспомогательной сетки
      xstart = xcur - h/2;
      xend = xcur + h/2;
      % И рассмотрим отрезок, заключенный между этими двумя точками
      % Найдем интеграл от функции, обратной к функции ресурса, по этому
      % отрезку
      inverse_carrying_capacity_integral_array(point_index) = integral(@(x) carrying_capacity(x).^(-1), xstart, xend) / h;
    end
  end

  % -----------------------------------------------------------------------
  
  function plot_spatiotemporal_distributions(t,w)    
    sz = size(w);
    nrow = sz(1);

    wres = zeros(nrow, N + 1, nspecies);

    for species_index = 1:nspecies
      for point_index = 1:N
        for time_moment_index = 1:nrow
          wres(time_moment_index, point_index, species_index) = w(time_moment_index, (species_index - 1) * N + point_index);
        end
      end
      wres(:, N + 1, species_index) = wres(:, 1, species_index);
    end
  
    for species_index = 1:nspecies
      figure
      gr = surf(X, t, wres(:,:,species_index));
      if species_index == 1
        zlabel('u')
      elseif species_index == 2
        zlabel('v_1')
      else
        zlabel('v_2')
      end
      xlabel('x')
      ylabel('t')
      % Раскомментировать, чтобы убрать черные линии
      set(gr, 'LineStyle', 'none')
    end
  end
  
  % -----------------------------------------------------------------------

  function plot_phase_portrait_projections(w)      
    figure
    plot(w(prey_center_point_var_index),w(first_predator_center_point_var_index));
    xlabel('u')
    ylabel('v_1')
    figure
    plot(w(prey_center_point_var_index),w(second_predator_center_point_var_index));
    xlabel('u')
    ylabel('v_2')
    figure
    plot(w(first_predator_center_point_var_index),w(second_predator_center_point_var_index));
    xlabel('v_1')
    ylabel('v_2')
  end

  % -----------------------------------------------------------------------
  
  function plot_phase_trajectories(solutions)
    % Выводит проекции фазовых траекторий из разных начальных данных на 
    % одном графике
    sz = size(solutions);
    nsol = sz(2);
    figure
    hold on    
    for sol_index = 1:nsol
      solution = solutions{sol_index};
      plot(solution(:,1),solution(:,2));
    end
    hold off
  end

  % -----------------------------------------------------------------------

  function P = carrying_capacity( x )
  % Carrying capacity function
    %P = 0.05 + 0.2*exp(-50*(x - L/4)^2) + 0.1*exp(-50*(x - 3*L/4)^2);
    %P = exp(x/2*sin(3*pi*x/L)) + 0.1;
    %if (x < L/2) 
    %  P = 0.1*sin((x-L/8)*2*pi) + 0.15;
    %else
    %  P = 0.05*sin((x-L/8)*2*pi) + 0.1;
    %end
    P = 1+0.2*exp(-0.0*x/L).*sin(2*pi*x/L);
  end
  % -----------------------------------------------------------------------
  
  function u = u10( x )
    if x >= 0 && x <= 0.4*L
      u = 0.2*sin(x*pi/0.4/L);
    else
      u = 0;
    end
  end
  % -----------------------------------------------------------------------
  
  function u = u20( x )
    if x >= L/2 && x <= 0.9*L
      u = max(0, 0.2*sin((x-L/2)*pi/0.4/L));
    else
      u = 0;
    end
  end
  % -----------------------------------------------------------------------
  
  function [value,isterminal,direction] = events(t,y)
    value = y(fixed_var_index)-fixed_var_value;
    isterminal = 0;
    direction = 0;
  end
  % -----------------------------------------------------------------------

  function status = poincare_map_iteration( t, w, flag )  
    global w_prev t_prev
    
    if ~strcmp(flag, 'init') && ~strcmp(flag, 'done')
      tf = t(end);
      wf = w(:, end);
        
      if ~isempty(w_prev) && sign(wf(fixed_var_index) - fixed_var_value) ~= sign(w_prev(fixed_var_index) - fixed_var_value)        
        w_poincare = zeros(1, nvar);
        w_poincare(fixed_var_index) = fixed_var_value;
        for var_index = 1:nvar
          if var_index ~= fixed_var_index
            w_poincare(var_index) = wf(var_index) - (wf(var_index) - w_prev(var_index)) * (wf(fixed_var_index) - fixed_var_value) / (wf(fixed_var_index) - w_prev(fixed_var_index));
          end
        end
        
        t_poincare = tf - (tf - t_prev) * (wf(fixed_var_index) - fixed_var_value) / (wf(fixed_var_index) - w_prev(fixed_var_index));
      
        sz_poincare = size(poincare_points);
        npoincare = sz_poincare(1);
        
        if npoincare > 1
          distance = euclidian_norm(w_poincare, poincare_points(end - 1, :));
          if distance < eps
            status = 1;
            isperiodic = true;
          end
        end
        
        are_zeros = true;
        if npoincare == 1
          for var_index = 1:nvar
            if poincare_points(1, var_index) > 0
              are_zeros = false;
            end
          end
        end
        
        if npoincare > 0 && (npoincare > 1 || ~are_zeros)
          poincare_times = [poincare_times, t_poincare];
          poincare_points(npoincare + 1, :) = w_poincare;
        else
          poincare_times(1) = t_poincare;
          poincare_points(1, :) = w_poincare;
        end
      end
      
      w_prev = wf;
      t_prev = tf;
    end 
    
    if ~strcmp(flag, 'done')
      sz = size(w);
      w_phas = zeros(2, sz(2));
      w_phas(1, :) = w(first_oscillating_var_index, :);
      w_phas(2, :) = w(second_oscillating_var_index, :);
    else
      w_phas = w;
    end
    
    if ~isperiodic
      status = odephas2(t, w_phas, flag);
    else
      odephas2(t, w_phas, flag);
    end
  end
  % -----------------------------------------------------------------------
  
  function mu = growth_fcn( w )
    mu = zeros(1, nspecies);
    for cur_species_index = 1:nprey
      mu(cur_species_index) = growth(cur_species_index) * w;
    end
    for cur_species_index = nprey + 1:nspecies
      mu(cur_species_index) = growth(cur_species_index);
    end
  end
  % -----------------------------------------------------------------------
  
  function dwdt = f( ~, w )
    dwdt = right_parts_of_equations( w, nprey, npredator, X, @growth_fcn, search_activity, diffusion_coeffs, taxis_coeffs_matrix, species_interaction_coeffs_matrix, @carrying_capacity, inverse_carrying_capacity_integral_array );
  end
  % -----------------------------------------------------------------------  
  
  function dwdt = g( ~, w, basis_vector_index )
    dwdt = linearized_system( w, basis_vector_index, nprey, npredator, X, growth, search_activity, diffusion_coeffs, taxis_coeffs_matrix, species_interaction_coeffs_matrix, @carrying_capacity, inverse_carrying_capacity_integral_array );
  end
  % -----------------------------------------------------------------------

  function dwdt = gg( ~, w, basis_vector_index )
    dwdt = zeros(nvar, 1);
      
    for cur_species_index = 1:nspecies
      cur_species_offset = (cur_species_index - 1) * N;
      
      for cur_point_index = 1:N
        prev_point_index = mod(cur_point_index + N - 2, N) + 1;
        next_point_index = mod(cur_point_index, N) + 1;
          
        cur_species_prev_point_var_index = cur_species_offset + prev_point_index;
        cur_species_cur_point_var_index = cur_species_offset + cur_point_index;
        cur_species_next_point_var_index = cur_species_offset + next_point_index;
        
        sum_1 = 0;
        sum_2 = 0;
        sum_3 = 0;
        sum_4 = 0;
        sum_5 = 0;
        sum_6 = 0;
        sum_7 = 0;
        sum_8 = 0;
        for another_species_index = 1:nspecies
          another_species_offset = (another_species_index - 1) * N;
            
          another_species_prev_point_var_index = another_species_offset + prev_point_index;
          another_species_cur_point_var_index = another_species_offset + cur_point_index;
          another_species_next_point_var_index = another_species_offset + next_point_index;
            
          sum_1 = sum_1 + taxis_coeffs_matrix(cur_species_index, another_species_index) * (w(cur_species_next_point_var_index) * w(N * nspecies * basis_vector_index + another_species_next_point_var_index) + w(N * nspecies * basis_vector_index + cur_species_next_point_var_index) * w(another_species_next_point_var_index));
          sum_2 = sum_2 + taxis_coeffs_matrix(cur_species_index, another_species_index) * (w(cur_species_next_point_var_index) * w(N * nspecies * basis_vector_index + another_species_cur_point_var_index) + w(N * nspecies * basis_vector_index + cur_species_next_point_var_index) * w(another_species_cur_point_var_index));
          sum_3 = sum_3 + taxis_coeffs_matrix(cur_species_index, another_species_index) * (w(cur_species_cur_point_var_index) * w(N * nspecies * basis_vector_index + another_species_next_point_var_index) + w(N * nspecies * basis_vector_index + cur_species_cur_point_var_index) * w(another_species_next_point_var_index));        
          sum_4 = sum_4 + taxis_coeffs_matrix(cur_species_index, another_species_index) * (w(cur_species_cur_point_var_index) * w(N * nspecies * basis_vector_index + another_species_cur_point_var_index) + w(N * nspecies * basis_vector_index + cur_species_cur_point_var_index) * w(another_species_cur_point_var_index));
          sum_5 = sum_5 + taxis_coeffs_matrix(cur_species_index, another_species_index) * (w(cur_species_cur_point_var_index) * w(N * nspecies * basis_vector_index + another_species_prev_point_var_index) + w(N * nspecies * basis_vector_index + cur_species_cur_point_var_index) * w(another_species_prev_point_var_index));
          sum_6 = sum_6 + taxis_coeffs_matrix(cur_species_index, another_species_index) * (w(cur_species_prev_point_var_index) * w(N * nspecies * basis_vector_index + another_species_cur_point_var_index) + w(N * nspecies * basis_vector_index + cur_species_prev_point_var_index) * w(another_species_cur_point_var_index));
          sum_7 = sum_7 + taxis_coeffs_matrix(cur_species_index, another_species_index) * (w(cur_species_prev_point_var_index) * w(N * nspecies * basis_vector_index + another_species_prev_point_var_index) + w(N * nspecies * basis_vector_index + cur_species_prev_point_var_index) * w(another_species_prev_point_var_index));
          sum_8 = sum_8 + species_interaction_coeffs_matrix(cur_species_index, another_species_index) * (w(cur_species_cur_point_var_index) * w(N * nspecies * basis_vector_index + another_species_cur_point_var_index) + w(N * nspecies * basis_vector_index + cur_species_cur_point_var_index) * w(another_species_cur_point_var_index));
        end
        
        % Рассчитываем координату текущей точки сетки
        xcur = (cur_point_index - 1) * h;
        
        factor = 1;
        if cur_species_index <= nprey
          % Вычисляем интеграл от обратной к функции ресурса функции по
          % промежутку, заключенному между соседними с текущей точкой
          % основной сетки точками вспомогательной сетки
          inverse_carrying_capacity_integral = integral(@(x) carrying_capacity(x).^(-1), xcur - h/2, xcur + h/2) / h;
            
          factor = 2 * w(cur_species_cur_point_var_index) - 3 * inverse_carrying_capacity_integral * w(cur_species_cur_point_var_index)^2;
        end
        
        % Рассчитываем координаты предыдущей, текущей и следующей точек сетки
        xprev = (prev_point_index - 1) * h;
        xcur = (cur_point_index - 1) * h;
        xnext = (next_point_index - 1) * h;
        
        carrying_capacity_taxis_prev = 0;
        carrying_capacity_taxis_cur = 0;
        carrying_capacity_taxis_next = 0;
      
        if search_activity(cur_species_index) ~= 0          
          % Вычисляем интеграл от функции ресурса по промежутку,
          % заключенному между соседними с предыдущей точкой основной сетки
          % точками вспомогательной сетки
          carrying_capacity_integral = integral(@carrying_capacity, xprev - h/2, xprev + h/2) / h;
          
          % Вычисляем таксис (направленную миграцию), вызванный
          % неравномерностью ресурса, в предыдущей точке
          carrying_capacity_taxis_prev = search_activity(cur_species_index) * carrying_capacity_integral;
                    
          % Вычисляем интеграл от функции ресурса по промежутку,
          % точками вспомогательной сетки
          carrying_capacity_integral = integral(@carrying_capacity, xcur - h/2, xcur + h/2) / h;
          
          % Вычисляем таксис (направленную миграцию), вызванный
          % неравномерностью ресурса, в текущей точке
          carrying_capacity_taxis_cur = search_activity(cur_species_index) * carrying_capacity_integral;
            
          % Вычисляем интеграл от функции ресурса по промежутку,
          % заключенному между соседними со следующей точкой основной сетки
          % точками вспомогательной сетки
          carrying_capacity_integral = integral(@carrying_capacity, xnext * h - h/2, xnext * h + h/2) / h;
          
          % Вычисляем таксис (направленную миграцию), вызванный
          % неравномерностью ресурса, в следующей точке
          carrying_capacity_taxis_next = search_activity(cur_species_index) * carrying_capacity_integral;
        end
        
        dwdt(cur_species_cur_point_var_index) = diffusion_coeffs(cur_species_index) * (w(nvar * basis_vector_index + cur_species_next_point_var_index) - 2 * w(nvar * basis_vector_index + cur_species_cur_point_var_index) + w(nvar * basis_vector_index + cur_species_prev_point_var_index)) / h^2 + ((- sum_1 + sum_2 - sum_3 - sum_5 + sum_6 - sum_7) / 2 + sum_4) / h^2 - (w(nvar * basis_vector_index + cur_species_next_point_var_index) + w(nvar * basis_vector_index + cur_species_cur_point_var_index)) * carrying_capacity_taxis_next / 2 / h^2 + (w(nvar * basis_vector_index + cur_species_next_point_var_index) + 2 * w(nvar * basis_vector_index + cur_species_cur_point_var_index) + w(nvar * basis_vector_index + cur_species_prev_point_var_index)) * carrying_capacity_taxis_cur / 2 / h^2 - (w(nvar * basis_vector_index + cur_species_cur_point_var_index) + w(nvar * basis_vector_index + cur_species_prev_point_var_index)) * carrying_capacity_taxis_prev / 2 / h^2 + mu(cur_species_index) * factor * w(nvar * basis_vector_index + cur_species_cur_point_var_index) + sum_8;
      end
    end
  end

end