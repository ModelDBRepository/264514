function stability_example()
%Test the stability of predictive coding models for a sythetic task

figoff=0;

iterations=50;

s=2;
m=s*2;

W=define_weights_stability_task(m,s)
[n,m]=size(W)
partition{1,1}=1:m;

%define test cases
x=zeros(m,1);
x(1:s,1)=1;

%present test cases to network and record results
[y,e,r,ytrace]=dim_activation(W,x,[],iterations);
figured(figoff+1),clf
plot_network({x},{y},{e},{r},partition)
figured(figoff+2),clf
if min(ytrace(:))<0, lo=-1; else, lo=0; end
plot([0:iterations],ytrace'); axis([0,iterations,lo,1])
xlabel('iteration'); ylabel('y')

[y,e,r,ytrace]=randb_pc_activation(W,x,iterations);
figured(figoff+3),clf
plot_network({x},{y},{e},{r},partition)
figured(figoff+4),clf
if min(ytrace(:))<0, lo=-1; else, lo=0; end
plot([0:iterations],ytrace'); axis([0,iterations,lo,1])
xlabel('iteration'); ylabel('y')

figured(figoff+5),clf, imagesc(W); drawnow
title('Weights')
ylabel('neuron');xlabel('input')
