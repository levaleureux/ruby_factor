# Installer la gem 'thor' si elle n'est pas déjà installée
# gem install thor

require 'parser/current'
require 'unparser'
require 'thor'
require_relative './lib/core.rb'
require_relative './lib/rename.rb'

class RefactorMethod < Thor
  desc "rename METHOD_OLD METHOD_NEW FILE", "Renomme une méthode dans un fichier Ruby"
  def rename(method_old, method_new, file)
    re = Rename.new(method_old, method_new, file)
    re.rename
  end

end

# Exécuter la commande
RefactorMethod.start(ARGV)

