function val = get(s,propName)

% GET Get singlepres properties from the specified object
% and return the value
try
    val = get(s.presentation,propName);
catch
    switch propName
        case 'presentation'
            val = s.presentation;
        case 'stim'
            val = s.stim;
        case 'type'
            val = get(s.stim,'type');
        case 'starttime'
            val = s.starttime;
        case 'endtime'
            val = s.endtime;
        otherwise
            error([propName,' Is not a valid property for singlepres'])
    end
end