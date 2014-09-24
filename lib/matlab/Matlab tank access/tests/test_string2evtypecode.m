function [res,detail] = test_string2evtypecode(actxobject)
% Tester for string2evtypecode()

res = true;
detail = '';

% TTankX.EvCodeToString does not support the data types 'Marker' or
% 'HasData' yet, even though they are documented.
test_vals = {'Unknown',...
             'Strobe+',...
             'Strobe-',...
             'Scalar',...
             'Stream',...
             'Snip'};

nvals = length(test_vals);

% Test the good test cases
for jj = 1:nvals
    val = test_vals{jj};
    returned_val = string2evtypecode(val);
    check_val = actxobject.EvTypeToString(returned_val);
    if strcmp(val,check_val)
        res = res & true;
    elseif strcmp(val,'Scalar') & strcmp (check_val,'Scaler')
        % This is needed because there's a bug in EvTypeToString, where it
        % returns 'Scalar' misspelled as 'Scaler'
        res = res & true;
    else
        if ~isempty(detail)
            detail = sprintf('%s\n',detail);
        end
        detail = sprintf('%sFailed test for value ''%s'' (%s,%d)',...
                         detail,val,check_val,returned_val);
        res = res & false;
    end
end

% Test error handling
try
    returned_val = string2evtypecode('nothing');
    res = res & false;
    if ~isempty(detail)
            detail = sprintf('%s\n',detail);
        end
        detail = sprintf('%sFailed test for input error (%s,%d)',...
                         detail,'nothing',returned_val);
catch
    res = res & true;
end