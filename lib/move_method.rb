#require_relative 'Core'

class MoveMethodToClass < Core

  def initialize method_name, source_class, target_class, file
    @method_name  = method_name
    @source_class = source_class
    @target_class = target_class
    @file         = file
  end

  private

  def perform
    ast = build_ast
    puts ast
    @modified_ast = move_method_in_ast(ast)
    rebuild_ast
    generate_output
  end

  def build_ast
    code           = File.read @file
    ast, @comments = Parser::CurrentRuby.parse_with_comments code
    ast
  end

  # Reste du code (build_ast, rebuild_ast, generate_output, etc.)

  def move_method_in_ast(ast)
    ast.updated(nil, ast.children.map do |node|
      if node.is_a?(Parser::AST::Node)
        if node.type == :class && class_name(node) == @source_class
          puts "source class"
          move_method(node)
        else
          move_method_in_ast(node)
        end
      else
        node
      end
    end)
  end

  def class_name(class_node)
    name = class_node.children[0].to_s
    name = class_node.children[0].children[1].to_s
    puts "---------- #{ name }"
    puts "---------- #{ name.class }"
    name
  end
=begin
  def move_method(class_node)
    puts "move_method #{ class_node }"
    puts class_node.children[2]
    puts "class du truc"
    puts class_node.children[2].class
    modified_methods = class_node.children[2].map do |node|
      if node.is_a?(Parser::AST::Node) && node.type == :def && node.children[0].to_s == @method_name
        unless method_already_exists(class_node, @target_class)
          # Clone the method and modify the class and method names
          new_method = node.dup
          new_method.children[0] = @method_name_new.to_sym
          @target_class_node = find_class_node(class_node, @target_class)
          @target_class_node.children[2] << new_method
        else
          puts "Méthode #{@method_name_new} existe déjà dans la classe #{@target_class}."
        end
        nil # Remove the original method from the source class
      else
        node
      end
    end.compact

    class_node.updated(nil, [class_node.children[0],
                             class_node.children[1],
                             modified_methods])
  end

  def method_already_exists(class_node, method_name)
    class_node.children[2].any? { |node|
      (node.is_a?(Parser::AST::Node) && node.type == :def && node.children[0].to_s == method_name)
    }
  end

=end

  def find_class_node(ast, class_name)
    ast.each_node do |node|
      return node if (node.is_a?(Parser::AST::Node) && node.type == :class && class_name(node) == class_name)
    end
  end

  # Déplace une méthode d'une classe vers une autre classe dans l'AST
  def move_method(class_node)
    @target_class_node = find_class_node(class_node, @target_class)

    if method_exists_in_target_class?
      puts "La méthode #{@method_name_new} existe déjà dans la classe #{@target_class}."
    else
      modify_class_node(class_node)
    end

    class_node
  end

  private

  def method_exists_in_target_class?
    @target_class_node.children[2].any? { |node| method_node_to_rename?(node) }
  end

  def modify_class_node(class_node)
    modified_methods = class_node.children[2].map do |node|
      if method_node_to_rename?(node)
        new_method = duplicate_method_node_with_new_name(node)
        @target_class_node.children[2] << new_method
        nil # Remove the original method from the source class
      else
        node
      end
    end.compact

    class_node.updated(nil, [class_node.children[0], class_node.children[1], modified_methods])
  end

  def method_node_to_rename?(node)
    node.is_a?(Parser::AST::Node) && node.type == :def && node.children[0].to_s == @method_name
  end

  def duplicate_method_node_with_new_name(node)
    new_method = node.dup
    new_method.children[0] = @method_name_new.to_sym
    new_method
  end

  def generate_output
    File.write @file, @code_with_comments_restored
    puts "Dans le fichier: #{@file}"
    puts "  La méthode        : #{@method_name}"
    puts "  a été déplacée de : #{@source_class}"
    puts "  vers              : #{@target_class}"
  end
end
