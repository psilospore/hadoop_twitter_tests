require 'fileutils'

filenames = Dir.entries(".")

#filter filenames to match expected format
expected_out_filenames = Array.new if expected_out_filenames.nil?

expected_out_filenames = filenames.select { |filename|
	filename =~ /(.*)expected.out/
}

expected_out_filenames.each{ |expected_out_filename|
	FileUtils.rm_rf "temp"
	out_folder = expected_out_filename.sub "_expected.out", ''
	out_file = out_folder + "/" + "part-r-00000"
	java_args = out_file.split '_' #first arg is type and second if cutoff
	twitter_return = %x{ java -jar ../twitter.jar #{java_args[0]} #{java_args[1]} ../testdata_1_mod.csv #{out_folder} }

	if not File.open(expected_out_filename).to_s.eql? File.open(out_file)
		puts "#{out_file} does not match #{expected_out_filename}"
		puts "run diff #{out_file} #{expected_out_filename}"
	end
	""
}