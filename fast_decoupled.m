
function [delta_correct_de, voltage_correct_de] = fast_decoupled(f_d_params)

    del_P = f_d_params.del_P;
    del_Q = f_d_params.del_Q;
    B = f_d_params.B;
    Voltage = f_d_params.Voltage;
    Swing_bus = f_d_params.Swing_bus;
    PQ_bus = f_d_params.PQ_bus;
    
    %% for delta correction
    V_delta = Voltage;
    V_delta(Swing_bus) = [];
    del_P_bar = del_P./V_delta;
    B_delta = -B;
    B_delta(Swing_bus,:) = [];
    B_delta(:,Swing_bus) = [];
    delta_correct_de = crout_solver(B_delta,del_P_bar);
    
    %% for voltage correction
    V_volt = Voltage(PQ_bus);
    del_Q_bar = del_Q./V_volt;
    B_volt = -B(PQ_bus, PQ_bus);
    voltage_correct_de = crout_solver(B_volt, del_Q_bar);
end
