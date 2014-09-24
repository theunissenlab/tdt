function obj = db_get(varargin)

%% Construct an epoc object from the database

%% Check input against specs
classname = varargin{1};
if ismethod(classname,'db_spec')
    [spec,pkey_name] = db_spec(eval(classname));
    if nargin-1 ~= length(pkey_name)
        error('Number of input arguments does not match class spec')
    end
else
    error('DbFind:NoSpec',...
        'No database specification is present for class ''%s''',classname);
end

%% Construct SELECT expression
nfields = length(spec);
select_expr = [spec(1).column];
for jj = 2:nfields
    select_expr = [select_expr ',' spec(jj).fields];
end

%% Construct table expression for FROM clause
for jj = 1:nfields
    tables{jj} = [spec(jj).schema '.' spec(jj).table];
end
tables = unsort_unique(tables);
table_references = tables{1};
for jj = 2:length(tables)
    table_references = [table_references ' NATURAL JOIN ' tables{jj}];
end

%% Construct WHERE expression
n_key_fields = length(pkey_name);
where_expr = [pkey_name{1} ' = ' sql_str(varargin{2})];
for jj = 2:n_key_fields
    where_expr = [where_expr ' AND ',...
        pkey_name{jj} ' = ' sql_str(varargin{2+jj})];
end

%% Construct SQL command and retrieve data
sql_cmd = sprintf('SELECT %s FROM %s WHERE %s;',select_expr,...
    table_references,where_expr);
result = mysql(sql_cmd);

%% Assign data