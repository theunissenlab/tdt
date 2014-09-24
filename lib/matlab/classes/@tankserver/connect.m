function succeed = connect(t)

%% Connect method for tankserver object

succeed = t.activex_obj.ConnectServer(t.servername,t.clientname);

if ~succeed
    error('error connecting to server');
end