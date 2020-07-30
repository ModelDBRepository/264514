function print_fig(fileName)

if exist('export_fig')==2 %&& exist('resize_matlab_figure_window')==2
  %set figure window to standard size, as export_fig uses onscreen size to define printed size
  
  system(['wmctrl -r Figures -e 0,-1,-1,800,500']); %if more than one MATLAB window this command will resize first one only, which is not necessarily the one being printed!
  
  system(['./resize_matlab_figure_window ',int2str(feature('getpid'))]); %will resize the figure window for this instance of MATLAB, but not 100% reliable!

  set(gcf, 'Color', 'w'); 
  export_fig(fileName,'-a1'); 
else
  disp('WARNING: using std print command');
  print(fileName,'-dpdf');
end
