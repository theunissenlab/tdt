function s = minus(varargin)

% Function to tell difference between two date/time objects

switch nargin
    case 2
        switch class(varargin{2})
            case 'datetime'
                s = etime(datevec(varargin{1}),datevec(varargin{2}));
            otherwise
                error('All inputs must be of class ''datetime''')
        end
    otherwise
        error('Wrong number of input arguments')
end