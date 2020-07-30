function multisensory_integration_log(method)
%perform feature integration given two features represented by Gaussian population codes
if nargin<1 || isempty(method)
  method='DIM'; %'randb'; %
end
figoff=0;

%define range of values over which feature values can vary, and how these ranges
%are sampled in input space and by feature-integration neurons
lowest=0.0625/4;
highest=64*4;
instep=1.75;
centstep=3;

inputs=[log(lowest):log(instep):log(highest)];
centres=[log(lowest):log(centstep):log(highest)];
partition{1,1}=[1:length(inputs)];
partition{1,2}=length(inputs)+[1:length(inputs)];

stdW=log(1.5*instep);
stdx=log(2*1.5*instep);

%define weights, to produce a 2d basis function network, where nodes have gaussian RFs.
W=[];
for c=centres
  W=[W;code(c,inputs,stdW,0,1),code(c,inputs,stdW,0,1)];
end
W=W./2;
[n,m]=size(W);

%define test cases
X=zeros(m,4);
X(:,1)=[code(log(40),inputs,stdx),code(log(40),inputs,stdx)]'; %running and visual flow
X(:,2)=[code(log(40),inputs,stdx),code(log(1),inputs,stdx)]';  %running and no visual flow
X(:,3)=[code(log(1),inputs,stdx), code(log(40),inputs,stdx)]'; %no running and visual flow
X(:,4)=[code(log(1),inputs,stdx), code(log(1),inputs,stdx)]'; %no running and no visual flow
X(:,5)=[code(log(40),inputs,stdx), 0*code(log(1),inputs,stdx)]'; %running in dark
X(:,6)=[code(log(1),inputs,stdx), 0*code(log(1),inputs,stdx)]'; %no running in dark

%present test cases to network and show results
for k=1:size(X,2)
  x=X(:,k);
  switch method
    case 'DIM'
      [y,e,r]=dim_activation(W,x);
    case 'randb'
      [y,e,r]=randb_pc_activation(W,x);
  end
  figured(figoff+k),clf
  plot_network({x},{y},{e},{r},partition)
end

%define ranges used to bin running speed (p) and visual flow (v)
visual=exp(-2.772588722:0.693147181:4.16);
motion=exp(-2.772588722:0.693147181:4.16);
mismatch_fit=ones(length(visual),length(motion),length(e)).*NaN;
integrate_fit=ones(length(visual),length(motion),length(y)).*NaN;
vc=0;
for v=visual
  vc=vc+1;
  mc=0;
  for m=motion
    mc=mc+1;
    x=[code(log(m),inputs,stdx),code(log(v),inputs,stdx)]';
    switch method
      case 'DIM'
        [y,e,r]=dim_activation(W,x);
      case 'randb'
        [y,e,r]=randb_pc_activation(W,x);
    end
    mismatch_fit(vc,mc,:)=e;
    integrate_fit(vc,mc,:)=y;
  end
end

%show responses of error neurons to different combinations of p and v
figured(figoff+11),clf
num=size(mismatch_fit,3);
[rows,cols]=best_subplot_rows_cols(num);
%rows=5; cols=9;
range=[min(0,min(mismatch_fit(:))),0.85.*max(mismatch_fit(:))]
for i=1:num
  maxsubplot(rows,cols,i); imagesc(flipud(mismatch_fit(:,:,i)),range); axis('equal','tight','off')
end
colormap('jet')
set(gcf, 'Color', 'w'); 
%switch method
%  case 'DIM'
%    export_fig('multisensory_integration_RFs_DIM.pdf','-a1');
%    export_fig('multisensory_integration_RFs_DIM.eps','-a1');
%  case 'randb'
%    export_fig('multisensory_integration_RFs_randb.pdf','-a1');
%    export_fig('multisensory_integration_RFs_randb.eps','-a1');    
%end

%show responses of prediction neurons to different combinations of p and v
figured(figoff+12),clf
num=size(integrate_fit,3);
[rows,cols]=best_subplot_rows_cols(num);
%rows=6;cols=6;
range=[min(0,min(integrate_fit(:))),max(integrate_fit(:))]
for i=1:num
  maxsubplot(rows,cols,i); imagesc(flipud(integrate_fit(:,:,i)),range); axis('equal','tight','off')
end
colormap('jet')
