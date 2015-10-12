function varargout = myode4(ode,tspan,y0,options,fixed_var_index,fixed_var_value,stopOnCycleDetection,eps,varargin)
%MYODE4 Summary of this function goes here
%   Detailed explanation goes here

% Output
FcnHandlesUsed  = isa(ode,'function_handle');

% Handle solver arguments
ntspan = length(tspan);
t0 = tspan(1);
tfinal = tspan(end);     
y0 = y0(:);
neq = length(y0);
f0 = feval(ode,t0,y0,varargin{:});

% Determine the dominant data type
dataType = superiorfloat(t0,y0,f0);     

% Handle the output
if nargout > 0
  outputFcn = odeget(options,'OutputFcn',[],'fast');
else
  outputFcn = odeget(options,'OutputFcn',@odeplot,'fast');
end
outputArgs = {};      
if isempty(outputFcn)
  haveOutputFcn = false;
else
  haveOutputFcn = true;
  outputs = odeget(options,'OutputSel',1:neq,'fast');
  if isa(outputFcn,'function_handle')  
    % With MATLAB 6 syntax pass additional input arguments to outputFcn.
    outputArgs = varargin;
  end  
end

tpoincareout = [];
ypoincareout = [];

% Handle the event function 
haveEventFcn = 0;   % no Events function
valt = [];
teout = [];
yeout = [];
ieout = [];

eventFcn = odeget(options,'Events',[],'fast');
if ~isempty(eventFcn)
  if FcnHandlesUsed
    haveEventFcn = 1;
  end
  valt = feval(eventFcn,t0,y0,varargin{:});
end

% Non-negative solution components
idxNonNegative = odeget(options,'NonNegative',[],'fast');
nonNegative = ~isempty(idxNonNegative);
if nonNegative  % modify the derivative function
  ode = odenonnegative(ode,idxNonNegative);
  f0 = feval(ode,t0,y0,varargin{:});
end

t = t0;
y = y0;

% Allocate memory if we're generating output.
nout = 0;
tout = []; yout = [];
if nargout > 0
  % output only at tspan points
  tout = zeros(1,ntspan,dataType);
  yout = zeros(neq,ntspan,dataType);
  nout = 1;
  tout(nout) = t;
  yout(:,nout) = y;  
end

% Initialize method parameters.
A = [0.25,0.5,1,1];
B = [
    1/4           0           1         1
    0             1/2         -2        -2
    0             0           2         2
    0             0           0         0
    ];
f = zeros(neq,4,dataType);
f(:,1) = f0;

% Initialize the output function.
if haveOutputFcn
  feval(outputFcn,[t tfinal],y(outputs),'init',outputArgs{:});
end

% THE MAIN LOOP

msg = sprintf('t = %f',tspan(nout));
fprintf(msg);
reverseStr = repmat(sprintf('\b'), 1, length(msg));

%stop_next = 0;
done = false;
while ~done
  h = tspan(nout+1)-tspan(nout);
  if nout == ntspan-1
    done = true;
  end
  
  hA = h * A;
  hB = h * B;
  
  f(:,2) = feval(ode,t+hA(1),y+f*hB(:,1),varargin{:});
  f(:,3) = feval(ode,t+hA(2),y+f*hB(:,2),varargin{:});
  f(:,4) = feval(ode,t+hA(3),y+f*hB(:,3),varargin{:});
  
  tnew = t + hA(4);  
  ynew = y + f*hB(:,4);
  
  if nonNegative && any(ynew(idxNonNegative)<0)
    ynew(idxNonNegative) = max(ynew(idxNonNegative),0);
  end
  
  if (nargin >= 6) && (sign(ynew(fixed_var_index)-fixed_var_value) ~= sign(y(fixed_var_index)-fixed_var_value))
    tpoincare = tnew-(tnew-t)*(ynew(fixed_var_index)-fixed_var_value)/(ynew(fixed_var_index)-y(fixed_var_index));
    ypoincare = ynew-(ynew-y)*(ynew(fixed_var_index)-fixed_var_value)/(ynew(fixed_var_index)-y(fixed_var_index));

    if nargout > 2
      tpoincareout = [tpoincareout, tpoincare];
      ypoincareout = [ypoincareout, ypoincare];
    end
    if (nargin >= 8) && stopOnCycleDetection...
        && (norm(ypoincare(end),ypoincare(end-2)) < eps) % Stop on a terminal event.               
      % Adjust the interpolation data to [t te(end)].   

      tnew = tpoincare;
      ynew = ypoincare;
      h = tnew - t;
      done = true;
    end
  end
  
  if haveEventFcn
    % Initialize.
    te = [];
    ye = [];
    ie = [];
    stop = 0;
    
%     if stop_next
%       done = true;
%     end
    
    [vnew,isterminal,direction] = feval(eventFcn,tnew,ynew,varargin{:});
    if isempty(direction)
      direction = zeros(size(vnew));   % zeros crossings in any direction
    end
    indzc = find((sign(valt) ~= sign(vnew)) & (direction .* (vnew - valt) >= 0));
    
    j = ones(1,length(indzc));
    te = tnew(j);
    ye = ynew(:,j);
    ie = indzc';
    
    if any(isterminal(indzc)) && t ~= t0
      stop = 1;
%       stop_next = 1;
    end
    
    valt = vnew;
    
    if ~isempty(te)
      if nargout > 4
        teout = [teout, te];
        yeout = [yeout, ye];
        ieout = [ieout, ie];
      end
      if stop               % Stop on a terminal event.               
        % Adjust the interpolation data to [t te(end)].
        
        tnew = te(end);
        ynew = ye(:,end);
        h = tnew - t;
        done = true;
      end
    end
  end
  
  if haveOutputFcn
    stop = feval(outputFcn,tnew,ynew(outputs),'',outputArgs{:});
    if stop
      done = true;
    end  
  end
    
  nout = nout + 1;
  
  tout(nout) = tnew;
  yout(:,nout) = ynew;    

  if done
    break
  end
  
  % Advance the integration one step.
  t = tnew;
  y = ynew;
  
  f(:,1) = feval(ode,tnew,ynew,varargin{:});
  
  msg = sprintf('t = %f',tspan(nout));
  fprintf([reverseStr, msg]);
  reverseStr = repmat(sprintf('\b'), 1, length(msg));
end

fprintf(reverseStr);

if ~isempty(outputFcn)
  feval(outputFcn,[],[],'done',outputArgs{:});
end

solver_output = {};
  
if (nout > 0)
  solver_output{1} = tout.';
  solver_output{2} = yout(:,1:nout).';
  solver_output{3} = tpoincareout.';
  solver_output{4} = ypoincareout.';
  solver_output{5} = teout.';
  solver_output{6} = yeout.';
  solver_output{7} = ieout.';
end

if nargout > 0
  varargout = solver_output;
end

function odeFcn = odenonnegative(ode,idxNonNegative)
  odeFcn = @local_odeFcn_nonnegative;

  % -----------------------------------------------------------
  % Nested function: ODE with nonnegativity constraints imposed
  %
    function yp = local_odeFcn_nonnegative(t,y,varargin)
      yp = feval(ode,t,y,varargin{:}); 
      ndx = idxNonNegative( find(y(idxNonNegative) <= 0) );
      yp(ndx) = max(yp(ndx),0);
    end  % local_odeFcn_nonnegative
  % -----------------------------------------------------------
end
% -----------------------------------------------------------------------

end
