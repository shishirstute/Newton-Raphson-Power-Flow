
function [Ybus] = y_bus_calculation(bus_data, branch_data)
    
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
end


