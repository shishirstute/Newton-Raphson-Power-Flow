
function [Voltage Delta] = update_value(update_params)

    % reading parameters values
    delta_correct = update_params.delta_correct;
    voltage_correct = update_params.voltage_correct;
    Swing_bus = update_params.Swing_bus;
    PV_bus = update_params.PV_bus;
    Voltage = update_params.Voltage;
    Delta = update_params.Delta;
    
    nsb = length(Swing_bus);
    nbus = length(Voltage);
    pv_count = 0;
    for i=1:nbus
        if ~ismember(i,Swing_bus)
            % no need to correct angle of swing bus
            % change angle of non-swing bus only
            Delta(i) = Delta(i) + delta_correct(i-nsb);
            if ismember(i,PV_bus)
                % no need to change voltage of PV bus
                pv_count = pv_count + 1;
            else
                % change voltage of non-PV, non-swing bus
                %Voltage(i) = Voltage(i)*(1+voltage_correct(i-nsb-pv_count));
                Voltage(i) = Voltage(i) + voltage_correct(i-nsb-pv_count);
            end
        end
    end
end



