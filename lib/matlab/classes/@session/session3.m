function s = session(varargin)
%% SESSION Constructor function for session object
% s = session(date,room,rig,experimenter)

% Class specification
classname = 'session';
fieldspec = {'name'         'class'         'notnull'   'default'};
classspec = {...
            'date'          'dateobj'       true        [];...
            'room'          'char'          true        '';...
            'rig'           'char'          true        '';...
    };
classspec = cell2struct(classspec,fieldspec,2);
nfields = length(classspec);

%% If no input arguments, create a default object

if nargin == 0
    for jj = 1:nfields
        s.(classspec(jj).name) = eval(classspec(jj).class);
    end
    
%% If single argument of class block, return it
elseif nargin == 1
   if (isa(varargin{1},classname))
        s = varargin{1};
        return
   else
      error('Wrong argument type')
   end
   
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
                s.(classspec(jj).name) = val;
                
            % Recast if needed
            elseif isnumeric(val)
                warning('ClassDef:InputType',...
                    'Recasting input "%s" as class "%s"',...
                    classspec(jj).name,classspec(jj).class);
                s.(classspec(jj).name) = eval([classspec(jj).class,...
                    '(val);']);
            else
                error('ClassDef:InputType',...
                    'Input "%s" must be of class "%s"',...
                    classspec(jj).name,classspec(jj).class);
            end
        else
            s.(classspec(jj).name) = cast(classspec(jj).default,...
                classspec(jj).class);
        end
    end
%%
else
   error('Wrong number of input arguments')
end

%% Create output object
s = class(s,classname);