% On nettoie l'espace de travail
clc;clear all;close all;

%Initialisation selon les données de la question
V_0 = -1.5;
n_0 = 0.5;
t_simu = 200;
I = 1;

%Utilisation de la fonction ode (cfr. Rapport)
ode(V_0, n_0, t_simu, I);