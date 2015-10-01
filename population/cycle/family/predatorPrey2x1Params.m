function [ rightParts,linearizedSystem,res,...
    nprey,npredator,tstep ] = predatorPrey2x1Params(...
  preyDiffusionCoeff,secondPredatorDiffusionCoeff,...
  firstPredatorMortality,resourceDeviation,N)

tstep = 0.002;

% ����� ��������� �����
nprey = 1;
% ����� ��������� ��������
npredator = 2;
nspecies = nprey + npredator;

% ����� ������
L = 1;
h = L/N;

X = zeros(N,1);
for pt = 1:N
  X(pt) = (pt-1)*h;
end

% ������������ ������������ ����� / ����������
% ���������
proportionalityRatio = 0.8;
growth = [3; -firstPredatorMortality; -proportionalityRatio*firstPredatorMortality];
% ������������ ��������� ����������
search_activity = [0.1; 0; 0];
% ������������ ��������
diffusion_coeffs = [preyDiffusionCoeff; 0.3; secondPredatorDiffusionCoeff];
% ������������ ������������ ��������
taxis_coeffs_matrix = [0    -0.2 -0.3
                       0.4     0    0
                       0.32    0    0];
% ������������ �����������
species_interaction_coeffs_matrix = [0 -1 -1
                                     2.5  0  0
                                     2  0  0];

res = @(x) resource(x,resourceDeviation);
                                   
% ��������� ��������� �� �������, �������� � ������� �������, �� ������
% ���� �����
inverse_carrying_capacity_integral_array = compute_integrals();

rightParts = @f;
linearizedSystem = @g;
                                   

  % -----------------------------------------------------------------------
  % Nested functions. Problem parameters provided by the outer function.
  %
  
  function inverse_carrying_capacity_integral_array = compute_integrals()
    inverse_carrying_capacity_integral_array = zeros(1, N);
    
    for point_index = 1:N
      % ������������ ���������� ������� ����� �����
      xcur = X(point_index);
      % ���������� ������� ����� �������� �����
      % ���������� ��� �������� � ��� ����� ��������������� �����
      xstart = xcur - h/2;
      xend = xcur + h/2;
      % � ���������� �������, ����������� ����� ����� ����� �������
      % ������ �������� �� �������, �������� � ������� �������, �� �����
      % �������
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

