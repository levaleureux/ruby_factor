require 'spec_helper'
require 'fileutils' # Assurez-vous d'inclure le module FileUtils

RSpec.describe RemoveMethod do
  include FileUtils # Inclure le module FileUtils pour utiliser ses méthodes

  before(:each) do
    # Copie du fichier fixture dans un répertoire de travail temporaire
    @temp_dir      = 'spec/tmp'
    @original_file = 'spec/fixtures/remove_method.rb'
    @res_file      = 'spec/fixtures/res/remove_method.rb'

    # Construction du chemin complet du fichier temporaire
    @temp_file_path = File.join(@temp_dir, File.basename(@original_file))
    puts @temp_file_path
    puts "@temp_file_path"
    # Copie du fichier fixture dans le répertoire temporaire
    #copy(File.join('spec/fixtures', @original_file), @temp_file_path)
    copy(@original_file, @temp_file_path)
  end

  it 'start' do
    args = [
      "trust_no_one_2",
      @temp_file_path
    ]
    RemoveMethod.new(*args).process
    puts @temp_file_path
    puts @res_file
    expect(compare_files(@temp_file_path, @res_file)).to be true
  end

  after(:each) do
    #FileUtils.remove(@temp_file_path)
  end

end
