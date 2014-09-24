function t = timeobj(varargin)
%% timeobj Constructor function for timeobj object
% d = timeobj(datenum)
% d = timeobj(val,time_unit)

switch nargin

%% If no input arguments, create a default object
case 0
    indate = zeros(1,6);
    
%% If single argument of class time, return it
case 1
    if (isa(varargin{1},'timeobj'))
        t = varargin{1};
        return
        
%% If single argument of class str or numeric, treat it as a Matlab date
% Use the time portion as the time
    elseif ischar(varargin{1}) | isnumeric(varargin{1})
        indate = datevec(varargin{1});
    else
        error('Wrong input argument type');
    end
    
%% If two arguments, format according to the second argument
case 2
    
    % Check if the arguments are formatted correctly
    if isnumeric(varargin{1}) && ischar(varargin{2})
        sf = time_scale_factor(varargin{2},'days');
    else
        error('Wrong input argument type');
    end
    
    indate = datevec(sf*varargin{1});
    
%% For other numbers of arguments, fail    
otherwise
    error('Wrong number of input arguments')
end

%% Create output object

t.hour = indate(4);
t.minute = indate(5);
t.second = indate(6);
t = class(t,'timeobj');