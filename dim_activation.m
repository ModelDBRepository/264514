function [y,e,r,ytrace]=dim_activation(W,x,V,iterations,y)
%implements the PC/BC-DIM method of calculating the prediction and error
%neuron responses in a predictive coding network
epsilon1=1e-6;
epsilon2=1e-4;
if nargin<4 || isempty(iterations), iterations=25; end

[n,m]=size(W);
[nInputChannels,batchLen]=size(x);
if nargin<5 || isempty(y)
  y=zeros(n,batchLen,'single'); %initialise prediction neuron outputs
end
%set feedback weights equal to feedforward weights normalized by maximum value 
if nargin<3 || isempty(V)
  V=bsxfun(@rdivide,abs(W),max(1e-6,max(abs(W),[],2)));
end
V=V'; %avoid having to take transpose at each iteration

if nargout>3, ytrace(:,1)=y; end
for t=1:iterations  
  %update responses
  r=V*y;
  %e=x./max(epsilon2,r);
  e=x./(epsilon2+r);
  %y=max(epsilon1,y).*(W*e);
  y=(epsilon1+y).*(W*e);
  if nargout>3, ytrace(:,t+1)=y; end
end	

