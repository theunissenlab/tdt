function db_insert(e)
%function epoc_ids = db_insert(e)

% Insert data from exported TDT file to the database

%% Check if epoc code is present in tank; if not, insert it

ec = db_find(code(e));
if isempty(ec)
    db_insert(code(e));
end

%% Check if block is present in tank; if not, insert it

b = db_find(e.block);
if isempty(b)
    db_insert(e.block);
end

%% Insert data into table
%epoc_ids = zeros(1,e.number);

for jj = 1:number(e)
    sql_cmd = sprintf(['INSERT INTO epocs ',...
        '(tdt_block_id,epoc_code,epoc_value,epoc_start,epoc_end) ',...
        'VALUES(%0.0f,''%s'',%0.0f,%0.20g,%0.20g)'],db_find(e.block),...
        db_find(code(e)),e.value(jj),e.starttime(jj),e.endtime(jj));
    mysql(sql_cmd);
end