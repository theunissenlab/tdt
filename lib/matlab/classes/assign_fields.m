function c = assign_fields(classspec,nfields,varargin)
% Assign fieldnames from classspec

%% Determine which inputs go where
assigned = [classspec.notnull];
n_notnull = sum([classspec.notnull]);
n_extra = length(varargin)-n_notnull;
if n_extra < 0
    error('Not enough input arguments')
elseif n_extra > 0
    % Assign earlier optional variables enough
    assigned(find(~assigned,n_extra,'first')) = true;
end

%% Assign field values
for jj = 1:nfields
    if assigned(jj)
        input_idx = sum(assigned(1:jj));
        val = varargin{input_idx};

        % Check input type
        if isa(val,classspec(jj).class)
            c.(classspec(jj).name) = val;

        % Recast if needed
        elseif isnumeric(val)
            warning('ClassDef:InputType',...
                'Recasting input "%s" as class "%s"',...
                classspec(jj).name,classspec(jj).class);
            c.(classspec(jj).name) = eval([classspec(jj).class,...
                '(val);']);
        else
            error('ClassDef:InputType',...
                'Input "%s" must be of class "%s"',...
                classspec(jj).name,classspec(jj).class);
        end
    else
        c.(classspec(jj).name) = cast(classspec(jj).default,...
            classspec(jj).class);
    end
end