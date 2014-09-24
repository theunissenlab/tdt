function c = channelmap(varargin)

%% channelmap Constructor function for channelmap object
% c = channelmap(electrode,electrodechannel,hwchannel)

switch nargin
%% If no input argumentr, create a default object
case 0
    c.electrode = electrode;
    c.electrodechannel = [];
    c.hwchannel = [];

%% If single input of class channelmap, return it
case 1
    c = varargin{1};
    return
    
%% If 3 input arguments, create object from input
case 3
    if (isa(varargin{1},'electrode'))
        c.electrode = varargin{1};
    else
        error('Wrong input type')
    end
    
    if all(cellfun(@isnumeric,varargin{2:3}))
        c_names = {'electrode','electrodechannel','hwchannel'};
        for jj = 2:length(c_names)
            c_val = varargin{jj};
            if ~isinteger(c_val)
                warning('ClassDef:TypeChange',...
                    ['Recasting input "%s" as integer -- ',...
                    'rounding error may occur'],c_names{jj})
                c.(c_names{jj}) = cast(c_val,'int32');
            else
                c.(c_names{jj}) = varargin{jj};
            end
        end
    else
        error('Wrong input type')
    end
        
otherwise
    error('Wrong number of input arguments')
end

%% Create output object
c = class(c,'channelmap');