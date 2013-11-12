require "./lexer.rb"
require "./parser.rb"

$variables = {}
$functions = {
	"print" => :print
}

def eval_constant(node)
	return node.children[0].to_i
end

def eval_function(node)
	func_name = node.children[0].children[0]
	args = interpret(node.children[2])
	return method($functions[func_name]).call(args)
end

def eval_symbol(node)
	varname = node.children[0]
	if $variables.key?(varname)
		return $variables[varname]
	else
		raise "#{varname} is undefined"
	end
end

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

def interpret(ptree)
	if ptree.value == :program
		return interpret(ptree.children[0])
	elsif ptree.value == :statement
		if ptree.children[0].value == :expression
			return interpret(ptree.children[0])
		elsif ptree.children[0].value == :function_call
			return eval_function(ptree.children[0])
		else
			# must be an assignment
			res = interpret(ptree.children[2])
			$variables[ptree.children[0].children[0]] = res
			return ""
		end
	elsif ptree.value == :expression
		return interpret(ptree.children[0])	
	elsif ptree.value == :math
		return evaluate_math(ptree)
	end
end

