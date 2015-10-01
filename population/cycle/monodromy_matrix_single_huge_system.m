function C = monodromy_matrix_single_huge_cauchy_problem( f, linearized_system, solver, tspan, w0, nvar, odeset )
%MONODROMY_MATRIX ������ ������� ����������, ����� ���� ������� �������
%   ��� ���������� ����� ���� �������� ������� ���������� �� ������� 
%   �������� ������� �������� ���� ������� �������, ������������ �� 
%   ��������� �������� ������� ���� ������� ���, ������� ��������� � 
%   �������� � �������, ��������� � ���������, ��� � �������� ��������� 
%   ������ ��� ���� ����� ��������� � ��������� ������� ��������� ����, 
%   ��������� ��������������� � ���� ������� ������

  C = zeros(nvar);
    
  w0_new = zeros(1, (nvar + 1) * nvar);
  w0_new(1:nvar) = w0;
  for var_index = 1:nvar
    w0_new((nvar + 1) * var_index) = 1;
  end
  [~, sol] = solver(@united_system, tspan, w0_new, odeset);
  for col_index = 1:nvar
    C(:, col_index) = sol(end, nvar * col_index + 1:nvar * (col_index + 1));
  end
  
  function dwdt = united_system( t, w )
    dwdt = zeros((nvar + 1) * nvar, 1);
    dwdt(1:nvar) = f( t, w );
    for basis_vector_index = 1:nvar
      offset = nvar * basis_vector_index;
      ksi = linearized_system( t, w, basis_vector_index );
      dwdt(offset + 1:offset + nvar) = ksi;% * w(offset + 1:offset + nvar);
    end
  end
end