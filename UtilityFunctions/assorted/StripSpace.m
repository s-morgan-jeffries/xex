function XexParameters=StripSpace(XexParameters)


WhereSpace=find(isspace(XexParameters));
if length(WhereSpace)>1&&WhereSpace(1)==1
    DiffSpace=diff(WhereSpace);
    FirstDiff=min(find(DiffSpace>1));
    if isempty(FirstDiff)

        XexParameters=XexParameters((WhereSpace(end)+1):end);
        
    else
        
        XexParameters=XexParameters((WhereSpace(FirstDiff)+1):end);
        
    end
elseif length(WhereSpace)==1&&WhereSpace(1)==1
    XexParameters=XexParameters(2:end);
end