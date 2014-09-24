function [names,ecs] = get_event_type_codes(b,event_type)
% Get event type codes as longs for all events of a given type

global ttank

access(b)
ecs = ttank.GetEventCodes(string2evtypecode(event_type));

names = {};
for jj = 1:length(ecs)
    names{jj} = ttank.CodeToString(ecs(jj));
end