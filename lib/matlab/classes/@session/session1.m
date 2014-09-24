function s = session(varargin)
%% SESSION Constructor function for session object
% s = session(date)

switch nargin

%% If no input arguments, create a default object
case 0
    s.date = [];
    s = class(s,'session');
    
%% If single argument of class session, return it
case 1
   if (isa(varargin{1},'session'))
        s = varargin{1};
   elseif isnumeric(varargin{1}) || ischar(varargin{1})
       s.date = varargin(1)
   else
      error('Wrong argument type')
   end
   
%%
otherwise
   error('Wrong number of input arguments')
end