require 'pry'
require 'pg'
require 'sinatra'

def db_connection
  begin
    connection = PG.connect(dbname: 'recipes')

    yield(connection)

  ensure
    connection.close
  end
end

get '/recipes' do
  query = "SELECT name, id FROM recipes ORDER by name;"
  @recipe_names = db_connection do |conn|
    conn.exec(query).to_a
  end
  erb :index_recipe
end

get '/recipes/:id' do
  id = params[:id]
  query = "SELECT recipes.name, ingredients.name AS ingredient, recipes.description,
          recipes.instructions, recipes.id FROM recipes
          JOIN ingredients ON recipes.id = ingredients.recipe_id
          WHERE recipes.id = #{id};"
  @ingredients = db_connection do |conn|
    conn.exec(query).to_a
  end
  erb :show_recipe
end



set :views, File.dirname(__FILE__) + '/views'
set :public_folder, File.dirname(__FILE__) + '/public'
