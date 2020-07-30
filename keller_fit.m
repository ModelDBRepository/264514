function keller_fit
%plot the experimental data predicted by the Zmarz and Keller model of V1
%mismatch neurons


%define ranges used to bin running speed (p) and visual flow (v)
p=exp(-2.772588722:0.693147181:4.16);
v=exp(4.158883083:-0.693147181:-2.78);
[P V]=meshgrid(p,v);


%Zmarz and Keller's model
%A=0.049;   % parameter value given in paper
A=16;      % parameters value that fits the data
d=0.049;
a=0.012;
b=0.009;
sat=0.08;
r=d+A./(1+exp(-(a.*P-b.*V)./sat)); % parameters that seem to fit data
figured(1), plot_fit(r,p,v)


%subtractive model
r=0.25.*(P-V); max(max(r))
figured(2),plot_fit(r,p,v);title('P-V')
%print_fig('keller_fit_randb_linear.pdf');
%print_fig('keller_fit_randb_linear.eps');


%subtractive model - in log space
r=2.5.*(log(P)-log(V)); max(max(r))
figured(3),plot_fit(r,p,v);title('log(P)-log(V)')
%print_fig('keller_fit_randb_log.pdf');
%print_fig('keller_fit_randb_log.eps');



function plot_fit(r,p,v)
clf
imagesc(r,[0,16]), axis('equal','tight'), 
s=[0.06,0.25,1,4,16,64];
%colorbar
tolabelp=3:2:12;
tolabelv=1:2:10;
set(gca,'XTick',tolabelp-0.25,'YTick',tolabelv+0.5,'XTickLabel',p(tolabelp),'YTickLabel',v(tolabelv),'FontSize',19);
%set(gca,'XTick',[],'YTick',[],'FontSize',21);

ylabel('visual flow speed (V)')
xlabel('running speed (P)')
colormap('jet')
set(gcf, 'Color', 'w'); 