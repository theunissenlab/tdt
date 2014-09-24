function s = singlepres(varargin)
%% SINGLEPRES Constructor function for singlepres object
% s = singlepres(presentation,stim,starttime,endtime)
% s = singlepres(block,stim,starttime,endtime)

switch nargin
    
%% If no input arguments, create a default object
case 0
    p = presentation;
    s.stim = stim;
    s.starttime = [];
    s.endtime = [];
    s = class(s,'singlepres',p);
    
%% If single argument of class singlepres, return it
case 1
   if (isa(varargin{1},'singlepres'))
      s = varargin{1};
   else
      error('Wrong argument type')
   end 
   
%% Create object using specified values
case {3,4}
    
    % Handle different input types
    if isa(varargin{1},'presentation')
        p = varargin{1};
    elseif isa(varargin{1},'block')
        p = presentation(varargin{1});
    else
        error('Wrong argument type')
    end
    
    % Check input argument 'stim'
    if isa(varargin{2},'stim')
        s.stim = varargin{2};
    else
        error('Wrong argument type')
    end
    
    % Check starttime argument
    if isnum(varargin{3})
        if isreal(varargin{3})
            s.starttime = varargin{3};
        else
            error('Timestamps must be real')
        end
    else
        error('Timestamps must be numeric')
    end
    
    % Check endtime argument
    if nargin == 4
    	if isnum(varargin{4})
            if isreal(varargin{4})
                s.endtime = varargin{4};
            else
                error('Timestamps must be real')
            end
        else
            error('Timestamps must be numeric')
        end
    else
        s.endtime = s.starttime + length(stim);
    end

    s = class(s,'singlepres',p);
    
%%
otherwise
   error('Wrong number of input arguments')
end