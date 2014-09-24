function r = reppres(varargin)
%% SINGLEPRES Constructor function for singleprer object
% r = reppres(singlepres1,singlepres2,...)
    
%% If no input argumentr, create a default object
if nargin == 0
    p = presentation;
    r = struct;
    r = class(r,'reppres',p);
    
%% If single argument of class reppres, return it
elseif nargin > 0 
    if (isa(varargin{1},'reppres'))
        r = varargin{1};
        if nargin > 1
            error('Multiple input arguments not supported for first arguments of class ''reppres''');
        end
        
%% If argument of class singlepres, make a reppres with it        
    elseif isa(varargin{1},'singlepres')
        r.singlepres(1) = varargin{1};
        p = get(varargin{1},'presentation');

        % Handle additional singlepres arguments if any, checking for
        % consistency with original
        for jj = 2:nargin
            if isa(varargin{jj},'singlepres')
                if get(varargin{jj},'block') == get(p,'block')
                    if get(varargin{jj},'stim') == get(r,'stim')              
                        r.singlepres(jj) = varargin{jj};
                    else
                        error('Presentation are of different stims')
                    end
                else
                    error('Presentations are not from the same block')
                end
            else
                error('Wrong argument type')
            end
        end
        r = class(r,'reppres',p);

        else
            error('Wrong argument type')
    end
end
end