function family_of_cycles_2()
%FAMILY_OF_CYCLES_2 Модель взаимодействия одной популяции
%жертвы и двух популяций хищника с ростом жертв, пропорциональным квадрату 
%плотности популяции, при неоднородной функции ресурса
%   Detailed explanation goes here
clear all; close all; clc

L = 2;

tspan = [0, 5000];
N = 18;
h = L / N;

famstep = 0.1;

x = zeros(N + 1, 1);
for i = 1:N + 1
  x(i) = (i - 1) * h;
end

nprey = 1;
npredator = 2;
nspecies = nprey + npredator;

nvar = nspecies * N;

growth = [1; -0.3; -0.4];
search_activity = [1; 0; 0];
diffusion_coeffs = [1; 3; 4];
taxis_coeffs_matrix = [0 0 0
                       3 0 0
                       4 0 0];
species_interaction_coeffs_matrix = [0 -6 -8
                                     6  0  0
                                     8  0  0];

nexp = 10;
wpredatormax = zeros(2, nexp);

first_species_center_point_var_index = fix((N+1)/2);
second_species_center_point_var_index = N+fix((N+1)/2);
third_species_center_point_var_index = 2*N+fix((N+1)/2);

first_oscillating_var_index = first_species_center_point_var_index;

fixed_var_index = first_species_center_point_var_index;
fixed_var_value = 0.05;
eps = 1e-4;

inverse_carrying_capacity_integral_array = compute_integrals();


wend_all = zeros(nexp,nvar);
wphasetrajectory_all = cell(1,nexp);
wdistribution_all = cell(1,nexp);
T_all = zeros(1,nexp);
t_all = cell(1,nexp);

second_oscillating_var_index = second_species_center_point_var_index;

w0 = zeros(1,nvar);
for pt = 1:N
  w0(pt) = u10((pt-1)*h);
  w0(N+pt) = u20((pt-1)*h);
  w0(2*N+pt) = u30((pt-1)*h);
end

for experiment = 1:nexp
  [~,w,te,~,~] = ...
        ode15s(@f,tspan,w0,...
               odeset('Events',@events,...
               'NonNegative',1:nvar));
  wend_all(1,:) = w(end,:);

  T = te(end)-te(end-2);
  T_all(1) = T;

  [t,wdistribution] = ...
        ode15s(@f,[0 4*T],w(end,:),odeset('NonNegative',1:nvar));
  t_all{1} = t;
  wdistribution_all{1} = wdistribution;

  figure
  plot_spatiotemporal_distributions(t,wdistribution);

  [~,wphasetrajectory] = ...
        ode15s(@f,[0 T],w(end,:),odeset('NonNegative',1:nvar));
  wphasetrajectory_all{1} = wphasetrajectory;

  famdir = calculate_multiplicators(w(end,:),T,odeset('NonNegative',1:nvar,'RelTol',1e-6),experiment)
  
  w0 = w(end,:)+famdir*famstep;
  ndx = find(w0 < 0);
  w0(ndx) = max(w0(ndx),0);
  
  figure
  plot_phase_portrait_projections(wphasetrajectory,w(end,:),w0);

  wpredatormax(1,experiment) = 0;
  wpredatormax(2,experiment) = 0;
  for spacept = 1:N
    wpredatormax(1,experiment) = wpredatormax(1,experiment)+wphasetrajectory(1,N+spacept);
    wpredatormax(2,experiment) = wpredatormax(2,experiment)+wphasetrajectory(1,2*N+spacept);
  end
  wpredatormax(1,experiment) = wpredatormax(1,experiment)/N;
  wpredatormax(2,experiment) = wpredatormax(2,experiment)/N;
  sz = size(wphasetrajectory);
  for timept = 2:sz(1)
    wpredator1 = 0;
    wpredator2 = 0;
    for spacept = 1:N
      wpredator1 = wpredator1+wphasetrajectory(timept,N+spacept);
      wpredator2 = wpredator2+wphasetrajectory(timept,2*N+spacept);
    end
    wpredator1 = wpredator1/N;
    wpredator2 = wpredator2/N;
    if wpredator1 >= wpredatormax(1,experiment)
      wpredatormax(1,experiment) = wpredator1;
    end
    if wpredator2 >= wpredatormax(2,experiment)
      wpredatormax(2,experiment) = wpredator2;
    end
  end
end

figure
hold on
xlabel('max(v_1)');
ylabel('max(v_2)');
plot(wpredatormax(1,:),wpredatormax(2,:),'o-');
hold off


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

    plot(x, w01)    
    xlabel('\xi')
    ylabel('u(\xi, 0)')
    title('Initial distributions')
  end

  % -----------------------------------------------------------------------
  
  function famdir = calculate_multiplicators(w,T,options,experiment)
    fprintf('\n');
    tic
    M = monodromy_matrix_one_system_for_each_column(@f, @g, @ode15s, [0 T], w, nvar,...
                   options);
    [V,D] = eig(M,'nobalance');
    sz = size(D);
    rho = zeros(1,sz(1));
    normrho = zeros(1,sz(1));
    for rho_index = 1:sz(1)
      rho(rho_index) = D(rho_index,rho_index);
      normrho(rho_index) = norm(rho(rho_index),1.0);
    end
    
    [~,ix] = sort(normrho);
    famdir = V(:,ix(2)).';
    elapsedTime = toc;
    
    fprintf('Мультипликаторы %d:\n',experiment);
    rho = sort(rho,'descend');
    for rho_index = 1:sz(1)
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
      if species_index > 1
        figure
      end
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

  function plot_phase_portrait_projections(w,wstart,wend)
    sz = size(w);
    uavg = zeros(sz(1),1);
    v1avg = zeros(sz(1),1);
    v2avg = zeros(sz(1),1);
    ustartavg = 0;
    uendavg = 0;
    v1startavg = 0;
    v1endavg = 0;
    v2startavg = 0;
    v2endavg = 0;
    for pt = 1:N
      uavg = uavg + w(:,pt);
      ustartavg = ustartavg + wstart(pt);
      uendavg = uendavg + wend(pt);
      v1avg = v1avg + w(:,N+pt);
      v1startavg = v1startavg + wstart(N+pt);
      v1endavg = v1endavg + wend(N+pt);
      v2avg = v2avg + w(:,2*N+pt);
      v2startavg = v2startavg + wstart(2*N+pt);
      v2endavg = v2endavg + wend(2*N+pt);
    end
    uavg = uavg/N;
    ustartavg = ustartavg/N;
    uendavg = uendavg/N;
    v1avg = v1avg/N;
    v1startavg = v1startavg/N;
    v1endavg = v1endavg/N;
    v2avg = v2avg/N;
    v2startavg = v2startavg/N;
    v2endavg = v2endavg/N;
    
    figure
    hold on
    xlabel('u')
    ylabel('v_1')
    plot(uavg,v1avg);    
    line([ustartavg,uendavg],[v1startavg,v1endavg]);
    hold off
    figure
    hold on
    xlabel('u')
    ylabel('v_2')
    plot(uavg,v2avg);
    line([ustartavg,uendavg],[v2startavg,v2endavg]);    
    hold off
    figure    
    hold on
    xlabel('v_1')
    ylabel('v_2')
    plot(v1avg,v2avg);
    line([v1startavg,v1endavg],[v2startavg,v2endavg]);    
    hold off
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
  
  function [value,isterminal,direction] = events(~,y)
    value = y(fixed_var_index)-fixed_var_value;
    isterminal = 0;
    direction = 0;
%     ne = length(ye);
%     if ne > 1
%       value = [value; euclidian_norm(y,ye(ne-1))-eps];
%       isterminal = [isterminal; 1];
%       direction = [direction; -1];
%     end    
  end

  % -----------------------------------------------------------------------

  function [value,isterminal,direction] = events2(~,y)
    value = y(fixed_var_index)-fixed_var_value;
    isterminal = 1;
    direction = 0;  
  end

  % -----------------------------------------------------------------------

%   function [value,isterminal,direction] = events(t,y)
%     value = euclidian_norm(y,w0)-eps;
%     isterminal = 1;
%     direction = -1;
%   end
  
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