% Some initial steps in adding a block

% Get name for TTank ActiveX object
global ttank

% Default to give error if channels or sortcodes do not match those already
% in block
if ~exist('errflag','var')
    errflag = 1;
end
msg = '';       % Used for fatal error messages
msg1 = '';      % Used for minor errors

% Channels and sortcodes with at least one spike will be considered valid
min_spikes = 1;