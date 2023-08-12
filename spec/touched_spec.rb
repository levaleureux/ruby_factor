# math_spec.rb

# Charger RSpec
#require 'rspec'
require 'spec_helper'

# Définir la spécification
RSpec.describe "Addition" do
  it "adds 2 and 2 to equal 4" do
    # Effectuer l'opération
    result = 2 + 2

    # Vérifier le résultat
    expect(result).to eq(4)
  end
end

# Décrivez la classe que vous testez
RSpec.describe RemoveMethod do
  # It/Exemple pour vérifier la présence de la classe
  it 'existe' do
    # Vérifiez si la classe est définie
    puts "coucou"
    expect(defined?(RemoveMethod)).to be_truthy
  end
end

