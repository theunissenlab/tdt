function c = epoc_code(varargin)
%% EPOC_CODE Constructor function for epoc_code object
% b = epoc_code(session,blocknumber,starttime,protocol,channelmap,experimenter,blockname,tankname)
% b = epoc_code(blockname,tank)

switch nargin

%% If no input arguments, create a default object
case 0
    for jj = 1:nfields
        
        % For some reason, calling 'int32' requires an argument even if
        % it's null
        if strncmp(classspec(jj).class,'int',3)
            c.(classspec(jj).name) = eval([classspec(jj).class,'([])']);
        else
            c.(classspec(jj).name) = eval(classspec(jj).class);
        end
    end
    
%% If single argument of class block, return it
case 1
   if (isa(varargin{1},'epoc_code'))
       c = varargin{1};
       return
   elseif isa(varargin{1},'char')
       if length(varargin{1}) == 4
           c.code = varargin{1};
       else
           error('Input ''code'' must be have exactly four characters')
       end
   else
       error('Wrong input type')
   end

%% Error for wrong number of inputs
otherwise
   error('Too many input arguments')
end

%% Create output object
c = class(c,'epoc_code');