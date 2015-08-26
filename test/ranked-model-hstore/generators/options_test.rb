require 'test_helper'

describe 'Options - positive senario' do
  # Model Entity already migrated

  let(:options) do
    Options.new('Entity', 'row')
  end

  it 'should be' do
    refute_nil options
  end

  it 'should respond on #model' do
    refute_nil options.send(:model)
  end

  it 'should detect model class' do
    assert_equal options.send(:model), Entity
  end

  it 'should respond on #table_name' do
    refute_nil options.table_name
  end

  it 'should detect table_name' do
    assert_equal options.table_name, 'entities'
  end

  it 'should respond on #valid?' do
    refute_nil options.valid?
  end

  it 'should be valid' do
    assert_equal options.valid?, true
  end
end

describe 'Options - negative senario' do

  describe 'bad model' do
    let(:options) do
      Options.new('Neverland', 'row')
    end

    it 'should be' do
      refute_nil options
    end

    it 'should respond on #valid?' do
      refute_nil options.valid?
    end

    it 'should not be valid' do
      assert_equal options.valid?, false
    end

    it 'should return nil on #model' do
      assert_equal options.send(:model), nil
    end

    it 'should return nil on #table_name' do
      assert_equal options.table_name, nil
    end
  end

  describe 'column already present' do
    let(:options) do
      Options.new('Entity', 'name')
    end

    it 'should be' do
      refute_nil options
    end

    it 'should respond on #valid?' do
      refute_nil options.valid?
    end

    it 'should not be valid' do
      assert_equal options.valid?, false
    end

    it 'should return true on #column_exists?' do
      assert_equal options.send(:column_exists?), true
    end
  end
end
