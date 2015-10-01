function predator_prey()
%PREDATOR_PREY Summary of this function goes here
%   Detailed explanation goes here
clear all; close all; clc

prey_cnt = 1;
predator_cnt = 1;
species_total_cnt = prey_cnt + predator_cnt;

tspan = [0, 200];
L = 1; N = 10;
h = L / N;
gamma = 1;
beta = 0.4;

x = zeros(N + 1, 1);
for i = 1:N + 1
  x(i) = (i - 1) * h;
end

mu = [1; -gamma];
search_activity = zeros(1, species_total_cnt);
diffusion_coeffs = [0.01; 10];
taxis_coeffs_matrix = zeros(species_total_cnt);
species_interaction_coeffs_matrix = [0     -1
                                     gamma  0];

w01 = [2.5, 1, 2.5, 1, 2.5, 1, 2.5, 1, 2.5, 1];
w02 = [0.6, 0.6, 0.6, 0.6, 0.6, 0.6, 0.6, 0.6, 0.6, 0.6];
w0 = zeros(1, 2*N);
w0(1:N) = approximate(w01, N);
w0(N + 1:2*N) = approximate(w02, N);

% Plot of the initial conditions        
w01 = zeros(N + 1, species_total_cnt);
for i = 1:species_total_cnt
  w01(1:N, i) = w0((i - 1) * N + 1:i * N);
  w01(N + 1, i) = w01(1, i);
end

figure
plot(x, w01)    
xlabel('\xi')
ylabel('u(\xi, 0)')
title('Initial distributions')

global poincare_times poincare_points
poincare_points = zeros(1, N*species_total_cnt);
fixed_var_index = N/2;
fixed_var_value = 1;

figure
[~, w] = ode15s(@f, tspan, w0, odeset('OutputFcn', @poincare_map_iteration));

last_poincare_point = poincare_points(end, :);
poincare_points = zeros(1, N*species_total_cnt);

figure
[~, w] = ode15s(@f, tspan, last_poincare_point, odeset('OutputFcn', @poincare_map_iteration));

T = poincare_times(end) - poincare_times(end - 2)

w_res = zeros(N + 1, species_total_cnt);
for i = 1:species_total_cnt
  w_res(1:N, i) = w(end, (i - 1)*N + 1:i*N);
  w_res(N + 1, i) = w_res(1, i);
end

% Plot of the solution
figure
plot(x, w_res)    
xlabel('\xi')
ylabel('u(\xi, 0)')
title('Predator-prey dynamics')

sz = size(w);

u_avg = zeros(sz(1), prey_cnt);
v_avg = zeros(sz(1), predator_cnt);

for i = 1:prey_cnt
  for j = 1:N
    u_avg(:, i) = u_avg(:, i) + w(:, (i - 1)*N + j);
  end
end

for i = 1:predator_cnt
  for j = 1:N
    v_avg(:, i) = v_avg(:, i) + w(:, (prey_cnt + i - 1)*N + j);
  end
end

u_avg = u_avg / N;
v_avg = v_avg / N;

% Phase portrait of the solution   
first_population_index = 1; second_population_index = 2; 
u_start = 0; v_start = 0; u_end = 3; v_end = 3;
plot_phase_portrait(@f, prey_cnt, predator_cnt, N, u_start, u_end, v_start, v_end, first_population_index, second_population_index);

hold on
plot(u_avg(:,1), v_avg(:,1))
hold off

M = monodromy_matrix_new_algorithm(@f, @g, T, w(end, :), N, species_total_cnt);
eig(M)

w01 = [0.5, 0.5, 2.5, 2.5, 0.5, 0.5, 0.5, 2.5, 2.5, 0.5];
w02 = [0.6, 0.6, 0.6, 0.6, 0.6, 0.6, 0.6, 0.6, 0.6, 0.6];
w0 = zeros(1, 2*N);
w0(1:N) = interpolate(w01, N);
w0(N + 1:2*N) = interpolate(w02, N);

% Plot of the initial conditions        
w01 = zeros(N + 1, species_total_cnt);
for i = 1:species_total_cnt
  w01(1:N, i) = w0((i - 1) * N + 1:i * N);
  w01(N + 1, i) = w01(1, i);
end

figure
plot(x, w01)    
xlabel('\xi')
ylabel('u(\xi, 0)')
title('Initial distributions')

poincare_points = zeros(1, N*species_total_cnt);
fixed_var_index = N/2;
fixed_var_value = 1;

figure
[~, w] = ode15s(@f, tspan, w0, odeset('OutputFcn', @poincare_map_iteration));

T = poincare_times(end) - poincare_times(end - 2)

w_res = zeros(N + 1, species_total_cnt);
for i = 1:species_total_cnt
  w_res(1:N, i) = w(end, (i - 1)*N + 1:i*N);
  w_res(N + 1, i) = w_res(1, i);
end

% Plot of the solution
figure
plot(x, w_res)    
xlabel('\xi')
ylabel('u(\xi, 0)')
title('Predator-prey dynamics')

sz = size(w);

u_avg = zeros(sz(1), prey_cnt);
v_avg = zeros(sz(1), predator_cnt);

for i = 1:prey_cnt
  for j = 1:N
    u_avg(:, i) = u_avg(:, i) + w(:, (i - 1)*N + j);
  end
end

for i = 1:predator_cnt
  for j = 1:N
    v_avg(:, i) = v_avg(:, i) + w(:, (prey_cnt + i - 1)*N + j);
  end
end

u_avg = u_avg / N;
v_avg = v_avg / N;

% Phase portrait of the solution   
first_population_index = 1; second_population_index = 2; 
u_start = 0; v_start = 0; u_end = 3; v_end = 3;
plot_phase_portrait(@f, prey_cnt, predator_cnt, N, u_start, u_end, v_start, v_end, first_population_index, second_population_index);

hold on
plot(u_avg(:,1), v_avg(:,1))
hold off

%multiplicators(@monodromy_matrix, @f, @g, T, w(end, :), N, species_total_cnt)

w01 = [2.5, 2.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 2.5];
w02 = [0.6, 0.6, 0.6, 0.6, 0.6, 0.6, 0.6, 0.6, 0.6, 0.6];
w0 = zeros(1, 2*N);
w0(1:N) = interpolate(w01, N);
w0(N + 1:2*N) = interpolate(w02, N);

% Plot of the initial conditions        
w01 = zeros(N + 1, species_total_cnt);
for i = 1:species_total_cnt
  w01(1:N, i) = w0((i - 1) * N + 1:i * N);
  w01(N + 1, i) = w01(1, i);
end

figure
plot(x, w01)    
xlabel('\xi')
ylabel('u(\xi, 0)')
title('Initial distributions')

poincare_points = zeros(1, N*species_total_cnt);
fixed_var_index = N/2;
fixed_var_value = 1;

figure
[~, w] = ode15s(@f, tspan, w0, odeset('OutputFcn', @poincare_map_iteration));

T = poincare_times(end) - poincare_times(end - 4)

w_res = zeros(N + 1, species_total_cnt);
for i = 1:species_total_cnt
  w_res(1:N, i) = w(end, (i - 1)*N + 1:i*N);
  w_res(N + 1, i) = w_res(1, i);
end

% Plot of the solution
figure
plot(x, w_res)    
xlabel('\xi')
ylabel('u(\xi, 0)')
title('Predator-prey dynamics')

sz = size(w);

u_avg = zeros(sz(1), prey_cnt);
v_avg = zeros(sz(1), predator_cnt);

for i = 1:prey_cnt
  for j = 1:N
    u_avg(:, i) = u_avg(:, i) + w(:, (i - 1)*N + j);
  end
end

for i = 1:predator_cnt
  for j = 1:N
    v_avg(:, i) = v_avg(:, i) + w(:, (prey_cnt + i - 1)*N + j);
  end
end

u_avg = u_avg / N;
v_avg = v_avg / N;

% Phase portrait of the solution   
first_population_index = 1; second_population_index = 2; 
u_start = 0; v_start = 0; u_end = 3; v_end = 3;
plot_phase_portrait(@f, prey_cnt, predator_cnt, N, u_start, u_end, v_start, v_end, first_population_index, second_population_index);

hold on
plot(u_avg(:,1), v_avg(:,1))
hold off

%multiplicators(@monodromy_matrix, @f, @g, T, w(end, :), N, species_total_cnt)


w01 = [2.5, 2.1, 1.5, 1.1, 0.6, 0.3, 0.6, 1.1, 1.5, 2.1];
w02 = [0.6, 0.6, 0.6, 0.6, 0.6, 0.6, 0.6, 0.6, 0.6, 0.6];
w0 = zeros(1, 2*N);
w0(1:N) = interpolate(w01, N);
w0(N + 1:2*N) = interpolate(w02, N);

% Plot of the initial conditions        
w01 = zeros(N + 1, species_total_cnt);
for i = 1:species_total_cnt
  w01(1:N, i) = w0((i - 1) * N + 1:i * N);
  w01(N + 1, i) = w01(1, i);
end

figure
plot(x, w01)    
xlabel('\xi')
ylabel('u(\xi, 0)')
title('Initial distributions')

poincare_points = zeros(1, N*species_total_cnt);
fixed_var_index = N/2;
fixed_var_value = 1;

figure
[~, w] = ode15s(@f, tspan, w0, odeset('OutputFcn', @poincare_map_iteration));

T = poincare_times(end) - poincare_times(end - 4)

w_res = zeros(N + 1, species_total_cnt);
for i = 1:species_total_cnt
  w_res(1:N, i) = w(end, (i - 1)*N + 1:i*N);
  w_res(N + 1, i) = w_res(1, i);
end

% Plot of the solution
figure
plot(x, w_res)    
xlabel('\xi')
ylabel('u(\xi, 0)')
title('Predator-prey dynamics')

sz = size(w);

u_avg = zeros(sz(1), prey_cnt);
v_avg = zeros(sz(1), predator_cnt);

for i = 1:prey_cnt
  for j = 1:N
    u_avg(:, i) = u_avg(:, i) + w(:, (i - 1)*N + j);
  end
end

for i = 1:predator_cnt
  for j = 1:N
    v_avg(:, i) = v_avg(:, i) + w(:, (prey_cnt + i - 1)*N + j);
  end
end

u_avg = u_avg / N;
v_avg = v_avg / N;

% Phase portrait of the solution   
first_population_index = 1; second_population_index = 2; 
u_start = 0; v_start = 0; u_end = 3; v_end = 3;
plot_phase_portrait(@f, prey_cnt, predator_cnt, N, u_start, u_end, v_start, v_end, first_population_index, second_population_index);

hold on
plot(u_avg(:,1), v_avg(:,1))
hold off

%multiplicators(@monodromy_matrix, @f, @g, T, w(end, :), N, species_total_cnt)


w01 = [2.5, 0.5, 0.5, 2.5, 2.5, 2.5, 2.5, 2.5, 0.5, 0.5];
w02 = [0.6, 0.6, 0.6, 0.6, 0.6, 0.6, 0.6, 0.6, 0.6, 0.6];
w0 = zeros(1, 2*N);
w0(1:N) = interpolate(w01, N);
w0(N + 1:2*N) = interpolate(w02, N);

% Plot of the initial conditions        
w01 = zeros(N + 1, species_total_cnt);
for i = 1:species_total_cnt
  w01(1:N, i) = w0((i - 1) * N + 1:i * N);
  w01(N + 1, i) = w01(1, i);
end

figure
plot(x, w01)    
xlabel('\xi')
ylabel('u(\xi, 0)')
title('Initial distributions')

poincare_points = zeros(1, N*species_total_cnt);
fixed_var_index = N/2;
fixed_var_value = 1;

figure
[~, w] = ode15s(@f, tspan, w0, odeset('OutputFcn', @poincare_map_iteration));

T = poincare_times(end) - poincare_times(end - 4)

w_res = zeros(N + 1, species_total_cnt);
for i = 1:species_total_cnt
  w_res(1:N, i) = w(end, (i - 1)*N + 1:i*N);
  w_res(N + 1, i) = w_res(1, i);
end

% Plot of the solution
figure
plot(x, w_res)    
xlabel('\xi')
ylabel('u(\xi, 0)')
title('Predator-prey dynamics')

sz = size(w);

u_avg = zeros(sz(1), prey_cnt);
v_avg = zeros(sz(1), predator_cnt);

for i = 1:prey_cnt
  for j = 1:N
    u_avg(:, i) = u_avg(:, i) + w(:, (i - 1)*N + j);
  end
end

for i = 1:predator_cnt
  for j = 1:N
    v_avg(:, i) = v_avg(:, i) + w(:, (prey_cnt + i - 1)*N + j);
  end
end

u_avg = u_avg / N;
v_avg = v_avg / N;

% Phase portrait of the solution   
first_population_index = 1; second_population_index = 2; 
u_start = 0; v_start = 0; u_end = 3; v_end = 3;
plot_phase_portrait(@f, prey_cnt, predator_cnt, N, u_start, u_end, v_start, v_end, first_population_index, second_population_index);

hold on
plot(u_avg(:,1), v_avg(:,1))
hold off

%multiplicators(@monodromy_matrix, @f, @g, T, w(end, :), N, species_total_cnt)


w01 = [2.5, 2.5, 2.5, 0.5, 0.5, 2.5, 0.5, 0.5, 2.5, 2.5]; 
w02 = [0.6, 0.6, 0.6, 0.6, 0.6, 0.6, 0.6, 0.6, 0.6, 0.6];
w0 = zeros(1, 2*N);
w0(1:N) = interpolate(w01, N);
w0(N + 1:2*N) = interpolate(w02, N);

% Plot of the initial conditions        
w01 = zeros(N + 1, species_total_cnt);
for i = 1:species_total_cnt
  w01(1:N, i) = w0((i - 1) * N + 1:i * N);
  w01(N + 1, i) = w01(1, i);
end

figure
plot(x, w01)    
xlabel('\xi')
ylabel('u(\xi, 0)')
title('Initial distributions')

poincare_points = zeros(1, N*species_total_cnt);
fixed_var_index = N/2;
fixed_var_value = 1;

figure
[~, w] = ode15s(@f, tspan, w0, odeset('OutputFcn', @poincare_map_iteration));

T = poincare_times(end) - poincare_times(end - 4)

w_res = zeros(N + 1, species_total_cnt);
for i = 1:species_total_cnt
  w_res(1:N, i) = w(end, (i - 1)*N + 1:i*N);
  w_res(N + 1, i) = w_res(1, i);
end

% Plot of the solution
figure
plot(x, w_res)    
xlabel('\xi')
ylabel('u(\xi, 0)')
title('Predator-prey dynamics')

sz = size(w);

u_avg = zeros(sz(1), prey_cnt);
v_avg = zeros(sz(1), predator_cnt);

for i = 1:prey_cnt
  for j = 1:N
    u_avg(:, i) = u_avg(:, i) + w(:, (i - 1)*N + j);
  end
end

for i = 1:predator_cnt
  for j = 1:N
    v_avg(:, i) = v_avg(:, i) + w(:, (prey_cnt + i - 1)*N + j);
  end
end

u_avg = u_avg / N;
v_avg = v_avg / N;

% Phase portrait of the solution   
first_population_index = 1; second_population_index = 2; 
u_start = 0; v_start = 0; u_end = 3; v_end = 3;
plot_phase_portrait(@f, prey_cnt, predator_cnt, N, u_start, u_end, v_start, v_end, first_population_index, second_population_index);

hold on
plot(u_avg(:,1), v_avg(:,1))
hold off

%multiplicators(@monodromy_matrix, @f, @g, T, w(end, :), N, species_total_cnt)


w01 = [2.5, 2.1, 1.6, 0.2, 0.7, 1, 0.7, 0.2, 1.6, 2.1];
w02 = [0.6, 0.6, 0.6, 0.6, 0.6, 0.6, 0.6, 0.6, 0.6, 0.6];
w0 = zeros(1, 2*N);
w0(1:N) = interpolate(w01, N);
w0(N + 1:2*N) = interpolate(w02, N);

% Plot of the initial conditions        
w01 = zeros(N + 1, species_total_cnt);
for i = 1:species_total_cnt
  w01(1:N, i) = w0((i - 1) * N + 1:i * N);
  w01(N + 1, i) = w01(1, i);
end

figure
plot(x, w01)    
xlabel('\xi')
ylabel('u(\xi, 0)')
title('Initial distributions')

poincare_points = zeros(1, N*species_total_cnt);
fixed_var_index = N/2;
fixed_var_value = 1;

figure
[~, w] = ode15s(@f, tspan, w0, odeset('OutputFcn', @poincare_map_iteration));

T = poincare_times(end) - poincare_times(end - 4)

w_res = zeros(N + 1, species_total_cnt);
for i = 1:species_total_cnt
  w_res(1:N, i) = w(end, (i - 1)*N + 1:i*N);
  w_res(N + 1, i) = w_res(1, i);
end

% Plot of the solution
figure
plot(x, w_res)    
xlabel('\xi')
ylabel('u(\xi, 0)')
title('Predator-prey dynamics')

sz = size(w);

u_avg = zeros(sz(1), prey_cnt);
v_avg = zeros(sz(1), predator_cnt);

for i = 1:prey_cnt
  for j = 1:N
    u_avg(:, i) = u_avg(:, i) + w(:, (i - 1)*N + j);
  end
end

for i = 1:predator_cnt
  for j = 1:N
    v_avg(:, i) = v_avg(:, i) + w(:, (prey_cnt + i - 1)*N + j);
  end
end

u_avg = u_avg / N;
v_avg = v_avg / N;

% Phase portrait of the solution   
first_population_index = 1; second_population_index = 2; 
u_start = 0; v_start = 0; u_end = 3; v_end = 3;
plot_phase_portrait(@f, prey_cnt, predator_cnt, N, u_start, u_end, v_start, v_end, first_population_index, second_population_index);

hold on
plot(u_avg(:,1), v_avg(:,1))
hold off

%multiplicators(@monodromy_matrix, @f, @g, T, w(end, :), N, species_total_cnt)


  % -----------------------------------------------------------------------
  % Nested functions. Problem parameters provided by the outer function.
  %
  
  function P = carrying_capacity( x )
  % Carrying capacity function
    P = 1 / beta;
  end
  % -----------------------------------------------------------------------

  function f0 = logistic( x, w )
  % Logistic function
    s = 0;
    for i = 1:prey_cnt
      s = s + w(i);
    end
    f0 = [1 - s / carrying_capacity(x); 1];
  end
  % -----------------------------------------------------------------------
  
  function status = poincare_map_iteration( t, w, flag )  
    global w_prev t_prev
    
    if ~strcmp(flag, 'init') && ~strcmp(flag, 'done') && sign(w(fixed_var_index) - fixed_var_value) ~= sign(w_prev(fixed_var_index) - fixed_var_value)
      w_asterisk = zeros(1, N*species_total_cnt);
      w_asterisk(fixed_var_index) = fixed_var_value;
      for var_index = 1:N*species_total_cnt
        if var_index ~= fixed_var_index
          w_asterisk(var_index) = w(var_index) - (w(var_index) - w_prev(var_index)) * (w(fixed_var_index) - fixed_var_value) / (w(fixed_var_index) - w_prev(fixed_var_index));
        end
      end
      
      t_asterisk = t - (t - t_prev) * (w(fixed_var_index) - fixed_var_value) / (w(fixed_var_index) - w_prev(fixed_var_index));
      
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
    
    w_prev = w;
    t_prev = t;  
    
    w_phas = zeros(2, 1);
    if numel(w) ~= 0
      w_phas(1) = w(N/2);
      w_phas(2) = w(3*N/2);
    end
    status = odephas2(t, w_phas, flag);
  end
  % -----------------------------------------------------------------------
  
  function dwdt = f( ~, w )
    carrying_capacity_integral = 1 / beta;
    dwdt = right_parts_of_equations_cubic_nonlinearity( w, @carrying_capacity, prey_cnt, predator_cnt, L, N, mu, search_activity, diffusion_coeffs, taxis_coeffs_matrix, species_interaction_coeffs_matrix, carrying_capacity_integral );
  end
  % -----------------------------------------------------------------------

  function dwdt = g( ~, w, basis_vector_index )
    carrying_capacity_integral = 1 / beta;
    dwdt = linearized_system( w, basis_vector_index, @carrying_capacity, prey_cnt, predator_cnt, L, N, mu, search_activity, diffusion_coeffs, taxis_coeffs_matrix, species_interaction_coeffs_matrix, carrying_capacity_integral );
  end
  % -----------------------------------------------------------------------
  
  function dwdt = united_system( t, w, f, g )
    species_total_cnt = prey_cnt + predator_cnt;
    dwdt = zeros(2 * species_total_cnt * N, 1);
    dwdt(1:N*species_total_cnt) = f( t, w );
    ksi = g( t, w );
    dwdt(N*species_total_cnt + 1:2*N*species_total_cnt) = ksi(N*species_total_cnt + 1:2*N*species_total_cnt);
  end
  % -----------------------------------------------------------------------
  
  function dwdt = ff( t, w )                     
  % Derivative function  
    h = L / N;

    dwdt = zeros(species_total_cnt * N, 1);

    for ii = 1:species_total_cnt
      offset = (ii - 1) * N;

      xi = 0;
      vect = zeros(species_total_cnt);
      for l = 1:species_total_cnt
        vect(l) = w((l - 1) * N + 1);
      end      
      f0 = logistic(xi, vect);

      interactive_taxis_0 = 0;
      interactive_taxis_1 = 0;
      interactive_taxis_2 = 0;
      for l = 1:species_total_cnt
        interactive_taxis_0 = interactive_taxis_0 + taxis_coeffs_matrix(ii, l) * w(l * N);
        interactive_taxis_1 = interactive_taxis_1 + taxis_coeffs_matrix(ii, l) * w((l - 1) * N + 1);
        interactive_taxis_2 = interactive_taxis_2 + taxis_coeffs_matrix(ii, l) * w((l - 1) * N + 2);
      end

      fi_0 = search_activity(ii) * carrying_capacity((N - 1) * h) + interactive_taxis_0;
      fi_1 = search_activity(ii) * carrying_capacity(0) + interactive_taxis_1;
      fi_2 = search_activity(ii) * carrying_capacity(h) + interactive_taxis_2;

      scalar = 0;
      for l = 1:species_total_cnt
        scalar = scalar + species_interaction_coeffs_matrix(ii, l) * w((l - 1) * N + 1);
      end

      dwdt(offset + 1) = diffusion_coeffs(ii) * (w(offset + 2) - 2 * w(offset + 1) + w(offset + N)) / (h^2) - w(offset + 1) * (fi_2 - 2 * fi_1 + fi_0) / (h^2) + mu(ii) * w(offset + 1) ^ 2 * f0(ii) + scalar * w(offset + 1);

      for j = 2:N - 1          
        xi = (j - 1) * h;
        vect = zeros(species_total_cnt);
        for l = 1:species_total_cnt
          vect(l) = w((l - 1) * N + j);          
        end
        
        f0 = logistic(xi, vect);

        interactive_taxis_0 = 0;
        interactive_taxis_1 = 0;
        interactive_taxis_2 = 0;
        for l = 1:species_total_cnt
          interactive_taxis_0 = interactive_taxis_0 + taxis_coeffs_matrix(ii, l) * w((l - 1) * N + j - 1);
          interactive_taxis_1 = interactive_taxis_1 + taxis_coeffs_matrix(ii, l) * w((l - 1) * N + j);
          interactive_taxis_2 = interactive_taxis_2 + taxis_coeffs_matrix(ii, l) * w((l - 1) * N + j + 1);
        end

        fi_0 = search_activity(ii) * carrying_capacity((j - 1) * h) + interactive_taxis_0;
        fi_1 = search_activity(ii) * carrying_capacity(j * h) + interactive_taxis_1;
        fi_2 = search_activity(ii) * carrying_capacity((j + 1) * h) + interactive_taxis_2;

        scalar = 0;
        for l = 1:species_total_cnt
          scalar = scalar + species_interaction_coeffs_matrix(ii, l) * w((l - 1) * N + j);
        end

        dwdt(offset + j) = diffusion_coeffs(ii) * (w(offset + j + 1) - 2 * w(offset + j) + w(offset + j - 1)) / (h^2) - w(offset + j) * (fi_2 - 2 * fi_1 + fi_0) / (h^2) + mu(ii) * w(offset + j) ^ 2 * f0(ii) + scalar * w(offset + j);
      end

      xi = (N - 1) * h;
      vect = zeros(species_total_cnt);
      for l = 1:species_total_cnt
        vect(l) = w(l * N);          
      end
      f0 = logistic(xi, vect);

      interactive_taxis_0 = 0;
      interactive_taxis_1 = 0;
      interactive_taxis_2 = 0;
      for l = 1:species_total_cnt
        interactive_taxis_0 = interactive_taxis_0 + taxis_coeffs_matrix(ii, l) * w(l * N - 1);
        interactive_taxis_1 = interactive_taxis_1 + taxis_coeffs_matrix(ii, l) * w(l * N);
        interactive_taxis_2 = interactive_taxis_2 + taxis_coeffs_matrix(ii, l) * w((l - 1) * N + 1);
      end

      fi_0 = search_activity(ii) * carrying_capacity((N - 1) * h) + interactive_taxis_0;
      fi_1 = search_activity(ii) * carrying_capacity(N * h) + interactive_taxis_1;
      fi_2 = search_activity(ii) * carrying_capacity(0) + interactive_taxis_2;

      scalar = 0;
      for l = 1:species_total_cnt
        scalar = scalar + species_interaction_coeffs_matrix(ii, l) * w(l * N);
      end

      dwdt(offset + N) = diffusion_coeffs(ii) * (w(offset + 1) - 2 * w(offset + N) + w(offset + N - 1)) / (h^2) - w(offset + N) * (fi_2 - 2 * fi_1 + fi_0) / (h^2) + mu(ii) * w(offset + N) ^ 2 * f0(ii) + scalar * w(offset + N);
    end    
  end
  % -----------------------------------------------------------------------

end  % predator_prey