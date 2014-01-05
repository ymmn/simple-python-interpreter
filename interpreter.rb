require "./lexer.rb"
require "./parser.rb"

def func_add(a,b)
	return a + b
end

$variables = {}
$functions = {
	"print" => :print,
	"add" => :func_add
}

# takes a constant node
def eval_constant(node)
	return node.children[0].to_i
end

# takes an _argument_list node
def _extract_args(node)
	return [] if node == nil
	return [interpret(node.children[1])] + _extract_args(node.children[2])
end

# takes an argument_list node
def extract_args(node)
	return [interpret(node.children[0])] + _extract_args(node.children[1])
end

# takes a function_call node
def eval_function(node)
	func_name = node.children[0].children[0]
	args = extract_args(node.children[2])
	return method($functions[func_name]).call(*args)
end

# takes a symbol node
def eval_symbol(node)
	varname = node.children[0]
	if $variables.key?(varname)
		return $variables[varname]
	else
		raise "#{varname} is undefined"
	end
end

# takes a math node
def evaluate_math(node)
	return lambda { |x| return x } if node == nil
	# puts 
	# puts node.to_s
	# puts 
	fchild = node.children[0].value
	if fchild == :plus
		return lambda { |x| return x + evaluate_math(node.children[1]) }
	elsif fchild == :multiply
		return lambda { |x| return x * evaluate_math(node.children[1]) }
	elsif fchild == :left_paren
		return evaluate_math(node.children[3]).call( evaluate_math(node.children[1]) ) 
	elsif fchild == :constant
		return evaluate_math(node.children[1]).call( eval_constant(node.children[0]) )
	elsif fchild == :symbol
		return evaluate_math(node.children[1]).call( eval_symbol(node.children[0]) )
	end
end

# takes a parse tree
def interpret(ptree)
	if ptree.value == :program
		return interpret(ptree.children[0])
	elsif ptree.value == :statement
		return interpret(ptree.children[0])
	elsif ptree.value == :boolean_expr
		left_val = interpret(ptree.children[0])
		right_val = interpret(ptree.children[2])
		if left_val == right_val
			return true
		else
			return false
		end
	elsif ptree.value == :expression
		return interpret(ptree.children[0])	
	elsif ptree.value == :assignment
		res = interpret(ptree.children[2])
		$variables[ptree.children[0].children[0]] = res
		return ""
	elsif ptree.value == :function_call
		return eval_function(ptree)
	elsif ptree.value == :math
		return evaluate_math(ptree)
	end
end

