function[bus_data, branch_data] = data_extract()

    addpath("C:\Users\shish\OneDrive - Washington State University (email.wsu.edu)\WSU_class\fall 2023\EE521\Homework\Homework1\Matlab\data\")
    %importing bus data
    %data and text data field is created 
    %data field description starts-
    % -3>>bus type(0-PQ,2-PV,3-Swing)
    %-6>> load MW, -7>> load MVAR, -8>>generation MW, -9>>generation MVAR,
    %-10>>KV base, -11>>desired voltage on bus if this is controlling other bus
    %-12>>maximum MVAR, -13>>minimum MVAR, -14>>Shunt conductance G(per unit)
    %-15>>shunt susceptance B(per unit), -16>>remote controlled bus number
    %bus data field description ends
    bus_data = importdata("bus_data.txt");
    
    %branch data is created, note structure is not created ghere as branch data
    %text file contains number only
    %data field description starts--
    %-1>> start bus number, -2>>end bus number, -7>>R(per unit), -8>>X(per unit)
    %-9>>Line charging B(per unit), -15>>transformer final turn ratio, 
    branch_data = importdata('branch_data.txt');
end
