require "./lexer.rb"
require "./parser.rb"
require "./interpreter.rb"

class Driver 

	def initialize
		@src = []
		@expected_indent = 0
		@parser = Parser.new

		# start interpreter loop
		evalLoop
	end

	# count tab characters in the beginning of a line
	def get_indent_level(line)
		res = 0
		while line[res] == "\t"
			res += 1
		end
		return res
	end

	# give the user an error and throw away bad input
	def raiseError(msg)
		puts msg
		@src = []
		@expected_indent = 0
	end

	# interpreter loop
	def evalLoop
		puts "Exit the interpeter by entering 'exit'"
		line = ""
		end_block = false
		while line != 'exit'


			if @expected_indent == 0
				# not inside a block
				print(">>> ")
			else 
				# within a block
				print("... ")
			end

			line = gets

			# get indent level
			line_indent = get_indent_level(line)

			if line_indent > @expected_indent
				raiseError("Unexpected indent") 
				next
			end

			end_block = line_indent < @expected_indent

			@expected_indent = line_indent

			# get rid of extra whitespace
			line = line.strip

			# check if we're starting a block
			if line.end_with?(":")
				@expected_indent += 1
			end

			# add the line we just got to our accumulated code
			if line != ""
				@src.push(line)
			end

			# interpret only if we're not inside a block
			if @expected_indent == 0
				begin
					res = interpret(@parser.parse(scan(@src.join("\n"))))
					puts res if res != ""
					@src = []
				rescue Exception => e
					puts e.message
				end
			end

		end # end loop
	end

end

Driver.new