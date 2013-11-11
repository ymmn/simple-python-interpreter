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
		return (self.class == other.class and (@name == other.name) and (@value == other.value))
	end

	alias_method :eql?, :==

end

TOKEN_DEFS = [
	Token_Def.new(:left_paren, /\(/),
	Token_Def.new(:right_paren, /\)/),
	Token_Def.new(:constant, /\d+/),
	Token_Def.new(:whitespace, /\s+/),
	Token_Def.new(:plus, /\+/),
	Token_Def.new(:multiply, /\*/),
	Token_Def.new(:assign, /=/),
	Token_Def.new(:symbol, /[a-zA-Z]\w*/)
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
				# skip whitespace. it's a useless token
				tokenized.push(Token.new(td.name, source_code[start..(i-1)])) if td.name != :whitespace
				break
			end
		}
	end
	return tokenized
end


