require 'spec_helper'
require 'fileutils'

RSpec.describe AddMethod do
  include FileUtils

  before(:each) do
    @temp_dir      = 'spec/tmp'
    @original_file = 'spec/fixtures/add_method.rb'
    @res_file      = 'spec/fixtures/res/add_method.rb'

    @temp_file_path = File.join(@temp_dir, File.basename(@original_file))
    copy(@original_file, @temp_file_path)
  end

  it 'adds a new method' do
    new_method_node = Parser::CurrentRuby.parse_with_comments('def new_method; puts "here" ; end')[0]
    args = [
      @temp_file_path,
      new_method_node

    ]
    puts new_method_node
    AddMethod.new(*args).process

=begin
    puts :temp_file_path_l
    puts @temp_file_path
    puts "res ----"
    puts "res ----"
    #puts_file @original_file
    puts_file @temp_file_path
    puts "res ----"
    puts @res_file
    puts_file @res_file
=end

    expect(compare_files(@temp_file_path, @res_file)).to be true
  end

  after(:each) do
    remove(@temp_file_path)
  end
end

