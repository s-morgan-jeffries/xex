function tbd(src,evt,numclicks,h,rr,firstdown)

    numclicks=numclicks+1;
    if numclicks==3, delete([h rr]); numclicks=1;end 
     
temp=get(src,'CurrentPoint');
firstdown(numclicks,1:2)=temp(1,1:2);
h(numclicks)=plot(firstdown(numclicks,1),firstdown(numclicks,2),'ro');
set(h(numclicks),'markersize',10,'markerfacecolor','r');
    

    if numclicks==2
       rr= rectangle('position',[min(firstdown(:,1)),min(firstdown(:,2)),range(firstdown(:,1)),range(firstdown(:,2))]);
    end