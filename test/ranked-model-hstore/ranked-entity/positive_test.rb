describe 'RankedEntity - positive senario' do
  let(:collection_one) { 1 }
  let(:position_one) { 12345 }
  let(:collections_ids) { [collection_one] }
  let(:collections_positions_hash) { {collection_one => position_one} }

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
end
