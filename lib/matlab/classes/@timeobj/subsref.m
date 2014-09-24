function b = subsref(t,index)
%SUBSREF Define field name indexing for time objects
switch index(1).type
case '()'
    error('Array indexing not supported by time objects');
case '.'
    switch index(1).subs
        case {'hour','minute','second'}
            b = t.(index.subs);
        otherwise
            error('Invalid field name')
    end
case '{}'
    error('Cell array indexing not supported by time objects')
end