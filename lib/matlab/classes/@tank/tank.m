function t = tank(varargin)
%% TANK Constructor function for tank object
% t = tank(tank_name,servername)

% Class specification
fieldspec = {'name'         'class'         'notnull'   'default'};
classspec = {...
            'name'          'char'          true        '';...
            'server'        'char'          false       'Local';...
            'filename'      'char'          false       ''...
    };
classspec = cell2struct(classspec,fieldspec,2);
nfields = length(classspec);

% global ttank
% clientname = 'MatlabTankExport';

%% If no input arguments, create a default object

if nargin == 0
    for jj = 1:nfields
        
        % For some reason, calling numeric constructors requires an argument even if
        % it's null
        if isnum_class(classspec(jj).class)
            t.(classspec(jj).name) = eval([classspec(jj).class,'([])']);
        else
            t.(classspec(jj).name) = eval(classspec(jj).class);
        end
    end
    
%% If single argument of class tank, return it
elseif nargin <= nfields
    if (isa(varargin{1},'tank'))
        t = varargin{1};
        return
        
%% If single char argument, construct a tank from it
    else
        t = assign_fields(classspec,nfields,varargin{:});
        
%         % Get filename of tank from the server; string 'PT' specifies to
%         % retrieve the full path of the tank file
%         ttank.ConnectServer(t.server,clientname);
%         t.filename = ttank.GetTankItem(t.name,'PT');
%         ttank.ReleaseServer;
    end
   
%% Fail for wrong number of arguments
else
   error('Wrong number of input arguments')
end

%% Create output object
t = class(t,'tank');