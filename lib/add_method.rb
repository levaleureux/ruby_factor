require 'parser/current'
require 'unparser'

#
# take a file and a method already convert to an ast node
#
#
class AddMethod < Core
  def initialize file, new_method_node
    @file            = file
    @new_method_node = new_method_node
    puts "==============================="
  end

  private

  def perform
    @ast          = build_ast
    #puts "AST"
    #puts @ast
    @modified_ast = add_method_in_ast @ast
    puts "AST modified_ast"
    puts @modified_ast
    puts "___________________________e"
    rebuild_ast
    generate_output
  end

  def add_method_in_ast ast
    ast.updated nil, ast_with_target_node(ast)
  end

  def ast_with_target_node ast
    ast.children.map do |node|
      map_node_with node
    end#.compact
  end

  def methods_node? node
    node.is_a?(Parser::AST::Node) \
      && node.type == :begin
  end

  def map_node_with node
    if methods_node? node
      node = node.updated(nil, [
        node.children[0], # Nom de la classe
        *node.children[1..-1], # Anciennes méthodes
        @new_method_node # Nouvelle méthode à ajouter

      ])
    else
      continue_parsing node
    end
  end

  def continue_parsing node
    add_method_in_ast(node) if node.is_a?(Parser::AST::Node)
    node
  end

  def update_ast ast
    if ast.is_a?(Parser::AST::Node) && ast.type == :class
    else
      if ast.is_a?(Parser::AST::Node) && ast.type == :begin
        #ast.updated nil, update_children(ast)
        puts "on va voir ça !!!"
        #puts ast.children[1..-1]
        #puts meths = ast.children[1..-1][1]
        #puts "meth 0"
        #puts meths
        puts "___________"
        ast = ast.updated(nil, [
          ast.children[0], # Nom de la classe
          *ast.children[1..-1], # Anciennes méthodes
          @new_method_node # Nouvelle méthode à ajouter

        ])
=begin
      puts "cette fois !!!!!!!!!!!!!!!!!!!!!!!!!!!"
      puts meths
      ast = ast.children[1..-1][1].updated(nil, [
        meths.children[0],
        *meths.children[1..-1], # Anciennes méthodes
      ])
      ast.children.map do |node|
        puts "----------- chid node"
        puts node
        puts node.class

      end
=end
        puts "on a vue --------------"
        puts ast
        #new_children = [@new_method_node] + existing_children
        #puts "-=================== voilà"
        #ast.updated nil, new_children
        ast

      else
        puts "AST n'est pas une class"
      end
    end
  end

  def generate_output
    puts "=========== generate_output ========="
    File.write @file, @code_with_comments_restored
    puts @code_with_comments_restored
    puts "Dans le fichier: #{@file}"
    puts "  La méthode ajouter : #{@new_method_node}"
  end
end

