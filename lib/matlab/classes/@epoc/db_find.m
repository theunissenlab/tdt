function varargout = db_find(e)

%% Get index of epoc in database

%% Process according to db_spec
[spec,pkey_id,values] = db_spec(e);
if nargout > length(pkey_id)
    error('Too many output arguments')
end

%% Call sql_find to query database
varargout = {sql_find(pkey_id,spec,values)};