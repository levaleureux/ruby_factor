require 'parser/current'
require 'unparser'

class Core

  def process
    perform
  rescue StandardError => e
    puts "Une erreur s'est produite : #{e.message}"
  end

  private

  def build_ast
    code = File.read(@file)
    ast, @comments = Parser::CurrentRuby.parse_with_comments(code)
    ast
  end

  # Convertir l'AST en code source avec les commentaires
  #
  def rebuild_ast
    modified_code                = Unparser.unparse @modified_ast
    @code_with_comments_restored = modified_code.dup
    re_insert_comments
    puts @code_with_comments_restored
  end

  # Remplacer les commentaires dans le code généré
  #
  def re_insert_comments
    @comments.each do |comment|
      line_number  = comment.location.line - 1
      comment_text = comment.text
      @code_with_comments_restored.insert line_number, comment_text + "\n"
    end
  end
end
