# math_spec.rb

# Charger RSpec
require 'rspec'

# Définir la spécification
RSpec.describe "Addition" do
  it "adds 2 and 2 to equal 4" do
    # Effectuer l'opération
    result = 2 + 2

    # Vérifier le résultat
    expect(result).to eq(4)
  end
end
