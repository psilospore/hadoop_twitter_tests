require 'fileutils'

filenames = Dir.entries(".")

#filter filenames to match expected format
expected_out_filenames = Array.new

expected_out_filenames = filenames.select { |filename|
	filename =~ /(.*)expected.out/
}

in_path = "../testdata_1_mod.csv"

in_path = ARGV[0] unless ARGV[0].nil?

results = ""
expected_out_filenames.each{ |expected_out_filename|

	out_folder = expected_out_filename.sub "_expected.out", ''
	out_file = out_folder + "/" + "part-r-00000"

	#first arg is type and second if cutoff
	java_args = out_folder.split '_' 
	type_tweet = java_args[0]
	cutoff = java_args[1]

	#remove any created files and dirs from previous run
	FileUtils.rm_rf "temp"
	FileUtils.rm_rf out_folder

	puts "java args: #{type_tweet} #{cutoff}"
	twitter_return = %x{ java -jar ../twitter.jar #{type_tweet} #{cutoff} #{in_path} #{out_folder} }

	if not File.open(expected_out_filename).read.eql? File.open(out_file).read
		results += "\nFAILURE: #{out_file} does not match #{expected_out_filename}"
		results += "\nrun diff #{out_file} #{expected_out_filename}"
	else
		results += "\nSUCCESS: #{out_file} matches #{expected_out_filename}"
	end
}

puts results

FileUtils.rm_rf "temp"