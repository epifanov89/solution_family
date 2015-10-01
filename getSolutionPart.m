function [ tpart,wpart ] = getSolutionPart( t,w,ptstart,tspan )

tpart = [];
wpart = [];

tstart = t(ptstart);
tf = tstart+tspan;

pt = ptstart;
while t(pt) <= tf
  tpart = [tpart,t(pt)-t(ptstart)];
  wpart = [wpart;w(pt,:)];
  pt = pt+1;
end
end

