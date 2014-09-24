function h = strf(varargin)
%% STRF Constructor function for strf object
% h = strf(file,paramsfile)

%% If no input arguments, create a default object

if nargin == 0
    h.file = '';
    f.paramsfile = '';

%% If single argument of class block, return it
elseif nargin == 1
   if (isa(varargin{1},'strf'))
        b = varargin{1};
        return
   else
      error('Wrong argument type')
   end
   
elseif nargin == 2
    if isa(varargin{1},'char')
        h.file = varargin{1};
    else
        error('ClassDef:InputType',...
                'Input "filename" must be of class "string"')
    end

    if isa(varargin{2},'char')
        h.paramsfile = varargin{2};
    else
        error('ClassDef:InputType',...
                'Input "paramsfile" must be of class "string"')
    end

else
    error('Wrong number of input arguments')
end

%% Create the object
h = class(h,'strf');