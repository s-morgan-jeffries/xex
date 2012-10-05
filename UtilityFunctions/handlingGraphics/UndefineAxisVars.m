evalString='';
AxisVars=handles.AxisVariable;
for tempind=1:length(AxisNum)
    AxisVars(AxisNum(tempind)).XAxis='Undefined';
    AxisVars(AxisNum(tempind)).YAxis='Undefined';
end

handles.AxisVariable=AxisVars;