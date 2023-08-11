require 'parser/current'
require 'unparser'
require 'thor'
require_relative './lib/core.rb'
require_relative './lib/rename.rb'

class RefactorMethod < Thor
  desc "rename method_old method_new file", "Renomme une méthode dans un fichier Ruby"
  def rename(method_old, method_new, file)
    re = Rename.new(method_old, method_new, file)
    re.rename
  end

end

RefactorMethod.start(ARGV)
