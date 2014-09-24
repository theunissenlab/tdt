function b = bird(varargin)
%% BIRD Constructor function for bird object
% b = bird(band_number)

%%
switch nargin
    
%% If no input arguments, create a default object
case 0
    s = subject('');
    b.bandnumber = '';
    b = class(b,'bird',s);
    
%% If single argument of class bird, return it
case 1
   if (isa(varargin{1},'bird'))
       b = varargin{1};
   elseif ischar(varargin{1})
       b.bandnumber = varargin{1};
       s = subject(b.bandnumber);
       b = class(b,'bird',s);
   else
      error('Wrong argument type')
   end
end