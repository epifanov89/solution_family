function dwdt = right_parts_of_equations_cubic_nonlinearity( w, carrying_capacity, prey_cnt, predator_cnt, L, N, mu, search_activity, diffusion_coeffs, taxis_coeffs_matrix, species_interaction_coeffs_matrix, inverse_carrying_capacity_integral, carrying_capacity_integral )                     
% Derivative function
  species_total_cnt = prey_cnt + predator_cnt;

  h = L / N;

  dwdt = zeros(species_total_cnt * N, 1);

  for ii = 1:species_total_cnt
    offset = (ii - 1) * N;  

    for j = 1:N
      xi = (j - 1) * h;
      
      i1 = mod(j + N - 2, N) + 1;
      i2 = j;
      i3 = mod(j, N) + 1;

      fi_0 = 0;
      fi_1 = 0;
      fi_2 = 0;
      for l = 1:species_total_cnt
        fi_0 = fi_0 + taxis_coeffs_matrix(ii, l) * w((l - 1) * N + i1);
        fi_1 = fi_1 + taxis_coeffs_matrix(ii, l) * w((l - 1) * N + i2);
        fi_2 = fi_2 + taxis_coeffs_matrix(ii, l) * w((l - 1) * N + i3);
      end
      
      if search_activity(ii) ~= 0
        % –ассчитываем координаты предыдущей, текущей и следующей точек сетки
        xprev = (i1 - 1) * h;
        xcur = (i2 - 1) * h;
        xnext = (i3 - 1) * h;
      
        fi_0 = fi_0 + search_activity(ii) * carrying_capacity(xprev);
        fi_1 = fi_1 + search_activity(ii) * carrying_capacity(xcur);
        fi_2 = fi_2 + search_activity(ii) * carrying_capacity(xnext);
      end

      scalar = 0;
      for l = 1:species_total_cnt
        scalar = scalar + species_interaction_coeffs_matrix(ii, l) * w((l - 1) * N + i2);
      end

      q_0 = diffusion_coeffs(ii) * (w(offset + i2) - w(offset + i1)) / h - (w(offset + i2) + w(offset + i1)) / 2 * (fi_1 - fi_0) / h;
      q_1 = diffusion_coeffs(ii) * (w(offset + i3) - w(offset + i2)) / h - (w(offset + i3) + w(offset + i2)) / 2 * (fi_2 - fi_1) / h;

      if ii <= prey_cnt
        if nargin < 12
          inverse_carrying_capacity_integral = integral(@(x) carrying_capacity(x).^(-1), xi - h/2, xi + h/2) / h;
        end
        s = 0;
        for l=1:prey_cnt
          s = s + w((l - 1) * N + i2);
        end
        f0 = w(offset + i2) * (1 - s * inverse_carrying_capacity_integral);
      else
        f0 = 1;
      end

      dwdt(offset + i2) = (q_1 - q_0) / h + mu(ii) * w(offset + i2)^2 * f0 + scalar * w(offset + i2);
    end
  end    
end