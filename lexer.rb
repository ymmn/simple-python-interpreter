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
	Token_Def.new(:while, /while/),
	Token_Def.new(:less_than, /</),
	Token_Def.new(:greater_than, />/),
	Token_Def.new(:constant, /\d+/),
	Token_Def.new(:boolean, /(True|False)/),
	Token_Def.new(:newline, /\n/),
	Token_Def.new(:indent, /\t/),
	Token_Def.new(:whitespace, /\s+/),
	Token_Def.new(:plus, /\+/),
	Token_Def.new(:comma, /,/),
	Token_Def.new(:multiply, /\*/),
	Token_Def.new(:equals, /==/),
	Token_Def.new(:assign, /=/),
	Token_Def.new(:if, /if/),
	Token_Def.new(:colon, /:/),
	Token_Def.new(:symbol, /[a-zA-Z]\w*/)
]

# Tokenizes a source code string.
# returns a list of Token items
def scan(source_code)
	tokenized = []
	start = 0
	while start < source_code.length
		TOKEN_DEFS.each{ |td|

			# match the token with the rest of the source string
			rest = source_code[start..source_code.length]
			match = rest.match(td.regex)

			# make sure that the match we found is at the beginning 
			if match != nil and source_code[start..start+(match.to_s.length - 1)] == match.to_s
				# skip whitespace. it's a useless token
				tokenized.push(Token.new(td.name, source_code[start..start+(match.to_s.length - 1)])) if td.name != :whitespace
				start += match.to_s.length
				break
			end
		}
	end
	return tokenized
end


