function r = responder(varargin)
%% RESPONDER Constructor function for responder object
% r = responder()

%%
switch nargin
    
%% If no input arguments, create a default object
case 0
    r = struct;
    r = class(r,'responder');
%%
otherwise
   error('Wrong number of input arguments')
end