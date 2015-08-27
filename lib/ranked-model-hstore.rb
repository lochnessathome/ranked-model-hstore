require 'ranked-model-hstore/ranker'
require 'ranked-model-hstore/version'

module RankedModelHstore
  # Ruby Fixnum limits
  #
  # MIN_RANK_VALUE = -2305843009213693952
  # MAX_RANK_VALUE = 2305843009213693952

  # Pg Integer limits
  #
  MIN_RANK_VALUE = -2147483648
  MAX_RANK_VALUE = 2147483647


  def self.included base
    base.class_eval do
      class_attribute :rankers

      extend RankedModelHstore::ClassMethods

      before_save :handle_ranking

      scope :rank, lambda { |name| order ranker(name.to_sym).column }
    end
  end

  private

  def handle_ranking
    self.class.rankers.each do |ranker|
      ranker.with(self).handle_ranking
    end
  end

  module ClassMethods

    def ranker(name)
      rankers.find do |ranker|
        ranker.name == name
      end
    end

    private

    def ranks(*args)
      self.rankers ||= []
      ranker = RankedModelHstore::Ranker.new(*args)
      self.rankers << ranker
      attr_reader "#{ranker.name}_position"
      define_method "#{ranker.name}_position=" do |position|
        if position.present?
          send "#{ranker.column}_will_change!"
          instance_variable_set "@#{ranker.name}_position", position
        end
      end

      public "#{ranker.name}_position", "#{ranker.name}_position="
    end

  end
end
