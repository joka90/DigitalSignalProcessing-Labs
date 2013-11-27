function pdf_print(fileName);
plot_export_size=20;%cm
%set(gcf,'PaperUnits','cm');
set(gcf,'PaperSize', [plot_export_size plot_export_size]);
set(gcf,'PaperPosition',[0 0 plot_export_size plot_export_size]);
set(gcf,'PaperPositionMode','Manual');
print(gcf, '-dpdf', fileName);


