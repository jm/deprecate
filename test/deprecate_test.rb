require 'test_helper'

class DeprecateTest < Test::Unit::TestCase  
  def test_deprecate
    assert_raises(DeprecatedError) do
      deprecate "things" do
        # wat
      end
    end
  end
  
  def test_raises_when_deprecated
    assert_raises(DeprecatedError) do
      deprecate "things", :when => proc { true } do
        # wat
      end
    end
  end
  
  def test_version_equal_deprecate
    assert_raises(DeprecatedError) do
      deprecate "things", :version => "1.0" do
        # wat
      end
    end
  end
  
  def test_version_not_equal_deprecate    
    assert_nothing_raised do
      deprecate "things", :version => "1.3" do
        # wat
      end
    end
  end
  
  def test_version_greater_deprecate
    assert_raises(DeprecatedError) do
      deprecate "things", :version => greater_than("0.5") do
        # wat
      end
    end
  end
  
  def test_version_greater_not_deprecate
    assert_nothing_raised do
      deprecate "things", :version => greater_than("2.5") do
        # wat
      end
    end
  end
  
  def test_when_deprecate
    assert_raises(DeprecatedError) do
      deprecate "things", :when => proc { true } do
        # wat
      end
    end
  end
  
  def test_when_not_deprecate
    assert_nothing_raised do
      deprecate "things", :when => proc { false } do
        # wat
      end
    end
  end
  
  def test_after_deprecate
    assert_raises(DeprecatedError) do
      deprecate "things", :after => "July 19, 2008" do
        # wat
      end
    end
  end
  
  def test_after_not_deprecate
    assert_nothing_raised do
      deprecate "things", :after => "July 19, 2020" do
        # wat
      end
    end
  end
  
  def test_block_is_properly_executed
    @thing = "hello"
    
    deprecate "things", :after => "July 19, 2020" do
      assert @thing
    end
  end
end
