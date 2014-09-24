% This is a basic script to get basic epoch information from the tank

% Specify tank # and block # to use
if ~exist('tanknum')
    tanknum = 2
end
if ~exist('blocknum')
    blocknum = 3
end
if ~exist('epocname')
    epocname = 'Frq+'
end

%===================================================================
% Access server and open specified tank and block
%===================================================================

% Connect to server
tank_access;

% Open tank specified by tanknum
[tanknames,ntanks] = get_tanknames(ttank);
tankname = tanknames{tanknum}.name;
if (invoke(ttank,'OpenTank',tankname,'R') ~=1)
    err = 'error opening tank'
end

% Open the block specified by blocknum
[blocknames,nblocks] = get_blocknames(ttank);
blockname = blocknames{blocknum}.name;
if (invoke(ttank,'SelectBlock',blockname) ~=1)
    err = 'error accessing block'
end

%===================================================================
% Get the epoch information
%===================================================================

Epoc_data = invoke(ttank,'GetEpocsV',epocname,0,0,1000);

%===================================================================
% Close connection
%===================================================================

invoke(ttank,'ReleaseServer');