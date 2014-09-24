function varargout = display(dt)

%% DISPLAY(dt) Display a datetime object

dstr = [disp(dt.dateobj), ' ', disp(dt.timeobj)];

switch nargout
    case 0
        disp(dstr);
    case 1
        varargout{1} = dstr;
    otherwise
        error('Too many output arguments')
end