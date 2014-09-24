function c = assign_defaults(classspec,nfields)
% Assign defaults to fields from classes
for jj = 1:nfields
    % For some reason, calling numeric class constructors requires an argument even if
    % it's null
    if isnum_class(classspec(jj).class)
        c.(classspec(jj).name) = eval([classspec(jj).class,'([])']);
    else
        c.(classspec(jj).name) = eval(classspec(jj).class);
    end
end