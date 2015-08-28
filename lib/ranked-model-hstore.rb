require 'ranked-model-hstore/ranker'
require 'ranked-model-hstore/version'

module RankedModelHstore
  # Ruby Fixnum limits
  #
  # MIN_RANK_VALUE = -2305843009213693952
  # MAX_RANK_VALUE = 2305843009213693951

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

    def ranks(name)
      self.rankers ||= []
      ranker = RankedModelHstore::Ranker.new(name)
      self.rankers << ranker

      # collections_positions_hash is a way to deal with numbers,
      # when collections_positions provides only strings.

      store_accessor ranker.positions_column.to_sym, "#{ranker.positions_column}_hash".to_sym

      define_method "#{ranker.positions_column}_hash" do
        hash = {}
        self.send(ranker.positions_column).each_pair do |key, val|
          hash.merge!({key.to_i => val.to_i})
        end
        hash
      end

      define_method "#{ranker.positions_column}_hash=" do |positions|
        positions ||= {}
        hash = {}
        positions.each_pair do |key, val|
          hash.merge!({key.to_s => val.to_s})
        end

        self.send("#{ranker.positions_column}=", hash)
      end

      define_method "position_in_#{ranker.name}" do |collection_id|
        if collection_id.present?
          positions = self.send("#{ranker.positions_column}_hash")
          positions[collection_id]
        end
      end

      public "position_in_#{ranker.name}"
    end

  end
end
