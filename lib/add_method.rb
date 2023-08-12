require 'parser/current'
require 'unparser'

class AddMethod < Core
  def initialize(file, new_method_node)
    @file = file
    @new_method_node = new_method_node
  end

  def add
    process
  end

  private

  def process
    ast           = build_ast
    @modified_ast = add_method_to_ast ast, @new_method_node
    rebuild_ast
    generate_output
  end

  # Ajouter un nœud de méthode (AST) à l'AST existant
  #
  def add_method_to_ast(ast, new_method_node)
    ast.updated(nil, ast.children.map do |node|
      if node.type == :class
        node.updated(nil, node.children.map do |child_node|
          if child_node.type == :def
            new_method_node # Ajouter le nouveau nœud de méthode
          else
            child_node
          end
        end)
      else
        add_method_to_ast(node, new_method_node) if node.is_a?(Parser::AST::Node)
        node
      end
    end.compact)
  end
end

