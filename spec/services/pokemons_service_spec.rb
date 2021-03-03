require 'rails_helper'

RSpec.describe PokemonService do
  context 'fill_pokemon_attributes' do
    before do
      @poke_api_response = OpenStruct.new({
        base_experience: 10,
        sprites: OpenStruct.new({ front_default: 'image_url_stub' })
      })
      @trade = Trade.new
      @trade.pokemons.build(
        [
          { name: 'pikachu', trade_group: 2 }
        ]
      )
      allow(PokeApi).to receive(:get).and_return(@poke_api_response)
    end
    it 'fills base_experience' do
      trade = PokemonService.new(@trade).call.payload
      expect(trade.pokemons.first.base_experience).to be @poke_api_response.base_experience
    end
    it 'fills image_url' do
      trade = PokemonService.new(@trade).call.payload
      expect(trade.pokemons.first.image_url).to eq(@poke_api_response.sprites.front_default)
    end
  end
  context 'base_experience_difference' do
    before do
      @poke_api_response = OpenStruct.new({
        base_experience: 10,
        sprites: OpenStruct.new({ front_default: 'image_url_stub' })
      })
      allow(PokeApi).to receive(:get).and_return(@poke_api_response)
    end
    it 'fills base_experience_difference with 10' do
      trade = Trade.new
      trade.pokemons.build(
        [
          { name: 'pikachu', trade_group: 2 },
          { name: 'pikachu', trade_group: 2 },
          { name: 'charmander', trade_group: 1 }
        ]
      )
      trade = PokemonService.new(trade).call.payload
      expect(trade.base_experience_difference).to eq(10)
    end
    it 'fills base_experience_difference with 20' do
      trade = Trade.new
      trade.pokemons.build(
        [
          { name: 'pikachu', trade_group: 2 },
          { name: 'pikachu', trade_group: 1 },
          { name: 'pikachu', trade_group: 1 },
          { name: 'charmander', trade_group: 1 }
        ]
      )
      trade = PokemonService.new(trade).call.payload
      expect(trade.base_experience_difference).to eq(20)
    end
    it 'fills base_experience_difference with 0' do
      trade = Trade.new
      trade.pokemons.build(
        [
          { name: 'pikachu', trade_group: 2 },
          { name: 'pikachu', trade_group: 1 }
        ]
      )
      trade = PokemonService.new(trade).call.payload
      expect(trade.base_experience_difference).to eq(0)
    end
    it 'fills base_experience_difference with 0 when pokemons list is empty' do
      trade = Trade.new
      trade = PokemonService.new(trade).call.payload
      expect(trade.base_experience_difference).to eq(0)
    end
  end
end
