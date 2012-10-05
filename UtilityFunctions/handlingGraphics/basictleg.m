
%	hacked scriptlet for annegret to insert legends quickly into her t-graphs

chi=get(gcf,'children');

m=findobj(chi,'tag','axes6');
if ~isempty(m)
axes(m);
leg=legend('dT outRF +','dT outRF -');
end

m=findobj(chi,'tag','axes5');
if ~isempty(m)
axes(m);
legend('uT outRF +','uT outRF -');
end

m=findobj(chi,'tag','axes3');
if ~isempty(m)
axes(m);
legend('dT inRF +','dT inRF -','uT inRF -');
end

m=findobj(chi,'tag','axes2');
if ~isempty(m)
axes(m);
legend('uT inRF +','uT inRF -','dT inRF -');
end

m=findobj(chi,'tag','axes1');
if ~isempty(m)
axes(m);
legend('uT inRF +','dT inRF +','uT outRF +','dT outRF +');
end