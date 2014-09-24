function dstr = disp(s)

%% DISPLAY(t) Display a default object

% dstr = sprintf(['Session: %s\nStarttime: %s\nBlock name: %s\n'...
%                 'Tank Name: %s\nProtocol: %s',get(b,'sessionid'),...
%                 disp(b.starttime),b.blockname,b.tankname,get(b.protocol)

fieldnames = fields(s);
nfields = length(fieldnames);
dstr = cell(nfields,1);

for jj = 1:nfields
    fieldname = fieldnames{jj};
    val = s.(fieldname);
    if ischar(val)
        dstr{jj} = sprintf('%s: %s\n',fieldname,val);
    elseif isinteger(val)
        dstr{jj} = sprintf('%s: %i\n',fieldname,val);
    elseif isfloat(val)
        dstr{jj} = sprintf('%s: %0.4f\n',fieldname,val);
    else
        dstr{jj} = sprintf('%s: %s\n',fieldname,disp(val));
    end
end

dstr = strtrim(horzcat(dstr{:}));
disp(dstr);

switch nargout
    case 0        
        disp(dstr);
    case 1
        varargout{1} = dstr;
    otherwise
        error('Too many output aruments')
end