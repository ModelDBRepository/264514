function plot_network(x,y,e,r,partition,inputs,centres)
numStages=length(y);
if nargin<5 || isempty(partition)
  for s=1:numStages
    partition{s,1}=[1:length(x{s})];
  end
end


for s=1:numStages
  ax=maxsubplot(3,numStages,2*numStages+s,0.15);
  bar(y{s},1,'FaceColor',[220,40,40]./255),axis([0.5,length(y{s})+0.5,0,1.05])
  ylabel('y');
  
  numPartitions=0;
  for p=1:size(partition,2)
    if ~isempty(partition{s,p})
      numPartitions=numPartitions+1;
    end
  end
  
  if min(e{s})<0, elow=-0.5; else, elow=0; end
  for p=1:numPartitions
    xtmp=x{s}(partition{s,p});
    %rtmp=r{s}(partition{s,p});
    etmp=e{s}(partition{s,p});
    
    maxsubplot(3,numStages*numPartitions,(s-1)*numPartitions+p,0.2);
    bar(xtmp,1,'k'),axis([0.5,length(xtmp)+0.5,0,1.05])
    if p==1, ylabel('x'); end

    %maxsubplot(4,numStages*numPartitions,2*numStages*numPartitions+(s-1)*numPartitions+p,0.15);
    %bar(rtmp,1,'FaceColor',[0,0.7,0]),axis([0.5,length(xtmp)+0.5,0,1.05])

    maxsubplot(3,numStages*numPartitions,numStages*numPartitions+(s-1)*numPartitions+p,0.2);
    bar(etmp,1,'FaceColor',[0,120,220]./255),axis([0.5,length(xtmp)+0.5,elow,2.5])
    if p==1, ylabel('e'); end
  end
end

cmap=colormap('gray');cmap=1-cmap;colormap(cmap);
drawnow;
