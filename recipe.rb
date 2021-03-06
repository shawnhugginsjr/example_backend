class Recipe
    # @@inprogress_recipe is used to progressively build a Recipe object when
    # using Recipe#describe. @@inprogress_recipe holds data between Ruby blocks
    # calls.
    @@inprogress_recipe = nil
    @@added_recipes = {}

    def initialize(name, ingredients, method_steps)
        @name = name
        @ingredients = ingredients
        @method_steps = method_steps
    end

    attr_reader :name, :ingredients, :method_steps

    class << self
        def clear
            @@added_recipes.clear
        end

        # Describe is used to dynamically build a Recipe object. Its usage can be
        # seen in recipe_spec.rb inside the Recipe description.
        def describe
            yield
        end

        def for(recipe_name)
            unless recipe_name.is_a?(String)
                raise ArgumentError.new(
                    'Expected recipe_name to be a string'
                  )
            end
            @@added_recipes[recipe_name]
        end

        def valid?(recipe)
            valid_name = recipe.name.is_a?(String) && !recipe.name.strip.empty?
            valid_name && !recipe.ingredients.empty? && !recipe.method_steps.empty?
        end

        def inprogress_recipe
            @@inprogress_recipe
        end

        def inprogress_recipe=(recipe)
            @@inprogress_recipe = recipe
        end

        def add(new_recipe)
            return false unless Recipe.valid?(new_recipe)
            @@added_recipes[new_recipe.name] = new_recipe
            true
        end
    end
end

# The following fuctions are used to dynamically build a Recipe object.
# Their usage can be seen in recipe_spec.rb inside the Recipe description.

def recipe_method
    yield
end

def ingredient(recipe_ingredient)
    Recipe.inprogress_recipe[:ingredients].append(recipe_ingredient)
end

def step(recipe_step)
    Recipe.inprogress_recipe[:method_steps].append(recipe_step)
end

def recipe(recipe_name)
    inprogress_recipe = {name: '', ingredients:[], method_steps: []}
    inprogress_recipe[:name] = recipe_name
    Recipe.inprogress_recipe = inprogress_recipe
    yield
    new_recipe = Recipe.new(inprogress_recipe[:name],inprogress_recipe[:ingredients], inprogress_recipe[:method_steps] )
    Recipe.add(new_recipe)
    Recipe.inprogress_recipe = nil
end
