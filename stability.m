function stability()
%Test the stability of predictive coding models for sythetic tasks of varying size.

figoff=0;

iterations=50;

svals=1:8; %the different tasks "scales" to be used
zetas=[0.0002,0.0005,0.001,0.002,0.005,0.01,0.02,0.05,0.1,0.2,0.5];%the values of zeta to be used by Rao and Ballard's algorithm

%allocate empy arrays to store the results
dim_results_ratio=zeros(1,length(svals));
dim_results_diff=zeros(1,length(svals));
dim_osc=zeros(1,length(svals));
randb_results_ratio=zeros(length(zetas),length(svals));
randb_results_diff=zeros(length(zetas),length(svals));
randb_osc=zeros(length(zetas),length(svals));
sind=0;
%perform experiments for each scale of task
for s=svals
  sind=sind+1;
  
  %define test case
  m=2*s;
  W=define_weights_stability_task(m,s);
  [n,m]=size(W);
  partition{1,1}=1:m;
  x=zeros(m,1);
  x(1:s,1)=1; %pattern that matches RF of 1st neuron in network
  
  %determine response for DIM algorithm
  [y,e,r,ytrace]=dim_activation(W,x,[],iterations);
  
  %check for oscillations and record result
  if max(abs(diff(ytrace(1,end-1:end))))>1
    dim_osc(1,sind)=1;
  else
    dim_results_ratio(1,sind)=y(1)./sum(y);
    dim_results_diff(1,sind)=y(1)-max(y(2:end));
  end
  
  %determine response for Roa and Ballard's algorithm with a range of zeta parameter values
  zind=0;
  for zeta=zetas
    zind=zind+1;
    %determine response
    [y,e,r,ytrace]=randb_pc_activation(W,x,iterations,[],zeta);
    
    %check for oscillations and record result
    if max(abs(diff(ytrace(1,end-1:end))))>1
      randb_osc(zind,sind)=1;
    else
      randb_results_ratio(zind,sind)=y(1)./sum(y);
      randb_results_diff(zind,sind)=y(1)-max(y(2:end));
    end
  end
end

%plot results


figured(figoff+1),
bhandle=plot_results([dim_results_diff;randb_results_diff],[dim_osc;randb_osc],svals,zetas);
ylabel(bhandle, {'prediction neuron';'response difference'},'FontSize',19)
%print_fig('stability_diff.pdf');
%print_fig('stability_diff.eps');


figured(figoff+2), 
bhandle=plot_results([dim_results_ratio;randb_results_ratio],[dim_osc;randb_osc],svals,zetas);
ylabel(bhandle, {'prediction neuron';'response ratio'},'FontSize',19)
%print_fig('stability_ratio.pdf');
%print_fig('stability_ratio.eps');




function bhandle=plot_results(results,osc,svals,zetas)

clf,
phandle=imagesc(results,[0,1]); bhandle=colorbar;
%set(phandle,'AlphaData',~isnan(results))
set(gca,'XTick',[1:length(svals)],'YTick',[1:length(zetas)+1],'XTickLabel',svals(1:length(svals)),'YTickLabel',['   DIM';num2str(zetas')],'FontSize',19);
axis('equal','tight'), 
ylabel('\zeta')
xlabel('s')
colormap('jet')
set(gcf, 'Color', 'w');

hold on
[x,y]=find(osc==1);
plot(y,x,'wx','MarkerSize',10,'LineWidth',2)
