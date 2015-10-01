function solve_and_plot_solution( X,tstep,filepath )
%SOLVE_AND_PLOT_SOLUTION Summary of this function goes here
%   Detailed explanation goes here
[right_parts_of_equations,linearized_system,carrying_capacity,nprey,npredator,N,tlast,...
    fixed_var_index,fixed_var_value,...
    first_phas_var_index,second_phas_var_index] = params(X);
  
plot_fcn_approx(X,carrying_capacity);
  
h = X(2)-X(1);
L = N*h;

nspecies = nprey+npredator;
nvar = nspecies*N;

if ~exist(filepath,'file')
  w0 = zeros(1,nvar);
  for pt = 1:N
    w0(pt) = u10((pt-1)*h);
    w0(N+pt) = u20((pt-1)*h);
  end
  
  tpoincareall = [];
  tstart = 0;
else
  load(filepath,'w0','tpoincareall','wpoincareend','tstart');
end
  
figure
[t,w,tpoincare,wpoincare,~] = ...
    myode4(right_parts_of_equations,tstart:tstep:tlast-tstart,w0,...
           odeset('NonNegative',1:nvar,...
                  'OutputFcn',@odephas2,...
                  'OutputSel',[first_phas_var_index,...
                               second_phas_var_index]),...
           fixed_var_index,fixed_var_value);

w0 = w(end,:);
tpoincareall = [tpoincareall,tpoincare];
tstart = t(end);
save(filepath,'w0','tpoincareall','tstart');

if ~isempty(wpoincare)
  wpoincareend = wpoincare(end,:);
  save(filepath,'wpoincareend','-append');
end
         
if t(end) == tlast
  % Ќаходим разницу между последними двум€ временами пересечени€ 
  % секущей плоскости отображени€ ѕуанкаре 
  % (дл€ периодического решени€ это будет период)
  T = tpoincareall(end)-tpoincareall(end-2);
  save(filepath,'T','-append');
end

plot_spatiotemporal_distributions(nprey,npredator,X,t,w);

u = w(:,first_phas_var_index);
v = w(:,second_phas_var_index);

figure
hold on
h1 = plot(t,u);
label(h1,'1','location','center');
h2 = plot(t,v);
label(h2,'2','location','center');
xlabel('t');
ylabel('u, v','rot',0);
hold off


  % -----------------------------------------------------------------------
  % Nested functions. Problem parameters provided by the outer function.
  %

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

end

