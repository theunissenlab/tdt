function b = subsref(dt,index)
%SUBSREF Define field name indexing for datetime objects
switch index(1).type
case '()'
    error('Array indexing not supported by datetime objects');
case '.'
    switch index(1).subs
        case {'day','month','year'}
            b = dt.dateobj.(index.subs);
        case {'hour','second','minute'}
            b = dt.timeobj.(index.subs);
        case {'date','time'}
            b = dt.([index.subs 'obj']);
        otherwise
            error('Invalid field name')
    end
case '{}'
    error('Cell array indexing not supported by datetime objects')
end