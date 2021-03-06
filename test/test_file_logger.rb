require 'test/unit'

require 'basic_logging'
require 'fileutils'

class TestFileLogger < Test::Unit::TestCase

	def setup
		@log_file_name = 'test/data/sample.log'
		# delete log file if exists and create any dirs required
		File.delete(@log_file_name) if File.exists?(@log_file_name)
		FileUtils.makedirs(File.split(@log_file_name)[0])
		# create logger object and message
		@logger = BasicLogging::FileLogger.new(@log_file_name)
		@message = 'simple message for FileLogger'
	end

	def test_for_logger_interface
		assert_respond_to(@logger, :log)
		assert_respond_to(@logger, :error)
		assert_respond_to(@logger, :warn)
		assert_respond_to(@logger, :info)
		assert_respond_to(@logger, :debug)
		assert_respond_to(@logger, :reset)
	end

	def test_file_logger
		@logger.warn(@message)

		first_line = ''
		assert_nothing_raised do
			File.open(@log_file_name, 'r') do |f|
				first_line = f.readline
			end
		end

		assert(format_is_correct?('WARN: ', @message, first_line), first_line)
	end

	# Test helper methods
	private

		def format_is_correct?(level, message, output)
			# regex pattern matches timestamp like '[2013-01-01 22:00:00]'
			# plus error level and message
			output.chomp =~ /^\[\d{4}\-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\] #{level}#{message}$/
		end

end