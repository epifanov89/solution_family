function [ right_parts,linearized,resource,nprey,npredator,N,tlast,fixed_var_index,fixed_var_value,first_phas_var_index,second_phas_var_index ] = params(X)
%PARAMS Summary of this function goes here
%   Detailed explanation goes here
% Длина временного интервала интегрирования до установления
tlast = 50;

% Число популяций жертв
nprey = 1;
% Число популяций хищников
npredator = 1;
nspecies = nprey + npredator;

N = length(X);
h = X(2)-X(1);
L = N*h;

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

right_parts = @f;
linearized = @g;
resource = @carrying_capacity;
                                   

  % -----------------------------------------------------------------------
  % Nested functions. Problem parameters provided by the outer function.
  %
  
  function inverse_carrying_capacity_integral_array = compute_integrals()
    inverse_carrying_capacity_integral_array = zeros(1, N);
    
    for point_index = 1:N
      % Рассчитываем координату текущей точки сетки
      xcur = X(point_index);
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
  
  function P = carrying_capacity( x )
  % Carrying capacity function
    P = 1+0.2*exp(-0.0*x/L).*sin(2*pi*x/L);
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

end

