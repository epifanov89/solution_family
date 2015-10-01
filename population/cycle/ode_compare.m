function ode_compare()
%ODE_COMPARE ������ �������������� ����� ���������
%������ � ���� ��������� ������� � ������ �����, ���������������� �������� 
%��������� ���������, ��� ������������ ������� �������
%   Detailed explanation goes here
clear all; close all; clc

L = 2;

tspan = [0,500];
N = 18;
h = L / N;

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

inverse_carrying_capacity_integral_array = compute_integrals();

first_oscillating_species = 1;
second_oscillating_species = 2;

first_oscillating_var_index = (first_oscillating_species-1)*N+fix((N+1)/2);
second_oscillating_var_index = (second_oscillating_species-1)*N+fix((N+1)/2);

fixed_var_index = first_oscillating_var_index;
fixed_var_value = 0.05;
eps = 1e-4;


first_oscillating_species = 1;
second_oscillating_species = 3;

first_oscillating_var_index = (first_oscillating_species-1)*N+fix((N+1)/2);
second_oscillating_var_index = (second_oscillating_species-1)*N+fix((N+1)/2);

fixed_var_index = first_oscillating_var_index;

nic = 1;
ic_matrix = zeros(nvar,nic);

ic_index = 1;
for point_index = 1:N
  ic_matrix(point_index,ic_index)=u10((point_index-1)*h);
  ic_matrix(N+point_index,ic_index)=u20((point_index-1)*h);
  ic_matrix(2*N+point_index,ic_index)=u30((point_index-1)*h);
end

m = 2; n = 3;

solutions = cell(1,nic);
for ic_index = 1:nic
  w0 = ic_matrix(:,ic_index);
  p = 1;
  figure
  %subplot(m,n,p);
  p = p+1;
  plot_spatial_distributions(w0);
  poincare_points = [];
  poincare_times = [];
  %subplot(m,n,p);
  figure
  p = p+1;  
  
  tic
  [t_arr,w,te,we,~] = ...
      ode15s(@f,tspan,w0,...
             odeset('OutputFcn',@odephas2,...
                    'OutputSel',[first_oscillating_var_index,...
                                 second_oscillating_var_index],...
                    'NonNegative',1:nvar,...
                    'Events',@events));
  elapsedTime = toc;
  fprintf('ode15s: %d ������\n', round(elapsedTime));
  
  tspan = 0:0.001:500;  
  tic
  w = ...
      myode4_2(@f,tspan,w0,...
             odeset('OutputFcn',@odephas2,...
                    'OutputSel',[first_oscillating_var_index,...
                                 second_oscillating_var_index]));
  elapsedTime = toc;
  fprintf('���� ����� �����-����� � ����� %f: %d ������\n', tspan(2)-tspan(1), round(elapsedTime));
  
  tspan = [0, 500];
  tic
  [t_arr,w,te,we,~] = ...
      ode45(@f,tspan,w0,...
             odeset('OutputFcn',@odephas2,...
                    'OutputSel',[first_oscillating_var_index,...
                                 second_oscillating_var_index],...
                    'NonNegative',1:nvar,...
                    'Events',@events));
  elapsedTime = toc;
  fprintf('ode45: %d ������\n', round(elapsedTime));
end


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
  
  function calculate_multiplicators(w,T,options,outputopts)
    %subplot(m,n,p);
    p = p+1;
    fprintf('\n');
    tic
    M = monodromy_matrix_one_system_for_each_column(@f, @g, @ode15s, [0 T], w, nvar,...
                                       options, outputopts);
    rho = sort(eig(M),'descend');
    elapsedTime = toc;
    fprintf('���������������:\n');
    for rho_index = 1:length(rho)
      disp(rho(rho_index));
    end
    fprintf('\n���������� ���������������� ��������� �� %d ������\n',round(elapsedTime));
  end

  % -----------------------------------------------------------------------
  
  function analyze_solution_and_output_results(t_arr,w)                               
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
      %subplot(m,n,p);
      figure
      p = p+1;
      gr = surf(x, t_arr, wres(:,:,species_index));
      % �����������������, ����� ������ ������ �����
      set(gr, 'LineStyle', 'none')
    end
  end

  % ----------------------------------------------------------------------- 
  
  function plot_phase_trajectories(solutions)
    % ������� �������� ������� ���������� �� ������ ��������� ������ �� 
    % ����� �������
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
    
  function inverse_carrying_capacity_integral_array = compute_integrals()
    inverse_carrying_capacity_integral_array = zeros(1, N);

    for point_index = 1:N
      % ������������ ���������� ������� ����� �����
      xcur = (point_index - 1) * h;
      % ���������� ������� ����� �������� �����
      % ���������� ��� �������� � ��� ����� ��������������� �����
      xstart = xcur - h/2;
      xend = xcur + h/2;
      % � ���������� �������, ����������� ����� ����� ����� �������
      % ������ �������� �� �������, �������� � ������� �������, �� �����
      % �������
      inverse_carrying_capacity_integral_array(point_index) = integral(@(x) carrying_capacity(x).^(-1), xstart, xend) / h;
    end
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
  
  function [value,isterminal,direction] = events(t,y)
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
        
        % ������������ ���������� ������� ����� �����
        xcur = (cur_point_index - 1) * h;
        
        factor = 1;
        if cur_species_index <= nprey
          % ��������� �������� �� �������� � ������� ������� ������� ��
          % ����������, ������������ ����� ��������� � ������� ������
          % �������� ����� ������� ��������������� �����
          inverse_carrying_capacity_integral = integral(@(x) carrying_capacity(x).^(-1), xcur - h/2, xcur + h/2) / h;
            
          factor = 2 * w(cur_species_cur_point_var_index) - 3 * inverse_carrying_capacity_integral * w(cur_species_cur_point_var_index)^2;
        end
        
        % ������������ ���������� ����������, ������� � ��������� ����� �����
        xprev = (prev_point_index - 1) * h;
        xcur = (cur_point_index - 1) * h;
        xnext = (next_point_index - 1) * h;
        
        carrying_capacity_taxis_prev = 0;
        carrying_capacity_taxis_cur = 0;
        carrying_capacity_taxis_next = 0;
      
        if search_activity(cur_species_index) ~= 0          
          % ��������� �������� �� ������� ������� �� ����������,
          % ������������ ����� ��������� � ���������� ������ �������� �����
          % ������� ��������������� �����
          carrying_capacity_integral = integral(@carrying_capacity, xprev - h/2, xprev + h/2) / h;
          
          % ��������� ������ (������������ ��������), ���������
          % ���������������� �������, � ���������� �����
          carrying_capacity_taxis_prev = search_activity(cur_species_index) * carrying_capacity_integral;
                    
          % ��������� �������� �� ������� ������� �� ����������,
          % ������� ��������������� �����
          carrying_capacity_integral = integral(@carrying_capacity, xcur - h/2, xcur + h/2) / h;
          
          % ��������� ������ (������������ ��������), ���������
          % ���������������� �������, � ������� �����
          carrying_capacity_taxis_cur = search_activity(cur_species_index) * carrying_capacity_integral;
            
          % ��������� �������� �� ������� ������� �� ����������,
          % ������������ ����� ��������� �� ��������� ������ �������� �����
          % ������� ��������������� �����
          carrying_capacity_integral = integral(@carrying_capacity, xnext * h - h/2, xnext * h + h/2) / h;
          
          % ��������� ������ (������������ ��������), ���������
          % ���������������� �������, � ��������� �����
          carrying_capacity_taxis_next = search_activity(cur_species_index) * carrying_capacity_integral;
        end
        
        dwdt(cur_species_cur_point_var_index) = diffusion_coeffs(cur_species_index) * (w(nvar * basis_vector_index + cur_species_next_point_var_index) - 2 * w(nvar * basis_vector_index + cur_species_cur_point_var_index) + w(nvar * basis_vector_index + cur_species_prev_point_var_index)) / h^2 + ((- sum_1 + sum_2 - sum_3 - sum_5 + sum_6 - sum_7) / 2 + sum_4) / h^2 - (w(nvar * basis_vector_index + cur_species_next_point_var_index) + w(nvar * basis_vector_index + cur_species_cur_point_var_index)) * carrying_capacity_taxis_next / 2 / h^2 + (w(nvar * basis_vector_index + cur_species_next_point_var_index) + 2 * w(nvar * basis_vector_index + cur_species_cur_point_var_index) + w(nvar * basis_vector_index + cur_species_prev_point_var_index)) * carrying_capacity_taxis_cur / 2 / h^2 - (w(nvar * basis_vector_index + cur_species_cur_point_var_index) + w(nvar * basis_vector_index + cur_species_prev_point_var_index)) * carrying_capacity_taxis_prev / 2 / h^2 + mu(cur_species_index) * factor * w(nvar * basis_vector_index + cur_species_cur_point_var_index) + sum_8;
      end
    end
  end

end