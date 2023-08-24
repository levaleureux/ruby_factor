require 'parser/current'
require 'unparser'

class RemoveMethod < Core
  def initialize method_name, file
    @method_name = method_name
    @file        = file
  end

  private

  def perform
    ast           = build_ast
    @modified_ast = remove_method_in_ast ast
    rebuild_ast
    generate_output
  end

  def rebuild_ast
    modified_code = Unparser.unparse @modified_ast
    @code_with_comments_restored = modified_code.dup
    re_insert_comments
    puts @code_with_comments_restored
  end

  def generate_output
    File.write @file, @code_with_comments_restored
    puts "Dans le fichier: #{@file}"
    puts "  La méthode supprimée : #{@method_name}"
  end

  def remove_method_in_ast ast
    ast.updated nil, ast_without_target_node(ast)
  end

  def ast_without_target_node ast
    ast.children.map do |node|
      map_node_with node
    end.compact
  end

  def method_node_to_remove? node
    node.is_a?(Parser::AST::Node) \
      && node.type == :def \
      && node.children[0].to_s == @method_name
  end

  def map_node_with node
    if method_node_to_remove?(node)
      @removed_method_node = node.dup # Copie le nœud supprimé
      nil # Remove the method node
    else
      continue_parsing node
    end
  end

  def continue_parsing node
    remove_method_in_ast(node) if node.is_a?(Parser::AST::Node)
    node
  end

end
