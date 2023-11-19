function [del_P del_Q P_calc Q_calc] = mismatch_calc(mismatch_calc_params)

    
    Swing_bus = mismatch_calc_params.Swing_bus;
    PQ_bus = mismatch_calc_params.PQ_bus;
    PV_bus = mismatch_calc_params.PV_bus;
    nbus = mismatch_calc_params.nbus;
    Y_mag = mismatch_calc_params.Y_mag;
    Theta = mismatch_calc_params.Theta;
    Delta = mismatch_calc_params.Delta;
    Voltage = mismatch_calc_params.Voltage;
    bus_data = mismatch_calc_params.bus_data;
    baseMVA = mismatch_calc_params.baseMVA;
    
    % column 6 and 8 conains real power load and generation
    % this calculates for swing bus also based on bus data but will not be
    % used as P_sch for swing bus is not known before solving
    P_gen = bus_data.data(:,8);
    P_gen = P_gen/baseMVA; % to pu value
    P_load = bus_data.data(:,6);
    P_load = P_load/baseMVA;
    % column 7 and 9 conains reactive power load and generation
    % this calculates for swing bus and PV bus also based on bus data but will not be
    % used as Q_sch for such bus is not known before solving
    Q_gen = bus_data.data(:,9);
    Q_gen = Q_gen/baseMVA; % to pu value
    Q_load = bus_data.data(:,7);
    Q_load = Q_load/baseMVA; % to pu value
    
    %% for testing 
    % % this problem is 9.2 from power system analysis by John J Grainger's book
    % Ybus =[
    % 
    %    8.9852-44.8360i -3.8156+19.0781i -5.1696+25.8478i 0.0000+0.0000i;
    %   -3.8156+19.0781i 8.9852-44.8360i 0.0000+0.0000i -5.1696+25.8478i;
    %   -5.1696+25.8478i 0.0000+0.0000i 8.1933-40.8638i -3.0237+15.1185i;
    %    0.0000+0.0000i -5.1696+25.8478i -3.0237+15.1185i 8.1933-40.8638i];
    % nbus = length(Ybus);
    % PV_bus = [4];
    % Swing_bus =[1];
    % PQ_bus = [2 3];
    % Voltage= ones(nbus,1);
    % Voltage(PV_bus) = 1.02;
    % Delta= zeros(nbus,1);
    % % getting G and B from Y bus
    % G = real(Ybus);
    % B = imag(Ybus);
    % [Theta Y_mag]=cart2pol(G,B);
    % baseMVA = 100;
    % P_gen = [0 0 0 318]/baseMVA;
    % P_load = [50 170 200 80]/100;
    % Q_gen = [0 0 0 0];
    % Q_load = [30.99 105.35 123.94 49.58]/baseMVA;
    
    
    
    
    %finding P,Q-calculated
        P_calc = zeros(nbus,1);
        Q_calc = zeros(nbus,1);
        for i=1:nbus
            for j=1:nbus
                P_calc(i) = P_calc(i) + Y_mag(i,j)*Voltage(i)*Voltage(j)*cos(Theta(i,j)+Delta(j)-Delta(i));
                Q_calc(i) = Q_calc(i) - Y_mag(i,j)*Voltage(i)*Voltage(j)*sin(Theta(i,j)+Delta(j)-Delta(i));
            end
        end
    
        %% finding P,Q-scheduled
        % calculating for P 
        P_sch =  P_gen - P_load;
        % calculating for Q
        Q_sch = Q_gen - Q_load;
    
       %% finding mismatch
       % finding size of mismatch
       del_P = zeros(length(PV_bus)+length(PQ_bus),1);
       del_Q = zeros(length(PQ_bus),1);
       nsb = length(Swing_bus);
       pv_count = 0;
       for i = 1:nbus
           if ~(ismember(i,Swing_bus))
               % for index balancing, nsb is subtracted
               % see jacobian_calc file for further illustration of such
               % concept
               del_P(i-nsb) = P_sch(i) - P_calc(i);
               if ismember(i,PV_bus)
                   pv_count = pv_count +1;
               else
                   del_Q(i-pv_count-nsb) = Q_sch(i) - Q_calc(i);
               end
           end
       end
    
       % all mismatch in one vector
       del_PQ = [del_P; del_Q];
end
