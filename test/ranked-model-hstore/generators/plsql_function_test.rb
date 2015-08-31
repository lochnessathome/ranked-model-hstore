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

    it 'should raise with invalid options' do
      assert_raises(NoMethodError) { FuncLatestPosition.new({}) }
    end

    it 'should get body, name and fullname with valid options' do
      function = FuncLatestPosition.new(options)
      refute_empty function.body
      refute_empty function.name
      refute_empty function.fullname
    end

    it 'should be equal to PlSql#func_latest_position' do
      plsql = PlSql.func_latest_position(
        options.table_name,
        options.collection_name,
        options.positions_column
      )
      function = FuncLatestPosition.new(options)

      assert_equal function.body, plsql["body"]
      assert_equal function.fullname, plsql["fullname"]
      assert_equal function.name, plsql["name"]
    end
  end

  describe 'FuncCountItems' do
    let(:options) do
      object = mock()
      object.stubs(:table_name).returns('entities')
      object.stubs(:collection_name).returns('collection')
      object.stubs(:positions_column).returns('collections_positions')
      object
    end

    it 'should get function hash with valid options' do
      refute_nil FuncCountItems.new(options)
    end

    it 'should raise with invalid options' do
      assert_raises(NoMethodError) { FuncCountItems.new({}) }
    end

    it 'should get body, name and fullname with valid options' do
      function = FuncCountItems.new(options)
      refute_empty function.body
      refute_empty function.name
      refute_empty function.fullname
    end

    it 'should be equal to PlSql#func_count_items' do
      plsql = PlSql.func_count_items(
        options.table_name,
        options.collection_name,
        options.positions_column
      )
      function = FuncCountItems.new(options)

      assert_equal function.body, plsql["body"]
      assert_equal function.fullname, plsql["fullname"]
      assert_equal function.name, plsql["name"]
    end
  end

  describe 'FuncGeneratePosition' do
    let(:options) do
      object = mock()
      object.stubs(:table_name).returns('entities')
      object.stubs(:collection_name).returns('collection')
      object.stubs(:positions_column).returns('collections_positions')
      object
    end

    # it 'should get function hash with valid options' do
    #   refute_nil FuncGeneratePosition.new(options)
    # end
  end

end
