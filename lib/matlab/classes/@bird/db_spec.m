function [spec,pkey_name,values] = db_spec(b)

% Specify where to find the relevant fields in the database

pkey_name = {'bird_id'};
property_names = {
    'field'         'schema'    'table'     'column'};
spec = {
    'bandnumber'    'birds'     'birds'     'bandnumber'
    };
spec = cell2struct(spec,property_names,2);

% Assign value from structure data
for jj = 1:length(spec)
    values{jj} = b.(spec(jj).field);
end