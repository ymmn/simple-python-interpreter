require "./lexer.rb"
require "./parser.rb"
require "./interpreter.rb"

src = ""
while src != 'exit'
	src = gets
	begin
		res = interpret(parse(scan(src)))
		puts res if res != ""
	rescue Exception => e
		puts e.message
	end
end