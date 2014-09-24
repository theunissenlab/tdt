function [spec,pkey_name,values] = db_spec(b)

% Specify where to find the relevant fields in the database

pkey_name = {'tdt_block_id'};
property_names = {
    'field'   'schema'        'table'     'column'};
spec = {
    'name'    'tdt_data'      'blocks'    'block_name'
    };
spec = cell2struct(spec,property_names,2);

% Assign value from structure data
for jj = 1:length(spec)
    values{jj} = b.(spec(jj).field);
end

% Insert values for tank as well
[t_spec,t_pkey,t_values] = db_spec(b.tank);
spec = [spec;t_spec];
values = [values,t_values];