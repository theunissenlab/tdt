function s = display(dt)

%% SQL_STR(dt) Print a datetime object for SQL injection
%
% MySQL 5.0 requires that DATETIME values be entered in the form
% 'YY-MM-DD HH:MM:SS' or 'YYYY-MM-DD HH:MM:SS'. Except for the year
% value, the number of digits is not at all flexible, making zero-padding
% necessary. INSERT and UPDATE commands entered with a single-digit year,
% month, day, hour, minute, or second will cause a value of 0 
% ('0000-00-00 00:00:00') to be stored in the database. The same is true
% for out-of-range values (e.g. 60 seconds or 36 hours).
%
% MySQL 5.0 discards fractional seconds. For compatibility, this program
% replicates that functionality and truncates second values, discarding any
% fraction.
%
% For more details, see
% http://dev.mysql.com/doc/refman/5.0/en/datetime.html

if dt == 0
    % Treat datetime values of 0 as null
    s = 'NULL';
else
    % Zero-pad and trim numbers if needed
    dv = datevec(dt);
    ds = cell(size(dv));
    for jj = 1:length(dv)
        if dv(jj) < 10
            ds{jj} = ['0',num2str(floor(dv(jj)))];
        else
            ds{jj} = num2str(floor(dv(jj)));
        end
    end
    
    % Print string with single quote marks around it
    s = sprintf('''%s-%s-%s %s:%s:%s''',ds{:});
end