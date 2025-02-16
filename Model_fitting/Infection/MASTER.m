clear all; close all; clc;

% s is a scalar from 0 to 1 (viral strain id):
% HM2 -> s = 0
% SSP7 -> s = 1
s = 0;

% Hypo = hypothesis to test: 0 to 7
%	0 = H0
%	1 = H1_\phi
%	2 = H1_\beta
%	3 = H1_\lambda
%	4 = H2_\phi\beta
%	5 = H2_\phi\lambda
%	6 = H2_\lambda\beta
%	7 = H3
Hypo = 0;

% delayLysis = initial model (0) or lysis inhibition model (1)
delayLysis = 1;

% nsimu = length of the mcmc chains
nsimu = 1000;

% nRun = number of mcmc run
nRun = 1;

[data,resmcmc] = main_SEIV_parasearch_MCMC(s,Hypo,delayLysis,nsimu,nRun);