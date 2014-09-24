function dt = datetime(varargin)
%% DATETIME Constructor function for datetime object
% d = datetime(datetime)

switch nargin

%% If no input arguments, create a default object
case 0
    d = dateobj(0,1,0);
    t = timeobj(0);
    
%% If single argument of class datestr, return it
case 1
    if (isa(varargin{1},'datetime'))
        dt = varargin{1};
        return
        
%% If single argument of class dateobj, reformat it to a datestr at 0:00:00
    elseif isa(varargin{1},'dateobj')
        d = varargin{1};
        t = timeobj(0);
        
%% If single argument of class timeobj, reformat it as 0/0/0000 at time
    elseif isa(varargin{1},'timeobj')
        d = dateobj(0);
        t = varargin{2};
        
%% If single argument of class str or numeric, treat it as a Matlab date 
    elseif ischar(varargin{1}) | isnumeric(varargin{1})
        d = dateobj(varargin{1});
        t = timeobj(varargin{1});
    else
        error('Wrong input type');
    end
        
%% If multiple arguments, fail
otherwise
    error('Wrong number of inputs')
end

%% Create output object
dt = class(struct,'datetime',d,t);