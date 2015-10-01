function family_of_cycles()
%FAMILY_OF_CYCLES Построение нескольких циклов семейства для модели одной
%популяции жертвы и двух популяций хищника с ростом жертв, 
%пропорциональным квадрату плотности популяции
%   Detailed explanation goes here
clear all; close all; clc

% Измените, чтобы поменять длину кольца
L = 1;
% Измените, чтобы поменять число точек сетки
N = 24;
h = L / N;
% Шаг интегрирования по времени для метода с постоянным шагом
tstep = 0.001;
% Длина временного интервала интегрирования до установления
tlast = 100;
% Временной интервал интегрирования до установления
tspan = 0:tstep:tlast;

X = zeros(N + 1, 1);
for pt = 1:N + 1
  X(pt) = (pt - 1) * h;
end

% Число популяций жертв
nprey = 1;
% Число популяций хищников
npredator = 2;
nspecies = nprey + npredator;

nvar = nspecies * N;

% Коэффициенты собственного роста / смертности
% популяций
growth = [3; -1; -0.8];
% Коэффициенты поисковой активности
search_activity = [1; 0; 0];
% Коэффициенты диффузии
diffusion_coeffs = [0.2; 0.3; 0.24];
% Коэффициенты направленной миграции
taxis_coeffs_matrix = [0 0 0
                       0.4 0 0
                       0.32 0 0];
% Коэффициенты хищничества
species_interaction_coeffs_matrix = [0 -1 -1
                                     2.5  0  0
                                     2  0  0];
% Номера выводимых решений
idxSolutions = [5,9];
                                  

% Число точек разбиения семейства
nexp = 10;
wpredatormax = zeros(2, nexp);

% Индекс средней точки разбиения
center_point_index = fix((N+1)/2);

% Индексы переменных, отвечающих плотностям популяций в средней
% точке ареала
prey_center_point_var_index = center_point_index;
first_predator_center_point_var_index = N+center_point_index;
second_predator_center_point_var_index = 2*N+center_point_index;

% Индекс первой переменной проективной плоскости для фазовых траекторий
first_phas_var_index = prey_center_point_var_index;

fixed_var_index = prey_center_point_var_index;
fixed_var_value = 0.5;
eps = 1e-4;

% Вычисляем интегралы от функции, обратной к функции ресурса, на каждом
% шаге сетки
inverse_carrying_capacity_integral_array = compute_integrals();

figure
fplot(@carrying_capacity,[0 L]);
xlabel('x');
ylabel('P(x)');
title('Carrying capacity');


wdistribution_all = cell(1,length(idxSolutions));
wtrajectory_all = cell(1,length(idxSolutions));
T_all = zeros(1,nexp);
t_all = cell(1,length(idxSolutions));


% Решаем систему для начальных данных, при которых плотность первой популяции 
% хищников положена равной нулю

% Индекс второй переменной проективной плоскости для фазовых траекторий
second_phas_var_index = second_predator_center_point_var_index;

w0 = zeros(1,nvar);
for pt = 1:N
  w0(pt) = u10((pt-1)*h);
  w0(N+pt) = 0;
  w0(2*N+pt) = u20((pt-1)*h);
end

solve(w0, 1);


% Решаем систему для начальных данных, при которых плотность второй популяции 
% хищников положена равной нулю

% Индекс второй переменной проективной плоскости для фазовых траекторий
second_phas_var_index = first_predator_center_point_var_index;

w0 = zeros(1,nvar);
for pt = 1:N
  w0(pt) = u10((pt-1)*h);
  w0(N+pt) = u20((pt-1)*h);
  w0(2*N+pt) = 0;
end

solve(w0,nexp);


% Индекс второй переменной проективной плоскости для фазовых траекторий
second_phas_var_index = first_predator_center_point_var_index;

predator1vals = linspace(0,wpredatormax(1,nexp),nexp);
predator2vals = linspace(0,wpredatormax(2,1),nexp);

w0 = zeros(1,nvar);

for experiment = 2:nexp-1  
  predator1 = predator1vals(experiment);
  predator2 = predator2vals(nexp-experiment+1);
  for pt = 1:N
    w0(pt) = u10((pt-1)*h);
    w0(N+pt) = predator1;
    w0(2*N+pt) = predator2;
  end
  
  solve(w0, experiment);
end

for sol = 1:length(idxSolutions)
  plot_spatiotemporal_distributions(t_all{sol},wdistribution_all{sol});
  plot_phase_portrait_projections(wdistribution_all{sol});
end


plot_max_space_point_densities();


% Измените, чтобы поменять временной интервал интегрирования для графика
% установления
tspangraph = [0,500];

for sol = 1:length(idxSolutions)
  experiment = idxSolutions(sol);
  predator1 = predator1vals(experiment);
  predator2 = predator2vals(nexp-experiment+1);
  for pt = 1:N
    w0(pt) = u10((pt-1)*h);
    w0(N+pt) = predator1;
    w0(2*N+pt) = predator2;
  end

  [t,w] = ode15s(@f,tspangraph,w0,...
                 odeset('NonNegative',1:nvar,'RelTol',1e-6,'AbsTol',1e-9));

  v1 = w(:,N+max_carrying_capacity_point_index);
  v2 = w(:,2*N+max_carrying_capacity_point_index);

  figure
  hold on
  h1 = plot(t,v1);
  label(h1,'1','location','center');
  h2 = plot(t,v2);
  label(h2,'2','location','center');
  xlabel('t');
  ylabel('v_1, v_2','rot',0);
  hold off
end

% Вывод графика зависимости периода от номера на семействе
plot_solution_periods(T_all);


  % -----------------------------------------------------------------------
  % Nested functions. Problem parameters provided by the outer function.
  %
  
  function solve(w0,experiment)
    % Сначала просто решаем систему до некоторого момента времени
    [~,w,te,~,~] = ...
        myode4(@f,tspan,w0,...
               odeset('NonNegative',1:nvar,...
                      'OutputFcn',@odephas2,...
                      'OutputSel',[first_phas_var_index,...
                                   second_phas_var_index]),...
               fixed_var_index,fixed_var_value);
      
    % Находим разницу между последними двумя временами пересечения секущей
    % плоскости отображения Пуанкаре (для периодического решения это будет период)
    T = te(end)-te(end-2);
    T_all(experiment) = T;
    
    %figure
    %ode15s(@f,tspan,w(end,:),...
    %       odeset('NonNegative',1:nvar,'OutputFcn',@odephas2,...
    %              'OutputSel',[first_phas_var_index,second_phas_var_index]));

    sol = find(idxSolutions == experiment);
    if sol      
      fprintf('Номер на семействе: %d\n\n',experiment);
      % Рассчитываем мультипликаторы (только для интересующих решений)
      figure
      calculate_multiplicators(w(end,:),0:tstep:T,@myode4,odeset('NonNegative',1:nvar),...
                               odeset('OutputFcn',@odephas2,...
                                      'OutputSel',[first_phas_var_index,second_phas_var_index]));
      if sol ~= length(idxSolutions)
        fprintf('\n\n');
      end
    end

    % Решаем систему на времени, кратном предполагаемому периоду, 
    % для построения графика пространственно-временного распределения, 
    % а также для нахождения максимальных плотностей популяций хищников
    figure
    [t,w] = ode15s(@f,[0 2*T],w(end,:),...
             odeset('NonNegative',1:nvar,'RelTol',1e-6,'AbsTol',1e-9,'OutputFcn',@odephas2,...
                    'OutputSel',[first_oscillating_var_index,second_oscillating_var_index]));

    if sol      
      t_all{sol} = t;
      wdistribution_all{sol} = w;
      wtrajectory_all{sol} = w;
    end
    
    wmax = get_max_point_densities(w,second_predator_center_point_var_index);
    wpredatormax(:,experiment) = wmax(idxOutputSpecies);
    
    %if sol      
    %  [t,w] = ode15s(@f,[0 T],w(end,:),...
    %                 odeset('NonNegative',1:nvar));
    %  wtrajectory_all{sol} = w;
    %end
  end
  % -----------------------------------------------------------------------
  
  % Возвращает значения всех переменных, 
  % соответствующие максимуму переменной с переданным номером
  function wmax = get_max_point_densities(w, varindex)
    % Сначала двигаемся, пока значения плотностей в точке не начнут расти.    
    grows = false;    
    timept = 2;
    
    while ~grows
      wprev = w(timept-1,:);
      if w(timept,varindex) >= wprev(varindex)
        grows = true;
      end  
      timept = timept+1;
    end
    
    % Теперь двигаемся, пока значения плотностей не начнут убывать. 
    % Это будет означать, что мы достигли максимума.
    sz = size(w);
    
    while timept <= sz(1) && grows
      wmax = w(timept-1,:);
      
      if w(timept,varindex) < wmax(varindex)
        grows = false;
        break;
      end
      
      timept = timept+1;
    end
  end
  % -----------------------------------------------------------------------
  
  function plot_max_space_point_densities()
    % Вывод максимумов значений плотностей популяций в точке ареала
    figure
    hold on
    xlabel('V_1');
    ylabel('V_2','rot',0);
    plot(wpredatormax(1,:),wpredatormax(2,:),'o-');


    % Вывод графиков установления на плоскости значений
    % плотностей популяций в точке ареала
    for sol = 1:length(idxSolutions)
      w = wtrajectory_all{sol};

      v1phasetrajectory = w(:,N+max_carrying_capacity_point_index);
      v2phasetrajectory = w(:,2*N+max_carrying_capacity_point_index);

      v1phasetrajectorytomin = v1phasetrajectory(1);
      v2phasetrajectorytomin = v2phasetrajectory(1);
      declines = true;
      timept = 2;
      while timept <= sz(1) && declines
        if v1phasetrajectory(timept) <= v1phasetrajectory(timept-1) && v2phasetrajectory(timept) <= v2phasetrajectory(timept-1)
          v1phasetrajectorytomin = [v1phasetrajectorytomin; v1phasetrajectory(timept)];
          v2phasetrajectorytomin = [v2phasetrajectorytomin; v2phasetrajectory(timept)];
        else
          declines = false;
        end
        timept = timept+1;
      end

      l = plot(v1phasetrajectorytomin,v2phasetrajectorytomin,'--');
      label(l,char('A'+sol-1),'location','center');
    end
  end
  % -----------------------------------------------------------------------
  
  % Вывод графика зависимости периода от номера на семействе
  function plot_solution_periods(T)
    figure
    plot(linspace(0,1,length(T)),T);
    xlabel('\theta');
    ylabel('T','rot',0);
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
  
  function calculate_multiplicators(w,tspan,solver,options,outputopts)
    fprintf('\n');
    tic
    M = monodromy_matrix_one_system_for_each_column(@f, @g, solver, tspan, w, nvar,...
                   options,outputopts);
    rho = sort(eig(M),'descend');
    elapsedTime = toc;
    fprintf('Мультипликаторы:\n\n');
    for rho_index = 1:length(rho)
      disp(rho(rho_index));
    end
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
      gr = surf(x, t, wres(:,:,species_index));
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
      %set(gr, 'LineStyle', 'none')
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
    P = 1+0.01*exp(-0.0*x/L).*sin(2*pi*x/L);
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
    dwdt = right_parts_of_equations( w, nprey, npredator, N, h, @growth_fcn, search_activity, diffusion_coeffs, taxis_coeffs_matrix, species_interaction_coeffs_matrix, @carrying_capacity, inverse_carrying_capacity_integral_array );
  end
  % -----------------------------------------------------------------------  
  
  function dwdt = g( ~, w, basis_vector_index )
    dwdt = linearized_system( w, basis_vector_index, nprey, npredator, N, h, growth, search_activity, diffusion_coeffs, taxis_coeffs_matrix, species_interaction_coeffs_matrix, @carrying_capacity, inverse_carrying_capacity_integral_array );
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