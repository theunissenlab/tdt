function s = spike(varargin)
%% SPIKE Constructor function for spike object
% s = spike(response,time,waveform)

%%
switch nargin
    
%% If no input arguments, create a default object
case 0
    s.time = [];
    s.waveform = [];
    r = response();
    s = class(s,'spike',r);
case 1
% if single argument of class asset, return it
   if (isa(varargin{1},'spike'))
      s = varargin{1};
   else
      error('Wrong argument type')
   end
case {3,4}
% create object using specified values
    r = response(varargin{1},varargin{2});
    s.time = varargin{3};
    if nargin == 4
    	s.waveform = varargin{4};
    else
        s.waveform = [];
    end
    s = class(s,'spike',r);
otherwise
   error('Wrong number of input arguments')
end