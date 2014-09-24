function ec = db_insert(c)

% Insert epoc data exported from TDT into the database

%% Check if code exists in the database already
mysql('use tdt_data');
ec = db_find(c);

if ec
    error('SQL:Insert',...
        'Epoc code is already present in database')
else
    sql_cmd = sprintf(...
        'INSERT INTO epoc_codes (epoc_code) VALUES (''%s'');',c.code);
    mysql(sql_cmd);
end

ec = db_find(c);