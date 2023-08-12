require 'parser/current'
require 'unparser'

class Rename < Core
  def initialize method_old, method_new, file
    @method_old = method_old
    @method_new = method_new
    @file       = file
  end

  def rename
    process
  end

  private

  def perform
    ast           = build_ast
    @modified_ast = rename_method_in_ast ast
    rebuild_ast
    generate_output
  end

  def build_ast
    code           = File.read @file
    ast, @comments = Parser::CurrentRuby.parse_with_comments code
    ast
  end

  def generate_output
    File.write @file, @code_with_comments_restored
    puts "Dans le fichier: #{@file}"
    puts "  La méthode        : #{@method_old}"
    puts "  a été renommée en : #{@method_new}"
  end

  def rename_method_in_ast ast
    ast.updated nil, ast.children.map do |node|
      if node.is_a? Parser::AST::Node
        if node.type == :def && node.children[0].to_s == @method_old
          node.updated nil, [@method_new.to_sym] + node.children[1..-1]
        else
          rename_method_in_ast node
        end
      else
        node
      end
    end
  end

end
