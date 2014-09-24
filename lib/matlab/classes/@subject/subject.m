function s = subject(varargin)
%% SUBJECT Constructor function for subject object
% s = subject(name)

%%
switch nargin
    
%% If no input arguments, create a default object
case 0
    s.name = '';
    s = class(s,'subject');
    
%% If single argument of class subject, return it
case 1
   if (isa(varargin{1},'subject'))
       s = varargin{1};
   elseif ischar(varargin{1})
       s.name = varargin{1};
       s = class(s,'subject');
   else
      error('Wrong argument type')
   end
end