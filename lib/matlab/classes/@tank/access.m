function access(t)

% Access tank on the TDT server

global ttank
clientname = 'MatlabTankExport';

% Changed t.ConnectServer to ttank.ConnectServer
if ttank.ConnectServer(t.server,clientname) ~=1
    error('error connecting to server');
end
if ttank.OpenTank(t.name,'R') ~=1
    error('error opening tank');
end

