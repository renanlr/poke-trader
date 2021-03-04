class PokemonService
  def initialize(trade)
    @trade = clean_trade(trade)
  end

  def call
    @trade.pokemons = @trade.pokemons.map { |p| fill_pokemon_attributes(p) }
    @trade.base_experience_difference = base_experience_difference(@trade)
    OpenStruct.new({ success?: true, payload: @trade })
  end

  private

  def fill_pokemon_attributes(pokemon)
    pokemon_from_api = PokeApi.get(pokemon: pokemon.name)
    pokemon.base_experience = pokemon_from_api.base_experience
    pokemon.image_url = pokemon_from_api.sprites.front_default
    pokemon
  end

  def base_experience_difference(trade)
    (trade.group_a_experience - trade.group_b_experience).abs
  end

  def clean_trade(trade)
    trade.pokemons = trade.pokemons.filter { |p| !p.name.blank? }.map { |p| downcase_pokemon_name(p) }
    trade
  end

  def downcase_pokemon_name(pokemon)
    pokemon.name = pokemon.name.downcase
    pokemon
  end

  def handle_error(error)
    OpenStruct.new({ success?: false, error: error })
  end
end
