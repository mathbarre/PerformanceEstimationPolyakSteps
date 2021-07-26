% PEP for 2 iterations a nonlinear conjuguate gradient method with Fletcher rule.
% You should add YALMIP, PESTO and an SDP solver such as 
% Mosek to your current path.

clear all; clc;

L=1;
mu=0.01;

betas = linspace(0,25,400);
res=zeros(length(betas),1);

for  k = 1:length(betas)
% (0) Initialize an empty PEP
P = pep();

% (1) Set up the objective function
param.L  = L;      % Smoothness parameter
param.mu = mu;    % Strong convexity parameter

% F is the objective function
F       =P.DeclareFunction('SmoothStronglyConvex',param); 
[xs,fs] = F.OptimalPoint(); % xs is an optimal point, and fs=F(xs)

% (2) Set up the starting point and initial condition
x0 = P.StartingPoint();		 % x0 is some starting point
f0 = F.value(x0);
P.InitialCondition( f0-fs <= 1); % Initial condition F(x0)-F(xs)<= 1

% (3) Algorithm

g0 = F.gradient(x0);
d0 = -g0; % search directions

% exact line search in directions d0
[x1, g1, f1] = exactlinesearch_step(x0,F,d0);

d1 = betas(k)*d0-g1; % compute new search direction
% exact line search in directions d1
[x2, g2, f2] = exactlinesearch_step(x1,F,d1);

% impose beta to be equal to ||g1||^2/||g0||^2
P.InitialCondition(betas(k)*(g0^2)-g1^2 ==0);

% (4) Set up the performance measure
perf_metric = f2 -fs;% Worst-case evaluated as F(x2)-F(xs)
P.PerformanceMetric(perf_metric); 

% (5) Solve the PEP
P.solve()

res(k,1) = double(perf_metric);
end

plot(betas,res)
hold on
plot(betas,ones(length(betas),1)*(L-mu)^4/(L+mu)^4)




