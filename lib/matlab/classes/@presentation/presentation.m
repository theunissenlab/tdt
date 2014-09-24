function p = presentation(varargin)
%% PRESENTATION Constructor function for presentation object
% p = presentation(block)

switch nargin
    
%% If no input arguments, create a default object
case 0
    p.block = block;
    p = class(p,'presentation');
case 1
% if single argument of class asset, return it
   if (isa(varargin{1},'presentation'))
       p = varargin{1};
   elseif (isa(varargin{1},'block'))
       p.block = varargin{1};
       p = class(p,'presentation');
   else
       error('Wrong argument type')
   end 
   
%%
otherwise
   error('Wrong number of input arguments')
end