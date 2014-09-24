function varargout = disp(d)

%% DISPLAY(t) Display a date object

dstr = datestr(datenum([d.year,d.month,d.day,zeros(1,3)]));

switch nargout
    case 0        
        disp(dstr);
    case 1
        varargout{1} = dstr;
    otherwise
        error('Too many output arguments.')
end