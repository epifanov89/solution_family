function predator_prey_nonuniform_resource()
%PREDATOR_PREY_NONUNIFORM_RESOURCE Модель взаимодействия одной популяции
%жертвы и одной популяции хищника с ростом жертв, пропорциональным квадрату 
%плотности популяции, при неоднородной функции ресурса
%   Detailed explanation goes here
clear all; close all; clc

% Признак установления. Присвойте ему true, чтобы рассчитать
% мультипликаторы и вывести графики пространственно-временного распределения
steady = false;

% Измените, чтобы поменять длину кольца
L = 1;
% Измените, чтобы поменять временной интервал первоначального интегрирования
tspan = [0,100];
% Измените, чтобы поменять число точек сетки
N = 36;
h = L / N;

X = zeros(N + 1, 1);
for pt = 1:N + 1
  X(pt) = (pt - 1) * h;
end

% Измените, чтобы поменять число популяций жертв
nprey = 1;
% Измените, чтобы поменять число популяций хищников
npredator = 2;
nspecies = nprey + npredator;

nvar = nspecies * N;

% Измените, чтобы поменять коэффициенты собственного роста / смертности
% популяций
growth = [3; -1; -0.8];
% Измените, чтобы поменять коэффициенты поисковой активности
search_activity = [1; 0; 0];
% Измените, чтобы поменять коэффициенты диффузии
diffusion_coeffs = [0.2; 0.3; 0.24];
% Измените, чтобы поменять коэффициенты направленной миграции
taxis_coeffs_matrix = [0 0 0
                       0.4 0 0
                       0.32 0 0];
% Измените, чтобы поменять коэффициенты хищничества
species_interaction_coeffs_matrix = [0 -1 -1
                                     2.5  0  0
                                     2  0  0];


% Индекс переменной, отвечающей плотности популяции жертв в центральной
% точке ареала
prey_center_point_var_index = fix((N+1)/2);
first_predator_center_point_var_index = N+fix((N+1)/2);
second_predator_center_point_var_index = 2*N+fix((N+1)/2);

first_oscillating_var_index = prey_center_point_var_index;

fixed_var_index = prey_center_point_var_index;
fixed_var_value = 1;
eps = 1e-4;

% Вычисляем интегралы от функции, обратной к функции ресурса, на каждом
% шаге сетки
inverse_carrying_capacity_integral_array = compute_integrals();

figure
fplot(@carrying_capacity,[0 L]);
xlabel('x');
ylabel('P(x)');
title('Carrying capacity');


% Решаем систему для начальных данных, при которых плотность второй популяции 
% хищников положена равной нулю
second_oscillating_var_index = first_predator_center_point_var_index;

filename = '1.mat';

if ~exist(filename,'file')
  w0 = zeros(1,nvar);
  for pt = 1:N
    w0(pt) = u10((pt-1)*h);
    w0(N+pt) = u20((pt-1)*h);
    w0(2*N+pt) = 0;
  end
else
  load(filename,'wend');
  w0 = wend;
end


figure
[t,w,te,~,~] = ode15s(@f,tspan,w0,...
                      odeset('NonNegative',1:nvar,...
                             'Events',@events,...
                             'OutputFcn',@odephas2,...
                             'OutputSel',[first_oscillating_var_index,second_oscillating_var_index]));
      
if ~steady
  wend = w(end,:);
  save(filename,'wend');
  
  figure
  hold on
  h2 = plot(t,w(:,first_predator_center_point_var_index));
  label(h2,'v_1','location','center');
  xlabel('t');
  ylabel('v_1','rot',0);
  hold off
else
  % Находим разницу между последними двумя временами пересечения секущей
  % плоскости отображения Пуанкаре (для периодического решения это будет период)
  T = te(end)-te(end-2);
  
  figure
  calculate_multiplicators(w(end,:),[0 T],@ode45,odeset('NonNegative',1:nvar,'RelTol',1e-5,'AbsTol',1e-8),...
                           odeset('OutputFcn',@odephas2,...
                                  'OutputSel',[first_oscillating_var_index,second_oscillating_var_index]));
                                
  figure
  [t,w] = ode15s(@f,[0 2*T],w(end,:),...
           odeset('NonNegative',1:nvar));
                
  plot_spatiotemporal_distributions(t,w);
  plot_phase_portrait_projections(w);
end


  % -----------------------------------------------------------------------
  % Nested functions. Problem parameters provided by the outer function.
  %
  
  function [t,w] = solve(w0,experiment)
    % Сначала решаем систему до некоторого момента времени
    figure
    [~,w,te,~,~] = ode15s(@f,tspan,w0,...
                          odeset('NonNegative',1:nvar,...
                                 'Events',@events,...
                                 'OutputFcn',@odephas2,...
                                 'OutputSel',[first_oscillating_var_index,second_oscillating_var_index]));
      
    % Находим разницу между последними двумя временами пересечения секущей
    % плоскости отображения Пуанкаре (для периодического решения это будет период)
    T = te(end)-te(end-2);
    
    %figure
    %ode15s(@f,tspan,w(end,:),...
    %       odeset('NonNegative',1:nvar,'OutputFcn',@odephas2,...
    %              'OutputSel',[first_oscillating_var_index,second_oscillating_var_index]));

    %sol = find(idxSolutions == experiment);
    %if sol
      %save('1.mat',w(end,:));

      figure
      calculate_multiplicators(w(end,:),[0 T],@ode15s,odeset('NonNegative',1:nvar,'RelTol',1e-6),...
                               odeset('OutputFcn',@odephas2,...
                                      'OutputSel',[first_oscillating_var_index,second_oscillating_var_index]));
      %if sol ~= length(idxSolutions)
        fprintf('\n\n');
      %end
    %end

    % Решаем систему на предполагаемом периоде для построения графика
    % пространственно-временного распределения
    figure
    [t,w] = ode15s(@f,[0 2*T],w(end,:),...
             odeset('NonNegative',1:nvar,'OutputFcn',@odephas2,...
                    'OutputSel',[first_oscillating_var_index,second_oscillating_var_index]));
  end
  % -----------------------------------------------------------------------

  function [wmax,w0trajectory] = get_max_densities(w, idxSpecies, spacept)
    wmax = zeros(2,1);
    for species = 1:idxSpecies
      wmax(species) = w(1,N*species+spacept);
    end

    sz = size(w);
    grows = false;
    maxreached = false;
    timept = 2;
    w0trajectory = w(1,:);
    while timept <= sz(1) && ~maxreached
      wpredator1 = w(timept,N*idxSpecies(1)+spacept);
      wpredator2 = w(timept,N*idxSpecies(2)+spacept);

      if wpredator1 >= wmax(1) && wpredator2 >= wmax(2)
        wmax(1) = wpredator1;
        wmax(2) = wpredator2;
        w0trajectory = w(timept,:);
        grows = true;
      elseif grows
        maxreached = true;
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
      %set(gr, 'LineStyle', 'none')
    end
  end
  
  % -----------------------------------------------------------------------

  function plot_phase_portrait_projections(w)      
    figure
    plot(w(:,prey_center_point_var_index),w(:,first_predator_center_point_var_index));
    xlabel('u')
    ylabel('v_1')
    figure
    plot(w(:,prey_center_point_var_index),w(:,second_predator_center_point_var_index));
    xlabel('u')
    ylabel('v_2')
    figure
    plot(w(:,first_predator_center_point_var_index),w(:,second_predator_center_point_var_index));
    xlabel('v_1')
    ylabel('v_2')
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
    P = 1+0.2*sin(2*pi*x/L);
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