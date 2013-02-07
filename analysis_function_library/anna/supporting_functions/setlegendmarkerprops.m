function setlegendmarkerprops(legend_h, markerprops)

lines = findobj(get(legend_h,'children'),'type','line');
markerpropind = 1;
% keyboard;
for k = length(lines):-2:1
	if ~isempty(markerprops(markerpropind))
		cur_marker_h = lines(k-1);
		settable_props = fieldnames(set(cur_marker_h));
		nonsettable_props = setdiff(fieldnames(markerprops{markerpropind}), settable_props);
		markerprops{markerpropind} = rmfield(markerprops{markerpropind}, nonsettable_props);
		set(cur_marker_h, markerprops{markerpropind});
		% keyboard;
	end
	markerpropind = markerpropind + 1;
end