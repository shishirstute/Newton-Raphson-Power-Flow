
function [Ybus] = y_bus_calculation(bus_data, branch_data,tap_include)
    
    % %for testing
    % nbus =4;
    % nbranch = 4;
    % start_bus = [1 1 2 3];
    % end_bus = [2 3 4 4];
    % branch_imp = [0.01008 0.0504 0.1025;
    %     0.00744 0.0372 0.0775;
    %     0.00744 0.0372 0.0775;
    %     0.01272 0.0636 0.1275
    %     ]
    % 
    % bus_adm = [0 0;
    %     0 0;
    %     0 0;
    %     0 0]
    % 
    % getting required data

    %getting conductance(14th column) and susceptance(15th) of each bus
    %bus_adm=[G, B]
    bus_adm = bus_data.data(:,14:15);

    % getting branch impedance (R--7th, X--8th, B--9th)
    branch_imp = [branch_data(:,7:9)];

    % getting start bus of branch
    start_bus = branch_data(:,1);
    %getting end bus of branch
    end_bus = branch_data(:,2);
    %getting number of bus
    nbus = length(bus_data.data(:,1));
    %getting number of branch
    nbranch = length(branch_data(:,1));


    Ybus = zeros(nbus,nbus);
    for j=1 : nbranch
        s = start_bus(j);
        e = end_bus(j);
        R = branch_imp(j,1);
        X = branch_imp(j,2);
        B = branch_imp(j,3);
        Ybus(s,e) = -(1/complex(R,X));
        Ybus(e,s) = Ybus(s,e);
        Ybus(s,s) = Ybus(s,s) + (-1)*Ybus(s,e) + 1i*0.5*B;
        Ybus(e,e) = Ybus(e,e) + (-1)*Ybus(s,e) + 1i*0.5*B;
    end
    
    for j = 1: nbus
        Ybus(j,j) = Ybus(j,j) + bus_adm(j,1) + 1i*bus_adm(j,2);
    end

    if tap_include == 1
        Ybus_tap = Ybus;
        % importing tap value magnitude
        tap_mag = branch_data(:,15);
        % importing tap angle value
        tap_angle = branch_data(:,16);
        % getting complex quantity for tap value
        tap_value = complex(pol2cart(tap_angle*pi/180,tap_mag));
        % just for checking
        %tap_value(:)=1;
        %tap_value = 1./tap_value;
        tap_branch_index = find(~branch_data(:,15)==0);
        for num_tap = 1:length(tap_branch_index)
            % getting branch index for tap
            j = tap_branch_index(num_tap);
            s = start_bus(j);
            e = end_bus(j);
            R = branch_imp(j,1);
            X = branch_imp(j,2);
            B = branch_imp(j,3);
            % dividing by conj(a) where a is transformer tap ratio
            Ybus_tap(s,e) = Ybus(s,e)/conj(tap_value(j));
            % divide by a
            Ybus_tap(e,s) = Ybus(e,s)/tap_value(j);
            % incorporated divided by a^2 to starting node (i)
            Ybus_tap(s,s) = Ybus_tap(s,s) - (-1)*Ybus(s,e) + (-1)*Ybus(s,e)/(abs(tap_value(j))^2);
            % no change to impedance node
            Ybus_tap(e,e) = Ybus(e,e);
        end
        Ybus = Ybus_tap;
    end

end


