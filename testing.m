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