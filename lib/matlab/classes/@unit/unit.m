function u = unit(varargin)
%% UNIT Constructor function for unit object
% u = unit(recsite,type)
% u = unit(penetration,depth,type)
% u = unit(subject,pen_number,depth,type)

r = responder;
switch nargin

%% If no input arguments, create a default object
case 0
    u.recsite = recsite;
    u.type = '';
    u = class(u,'unit',r);
    
%% If single argument of class unit, return it
case 1
   if (isa(varargin{1},'unit'))
        u = varargin{1};
   else
      error('Wrong argument type')
   end
   
%% Use input recsite
case {2}
    if isa(varargin{1},'recsite')
        u.recsite = varargin{1};
    else
        error('Wrong argument type')
    end
    u.type = varargin{2};
    u = class(u,'unit',r);
    
%% Creating a recsite object from partial specs
case 3
    u.recsite = recsite(varargin{1},varargin{2});
    u.type = varargin{3};
    u = class(u,'unit',r);
    
%% Creating a recsite object from full specs
case 4
    u.recsite = recsite(varargin{1},varargin{2},varargin{3});
    u.type = varargin{4};
    u = class(u,'unit',r);
    
%%
otherwise
   error('Wrong number of input arguments')
end