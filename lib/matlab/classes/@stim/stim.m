function s = stim(varargin)
%% STIM Constructor function for stim object
% s = stim()

switch nargin
    
%% If no input arguments, create a default object
case 0
    s = struct;
    s = class(s,'stim');
    
%% If single argument of class stim, return it
case 1
   if (isa(varargin{1},'stim'))
      s = varargin{1};
   else
       error('Wrong argument type')
   end 
   
%%
otherwise
   error('Wrong number of input arguments')
end