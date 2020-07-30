function figured(figNum)
%Alternative to the "figure" command that does not grab focus unless the figure window needs to be created
figHandles = findobj('Type','figure');

if sum(figNum==figHandles)<0.5
  %new figure number, so create
  figure(figNum);
else
  %existing figure number, so use without giving that figure focus
  drawnow; %but empty buffer first
  set(0,'CurrentFigure',figNum);
end