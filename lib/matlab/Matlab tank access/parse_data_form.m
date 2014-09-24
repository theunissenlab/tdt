function [data_type,file_ext,typename] = parse_data_form(data_form)
% Return MATLAB data type for TDT data type

switch lower(data_form)
case 'float'
	data_type = 'float32';
	file_ext = 'f32';
	typename = 'single';
case 'long'
	data_type = 'int32';
	file_ext = 'i32';
	typename = 'int32';
case 'short'
	data_type = 'int16';
	file_ext = 'i16';
	typename = 'int16';
case 'byte'
	data_type = 'int8';
	file_ext = 'i8';
	typename = 'int8';
otherwise
	error('Data format not recognized')
end