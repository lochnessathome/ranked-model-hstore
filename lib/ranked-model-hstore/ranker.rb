module RankedModelHstore

  class Ranker
    attr_accessor :name, :column

    def initialize(name)
      self.name = name.to_sym
      self.column = name
      # consociation
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
        rank_at(rand(RankedModelHstore::MIN_RANK_VALUE..RankedModelHstore::MAX_RANK_VALUE))
      end

      private

      def rank_at(value)
        instance.send "#{ranker.column}=", value
      end
    end

  end

end
