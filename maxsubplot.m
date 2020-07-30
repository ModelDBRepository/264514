function position=maxsubplot(rows,cols,ind,fac)
%Create subplots that are larger than those produced by the standard subplot command.
%Good for plots with no axis labels, tick labels or titles.
%*NOTE*, unlike subplot new axes are drawn on top of old ones; use clf first
%if you don't want this to happen.
%*NOTE*, unlike subplot the first axes are drawn at the bottom-left of the
%window.

if nargin<4, fac=0.05; end
position=[(fac/2)/cols+rem(min(ind)-1,cols)/cols,(fac/2)/rows+fix((min(ind)-1)/cols)/rows,(length(ind)-fac)/cols,(1-fac)/rows];
axes('Position',position); 
