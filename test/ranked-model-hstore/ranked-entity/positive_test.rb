describe 'RankedEntity - positive senario' do
  let(:collection_one) { 1 }
  let(:position_one) { 12345 }
  let(:collections_ids) { [collection_one] }
  let(:collections_positions_hash) { {collection_one => position_one} }

  describe 'HStore - Hash conversion' do
    let(:collection_two) { 2 }
    let(:position_two) { nil }
    let(:entity) do
      RankedEntity.create(
        collections_ids: collections_ids,
        collections_positions_hash: collections_positions_hash
      )
    end

    it 'should convert Integer to String' do
      assert_equal ({collection_one.to_s => position_one.to_s}), entity.collections_positions
    end

    it 'should convert String to Integer' do
      entity.collections_positions = ({collection_one.to_s => position_one.to_s})

      assert_equal ({collection_one => position_one}), entity.collections_positions_hash
    end

    it 'should convert nil to NULL' do
      entity.collections_positions_hash = ({collection_two => position_two})

      assert_equal ({collection_two.to_s => 'NULL'}), entity.collections_positions
    end

    it 'should convert NULL to nil' do
      entity.collections_positions = ({collection_two.to_s => 'NULL'})

      assert_equal ({collection_two => nil}), entity.collections_positions_hash
    end
  end

  it 'should save regular attributes' do
    refute_nil RankedEntity.create(
      name: 'first',
      collections_ids: collections_ids,
      collections_positions_hash: collections_positions_hash
    )
  end

  it 'should save ranked attributes' do
    refute_nil RankedEntity.create(
      collections_ids: collections_ids,
      collections_positions_hash: collections_positions_hash
    )
  end

  it 'should respond to #ranker' do
    refute_nil RankedEntity.ranker(:collection)
  end

  # it 'should respond on #rank_in_category' do
  # end

  it 'should respond on #position_in_collection' do
    entity = RankedEntity.create(
      collections_ids: collections_ids,
      collections_positions_hash: collections_positions_hash
    )
    assert_equal entity.position_in_collection(collection_one), position_one
  end

  # it 'should set given rank' do
  #
  # end
  #
  # it 'should set random rank' do
  #
  # end
end
