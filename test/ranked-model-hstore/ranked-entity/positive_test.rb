describe 'RankedEntity - positive senario' do
  it 'should create new objects' do
    refute_nil RankedEntity.create
  end

  it 'should save regular attributes' do
    refute_nil RankedEntity.create(name: 'first')
  end

  it 'should save ranked attributes' do
    refute_nil RankedEntity.create(row: 11223344)
  end

  it 'should respond to #ranker' do
    refute_nil RankedEntity.ranker(:row)
  end
end
