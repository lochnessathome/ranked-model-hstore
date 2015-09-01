describe 'PlSql - positive scenario' do
  let(:collection_one) { 1 }
  let(:position_one) { 12345 }
  let(:collections_ids) { [collection_one] }
  let(:collections_positions_hash) { {collection_one => position_one} }

  describe 'func_latest_position()' do
    let(:func_name) { 'latest_position_in_collection_at_ranked_entities' }

    it 'should return position number for existent collection' do
      entity = RankedEntity.create(
        collections_ids: collections_ids,
        collections_positions_hash: collections_positions_hash
      )

      result = ActiveRecord::Base.connection.execute("select #{func_name}('#{collection_one}');")

      refute_nil result.first
      assert_equal position_one, result.first[func_name].to_i
    end

    it 'should return nil for non-existent collection' do
      entity = RankedEntity.create(
        collections_ids: collections_ids,
        collections_positions_hash: collections_positions_hash
      )

      result = ActiveRecord::Base.connection.execute("select #{func_name}('#{collection_one + 1}');")

      refute_nil result.first
      assert_nil result.first[func_name]
    end
  end

  describe 'func_count_items()' do
    let(:func_name) { 'count_items_in_collection_at_ranked_entities' }

    it 'should return positions count for existent collection' do
      entity = RankedEntity.create(
        collections_ids: collections_ids,
        collections_positions_hash: collections_positions_hash
      )

      result = ActiveRecord::Base.connection.execute("select #{func_name}('#{collection_one}');")

      refute_nil result.first
      assert_equal '1', result.first[func_name].to_s
    end

    it 'should return zero for non-existent collection' do
      entity = RankedEntity.create(
        collections_ids: collections_ids,
        collections_positions_hash: collections_positions_hash
      )

      result = ActiveRecord::Base.connection.execute("select #{func_name}('#{collection_one + 1}');")

      refute_nil result.first
      assert_equal '0', result.first[func_name].to_s
    end
  end

  describe 'func_generate_sequence()' do
    let(:func_name) { 'generate_sequence_for_collection_at_ranked_entities' }
    let(:collection_three) { 3 }
    let(:sequence_one) { 'collection_1_at_ranked_entities_seq' }
    let(:sequence_three) { 'collection_3_at_ranked_entities_seq' }

    it 'should create sequence for collection' do
      result_one = ActiveRecord::Base.connection.execute("select #{func_name}('#{collection_one}');")
      result_three = ActiveRecord::Base.connection.execute("select #{func_name}('#{collection_three}');")

      refute_nil result_one.first
      refute_nil result_three.first

      assert_equal sequence_one, result_one.first[func_name].to_s
      assert_equal sequence_three, result_three.first[func_name].to_s
    end

    it 'should return increasing nextval()' do
      ActiveRecord::Base.connection.execute("select #{func_name}('#{collection_one}');")

      step_one = ActiveRecord::Base.connection.execute("select nextval('#{sequence_one}');")
      step_two = ActiveRecord::Base.connection.execute("select nextval('#{sequence_one}');")

      assert_operator step_one.first["nextval"].to_i, :<, step_two.first["nextval"].to_i
    end
  end

  describe 'func_generate_position()' do
    let(:func_name) { 'generate_position_in_collection_at_ranked_entities' }
    let(:func_seq_name) { 'generate_sequence_for_collection_at_ranked_entities' }
    let(:collection_four) { 4 }
    let(:collection_five) { 5 }
    let(:sequence_four) { 'collection_4_at_ranked_entities_seq' }
    let(:sequence_five) { 'collection_5_at_ranked_entities_seq' }

    it 'should replace NULL with a number' do
      ActiveRecord::Base.connection.execute("select #{func_seq_name}('#{collection_four}');")

      entity = RankedEntity.new(
        collections_ids: [collection_four],
        collections_positions_hash: {collection_four => nil}
      )
      entity.save
      entity.reload

      refute_nil entity.collections_positions_hash[collection_four]
    end

    it 'should get separate counters for different collections' do
      ActiveRecord::Base.connection.execute("select #{func_seq_name}('#{collection_four}');")
      ActiveRecord::Base.connection.execute("select #{func_seq_name}('#{collection_five}');")

      entity_four = RankedEntity.new(
        collections_ids: [collection_four, collection_five],
        collections_positions_hash: {collection_four => nil, collection_five => nil}
      )
      entity_four.save
      entity_four.reload

      entity_five = RankedEntity.new(
        collections_ids: [collection_five],
        collections_positions_hash: {collection_five => nil}
      )
      entity_five.save
      entity_five.reload

      refute_equal entity_four.collections_positions_hash[collection_five], entity_five.collections_positions_hash[collection_five]
    end
  end
end
