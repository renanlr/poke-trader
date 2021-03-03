require 'rails_helper'

RSpec.describe Trade, type: :model do
  context 'with no base_experience_difference set' do
    it 'should return false' do
      trade = Trade.new
      expect(trade.save).to be false
    end
  end
  context 'with no pokemons set' do
    it 'on both sides of the trade should return false' do
      trade = Trade.new(base_experience_difference: 1)
      expect(trade.save).to be false
    end
    it 'in only A group of the trade should return false' do
      trade = Trade.new(base_experience_difference: 1)
      trade.pokemons.build(
        [
          { name: 'pikachu', base_experience: 10, trade_group: 1 },
          { name: 'ratata', base_experience: 10, trade_group: 1 }
        ]
      )
      expect(trade.save).to be false
    end
    it 'in only B group of the trade should return false' do
      trade = Trade.new(base_experience_difference: 1)
      trade.pokemons.build(
        [
          { name: 'pikachu', base_experience: 10, trade_group: 2 },
          { name: 'ratata', base_experience: 10, trade_group: 2 }
        ]
      )
      expect(trade.save).to be false
    end
  end
  context 'with pokemons set' do
    it 'in both groups should create trade with success' do
      trade = Trade.new(base_experience_difference: 1)
      trade.pokemons.build(
        [
          { name: 'pikachu', base_experience: 10, trade_group: 1 },
          { name: 'ratata', base_experience: 10, trade_group: 2 }
        ]
      )
      expect(trade.save).to be true
      expect(Trade.find(trade.id).pokemons.from_group_a.count).to be 1
      expect(Trade.find(trade.id).pokemons.from_group_b.count).to be 1
    end
    it 'in both groups with more than 6 pokemons in group A should return false' do
      trade = Trade.new(base_experience_difference: 1)
      trade.pokemons.build(
        [
          { name: 'pikachu', base_experience: 10, trade_group: 2 },
          { name: 'pikachu', base_experience: 10, trade_group: 1 },
          { name: 'ratata', base_experience: 10, trade_group: 1 },
          { name: 'ratata', base_experience: 10, trade_group: 1 },
          { name: 'ratata', base_experience: 10, trade_group: 1 },
          { name: 'ratata', base_experience: 10, trade_group: 1 },
          { name: 'ratata', base_experience: 10, trade_group: 1 },
          { name: 'ratata', base_experience: 10, trade_group: 1 }
        ]
      )
      expect(trade.save).to be false
    end
    it 'in both groups with more than 6 pokemons in group B should return false' do
      trade = Trade.new(base_experience_difference: 1)
      trade.pokemons.build(
        [
          { name: 'pikachu', base_experience: 10, trade_group: 1 },
          { name: 'pikachu', base_experience: 10, trade_group: 2 },
          { name: 'ratata', base_experience: 10, trade_group: 2 },
          { name: 'ratata', base_experience: 10, trade_group: 2 },
          { name: 'ratata', base_experience: 10, trade_group: 2 },
          { name: 'ratata', base_experience: 10, trade_group: 2 },
          { name: 'ratata', base_experience: 10, trade_group: 2 },
          { name: 'ratata', base_experience: 10, trade_group: 2 }
        ]
      )
      expect(trade.save).to be false
    end
  end
end
