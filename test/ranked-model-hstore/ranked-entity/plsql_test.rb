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

end