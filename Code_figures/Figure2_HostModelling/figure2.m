%% figure 2 -- 2019Demory_light
% figure of the host modelling results

%% setup environment
clear all; close all;

% nbr of parameter set to use in the analysis ... max nn = 5000 (take few
% minutes => so for a code try, use a small nn value).
nn = 100;
t = 0:0.01:32;

%% setup figure
disp('takes some times ...')
figure('position',[0 0 700 2000])
dimc = [0.4660    0.6740    0.1880]; % color for the host strain dynamic
data.ydata = xlsread('dataHOST.xlsx',1);
dataplot.ydata = datamerge(data.ydata,t'); %datamerge function from the MCMC toolbox (https://mjlaine.github.io/mcmcstat/)
load('MED4_mcst.mat') % MCMC results (5000 chains)
res{1}.chain(:,6) = res{1}.chain(:,6)*0.1; %correction of the initial conditions values.

%%  Calculate the output (dynamics) with th nn parameter set
outmod = mcmcpred(res{1}.results,res{1}.chain,res{1}.s2chain,dataplot,@fun_growth,nn);
outPI = mcmcpred(res{1}.results,res{1}.chain,[],dataplot,@fun_PI,nn);


%% Plot the host dynamics 
subplot(5,2,[1,2,3,4]);

% dynamics
mcmcplot_host(outmod,dataplot,1,dimc);

% add data and gray area (dark condition)
hold on
vfill([14 24],'gray','facealpha',0.2,'EdgeColor','none')
%plot(data.ydata(2:end,1), data.ydata(2:end,2),'ok','MarkerFaceColor','k','MarkerSize',10)

% info
ylabel('Cell concentration (Cell.mL^{-1})')
xlabel('time (hours)')
title('a. Uninfected host dynamic')
set(gca,'Xlim',[0 35])
set(gca,'Fontsize',18)

%% histogram 1: \alpha
subplot(5,2,5);
histogram(res{1}.chain(:,1),25,'Facecolor',dimc,'EdgeColor',dimc,'Facealpha',1,'Normalization','probability')
ylabel('Probability')
xlabel('\alpha (h^{-1})','interpreter','tex')
title('b. Growth parameters ')
set(gca,'ylim',[0 0.15])

%% histogram 2: L_{opt}
subplot(5,2,6);
histogram(res{1}.chain(:,2),25,'Facecolor',dimc,'EdgeColor',dimc,'Facealpha',1,'Normalization','probability')
xlabel('L_{opt} (\mu mol quanta m^{-2} s^{-1})','interpreter','tex')
set(gca,'ylim',[0 0.15])

%% histogram 3: \mu_{max}
subplot(5,2,7);
histogram(res{1}.chain(:,3),25,'Facecolor',dimc,'EdgeColor',dimc,'Facealpha',1,'Normalization','probability')
xlabel('\mu_{max} (h^{-1})','Interpreter','tex')
ylabel('Probability')
set(gca,'ylim',[0 0.15])

%% histogram 4: k_{d}
subplot(5,2,8);
histogram(res{1}.chain(:,4),25,'Facecolor',dimc,'EdgeColor',dimc,'Facealpha',1,'Normalization','probability')
xlabel(' k_{d} (\mu mol quanta m^{-2} s^{-1})','Interpreter','tex')
set(gca,'ylim',[0 0.15])

%% histogram 5: \omega
subplot(5,2,9);
histogram(res{1}.chain(:,5),25,'Facecolor',dimc,'EdgeColor',dimc,'Facealpha',1,'Normalization','probability')
xlabel('\omega (h^{-1})','Interpreter','tex')
ylabel('Probability')
set(gca,'ylim',[0 0.15])

%% PI curve
subplot(5,2,10);
hold on
h = mcmcplot_PI(outPI,dataplot,dimc);
xlabel('Light intensity (\mu mol quanta m^{-2} s^{-1})','Interpreter','tex')
ylabel('Gross growth rate (h^{-1})','Interpreter','tex')
set(gca,'Xlim',[0 100])


%% Export

% cleanup figure
set(findall(gcf,'-property','FontSize'),'FontSize',20)
set(findall(gcf,'-property','FontName'),'FontName','Times New Roman')
set(gcf,'renderer','Painters')
set(gcf,'Color','w')

% export
print -dpdf -r600 -painters figure2.pdf
print -depsc2 -tiff -r600 -painters figure2.eps
print -dpng -r600 -painters figure2.png