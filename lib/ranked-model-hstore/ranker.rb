module RankedModelHstore

  class Ranker
    attr_accessor :name, :positions_column, :ids_column

    def initialize(name)
      self.name = name.to_sym
      self.positions_column = "#{name.to_s.pluralize}_positions"
      self.ids_column = "#{name.to_s.pluralize}_ids"
    end

    def with(instance)
      Mapper.new(self, instance)
    end

    class Mapper
      attr_accessor :ranker, :instance

      def initialize(ranker, instance)
        self.ranker   = ranker
        self.instance = instance
      end

      def handle_ranking
        ids = instance.send(ranker.ids_column)
        positions = instance.send(ranker.positions_column)

        true
        # rank_at(rand(RankedModelHstore::MIN_RANK_VALUE..RankedModelHstore::MAX_RANK_VALUE))
      end

      private

      def rank_at(value)
        # instance.send "#{ranker.column}=", value
      end
    end

  end

end
