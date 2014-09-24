function val = get(p,propName)

% GET Get singlepres properties from the specified object
% and return the value
switch propName
case 'block'
    val = p.block;
otherwise
    error([propName,' Is not a valid presentation property'])
end