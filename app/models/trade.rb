class Trade < ApplicationRecord
  has_many :pokemons, dependent: :destroy, inverse_of: :trade

  validates :base_experience_difference, presence: true
  validate :must_have_at_least_one_pokemon_on_each_side_of_the_trade, :max_6_pokemons_on_each_side

  def must_have_at_least_one_pokemon_on_each_side_of_the_trade
    errors.add(:pokemons, 'must have at least one pokemon on each side of the trade') unless
    pokemons.reduce(0) { |sum, p| sum + (p.trade_group == 1 ? 1 : 0) }.positive? &&
    pokemons.reduce(0) { |sum, p| sum + (p.trade_group == 2 ? 1 : 0) }.positive?
  end

  def max_6_pokemons_on_each_side
    errors.add(:pokemons, 'must have maximum 6 pokemons on each side of the trade') unless
    pokemons.size.zero? ||
    pokemons.reduce(0) { |sum, p| sum + (p.trade_group == 1 ? 1 : 0) } < 7 &&
    pokemons.reduce(0) { |sum, p| sum + (p.trade_group == 2 ? 1 : 0) } < 7
  end
end
