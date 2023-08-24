# NOTE: This is a work in progress
#
=begin
# Méthode qui ajoute un puts "salut" avant chaque instruction
def add_puts_before_instructions(code)
  ast, comments = Parser::CurrentRuby.parse_with_comments(code)
  # Analyser l'AST
  ast = Parser::CurrentRuby.parse(code)

  # Parcourir l'AST
  new_statements = ast.children.map do |node|
    # Si c'est une instruction (nœud de type :send), ajouter un puts avant
    if node.type == :send
      # Créer un nœud pour le puts
      puts_node = Parser::CurrentRuby.parse("puts 'Salut!'")

      # Ajouter le nœud d'instruction actuel après le puts
      [puts_node, node]
    else
      # Ne rien changer pour les autres nœuds
      node
    end
  end

  # Créer un nouveau nœud de méthode avec les nouvelles instructions
  new_method = ast.updated(nil, new_statements)

  # Convertir l'AST en code source modifié
  modified_code = Unparser.unparse(new_method)

  modified_code
end
=end

# Méthode pour ajouter un puts avant chaque instruction dans une méthode
def add_puts_before_instructions(code)
  # Analyser l'AST
  ast = Parser::CurrentRuby.parse(code)

  # Méthode récursive pour parcourir l'AST
  def process_node(node)
    if node.is_a?(Parser::AST::Node)
      # Si c'est un nœud d'instruction, ajouter un puts avant
      if node.type == :send
        # Créer un nœud pour le puts
        puts_node = Parser::CurrentRuby.parse("puts 'Salut!'")

        # Remplacer le nœud d'instruction par les deux nœuds (puts et instruction)
        return Parser::AST::Node.new(:begin, [puts_node, node])
      else
        # Si ce n'est pas une instruction, parcourir les enfants
        return node.updated(nil, node.children.map { |child| process_node(child) })
      end
    else
      # Retourner les nœuds non-AST inchangés
      node
    end
  end

  # Appeler la méthode de traitement récursif sur l'AST
  modified_ast = process_node(ast)

  # Convertir l'AST en code source modifié
  modified_code = Unparser.unparse(modified_ast)

  modified_code
end

# Méthode d'origine
original_code = <<~EOL
  def add(a, b)
    puts a + b
    c = a + b
  end
EOL
#puts "Original : #{original_code}"

# Appel de la méthode qui ajoute les puts
#modified_code = add_puts_before_instructions(original_code)
#puts "Modifié : #{modified_code}"
