function [spec,pkey_name,values] = db_spec(e)

% Specify where to find the relevant fields in the database

pkey_name = {'epoc_id'};
property_names = {
    'field'         'schema'        'table'     'column'};
spec = {
    'name'          'tdt_data'      'epocs'     'epoc_code';...
    'value'         'tdt_data'      'epocs'     'epoc_value';...
    'starttime'     'tdt_data'      'epocs'     'epoc_start';...
    'endtime'       'tdt_data'      'epocs'     'epoc_end'
    };
spec = cell2struct(spec,property_names,2);

% Assign value from structure data
for jj = 1:length(spec)
    values{jj} = e.(spec(jj).field);
end

% Insert values for tdt block as well
[b_spec,b_pkey,b_values] = db_spec(e.block);
spec = [spec;b_spec];
values = [values,b_values];