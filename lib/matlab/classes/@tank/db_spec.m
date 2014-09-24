function [spec,pkey_name,values] = db_spec(t)

% Specify where to find the relevant fields in the database

pkey_name = {'tank_id'};
property_names = {
    'field'     'schema'        'table'     'column'};
spec = {
    'name'      'tdt_data'      'tanks'    'tank_name'
    };
spec = cell2struct(spec,property_names,2);

% Assign value from structure data
for jj = 1:length(spec)
    values{jj} = t.(spec(jj).field);
end