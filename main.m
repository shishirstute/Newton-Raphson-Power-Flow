% Author: Shishir Lamichhane, @Washington State University

clc;
clear all;

%% setting parameters

% tolerance error for voltage and angle for consecutive values
tol_volt = 1e-3;
tol_ang = 1e-3;
tap_include = 0;
solver = 'full_NR'; % full_NR for full newton raphson, fast_decoupled for fast decoupled method
%solver = 'fast_decoupled'
%% getting data

[bus_data, branch_data] = data_extract();
baseMVA = 100;

%% Y bus formation
% calling function for ybus calculation
Ybus = y_bus_calculation(bus_data, branch_data, tap_include);
% getting G and B from Y bus
G = real(Ybus);
B = imag(Ybus);
% converting to polar
[Theta Y_mag]=cart2pol(G,B);

%% initializing solution
% finding types of bus
nbus = length(Ybus); % total bus number
% find indexing of PV bus
PV_bus = find(bus_data.data(:,3)==2);

% find indexing of swing bus
Swing_bus =find(bus_data.data(:,3)==3);

% find indexing of PQ bus
PQ_bus = find(bus_data.data(:,3)==0);

% flat start; initialization
% assign 1 to all voltage
Voltage= ones(nbus,1);
% fix voltage of swing bus and PV bus to given value
% column 4 of bus data contains bus voltage, you can also use column 11
Voltage(Swing_bus) = bus_data.data(Swing_bus,4);
Voltage(PV_bus) = bus_data.data(PV_bus,4);

% assign 0 to all bus angles
Delta= zeros(nbus,1);
% fix bus angle of Swing bus to given value
% column 5 of bus data contains angle
Delta(Swing_bus) = bus_data.data(Swing_bus,5) * pi/180; % converting to radian as well

%% iterations starts from here

% maximum iterations is set as 15
% if value converges within prescribed limit, loop will terminate
 for i=1:200
 
     if i > 2
         max_error_volt = max(abs(Voltage_history(:,i-1)-Voltage_history(:,i-2)));
         max_error_ang = max(abs(Delta_history(:,i-1)-Delta_history(:,i-2)));
         if max_error_volt < tol_volt & max_error_ang < tol_ang
             break;
         end
     end
     % for observing iteration
     i


     % storing v and angle of every iterations
    Voltage_history(:,i) = Voltage;
    Delta_history(:,i) = Delta*180/pi; % to degree as well

    %% calculating mismatch vector
    % listing parameters for mismatch calculation
    mismatch_calc_params.Swing_bus = Swing_bus;
    mismatch_calc_params.PQ_bus = PQ_bus;
    mismatch_calc_params.PV_bus = PV_bus;
    mismatch_calc_params.nbus = nbus;
    mismatch_calc_params.Y_mag = Y_mag;
    mismatch_calc_params.Theta = Theta;
    mismatch_calc_params.Delta = Delta;
    mismatch_calc_params.Voltage = Voltage;
    mismatch_calc_params.bus_data = bus_data;
    mismatch_calc_params.baseMVA = baseMVA;

    % calling function
    [del_P del_Q] = mismatch_calc(mismatch_calc_params);
    del_PQ = [del_P; del_Q];

   
    if strcmpi(solver,'full_NR')
        %% calculating jacobian matrix
        %listing parameters for jacobian calculation
        jacobian_params.nbus = nbus;
        jacobian_params.G = G;
        jacobian_params.B = B;
        jacobian_params.Theta = Theta;
        jacobian_params.Y_mag = Y_mag;
        jacobian_params.PV_bus = PV_bus;
        jacobian_params.Swing_bus = Swing_bus;
        jacobian_params.PQ_bus = PQ_bus;
        jacobian_params.Voltage = Voltage;
        jacobian_params.Delta = Delta;
        % calling jacobian function
        [J11,J12,J21,J22] = jacobian_calc_original(jacobian_params);
        J = [J11 J12;J21 J22];
        
        % solving for delta x
        % delta_x = [delta_angle for non-swing bus; deltaV for PQ bus]
        % passing to solver
        delta_x = crout_solver(J,del_PQ);
        % getting delta_correct(angle) and voltage_correct
        delta_correct = delta_x([1:nbus-length(Swing_bus)]);
        voltage_correct = delta_x(nbus-length(Swing_bus)+1:end);
    elseif strcmpi(solver,'fast_decoupled')
        %% fast decoupled

        % listing parameters for fast decoupled
        f_d_params.del_P = del_P;
        f_d_params.del_Q = del_Q;
        f_d_params.B = B;
        f_d_params.Voltage = Voltage;
        f_d_params.Swing_bus = Swing_bus;
        f_d_params.PQ_bus = PQ_bus;
        % calling function
        [delta_correct, voltage_correct] = fast_decoupled(f_d_params);
    end

    %% updating
    
    % creating parameter list
    update_params.delta_correct = delta_correct;
    update_params.voltage_correct = voltage_correct;
    update_params.Swing_bus = Swing_bus;
    update_params.PV_bus = PV_bus;
    update_params.Voltage = Voltage;
    update_params.Delta = Delta;
    
    % calling function
    [Voltage Delta] = update_value(update_params);
 end


   


