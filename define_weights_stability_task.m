function W=define_weights_stability_task(m,s)
%define weights so that nodes represent every combination of s out of m
c=nchoosek(1:m,s);
n=size(c,1); 
W=zeros(n,m); 
for i=1:n, 
  W(i,c(i,:))=1; 
end
W=bsxfun(@rdivide,W,max(1e-6,sum(abs(W),2)));

