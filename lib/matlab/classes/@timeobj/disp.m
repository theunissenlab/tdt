function varargout = disp(t)

%% DISPLAY(t) Display a time object

hrstr = sprintf('%0.0f',t.hour);
if t.hour < 10
    hrstr = ['0',hrstr];
end

minstr = sprintf('%0.0f',t.minute);
if t.minute < 10
    minstr = ['0',minstr];
end

secstr = sprintf('%0.0f',t.second);
if t.second < 10
    secstr = ['0',secstr];
end

tstr = sprintf('%s:%s:%s',hrstr,minstr,secstr);

switch nargout
    case 0        
        disp(tstr);
    case 1
        varargout{1} = tstr;
    otherwise
        error('Too many output arguments.')
end