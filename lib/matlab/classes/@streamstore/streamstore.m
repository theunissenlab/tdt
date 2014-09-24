classdef streamstore
	properties
		block
		store_name
		store_code
		samplerate
		channels
		datasize
        data_form
	end
	methods
		function s = streamstore(block,store_name,store_code,samplerate,...
								 datasize,data_form)
			s.block = block;
			s.store_name = store_name;
			s.store_code = store_code;
			if nargin > 3
				s.samplerate = samplerate;
			end
			if nargin > 4
				s.datasize = datasize;
			end
			if nargin > 5
				s.data_form = data_form;
			end
		end
	end
end