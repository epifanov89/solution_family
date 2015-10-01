function yout = myode4_2(ode,tspan,y0,options)
%MYODE4_2 Summary of this function goes here
%   Detailed explanation goes here

% Handle solver arguments
ntspan = length(tspan);
t0 = tspan(1);
tfinal = tspan(end);
neq = length(y0); 

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
end

t = t0;
y = y0;

% Allocate memory if we're generating output.
yout = [];
if nargout > 0
  yout = zeros(ntspan,neq);
  yout(1,:) = y;  
end

% Initialize method parameters.
alpha = [0.25,0.5,1];
beta = [
       0             0
       1/4           0
       0             1/2
       ];
p = [1 -2 2 0];

% Initialize the output function.
if haveOutputFcn
  feval(outputFcn,[t tfinal],y(outputs),'init',outputArgs{:});
end

k = zeros(neq,3);
sz = size(k);

% THE MAIN LOOP

for nout = 1:ntspan-1
  h = tspan(nout+1)-tspan(nout);
  
  for j = 1:sz(2)
    sum = 0;
    for l = 1:j-1
      sum = sum + k(:,l)*beta(j,l);
    end
    k(:,j) = h*ode(t+h*alpha(j),y+sum);
  end
  
  tnew = t + h;  
  ynew = y + k(:,1)*p(1) + k(:,2)*p(2) + k(:,3)*p(3);
  
  if haveOutputFcn
    outputFcn(tnew,ynew(outputs),'');
  end
  
  yout(nout+1,:) = ynew;    
  
  t = tnew;
  y = ynew;  
end

if haveOutputFcn
  feval(outputFcn,[],[],'done');
end
