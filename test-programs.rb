TEST_PROGRAMS = {

	# trivial program consisting of a single constant
	:single_constant => {
		:src => "1",
		:tokenized => [Token.new(:constant, "1")],
		:parsed => {
			:program => [
				{:statement => [
					{:expression => [
						{:math => [
							{:constant => ["1"]},
						]}
					]}
				]}
			]
		},
		:interpreted => 1
	},

	# simple addition of numbers
	:number_addition => {
		:src => "1 + 2",
		:tokenized => [Token.new(:constant, "1"), Token.new(:plus, "+"), Token.new(:constant, "2")],
		:parsed => {
			:program => [
				{:statement => [
					{:expression => [
						{:math => [
							{:constant => ["1"]},
							{:math => [
								{:plus => ["+"]},
								{:math => [
									{:constant => ["2"]}						]},
								]}
						]}
					]}
				]}
			]
		},
		:interpreted => 3
	},

	# multiplication and addition with parens 
	:math_with_parens => {
		:src => "3*(1+2)",
		:tokenized => [Token.new(:constant, "3"), Token.new(:multiply, "*"), Token.new(:left_paren, "("),
			 Token.new(:constant, "1"), Token.new(:plus, "+"), Token.new(:constant, "2"), Token.new(:right_paren, ")")],
		:parsed => {
			:program => [
				{:statement => [
					{:expression => [
						{:math => [
							{:constant => ["3"]},
							{:math => [
								{:multiply => ["*"]},
								{:math => [
									{:left_paren => ["("]},
									{:math => [
										{:constant => ["1"]},
										{:math => [ 
											{:plus => ["+"]},
											{:math => [
												{:constant => ["2"]}						
											]}
										]}
									]},
									{:right_paren => [")"]}
								]}
							]}
						]}
					]}				
					]}
			]
		},
		:interpreted => 9
	},

	# basic assignment of number 
	:basic_assignment => {
		:src => "a = 1",
		:tokenized => [Token.new(:symbol, "a"), Token.new(:assign, "="), Token.new(:constant, "1")],
		:parsed => {
			:program => [
				{:statement => [
					{:assignment => [
						{:symbol => ["a"]},
						{:assign => ["="]},
						{:expression => [
							{:math => [
								{:constant => ["1"]}
							]}
						]}
					]}
				]}
			]
		},
		:interpreted => ""
	},

	# function call with one arg
	:single_arg_func_call => {
		:src => "print(1)",
		:tokenized => [Token.new(:symbol, "print"), Token.new(:left_paren, "("), Token.new(:constant, "1"), Token.new(:right_paren, ")")],
		:parsed => {
			:program => [
				{:statement => [
					{:expression => [
						{:function_call => [
							{:symbol => ["print"]},
							{:left_paren => ["("]},
							{:argument_list => [
								{:expression => [
									{:math => [
										{:constant => ["1"]}
									]}
								]}
							]},
							{:right_paren => [")"]}
						]}
					]}
				]}
			]
		},
		:interpreted => nil
	},

	# function call with more than one arg
	:multi_arg_func_call => {
		:src => "add(1,2)",
		:tokenized => [Token.new(:symbol, "add"), Token.new(:left_paren, "("), Token.new(:constant, "1"), Token.new(:comma, ","), Token.new(:constant, "2"), Token.new(:right_paren, ")")],
		:parsed => {
			:program => [
				{:statement => [
					{:expression => [
						{:function_call => [
							{:symbol => ["add"]},
							{:left_paren => ["("]},
							{:argument_list => [
								{:expression => [
									{:math => [
										{:constant => ["1"]}
									]}
								]},
								{:_argument_list => [
									{:comma => [","]},
									{:expression => [
										{:math => [
											{:constant => ["2"]}
										]}
									]}
								]}
							]},
							{:right_paren => [")"]}
						]}
					]}
				]}
			]
		},
		:interpreted => 3
	},

	# boolean statement
	:boolean_statement => {
		:src => "1 == 1",
		:tokenized => [Token.new(:constant, "1"), Token.new(:equals, "=="), Token.new(:constant, "1")],
		:parsed => {
			:program => [
				{:statement => [
					{:expression => [
						{:boolean_expr => [
							{:expression => [
								{:math => [
									{:constant => ["1"]},
								]}
							]},
							{:equals => ["=="]},
							{:expression => [
								{:math => [
									{:constant => ["1"]},
								]}
							]}
						]}
					]}
				]}
			]
		},
		:interpreted => true
	},


	# trivial if statement
	:trivial_if => {
		:src => "if 1 == 1:\n\t1",
		:tokenized => [Token.new(:if, "if"), Token.new(:constant, "1"), Token.new(:equals, "=="), Token.new(:constant, "1"), Token.new(:colon, ":"), Token.new(:newline, "\n"), Token.new(:indent, "\t"), Token.new(:constant, "1")]
	}


}

