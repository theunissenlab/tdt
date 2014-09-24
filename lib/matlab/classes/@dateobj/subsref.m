function b = subsref(d,index)
%SUBSREF Define field name indexing for date objects
switch index(1).type
case '()'
    error('Array indexing not supported by date objects');
case '.'
    switch index(1).subs
        case {'day','month','year'}
            b = d.(index.subs);
        otherwise
            error('Invalid field name')
    end
case '{}'
    error('Cell array indexing not supported by date objects')
end