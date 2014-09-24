function b = subsref(t,index)
%SUBSREF Define field name indexing for asset objects
switch index.type
case '()'
    error('Array indexing not supported by tank objects');
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
    switch index.subs
        case {'name','server','filename'}
        	b = t.(index.subs);
        otherwise
            error('Invalid field name')
    end
case '{}'
    error('Cell array indexing not supported by tank objects')
end