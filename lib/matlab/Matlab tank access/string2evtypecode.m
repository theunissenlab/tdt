function event_type_code = string2evtypecode(event_type_name)
% Convert TDT data types into event types
% This should really be a TDT function, but they don't provide it

switch lower(event_type_name)
    case 'unknown'
        event_type_code = '00000000';
    case 'strobe+'
        event_type_code = '00000101';
    case 'strobe-'
        event_type_code = '00000102';
    case 'scalar'
        event_type_code = '00000201';
    case 'stream'
        event_type_code = '00008101';
    case 'snip'
        event_type_code = '00008201';
    case 'mark'
        % N.b. although this case is in the TTankX.EvCodeToString,
        % documentation, the function does not yet support it
        event_type_code = '00008801';
    case 'hasdata'
        % N.b. although this case is in the TTankX.EvCodeToString,
        % documentation, the function does not yet support it
        event_type_code = '00008000';
    otherwise
        error('Event type ''%s'' not recognized',event_type_name)
end

event_type_code = hex2dec(event_type_code);