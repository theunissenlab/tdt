function str_out = sql_find_str(target_fields,db_spec,nfields,noutputs)

% Construct a find string from a database spec

select_expr = target_fields{1};
for jj = 2:noutputs
    select_expr = [select_expr ',' target_fields{jj}];
end

%% Build table and where expressions
table_references = [db_spec(1).schema '.' db_spec(1).table];
where_condition = db_spec(1).column;
for jj = 2:nfields
    table_references = [table_references ' NATURAL JOIN ',...
        db_spec(jj).schema '.' db_spec(jj).table];
    where_condition = [where_condition ' AND ' db_spec(jj).column];
end

%% Build SQL command and evaluate
sql_cmd = sprintf('SELECT %s FROM %s WHERE %s;',select_expr,...
    table_references,where_condition);