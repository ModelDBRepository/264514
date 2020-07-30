function [y,e,r,ytrace]=randb_pc_activation(W,x,iterations,y,zeta)
%implements the Rao and Ballard method of calculating the prediction and error
%neuron responses in a predictive coding network

vartheta=0; %0.05;
if nargin<5 || isempty(zeta), zeta=0.1; end
if nargin<3 || isempty(iterations), iterations=25; end

[n,m]=size(W);
[nInputChannels,batchLen]=size(x);
if nargin<4 || isempty(y)
  y=zeros(n,batchLen); %initialise prediction neuron outputs
end
if nargout>3, ytrace(:,1)=y; end

if 0
  for t=1:iterations
    %linear model with Gaussian prior
    r=W'*y;
    e=x-r;
    y=((1-vartheta)*y)+zeta.*(W*e);
    %y(y<0)=0;
    if nargout>3, ytrace(:,t+1)=y; end
  end
else
  for t=1:iterations
    %dy= -vartheta*y + zeta.*W*x - zeta.*(W*W')*y; %linear model with Gaussian prior (formulated like lateral-inhib)
    dy= -vartheta*y + zeta.*W*(x - W'*y); %linear model with Gaussian prior
    %dy= -vartheta*(y./(1+y.^2)) + zeta.*W*(x - W'*y); %linear model with kurtotic prior
    %dy= -vartheta*y + zeta.*W*(1-tanh(x-tanh(W'*y)).^2);%non-linear model with Gaussian prior
    %dy= -vartheta*(y./(1+y.^2)) + zeta.*W*(1-tanh(x-tanh(W'*y)).^2);%non-linear model with kurtotic prior
    y=y+dy;
    %y(y<0)=0;
    if nargout>3, ytrace(:,t+1)=y; end
  end
  r=W'*y;
  e=x-r; %linear model
  %e=(1-tanh(x-tanh(W'*y)).^2); %non-linear model
end
