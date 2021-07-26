% PEP for gradient descent with exact line search.
% You should add YALMIP, PESTO and an SDP solver such as 
% Mosek to your current path.

clc; clear all;
L=1;
m=0.01;
gammas = logspace(-0.2,-log10(m)+0.02,100);

res = zeros(length(gammas),1);
l=1;
for gamma = gammas

% (0) Initialize an empty PEP
P = pep();

% (1) Set up the objective function


% F is the objective function
params.mu = m;
params.L  = L;
F = P.DeclareFunction('SmoothStronglyConvex',params); 


% (2) Set up the starting point and initial condition
x0      = P.StartingPoint();		 % x0 is some starting point
[xs,fs] = F.OptimalPoint(); % xs is an optimal point, and fs=F(xs)
f0      = F.value(x0);
g0      = F.gradient(x0);
P.InitialCondition(f0-fs <= 1); % Initial condition F(x0)- F(xs)<= 1
%P.InitialCondition(g0^2 <= 1); % Initial condition ||g0||^2<= 1
%P.InitialCondition((x0-xs)^2 <= 1); % Initial condition ||x0-xs||^2<= 1

% (3) Algorithm

x1 = x0 - gamma*g0;
g1 = F.gradient(x1);
f1 = F.value(x1);

P.InitialCondition(g1*g0 == 0); % Exact line search condition

% (4) Set up the performance measure
perf_metric = F.value(x1)-fs;% Worst-case evaluated as F(x1)-F(xs)
%perf_metric = g1^2;% Worst-case evaluated as ||g1||^2
%perf_metric = (x1-xs)^2;% Worst-case evaluated as ||x1-xs||^2
P.PerformanceMetric(perf_metric); 


% (5) Solve the PEP
P.solve()
res(l) = double(perf_metric);
l=l+1;
end

plot(gammas,res)