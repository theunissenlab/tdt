% Connect to the server, select tank and block
global servername clientname
if actxname.ConnectServer(servername,clientname) ~=1
    err = 'error connecting to server'
end
if actxname.OpenTank(tankname,'R') ~=1
    err = 'error opening tank'
end