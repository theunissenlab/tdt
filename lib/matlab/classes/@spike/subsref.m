function varargout = subsref(s,index)
%SUBSREF Define field name indexing for spike objects

goodfields = {'time','channel','sortcode','waveform'};

switch index(1).type
case '()'
    switch length(index)
        case 1
            spiketimes = [s(index(1).subs{:}).time];
            channels = [s(index(1).subs{:}).channel];
            sortcodes = [s(index(1).subs{:}).sortcode];
            waveforms = [s(index(1).subs{:}).waveform];
            varargout{1} = spike(spiketimes,channels,sortcodes,waveforms);
        case 2
            switch index(2).type
                case '()'
                    error('Array indexing not supported for spike references')
                case '.'
                    switch index(2).subs
                        case goodfields
                            varargout = {[s(index(1).subs{:}).(index(2).subs)]};
                        otherwise
                            error('Invalid field name')
                    end
                case '{}'
                    error('Cell array indexing not supported for spike references')
            end
        otherwise
            error('Reference too deep')
    end
case '.'
    switch index.subs
        case goodfields
            varargout = {s.(index.subs)};
        otherwise
            error('Invalid field name')
    end
case '{}'
    error('Cell array indexing not supported by spike objects')
end