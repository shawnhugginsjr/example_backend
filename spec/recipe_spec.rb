require_relative '../recipe'

describe Recipe do
  before do
    Recipe.clear

    Recipe.describe do
      recipe 'Pancake' do
        ingredient 'Store-bought pancake mix'
        ingredient 'Water'

        # The test context kept using main.method instead of my function definition
        # of main. Since the Object class is already using 'method', I changed
        # the function name to 'recipe_method' instead.
        recipe_method do
          step 'Mix the ingredients'
          step 'Cook them in a pan'
        end
      end

      recipe 'Miso Soup' do
        ingredient 'Tofu'
        ingredient 'White miso paste'

        recipe_method do
          step 'Mix miso paste into boiling water'
          step 'Add tofu and serve'
        end
      end
    end
  end

  it 'records the ingredients and method of each recipe' do
    pancake_recipe = Recipe.for('Pancake')

    expect(pancake_recipe.name).to eq 'Pancake'
    expect(pancake_recipe.ingredients).to eq ['Store-bought pancake mix', 'Water']
    expect(pancake_recipe.method_steps).to eq ['Mix the ingredients', 'Cook them in a pan']

    soup_recipe = Recipe.for('Miso Soup')

    expect(soup_recipe.name).to eq 'Miso Soup'
    expect(soup_recipe.ingredients).to eq ['Tofu', 'White miso paste']
    expect(soup_recipe.method_steps).to eq ['Mix miso paste into boiling water', 'Add tofu and serve']
  end

  let(:pancake_ingredients) {['Store-bought pancake mix', 'Water']}
  let(:pancake_method_steps) {['Mix the ingredients', 'Cook them in a pan']}
  let(:soup_ingredients) {['Tofu', 'White miso paste']}
  let(:soup_method_steps) {['Mix miso paste into boiling water', 'Add tofu and serve']}
  let(:pancake_recipe) {Recipe.for('Pancake')}
  let(:soup_recipe) { Recipe.for('Miso Soup')}

  describe "#for" do
    context "given a recipe name that exists" do
      it "returns the Recipe" do
        expect(pancake_recipe).not_to eq(nil)
      end

      it 'returns a valid Recipe' do
        expect(Recipe.valid?(pancake_recipe)).to eq(true)
      end
    end

    it "returns nil for non-existent Recipe names" do
      no_recipe = Recipe.for('no_reipe')
      expect(no_recipe).to eq(nil) 
    end

    context "given a non-string Recipe name" do
      it "raises an ArgumentError" do
        expect {Recipe.for(1)}.to raise_error(ArgumentError)
      end
    end
  end


  describe '#clear' do
    it 'deletes all created recipes' do
      expect(pancake_recipe).to be
      expect(soup_recipe).to be
      expect(Recipe.clear.empty?).to equal(true)
    end
  end

  describe '#valid?' do
    it 'returns true for valid Recipes' do
      expect(Recipe.valid?(pancake_recipe)).to equal(true)
    end

    context 'given an invalid Recipe' do
      context 'given an invalid name' do
        it 'returns false for empty names' do
          recipe = Recipe.new('', ['test'], '[test]')
          expect(Recipe.valid?(recipe)).to equal(false)
        end

        it 'returns false for white space only names' do
          recipe = Recipe.new('     ', ['test'], ['test'])
          expect(Recipe.valid?(recipe)).to equal(false)
        end
      end

      it 'returns false for empty ingredients' do
        recipe = Recipe.new('Miso', [], ['test'])
        expect(Recipe.valid?(recipe)).to equal(false)
      end

      it 'returns false for empty method steps' do
        recipe = Recipe.new('Miso', ['test'], [])
        expect(Recipe.valid?(recipe)).to equal(false)
      end
    end
  end

  describe '#add_recipe' do
    context 'given a valid Recipe' do
      let(:valid_recipe) {Recipe.new('soap stew',['soap', 'warm water'],['place stew in warm water'])}

      it 'returns true for valid Recipes' do
        result = Recipe.add_recipe(valid_recipe)
        expect(result).to eq(true)
      end

      it 'does add the valid Recipe' do
        expect(Recipe.for(valid_recipe.name)).not_to eq(nil)
      end
    end

    context 'given an invalid Recipe' do
      let(:invalid_recipe) {Recipe.new('invalid',[],[])}

      it 'returns false for invalid Recipes' do
        result = Recipe.add_recipe(invalid_recipe)
        expect(result).to eq(false)
      end

      it 'does not add the invalid Recipe' do
        result = Recipe.add_recipe(invalid_recipe)
        expect(Recipe.for(invalid_recipe.name)).to eq(nil)
      end
    end
  end

  describe ".name" do
    it "returns 'Pancake' for the Pancake Recipe" do
      expect(pancake_recipe.name).to eq('Pancake')
    end

    it "returns 'Miso Soup' for the Miso Soup Recipe " do
      expect(soup_recipe.name).to eq('Miso Soup')
    end
  end

  describe ".ingredients" do
    it "returns pancake ingredients for the Pancake Recipe" do
      expect(pancake_recipe.ingredients).to eq(pancake_ingredients)
    end

    it "returns miso soup ingredients for the Miso Soup Recipe " do
      expect(soup_recipe.ingredients).to eq(soup_ingredients)
    end
  end

  describe ".method_steps" do
    it "returns pancake method steps for the Pancake Recipe" do
      expect(pancake_recipe.method_steps).to eq(pancake_method_steps)
    end

    it "returns miso Soup method steps for the Miso Soup Recipe " do
      expect(soup_recipe.method_steps).to eq(soup_method_steps)
    end
  end
end