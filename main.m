% Author: Shishir Lamichhane, @Washington State University

clc;
clear all;


%% getting data

[bus_data, branch_data] = data_extract()

%% Y bus formation
% calling function for ybus calculation
Ybus = y_bus_calculation(bus_data, branch_data);
% getting G and B from Y bus
G = real(Ybus);
B = imag(Ybus);
% converting to polar
[Theta Y_mag]=cart2pol(G,B);
%% initializing solution

% finding types of bus
nbus = length(Ybus);
PV_bus = find(bus_data.data(:,3)==2);
Swing_bus =find(bus_data.data(:,3)==3);
PQ_bus = find(bus_data.data(:,3)==0);

% flat start; initialization
V= ones(nbus,1);
Delta= zeros(nbus,1);

% calling jacobian calculation function
jacobian_params.nbus = nbus;
jacobian_params.G = G;
jacobian_params.B = B;
jacobian_params.Theta = Theta;
jacobian_params.Y_mag = Y_mag;
jacobian_params.PV_bus = PV_bus;
jacobian_params.Swing_bus = Swing_bus;
jacobian_params.PQ_bus = PQ_bus;
jacobian_params.V = V;
jacobian_params.Delta = Delta;
[J11,J12,J21,J22] = jacobian_calc(jacobian_params);
J = [J11 J12;J21 J22];



%% calculating Jacobian matrix



