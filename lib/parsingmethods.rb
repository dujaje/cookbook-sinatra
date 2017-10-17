require 'pry'

class Parsing
  def get_recipe_names(ingredient)
    url = "http://www.letscookfrench.com/recipes/find-recipe.aspx?s=#{ingredient}&type=all"
    doc = Nokogiri::HTML(open(url))
    recipe_names = []
    divs = doc.search('.m_item')
    divs.each do |div|
      recipe_names << div.search('.m_titre_resultat').text.strip
    end
    recipe_names
  end

  def get_recipe_full_info(ingredient, number_returned)
    url = "http://www.letscookfrench.com/recipes/find-recipe.aspx?s=#{ingredient}&type=all"
    doc = Nokogiri::HTML(open(url))
    recipe_details = {}
    divs = doc.search('.m_item')
    # getting recipe title
    recipe_details[:name] = divs[number_returned].search('.m_titre_resultat').text.strip
    recipe_details[:difficulty] = divs[number_returned].search('.m_detail_recette').text.strip.split(" - ")[2]
    # getting recipe description
    # getting recipe link
    link = 'http://www.letscookfrench.com' + divs[number_returned].search('a')[0]['href']
    recipe_details[:href] = link
    # opening into recipe website
    new_document = Nokogiri::HTML(open(recipe_details[:href]).read)
    # getting more recipe details
    ugly_method = new_document.search('.m_content_recette_todo').text.strip
    clean_method = ugly_method.sub(/Method :/, '').match(/\w.+/).to_s
    recipe_details[:description] = clean_method
    recipe_details[:prep_time] = new_document.search('.preptime').text.strip + " minutes"
    recipe_details[:ingredients] = new_document.search('.m_content_recette_ingredients').text.strip.match(/-.+/).to_s
    # getting recipe difficulty
    # recipe_names[number_returned]
    recipe_details
  end
end
