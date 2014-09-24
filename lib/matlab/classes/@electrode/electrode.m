function e = electrode(varargin)

%% ELECTRODE Constructor function for electrode class
% e = electrode(electrode_id,nchannels,type,manufacturer,partnum,lot)

%% Stop if too many input arguments
if nargin > 6
    error('Too many input arguments')
end

%% For single input of class electrode, return it
if nargin == 1
    if isa(varargin{1},'electrode')
        e = varargin{1};
        return
    end
end

%% If no input argumentr, create a default object
if nargin < 1
    e.electrode_id = '';
    e.nchannels = [];
    e.type = '';
    e.manufacturer = [];
    e.lot = [];
else
    if ischar(varargin{1})
        e.electrode_id = varargin{1};
    else
        error('Wrong input type')
    end
end

%% If nchannels is specified, use that value; default is 1
if nargin > 1
    if isnumeric(varargin{2})
        e_val = varargin{2};
        if ~isinteger(e_val)
            warning('ClassDef:TypeChange',...
                ['Recasting input "nchannels" as integer -- ',...
                'rounding error may occur'])
            e.nchannels = cast(c_val,'int32');
        else
            e.nchannels = varargin{2};
        end
    else
        error('Wrong input type')
    end
else
    e.nchannels = int32(1);
end

%% If type is specified, use it; default to empty str
if nargin > 2
    if ischar(varargin{3})
        e.type = varargin{3};
    else
        error('Wrong input type');
    end
else
    e.type = '';
end

%% If manufacturer is specified, use it; default to empty str
if nargin > 3
    if ischar(varargin{4})
        e.manufacturer = varargin{4};
    else
        error('Wrong input type')
    end
else
    e.manufacturer = '';
end

%% If partnum is specified, use it; default to empty str
if nargin > 4
    if ischar(varargin{5})
        e.partnum = varargin{5};
    else
        error('Wrong input type')
    end
else
    e.partnumber = '';
end

%% If lot is specified, use it; default to empty str
if nargin > 5
    if ischar(varargin{6})
        e.lot = varargin{6};
    else
        error('Wrong input type')
    end
else
    e.lot = '';
end

%% Create output structure
e = class(e,'electrode');