class Trade < ApplicationRecord
  has_many :pokemons, dependent: :destroy, inverse_of: :trade
  accepts_nested_attributes_for :pokemons, allow_destroy: true, reject_if: :all_blank

  validates :base_experience_difference, presence: true
  validate :must_have_at_least_one_pokemon_on_each_side_of_the_trade, :max_6_pokemons_on_each_side

  def must_have_at_least_one_pokemon_on_each_side_of_the_trade
    errors.add(:pokemons, 'must have at least one pokemon on each side of the trade') unless
    pokemons_from_group_a.size.positive? &&
    pokemons_from_group_b.size.positive?
  end

  def max_6_pokemons_on_each_side
    errors.add(:pokemons, 'must have maximum 6 pokemons on each side of the trade') unless
    pokemons.size.zero? ||
    pokemons_from_group_a.size < 7 &&
    pokemons_from_group_b.size < 7
  end

  def pokemons_from_group_a
    pokemons.select { |p| p.trade_group == 1 }
  end

  def pokemons_from_group_b
    pokemons.select { |p| p.trade_group == 2 }
  end

  def group_a_experience
    pokemons_from_group_a.reduce(0) { |sum, p| sum + p.base_experience }
  end

  def group_b_experience
    pokemons_from_group_b.reduce(0) { |sum, p| sum + p.base_experience }
  end

  def fair?
    base_experience_difference <= 30
  end
end
