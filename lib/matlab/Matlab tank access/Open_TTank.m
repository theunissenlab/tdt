% This script gets us ready to use the tankserver

% Create the ActiveX control
global ttank
global servername clientname

ttank = actxcontrol('TTank.X');


% Default values for clientname and servername
if ~exist('servername', 'var')
    servername = 'Local';
end
if ~exist('clientname', 'var')
    clientname = 'Myclient';
end

