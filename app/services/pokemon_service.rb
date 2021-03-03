class PokemonService
  def initialize(trade)
    @trade = trade
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
    (trade.pokemons_from_group_a.reduce(0) { |sum, p| sum + p.base_experience } -
    trade.pokemons_from_group_b.reduce(0) { |sum, p| sum + p.base_experience }).abs
  end

  def handle_error(error)
    OpenStruct.new({ success?: false, error: error })
  end
end
