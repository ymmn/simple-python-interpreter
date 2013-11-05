require "test/unit"

class Token_Def

	attr_accessor :name, :regex

	def initialize(n, r)
		@name = n
		@regex = r
	end

end

class Token

	attr_accessor :name, :value

	def initialize(t, v)
		@name = t
		@value = v
	end

	def ==(other)
		return ((@name == other.name) and (@value == other.value))
	end

	alias_method :eql?, :==

end

TOKEN_DEFS = [
	Token_Def.new(:left_paren, /\(/),
	Token_Def.new(:right_paren, /\)/),
	Token_Def.new(:constant, /\d+/),
	Token_Def.new(:whitespace, /\s+/),
	Token_Def.new(:plus, /\+/)
]

def scan(source_code)
	tokenized = []
	i = 0
	while i < source_code.length
		start = i
		TOKEN_DEFS.each{ |td|
			# maximal munch
			match = source_code[start..i].match(td.regex)
			while i < source_code.length and match != nil and match[0].length == (i - start + 1)
				i += 1
				match = source_code[start..i].match(td.regex)
			end

			# push the token if anything matched
			if i > start
				tokenized.push(Token.new(td.name, source_code[start..(i-1)]))
				break
			end
		}
	end
	return tokenized
end



class TestBoundedQueue < Test::Unit::TestCase

	def test_simple_num
		assert_equal(scan("1")[0], Token.new(:constant, "1"))
		assert_equal(scan("1234")[0], Token.new(:constant, "1234"))
	end	

	def test_simple_mixed
		assert_equal(scan("()"), [Token.new(:left_paren, "("), Token.new(:right_paren, ")")])
		assert_equal(scan("(123)"), [Token.new(:left_paren, "("), Token.new(:constant, "123"), Token.new(:right_paren, ")")])
		assert_equal(scan("1 + 2"), [Token.new(:constant, "1"), Token.new(:whitespace, " "), Token.new(:plus, "+"), Token.new(:whitespace, " "), Token.new(:constant, "2")])
	end

end