function out_str = sql_str(argin)

% Format builtin variable classes for MySQL command-line

switch class(argin)
    case {'int8','int16','int32','int64',...
            'uint8','uint16','uint32','uint64'}
        out_str = sprintf('%0.0f',argin);
    case 'single'
        % MATLAB class 'single' implements IEEE 754-1985 single-precision 
        % binary floating-point numbers. These have 7 decimal digits 
        % (24 bits) precision.
        out_str = sprintf('%7e',argin);
    case 'double'
        % MATLAB class 'double' implements IEEE 754-1985 double-precision 
        % binary floating-point numbers. These have 16 decimal digits 
        % (53 bits) precision.
        out_str = sprintf('%16e',argin);
    case 'char'
        out_str = ['''' strrep(argin,'\','/') ''''];
    otherwise
        error('DbConversion:UnsupportedType',...
            '''sql_str'' not defined for inputs of class ''%s''.',...
            class(argin));
end