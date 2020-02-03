%clc; clear all;

% SOLVER OPTIONS
verbose   =  1;
tolerance = 1e-8;

% PROBLEM & ALGORITHM OPTIONS
L     = 1;
m     = 0.01;
rhos = [];

% the constant in front of (f-f_*)/\|nabla f\|^2,
% polyak_coefficient = 1 for Vanilla Polyak
polyak_coefficient = 2;

gammas = polyak_coefficient*logspace(log10(1/(2*L)),log10(1/(2*m)),50);

for gamma = gammas

% SDP NOTATIONS

% P = [x0 | gx0 gx1]
% F = [fx0 gx1]
dimG = 3;
dimF = 2;

%x_* can be taken to 0 without loss of generality since only x_0-x_* and
% x_1-x_* appears in inequalites.
xs   = zeros(1, dimG); gxs = zeros(1, dimG);
x0 = zeros(1,dimG); x0(1) =1;
gx0 = zeros(1,dimG); gx0(2) =1;
gx1 = zeros(1,dimG); gx1(3) =1;

x1 = x0 - gamma*gx0;

%f_* can be taken to 0 without loss of generality since only f(x_0)-f_* and
% f(x_1)-f_* appears in inequalites.

fxs  = zeros(1, dimF);
fx0  = zeros(1, dimF); fx0(1) = 1;
fx1  = zeros(1, dimF); fx1(2) = 1;





XX = [xs; x0;x1];
GG = [gxs; gx0;gx1];
FF = [fxs; fx0;fx1];

nbPts = 3 ;% xs, x0, x1


G = sdpvar(dimG);
F = sdpvar(dimF, 1);


cons = (G >= 0);

cons = cons + ((x0-xs)*G*(x0-xs).' == 1);

%Definition of the step-size
cons = cons + (polyak_coefficient*(fx0-fxs)*F == gamma*(gx0*G*gx0.'));

%Smooth strongly convex inequalities
for i = 1:nbPts
    for j = 1:nbPts
        if i ~= j
            xi = XX(i,:); gi = GG(i,:); fi = FF(i,:);
            xj = XX(j,:); gj = GG(j,:); fj = FF(j,:);
            cons = cons + ( (fj-fi)*F + gj*G*(xi-xj).' + 1/2/(1-m/L) * (1/L * (gi-gj)*G*(gi-gj).' + m*(xi-xj)*G*(xi-xj).' - 2*m/L *(xi-xj)*G*(gi-gj).')<= 0);
        end
    end
end


obj = (x1-xs)*G*(x1-xs).';

solver_opt = sdpsettings('solver','mosek','verbose',verbose,'mosek.MSK_DPAR_INTPNT_CO_TOL_PFEAS',tolerance);
solverDetails=optimize(cons,-obj,solver_opt);

rhos = [rhos;double(obj)];

end

figure()

plot(gammas,rhos,'LineWidth',2);
hold on ;
if polyak_coefficient == 2
    plot([0 1/2/m*polyak_coefficient],(L-m)^2/(L+m)^2*ones(2,1),'LineWidth',2,'LineStyle','--')
    legend(["convergence rate","$\frac{(L-\mu)^2}{(L+\mu)^2}$"],'Interpreter','latex');
elseif polyak_coefficient ==1
    plot([0 1/2/m*polyak_coefficient],((L-m)^2/(L+m)^2 + L*m/(L+m)^2)*ones(2,1),'LineWidth',2,'LineStyle','--')
    legend(["convergence rate","$\frac{L^2 -L\mu + \mu^2}{(L+\mu)^2}$"],'Interpreter','latex');    
end
xlabel("$\gamma$",'Interpreter','latex');
ylabel("$\rho(\gamma)$",'Interpreter','latex');








