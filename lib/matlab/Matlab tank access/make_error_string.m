function err_string = make_error_string(err_message)

% Turn an error message array into string with linefeeds

nlines = size(err_message,1);
err_string = err_message(1,:);

for jj = 2:nlines
    err_string = sprintf('%s\n%s',err_string,err_message(jj,:));
end