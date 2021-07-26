% PEP for Regularized Anderson acceleration with 2 points.
% You should add YALMIP, PESTO and an SDP solver such as 
% Mosek to your current path.

clc; clear all;
L=1;
m=0.1;
cs = linspace(0.5,4,300);

lambdas = [0.1];
res = zeros(length(cs),length(lambdas));
l=1;
for c = cs
j = 1;
for lambda = lambdas

P = pep();

% (1) Set up the objective function


% F is the objective function
params.mu=m;
params.L = L;
F=P.DeclareFunction('SmoothStronglyConvex',params); 



% (2) Set up the starting point and initial condition
x0      = P.StartingPoint();		 % x0 is some starting point
[xs,fs] = F.OptimalPoint(); % xs is an optimal point, and fs=F(xs)
f0      = F.value(x0);
g0      = F.gradient(x0);
P.InitialCondition( g0^2 <= 1); % Initial condition ||g0||^2<= 1


% (3) Algorithm

x1 = x0-1/L * g0;
g1 = F.gradient(x1);

xe = x0 - c/L*g0; % update xe = (1-c)x0 + c x1

% optimality condition for c
P.InitialCondition((g0*(g0-g1) + lambda*g0^2) == c*((g1-g0)^2 + 2*lambda*g0^2));




% (4) Set up the performance measure
gxe = F.gradient(xe);
perf_metric = gxe^2;
P.PerformanceMetric(perf_metric); % Worst-case evaluated as ||gxe||^2


% (5) Solve the PEP
P.solve()
res(l,j) = double(perf_metric);
j = j+1;
end
l=l+1;
end

plot(cs,res)