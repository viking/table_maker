require 'helper'

class TestTableMaker < Test::Unit::TestCase
  def test_creates_simple_table_with_auto_id
    db = Sequel.connect("#{RUBY_PLATFORM == 'java' ? "jdbc:" : ""}sqlite::memory:")
    TableMaker.new(db, :foo, <<-EOF)
      +-------------+-------------+--------------+
      | foo(String) | bar(String) | baz(Integer) |
      +=============+=============+==============+
      | abc         | def         | 123          |
      | ghi         | jkl         | 456          |
      | mno         | pqr         | 789          |
      | stu         | vwx         | 000          |
      +-------------+-------------+--------------+
    EOF
    assert db.tables.include?(:foo)
    schema = db.schema(:foo)
    assert_equal [:id, :foo, :bar, :baz], schema.collect(&:first)
    assert_equal [:integer, :string, :string, :integer], schema.collect { |c| c[1][:type] }
    assert schema.assoc(:id)[1][:primary_key]

    ds = db[:foo]
    expected = [
      {:id => 1, :foo => 'abc', :bar => 'def', :baz => 123},
      {:id => 2, :foo => 'ghi', :bar => 'jkl', :baz => 456},
      {:id => 3, :foo => 'mno', :bar => 'pqr', :baz => 789},
      {:id => 4, :foo => 'stu', :bar => 'vwx', :baz => 000}
    ]
    assert_equal expected, ds.select(:id, :foo, :bar, :baz).order(:id).all
  end
end
