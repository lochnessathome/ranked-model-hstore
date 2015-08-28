require 'test_helper'

describe 'PlSqlFunction - positive senario' do

  describe 'FuncLatestPosition' do
    let(:options) do
      object = mock()
      object.stubs(:table_name).returns('entities')
      object.stubs(:collection_name).returns('collection')
      object.stubs(:positions_column).returns('collections_positions')
      object
    end

    it 'should get function hash with valid options' do
      refute_nil FuncLatestPosition.new(options)
    end

    it 'should get body, name and fullname with valid options' do
      function = FuncLatestPosition.new(options)
      refute_empty function.body
      refute_empty function.name
      refute_empty function.fullname
    end

    it 'should raise with invalid options' do
      assert_raises(NoMethodError) { FuncLatestPosition.new({}) }
    end
  end

end
