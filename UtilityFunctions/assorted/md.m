function md(num)

%	This function is a hack to quickly make directories from 'c1' to 'c'num in the current directory
%	The day's data can then be moved into individual cell directories

for ind=1:num
    eval(['!mkdir c' num2str(ind)]);
end