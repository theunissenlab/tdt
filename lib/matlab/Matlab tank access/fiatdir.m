function out = fiatdir(dirname)
% Creates a directory even if its subdirectories do not exist.

%posslash = findstr(dirname,'/');
posslash = findstr(dirname,'\'); % Taffeta trying to edit for XP
for i = 2:length(posslash)
    if isdir(dirname(1:posslash(i)))
    else
        toexec = strcat(['! mkdir ' dirname(1:posslash(i))]);
        eval(toexec);
    end
end
if isdir(dirname)
else
    toexec = strcat(['! mkdir ' dirname]);
    eval(toexec);
end
out = 1;