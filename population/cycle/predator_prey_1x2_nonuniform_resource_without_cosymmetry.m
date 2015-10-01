function predator_prey_1x2_nonuniform_resource_without_cosymmetry()
%PREDATOR_PREY_1x2_NONUNIFORM_RESOURCE_WITHOUT_COSYMMETRY Модель взаимодействия двух популяций
%жертвы и одной популяции хищника с ростом жертв, пропорциональным квадрату 
%плотности популяции, при неоднородной функции ресурса
%   Detailed explanation goes here
clear all; close all; clc

L = 2;

tspan = [0,1000];
N = 18;
h = L / N;

x = zeros(N + 1, 1);
for i = 1:N + 1
  x(i) = (i - 1) * h;
end

nprey = 2;
npredator = 1;
nspecies = nprey + npredator;

nvar = nspecies * N;

growth = [3; 4; -0.1];
search_activity = [0.18; 0.15; 0];
diffusion_coeffs = [3; 4; 1];
taxis_coeffs_matrix = [0 0 0
                       0 0 0
                       1 1 0];
species_interaction_coeffs_matrix = [0 0 -3
                                     0 0 -4  
                                     3 4  0];

is_search_activity_all_zeros = true;
species_index = 1;
while species_index <= nprey && is_search_activity_all_zeros
  if search_activity(species_index) ~= 0
    is_search_activity_all_zeros = false;
  end
end

carrying_capacity_integral_array = zeros(1, N);
inverse_carrying_capacity_integral_array = zeros(1, N);

for point_index = 1:N
  % Рассчитываем координату текущей точки сетки
  xcur = (point_index - 1) * h;
  % Рассмотрим текущую точку основной сетки
  % Рассмотрим две соседние с ней точки вспомогательной сетки
  xstart = xcur - h/2;
  xend = xcur + h/2;
  % И рассмотрим отрезок, заключенный между этими двумя точками
  if ~is_search_activity_all_zeros
    % Не все коэффициенты таксиса, вызываемого неоднородностью 
    % распределения ресурса, равны нулю
      
    % Найдем интеграл от функции ресурса по этому отрезку
    carrying_capacity_integral_array(point_index) = integral(@carrying_capacity, xstart, xend) / h;
  end
  % Найдем интеграл от функции, обратной к функции ресурса, по этому же
  % отрезку
  inverse_carrying_capacity_integral_array(point_index) = integral(@(x) carrying_capacity(x).^(-1), xstart, xend) / h;
end

first_oscillating_species = 1;
second_oscillating_species = 3;

first_oscillating_var_index = (first_oscillating_species-1)*N+fix((N+1)/2);
second_oscillating_var_index = (second_oscillating_species-1)*N+fix((N+1)/2);

global poincare_times poincare_points
fixed_var_index = first_oscillating_var_index;
fixed_var_value = 0.02;
eps = 1e-6;

nic = 5;
ic_matrix = zeros(nic,nvar);

ic_index = 1;
for point_index = 1:N
  ic_matrix(ic_index,point_index)=u10((point_index-1)*h);
  ic_matrix(ic_index,N+point_index)=u20((point_index-1)*h);
  ic_matrix(ic_index,2*N+point_index)=u10((point_index-1)*h);
end

ic_index = 2;
for point_index = 1:N
  ic_matrix(ic_index,point_index)=u10((point_index-1)*h);
  ic_matrix(ic_index,N+point_index)=u20((point_index-1)*h);
  ic_matrix(ic_index,2*N+point_index)=u30((point_index-1)*h);
end

ic_index = 3;
for point_index = 1:N
  ic_matrix(ic_index,point_index)=u40((point_index-1)*h);
  ic_matrix(ic_index,N+point_index)=u60((point_index-1)*h);
  ic_matrix(ic_index,2*N+point_index)=u50((point_index-1)*h);
end

ic_index = 4;
prey0 = [2.5, 1, 2.5, 1, 2.5, 1, 2.5, 1, 2.5, 1];
prey0 = approximate(prey0,N);

predator0(1:N) = 0.6;

ic_matrix(ic_index,1:N) = prey0;
ic_matrix(ic_index,N+1:2*N) = prey0;
ic_matrix(ic_index,2*N+1:3*N) = predator0;

ic_index = 5;
for point_index = 1:N
  ic_matrix(ic_index,point_index)=u70((point_index-1)*h);
  ic_matrix(ic_index,N+point_index)=u80((point_index-1)*h);
  ic_matrix(ic_index,2*N+point_index)=u60((point_index-1)*h);
end

solutions = cell(1,nic);
for ic_index = 1:nic
  w0 = ic_matrix(ic_index,:)
  plot_spatial_distributions(w0);
  is_periodic = false;
  figure
  [t_arr,w] = ode15s(@f,tspan,w0,...
                    odeset('OutputFcn',@poincare_map_iteration,...
                           'NonNegative',1:nvar));
  analyze_solution_and_output_results(t_arr,w);
  figure
  [t_arr,w] = ...
      ode15s(@f,tspan,w(end,:),...
             odeset('OutputFcn',@odephas2,...
                   'OutputSel',[first_oscillating_var_index,...
                                second_oscillating_var_index],...
                   'NonNegative',1:nvar));
  sz = size(w);
  solution = zeros(sz(1),2);
  solution(:,1) = w(:,first_oscillating_var_index);
  solution(:,2) = w(:,second_oscillating_var_index);
  solutions{ic_index} = solution;
end

plot_phase_trajectories(solutions);


first_oscillating_species = 2;
second_oscillating_species = 3;

first_oscillating_var_index = (first_oscillating_species-1)*N+fix((N+1)/2);
second_oscillating_var_index = (second_oscillating_species-1)*N+fix((N+1)/2);

nic = 3;
ic_matrix = zeros(nic,nvar);
ic_index = 1;
for point_index = 1:N
  ic_matrix(ic_index,point_index)=u40((point_index-1)*h);
  ic_matrix(ic_index,N+point_index)=u20((point_index-1)*h);
  ic_matrix(ic_index,2*N+point_index)=u50((point_index-1)*h);
end

ic_index = 2;
for point_index = 1:N
  ic_matrix(ic_index,point_index)=u40((point_index-1)*h);
  ic_matrix(ic_index,N+point_index)=u90((point_index-1)*h);
  ic_matrix(ic_index,2*N+point_index)=u50((point_index-1)*h);
end

ic_index = 3;
for point_index = 1:N
  ic_matrix(ic_index,point_index)=u40((point_index-1)*h);
  ic_matrix(ic_index,N+point_index)=u30((point_index-1)*h);
  ic_matrix(ic_index,2*N+point_index)=u50((point_index-1)*h);
end

solutions = cell(1,nic);
for ic_index = 1:nic
  w0 = ic_matrix(ic_index,:);
  plot_spatial_distributions(w0);
  is_periodic = false;
  figure
  [t_arr,w] = ode15s(@f,tspan,w0,...
                    odeset('OutputFcn',@poincare_map_iteration));
  analyze_solution_and_output_results(t_arr,w);
  figure
  [~,w] = ...
      ode15s(@f,tspan,w(end,:),...
            odeset('OutputFcn',@odephas2,...
                   'OutputSel',[first_oscillating_var_index,...
                                 second_oscillating_var_index]));
  sz = size(w);
  solution = zeros(sz(1),2);
  solution(:,1) = w(:,first_oscillating_var_index);
  solution(:,2) = w(:,second_oscillating_var_index);
  solutions{ic_index} = solution;
end

plot_phase_trajectories(solutions);


  % -----------------------------------------------------------------------
  % Nested functions. Problem parameters provided by the outer function.
  %
  
  function plot_spatial_distributions(w0)
    % Plot of the initial conditions        
    w01 = zeros(N + 1, nspecies);
    for i = 1:nspecies
      w01(1:N, i) = w0((i - 1) * N + 1:i * N);
      w01(N + 1, i) = w01(1, i);
    end

    figure
    plot(x, w01)    
    xlabel('\xi')
    ylabel('u(\xi, 0)')
    title('Initial distributions')
  end
  % -----------------------------------------------------------------------
  
  function analyze_solution_and_output_results(t_arr,w)
    if is_periodic
      'Periodic solution'
    else
      'Not periodic solution'
    end

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
      gr = surf(x, t_arr, wres(:,:,species_index));
      % Раскомментировать, чтобы убрать черные линии
      %set(gr, 'LineStyle', 'none')
    end
                               
    %w_end = zeros(N+1, nspecies);
    %for i = 1:N + 1
    %  w_end(i, :) = w_res(end, i, :);
    %end

    % Plot of the solution
    %figure
    %plot(x, w_end)    
    %xlabel('\xi')
    %ylabel('u(\xi, 0)')
    %title('Predator-prey dynamics')

    %if is_periodic
    %  T = poincare_times(end) - poincare_times(end - 2)

    %  figure
  
    %  set = odeset('OutputFcn', @odephas2, 'OutputSel', [first_oscillating_var_index, second_oscillating_var_index]);
    %  multiplicators(@monodromy_matrix_cauchy_problem_for_each_column, @f, @g, @ode15s, T, w(end, :), nvar, set)
    %end
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
    if (x < L/2) 
      P = 0.1*sin((x-L/8)*2*pi) + 0.15;
    else
      P = 0.05*sin((x-L/8)*2*pi) + 0.1;
    end
  end
  % -----------------------------------------------------------------------
  
  function u = u10( x )
    if x >= 0 && x <= 0.8
      u = 0.2*sin(x*pi/0.8);
    else
      u = 0;
    end
  end
  % -----------------------------------------------------------------------
  
  function u = u20( x )
    if x >= L/2 && x <= L/2+0.8
      u = max(0, 0.2*sin((x-L/2)*pi/0.8));
    else
      u = 0;
    end
  end
  % -----------------------------------------------------------------------
  
  function u = u30( x )
    if x >= 0.6 && x <= 1.4
      u = 0.2*sin((x-0.6)*pi/0.8);
    else
      u = 0;
    end
  end
  % -----------------------------------------------------------------------
  
  function u = u40( x )
    if x >= 0.4 && x <= 1.2
      u = 0.05*sin((x-0.4)*pi/0.8);
    else
      u = 0;
    end
  end
  % -----------------------------------------------------------------------
  
  function u = u50( x )
    if x >= 0.8 && x <= 1.6
      u = 0.05*sin((x-0.8)*pi/0.8);
    else
      u = 0;
    end
  end
  % -----------------------------------------------------------------------
  
  function u = u60( x )
    if x >= L/2 && x <= L/2+0.8
      u = max(0, 0.05*sin((x-L/2)*pi/0.8));
    else
      u = 0;
    end
  end
  % -----------------------------------------------------------------------
  
  function u = u70( x )
    u = exp(x/20*sin(3*pi*x/L))-0.9;
  end
  % -----------------------------------------------------------------------
  
  function u = u80( x )
    u = 0.05 + 0.2*exp(-50*(x - L/4)^2) + 0.1*exp(-50*(x - 3*L/4)^2);
  end
  % -----------------------------------------------------------------------
  
  function u = u90( x )
    if x >= 0.8 && x <= 1.6
      u = max(0, 0.2*sin((x-0.8)*pi/0.8));
    else
      u = 0;
    end
  end
  % -----------------------------------------------------------------------
  
  function status = poincare_map_iteration( t, w, flag )  
    global w_prev t_prev
    
    if ~strcmp(flag, 'init') && ~strcmp(flag, 'done')
      tf = t(end);
      wf = w(:, end);
    
      sz = size(w_prev);
        
      if sz(2) == 1 && sign(wf(fixed_var_index) - fixed_var_value) ~= sign(w_prev(fixed_var_index) - fixed_var_value)        
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
            is_periodic = true;
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
    
    if ~is_periodic
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
    dwdt = right_parts_of_equations( w, nprey, npredator, N, h, @growth_fcn, search_activity, diffusion_coeffs, taxis_coeffs_matrix, species_interaction_coeffs_matrix, carrying_capacity_integral_array, inverse_carrying_capacity_integral_array );
  end
  % -----------------------------------------------------------------------

  function dwdt = g( ~, w, basis_vector_index )
    dwdt = linearized_system( w, basis_vector_index, nprey, npredator, N, h, growth, search_activity, diffusion_coeffs, taxis_coeffs_matrix, species_interaction_coeffs_matrix, carrying_capacity_integral_array, inverse_carrying_capacity_integral_array );
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