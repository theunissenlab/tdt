function ec = db_find(c)

% Get index of tank in database

mysql('use tdt_data');
sql_cmd = sprintf(['SELECT epoc_code ',...
    'FROM epoc_codes WHERE epoc_code = ''%s'';'],c.code);
result = mysql(sql_cmd);
ec = [result.epoc_code];