function r = room(varargin)
%% ROOM Constructor function for room object
% r = room(roomnumber,building)

% Class specification
classname = 'room';
fieldspec = {'name'         'class'         'notnull'   'default'};
classspec = {...
            'roomnumber'    'char'          true        '';...
            'building'      'building'      true        []...
    };
classspec = cell2struct(classspec,fieldspec,2);
nfields = length(classspec);

%% If no input arguments, create a default object
if nargin == 0
    r = assign_defaults(classspec,nfields);
    
%% If single argument of class room, return it
elseif nargin == 1 & isa(varargin{1},classname)
    r = varargin{1};
    return
   
%% Otherwise use input session
elseif nargin <= nfields
    r = assign_fields(classspec,nfields,varargin{:});
%%

%% Throw error for wrong number of input arguments
else
   error('Wrong number of input arguments')
end

%% Create output object
r = class(r,'room');