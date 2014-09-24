function b = subsref(t,index)
%SUBSREF Define field name indexing for asset objects
switch index(1).type
case '()'
    error('Array indexing not supported by tdt_block objects');
%    switch index.subs{:}
%    case 1
%       b = a.descriptor;
%    case 2
%       b = a.date;
%    case 3
%       b = a.currentValue;
%    otherwise
%       error('Index out of range')
%    end
case '.'
    if length(index) > 1
        switch index(1).subs
        case {'name','starttime','endtime'}
            b = subsref(t.(index(1).subs),index(2:end));
        case {'tank'}
            b = subsref(t.tank,index(2:end));
        otherwise
            error('Invalid field name')
        end
    else
        switch index(1).subs
        case {'name','starttime','endtime'}
            b = t.(index.subs);
        case {'tank'}
            b = t.tank;
        otherwise
            error('Invalid field name')
        end
    end
    
case '{}'
    error('Cell array indexing not supported by tdt_block objects')
end