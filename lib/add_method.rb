require 'parser/current'
require 'unparser'

class AddMethod < Core
  def initialize file, new_method_node
    @file            = file
    @new_method_node = new_method_node
  end

  private

  def process
    @ast          = build_ast
    @modified_ast = update_ast
    rebuild_ast
    generate_output
  end

  def update_ast
    @ast.updated nil, add_method_to_ast(ast)
  end

  def add_method_to_ast ast
    ast.children.map do |node|
      map_node_with node
    end.compact
  end

  def map_node_with node
    if node.type == :class
      node.updated(nil, node.children.map do |child_node|
        if child_node.type == :def
          @new_method_node # Ajouter le nouveau nœud de méthode
        else
          child_node
        end
      end)
    else
      continue_parsing node
    end
  end

  def continue_parsing node
    add_method_to_ast(node) if node.is_a?(Parser::AST::Node)
    node
  end
end

