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
end
