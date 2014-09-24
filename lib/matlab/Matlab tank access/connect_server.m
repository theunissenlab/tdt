% Script to connect to server

global servername clientname
if actxname.ConnectServer(servername,clientname) ~=1
    err = 'error connecting to server'
end