
function x=suggest_varname(x,hObject)

% Funktion schl�gt Name f�r Variable vor, den es noch nicht im workspace
% gibt, angefangen wird mit x, das Vorschlag wird, wenn hObjct �bergeben
% wurde, in den String von hObject geschrieben und auch zur�ck gegeben
% letzte �nderung 11.08.2010
if exist_in_base_ws(x)==0
    set(hObject,'UserData',0)
    set(hObject,'string',x) 
    return
end
i=2;
while exist_in_base_ws(sprintf('%s%i',x,i))==1
    i=i+1;
end
x=sprintf('%s%i',x,i);
if isempty(hObject)
    return
end
set(hObject,'UserData',0)
set(hObject,'string',x)
