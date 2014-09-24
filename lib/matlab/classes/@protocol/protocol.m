function p = protocol(varargin)

%% PROTOCOL Constructor function for protocol class

switch nargin
    
    case 0
        p = struct;
        p = class(p,'protocol');
    otherwise
        error('Too many input arguments');
end