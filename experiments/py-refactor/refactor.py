#!/usr/bin/env python
from lib2to3.fixer_util import syms, token, Leaf, Name 
from textwrap import dedent

def pudb_watch(func):
	#FIXME: don't wrap when not connected to tty
	def pudb_wrapper(*args, **kwargs):
		try:
			return func(*args, **kwargs)
		except:
			print 'pudb to the rescue!'
			import pudb, sys
			pudb.post_mortem(sys.exc_info())
	return pudb_wrapper

def trace():
	import pudb
	pudb.set_trace()


from lib2to3.fixer_base import BaseFix
class FixActionMapper(BaseFix):

	PATTERN = r'''
		simple_stmt<
			import_from<any*> any*
		>
		|
		classdef<
			'class' any '(' arglist<
				(any ',')* 'ActionMapper' (',' any)*
			> ')' ':'
			suite<any*>
		>
	'''
	#do I need to look out for this?
	simple_import = '| simple_stmt< import_name<any*> any* >'

	#@pudb_watch
	def transform(self, node, results):
		if node.parent.type != syms.file_input:
			#we only look at top-level stuff
			return

		insert_done = getattr(self, 'insert_done', False)
		if ( node.children and node.children[0].type in 
			( syms.import_from, syms.import_name )
		):
			myimport = node.children[0]
			name = str(myimport.children[1]).strip() 
			if name == 'cmds._action_mapper':
				from lib2to3.fixer_util import BlankLine
				return BlankLine() #deleted!
			elif not insert_done and name > 'cmds._request_mapper':
				insert_imports(node)
				self.insert_done = True
		elif node.type == syms.classdef:
			if not insert_done:
				insert_imports(node)
				self.insert_done = True

			#see filter above:
			# class business ( ... ) : <suite>
			# 0	1	 2 3   4 5 6
			
			inheritance = node.children[3]
			suite = node.children[6]

			#fix inheritance
			classes = by(inheritance.children, 'type')[token.NAME]
			#FIXME: also look for cmds._action_mapper.ActionMapper
			am_classes = by(classes, 'value')['ActionMapper']
			for clazz in am_classes:
				clazz.value = 'RequestMapper'

			#fix execute to be servlet_init
			fix_execute(suite)

			#find and un-decorate the @expose-ed methods
			decorated_functions = by(suite.children, 'type')[syms.decorated]
			exposed_functions = []
			for func in decorated_functions:
				#split the function into its parts, by type
				func_parts = by(func.post_order(), 'type')
				decorators = func_parts[syms.decorator]
				for decorator in decorators:
					name = str(decorator.children[1]).strip()
					if name == 'expose':
						#record the function and remove the decorator
						exposed_functions.extend( func_parts[syms.funcdef] )

						#make sure indentation comes out right
						decorator.next_sibling.prefix=decorator.prefix
						decorator.remove()

			if not exposed_functions:
				return

			#generate and insert the rules code
			indent = find_indentation(suite)

			rule_list = []
			rule_map = {}
			for func in exposed_functions:
				name, rule = make_rule(func)
				rule_map[name] = rule
				rule_list.append(rule)

			#make sure default rule comes last
			if 'default' in rule_map:
				rule_list.remove(rule_map['default'])
				rule_list.append(rule_map['default'])

			rules = '\n\t\t'.join(rule_list)

			rules = dedent('''
			def rules(self):
				return (
					%s
				)
			''') % rules
			rules = rules.strip().replace('\n', '\n' + indent) #indent
			rules += '\n\n' + indent
			suite.insert_child(2, Name(rules))

		else:
			raise NotImplementedError('something else?')

def insert_imports(node):
	"insert the necessary imports before this node"
	index = node.parent.children.index(node)
	node.parent.insert_child(index, Name(dedent('''\
		from cmds._request_mapper import And
		from cmds._request_mapper import GET
		from cmds._request_mapper import Path
		from cmds._request_mapper import RequestMapper
	''')))

def fix_execute(class_suite):
	"fix execute to be servlet_init"
	functions = by(class_suite.children, 'type')[syms.funcdef]
	for func in functions:
		name = func.children[1].value
		if name == 'execute':
			break
	else:
		return
	func.children[1].value = 'servlet_init'

	#fix up arguments
	func_parts = by(func.children, 'type')
	params = func_parts[syms.parameters][0].children[1]

	#we assume that the parameter list is just 'self'
	if str(params).strip() != 'self':
		raise NotImplementedError('handle multiple arguments')

	#this could be more rigorous...
	params.replace(Name("self, *args, **kwargs"))

	#add cooperative superclass init_servlet() call
	classname = class_suite.parent.children[1].value
	suite = func_parts[syms.suite][0]
	indent = find_indentation(suite)
	suite.insert_child(2, Name(
		'super(%s, self).servlet_init(*args, **kwargs)\n\n'%classname+indent
	))

	#finally, remove 'return self._consume_action()'
	for node in suite.post_order():
		if getattr(node, 'value', None) == '_consume_action':
			while node.type != syms.simple_stmt:
				node = node.parent
			node.remove()
			break

def make_rule(func):
	func_parts = by(func.children, 'type')
	name = func.children[1].value
	suite, = func_parts[syms.suite]
	params = func_parts[syms.parameters][0].children[1]
	param_vals = by(params.children, 'value') #params by value
	#assert param_vals, "No param values!" #it's fine if it's only "(self)"

	if '*' in param_vals:
		#check that it's used...
		vararg = param_vals['*'][0].next_sibling
		if vararg.value not in names_mentioned(suite):
			#kill the *
			vararg.prev_sibling.remove()
			#look for a comma
			if vararg.prev_sibling and vararg.prev_sibling.value == ',':
				vararg.prev_sibling.remove()
			#remove this variable
			vararg.remove()
		else:
			#raise NotImplementedError('That variable is used!')
			pass #let's see what happens if we leave it

	#look at params again
	params = iter(func_parts[syms.parameters][0].children[1].children[1:])
	args = []
	for param in params:
		if param.value == ',':
			continue
		elif param.value == '*':
			break
		elif param.value == '=':
			params.next() #don't look at the value
		else:
			args.append(param.value)

	#model: (from user_favorites.py)
	# (And(POST(), Path('^delete_list/(?P<list_id>[^/]+)$')), self.delete_list),
	pattern = "r'^"
	if name != 'default':
		pattern += name 
		pattern += '/'
	for arg in args:
		pattern += "(?P<%s>[^/]+)" % arg
		pattern += '/'
	if not pattern.endswith('/'):
		pattern += '/'
	pattern += "?$'"

	rule = "(And(GET(), Path({0})), self.{func}),".format(pattern, func=name)
	return name, rule

def by(objlist, attr):
	"return the object list, represented as an defaultdict(list) of their specified attribute"
	from collections import defaultdict
	types = defaultdict(list)
	try:
		objlist = iter(objlist)
	except TypeError:
		return types
	for obj in objlist:
		types[getattr(obj, attr, None)].append(obj)
	return types



def refactor(fname, fixer):
	from lib2to3 import pygram, pytree
	from lib2to3.pgen2 import driver
	from lib2to3.refactor import RefactoringTool

	drv = driver.Driver(pygram.python_grammar, pytree.convert)
	tree = drv.parse_string(open(fname).read(), True)

	refactory = RefactoringTool(fixer)
	refactory.refactor_tree(tree, fname)

	return str(tree)
	#return str()

def main(files):
	from sys import stdout
	for fname in files:
		 stdout.write( refactor(fname, ['action_mapper']) )

## fixer_util : these should really go into lib2to3.fixer_util ##############################
def Colon():
	return Leaf(token.COLON, u":")
def Indent(prev_indent, additional=0, style='\t'):
	return Leaf(token.INDENT, prev_indent + additional*style)
def Tuple(mytuple):
	from lib2to3.pytree import LParen, Comma, RParen, Node
	content = [LParen()]
	for node in mytuple:
		if not isinstance(node, (Node, Leaf)):
			node = Name(node)
		content.append(node)
		content.append(Comma())
	content.append(RParen())
    	return Node(syms.atom, content)
def find_indentation(node):
    """Find the indentation of *node*."""
    while node is not None:
        if node.type == syms.suite and len(node.children) > 2:
            indent = node.children[1]
            if indent.type == token.INDENT:
                return indent.value
        node = node.parent
    return u""
def names_mentioned(node):
    "return a list of all names mentioned within this node"
    return by(by(node.post_order(), 'type')[token.NAME], 'value').keys()
## fixer_util : #############################################################################

if __name__ == '__main__':
	from sys import argv
	exit(main(argv[1:]))
