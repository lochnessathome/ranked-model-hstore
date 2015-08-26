require 'test_helper'

describe 'Filesystem - positive senario' do
  let(:fs) do
    Filesystem.any_instance.stubs(:clear_dir!).returns(false)
    root_dir = File.expand_path(File.dirname(__FILE__) + '../../../../')
    fs = Filesystem.new Options.new('Entity', 'row')
    fs.instance_variable_set(:@root_dir, root_dir)
    fs
  end

  it 'should be' do
    refute_nil fs
  end

  it 'should respond on #filename' do
    refute_nil fs.filename
  end

  it 'should respond on #migration_origin' do
    refute_nil fs.migration_origin
  end

  it 'should respond on #migration_target' do
    refute_nil fs.migration_target
  end

  it 'should return timestamp of 14-digit format' do
    assert_match /\d{14}/, fs.send(:migration_timestamp)
  end

  it 'should define ORIGIN' do
    refute_nil Filesystem::ORIGIN
  end

  it 'should return filename with known data' do
    assert_equal fs.filename, "#{fs.send(:migration_timestamp)}_add_ranker_row_to_entities.rb"
  end

  it 'should store data' do
    File.expects(:open).returns(true)
    assert_equal fs.store('***'), true
  end
end

describe 'Filesystem - negative senario' do
  let(:fs) do
    Filesystem.any_instance.stubs(:clear_dir!).returns(false)
    root_dir = File.expand_path(File.dirname(__FILE__) + '../../../../')
    fs = Filesystem.new Options.new('Entity', 'row')
    fs.instance_variable_set(:@root_dir, root_dir)
    fs
  end

  describe 'FS problem' do
    it 'should not store data' do
      File.expects(:open).raises('Bad happens')
      assert_equal fs.store('***'), false
    end
  end
end
