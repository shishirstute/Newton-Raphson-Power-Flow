function [] = plot_function(Voltage_history,Delta_history)
      
    Voltage_history = Voltage_history;
    iterations = length(Voltage_history(1,:));
    nbus = length(Voltage_history(:,1));
    x_data = 1:iterations;
    Delta_history = Delta_history;
    %% plotting voltage
    figure;
    xlabel('iteration number');
    ylabel('Voltage (pu)');
    %title('FDPF bus Voltage magnitude including tap');
    title('NRPF bus Voltage magnitude excluding tap');
    set(gca,'XTick',x_data, 'fontsize', 11);
    grid on;
    
    for i = 1:nbus
    
        hold on;
        plot(Voltage_history(i,:),'LineWidth',1.2,'DisplayName',strcat('bus',num2str(i)));
    end
    lgd = legend('NumColumns',3);
    
    %% plotting angle
    figure;
    xlabel('iteration number');
    ylabel('Angle (Degree)');
    title('NRPF Angle excluding tap');
    set(gca,'XTick',x_data, 'fontsize', 11);
    grid on;
    
    for i = 1:nbus
    
        hold on;
        plot(Delta_history(i,:),'LineWidth',1.2,'DisplayName',strcat('bus',num2str(i)));
    end
    lgd = legend('NumColumns',3);
    
    % For comparing bus voltage between NRPF and FDPF
    % figure;
    % %title('FDPF bus Voltage magnitude including tap');
    % x_data = 1:14;
    % set(gca,'XTick',x_data, 'fontsize', 11);
    % grid on;
    % plot(V_NRPF,'LineWidth',1.2);
    % hold on;
    % plot(Voltage,'LineWidth',1.2);
    % xlabel('bus number');
    % ylabel('Voltage (pu)');
    % title('Bus Voltage Magnitude');
    % legend('NRPF','FDPF');
    % xlim([1,14]);
    
    % for comparing angle between NRPF and FDPF
    % figure;
    % %title('FDPF bus Voltage magnitude including tap');
    % x_data = 1:14;
    % set(gca,'XTick',x_data, 'fontsize', 11);
    % grid on;
    % plot(Delta_NRPF,'LineWidth',1.2);
    % hold on;
    % plot(Delta_history(:,10),'LineWidth',1.2);
    % xlabel('bus number');
    % ylabel('Angle(Degree)');
    % title('Bus Voltage Angle');
    % legend('NRPF','FDPF');
    % xlim([1,14]);



end


