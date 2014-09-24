function [spec,pkey_name,values] = db_spec(s)

% Specify where to find the relevant fields in the database

pkey_name = {'session_id'};
property_names = {
    'field'     'schema'    'table'     'column'};
spec = {
    'date'      'cells'     'sessions'  'date'
    };
spec = cell2struct(spec,property_names,2);

% Assign value from structure data
for jj = 1:length(spec)
    values{jj} = s.(spec(jj).field);
end

% Insert values for room as well
[r_spec,r_pkey,r_values] = db_spec(s.room);
spec = [spec;r_spec];
values = [values;r_values];