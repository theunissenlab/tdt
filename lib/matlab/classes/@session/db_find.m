function varargout = db_find(s)

%% Get index of tank in database

%% Process according to db_spec
[spec,pkey_id,values] = db_spec(s);
if nargout > length(pkey_id)
    error('Too many output arguments')
end

%% Call sql_find to query database
varargout = {sql_find(pkey_id,spec,values)};