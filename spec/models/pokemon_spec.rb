require 'rails_helper'

RSpec.describe Pokemon, type: :model do
  context 'with no trade set' do
    it 'should return false' do
      pokemon = Pokemon.new
      expect(pokemon.save).to be false
    end
  end
  context 'with trade set' do
    before do
      @trade = Trade.new(base_experience_difference: 1)
      @trade.pokemons.build(
        [
          { name: 'pikachu', base_experience: 10, trade_group: 2 },
          { name: 'raichu', base_experience: 10, trade_group: 1 }
        ]
      )
      @trade.save
    end
    it 'should return true' do
      pokemon = Pokemon.new(name: 'torchic', base_experience: 10, trade_group: 1)
      pokemon.trade = @trade
      expect(pokemon.save).to be true
    end
    it 'and name empty should return false' do
      pokemon = Pokemon.new(base_experience: 10, trade_group: 1)
      pokemon.trade = @trade
      expect(pokemon.save).to be false
    end
    it 'and base_experience empty should return false' do
      pokemon = Pokemon.new(name: 'Torchic', trade_group: 1)
      pokemon.trade = @trade
      expect(pokemon.save).to be false
    end
    it 'and trade_group empty should return false' do
      pokemon = Pokemon.new(name: 'Torchic', trade_group: 1)
      pokemon.trade = @trade
      expect(pokemon.save).to be false
    end
  end
  context 'when call from_group_a' do
    it 'should return only pokemons from group a' do
      trade = Trade.new(base_experience_difference: 1)
      trade.pokemons.build(
        [
          { name: 'pikachu', base_experience: 10, trade_group: 2 },
          { name: 'raichu', base_experience: 10, trade_group: 1 },
          { name: 'raichu', base_experience: 10, trade_group: 1 },
        ]
      )
      trade.save
      expect(trade.pokemons.from_group_a.count).to be 2
    end
  end
  context 'when call from_group_b' do
    it 'should return only pokemons from group b' do
      trade = Trade.new(base_experience_difference: 1)
      trade.pokemons.build(
        [
          { name: 'pikachu', base_experience: 10, trade_group: 2 },
          { name: 'raichu', base_experience: 10, trade_group: 1 },
          { name: 'raichu', base_experience: 10, trade_group: 1 }
        ]
      )
      trade.save
      expect(trade.pokemons.from_group_b.count).to be 1
    end
  end
end
