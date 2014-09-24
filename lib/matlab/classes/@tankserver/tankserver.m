function t = tankserver(varargin)

%% TANKSERVER Constructor function for tankserver object
% t = tankserver(activex_obj,servername,clientname)

% Class specification
classname = 'tankserver';
fieldspec = {'name'         'class'         'notnull'   'default'};
classspec = {...
            'activex_obj'   'COM.TTank_x'   true        [];...
            'servername'    'char'         false       'Local';...
            'clientname'    'char'          false       'MatlabTankAccess'...
    };
classspec = cell2struct(classspec,fieldspec,2);
nfields = length(classspec);

%% If no input arguments, create a default object

if nargin == 0
    for jj = 1:nfields
        
        % For some reason, calling 'int32' requires an argument even if
        % it's null
        if strncmp(classspec(jj).class,'int',3)
            t.(classspec(jj).name) = eval([classspec(jj).class,'([])']);
        else
            t.(classspec(jj).name) = eval(classspec(jj).class);
        end
    end
    
%% If single argument of class tankserver, return it
elseif nargin == 1
   if (isa(varargin{1},classname))
        t = varargin{1};
        return
   
%% Use input session
    elseif nargin <= nfields
        % Determine which inputs go where
        assigned = [classspec.notnull];
        n_notnull = sum([classspec.notnull]);
        n_extra = nargin-n_notnull;
        if n_extra < 0
            error('Not enough input arguments')
        elseif n_extra > 0
            % Assign earlier optional variables enough
            assigned(find(~assigned,extra,'first')) = true;
        end

        % Assign field values
        for jj = 1:nfields
            if assigned(jj)
                input_idx = sum(assigned(1:jj));
                val = varargin{input_idx};

                % Check input type
                if isa(val,classspec(jj).class)
                    t.(classspec(jj).name) = val;

                % Recast if needed
                elseif isnumeric(val)
                    warning('ClassDef:InputType',...
                        'Recasting input "%s" as class "%s"',...
                        classspec(jj).name,classspec(jj).class);
                    t.(classspec(jj).name) = eval([classspec(jj).class,...
                        '(val);']);
                else
                    error('ClassDef:InputType',...
                        'Input "%s" must be of class "%s"',...
                        classspec(jj).name,classspec(jj).class);
                end
            else
                t.(classspec(jj).name) = cast(classspec(jj).default,...
                    classspec(jj).class);
            end
        end
   end
%%
else
   error('Wrong number of input arguments')
end

%% Create output object
t = class(t,'tankserver');