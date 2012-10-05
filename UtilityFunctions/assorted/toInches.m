
%This little scriptlet changes the units of all children of current figure to inches

Children=get(gcf,'children');
set(Children,'units',inches');