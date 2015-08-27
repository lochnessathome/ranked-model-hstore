require 'test_helper'

describe 'TemplateProcessor' do
  let(:options) do
    object = mock()
    object.stubs(:model_name).returns('Entity')
    object.stubs(:table_name).returns('entities')
    object.stubs(:column_name).returns('row')
    object
  end

  let(:template) do
    root_dir = File.expand_path(File.dirname(__FILE__) + '../../../../')
    migration_origin = File.join(root_dir, 'lib', 'generators', 'ranker', 'templates', Filesystem::ORIGIN)
    TemplateProcessor.new(migration_origin)
  end

  describe 'Positive senario' do
    it 'should be' do
      refute_nil template
    end

    it 'should respond on #perform' do
      refute_nil template.perform!(options)
    end

    it 'should perform source' do
      File.stubs(:read).returns('***')
      assert_equal template.perform!(options), true
    end
  end

  describe 'Negative scenario - FS problem' do
    it 'should not perform source' do
      File.stubs(:read).raises('Bad happens')
      assert_equal template.perform!(options), false
    end
  end

end
