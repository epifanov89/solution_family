function [ rightParts,linearizedSystem,res,...
    nprey,npredator,tstep ] = predatorPrey2x1Params(...
  preyDiffusionCoeff,secondPredatorDiffusionCoeff,...
  firstPredatorMortality,resourceDeviation,N)

tstep = 0.002;

% Число популяций жертв
nprey = 1;
% Число популяций хищников
npredator = 2;
nspecies = nprey + npredator;

% Длина кольца
L = 1;
h = L/N;

X = zeros(N,1);
for pt = 1:N
  X(pt) = (pt-1)*h;
end

% Коэффициенты собственного роста / смертности
% популяций
proportionalityRatio = 0.8;
growth = [3; -firstPredatorMortality; -proportionalityRatio*firstPredatorMortality];
% Коэффициенты поисковой активности
search_activity = [0.1; 0; 0];
% Коэффициенты диффузии
diffusion_coeffs = [preyDiffusionCoeff; 0.3; secondPredatorDiffusionCoeff];
% Коэффициенты направленной миграции
taxis_coeffs_matrix = [0    -0.2 -0.3
                       0.4     0    0
                       0.32    0    0];
% Коэффициенты хищничества
species_interaction_coeffs_matrix = [0 -1 -1
                                     2.5  0  0
                                     2  0  0];

res = @(x) resource(x,resourceDeviation);
                                   
% Вычисляем интегралы от функции, обратной к функции ресурса, на каждом
% шаге сетки
inverse_carrying_capacity_integral_array = compute_integrals();

rightParts = @f;
linearizedSystem = @g;
                                   

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
      inverse_carrying_capacity_integral_array(point_index) = integral(@(x) res(x).^(-1), xstart, xend) / h;
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
    dwdt = right_parts_of_equations( w, nprey, npredator, X, @growth_fcn, search_activity, diffusion_coeffs, taxis_coeffs_matrix, species_interaction_coeffs_matrix, res, inverse_carrying_capacity_integral_array );
  end
  % -----------------------------------------------------------------------        
  
  function dwdt = g( ~, w, basis_vector_index )
    dwdt = linearized_system( w, basis_vector_index, nprey, npredator, X, growth, search_activity, diffusion_coeffs, taxis_coeffs_matrix, species_interaction_coeffs_matrix, res, inverse_carrying_capacity_integral_array );
  end
  % -----------------------------------------------------------------------

end

