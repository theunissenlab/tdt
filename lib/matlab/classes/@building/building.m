function b = building(varargin)
%% ROOM Constructor function for room object
% r = room(building,roomnumber)

% Class specification
classname = 'building';
fieldspec = {'name'         'class'     'notnull'   'default'};
classspec = {...
            'name'          'char'      true        []
    };
classspec = cell2struct(classspec,fieldspec,2);
nfields = length(classspec);

%% If no input arguments, create a default object
if nargin == 0
    b = assign_defaults(classspec,nfields);
    
%% If single argument of class room, return it
elseif nargin == 1 & isa(varargin{1},classname)
    b = varargin{1};
    return
   
%% Otherwise use input session
elseif nargin <= nfields
    b = assign_fields(classspec,nfields,varargin{:});
%%

%% Throw error for wrong number of input arguments
else
   error('Wrong number of input arguments')
end

%% Create output object
b = class(b,classname);