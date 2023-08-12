require 'parser/current'
require 'unparser'
require 'thor'
require_relative './lib/core.rb'
require_relative './lib/rename.rb'
require_relative './lib/move_method.rb'
require_relative './lib/remove_method.rb'

class RefactorMethod < Thor
  desc "rename method_old method_new file",
    "Renomme une méthode dans un fichier Ruby"
  def rename(method_old, method_new, file)
    re = Rename.new(method_old, method_new, file)
    re.rename
  end

  desc "move_method source_class method_name target_class file",
    "Déplace une méthode d'une classe source vers une classe cible"
  def move_method(source_class, method_name, target_class, file)
    MoveMethodToClass.new(
      method_name,
      source_class,
      target_class,
      file
    ).process
  end

  desc "remove_method source_class method_name target_class file",
    "Supprimer une méthode d'un fichier source"
  def remove_method(method_name, file)
    RemoveMethod.new(
      method_name,
      file
    ).process
  end

end

RefactorMethod.start(ARGV)
