require 'parser/current'
require 'unparser'

class Core

  private

  def process
    perform
  rescue StandardError => e
    puts "Une erreur s'est produite : #{e.message}"
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
