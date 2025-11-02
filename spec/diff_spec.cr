require "./spec_helper"

describe StringDiff do
  it "does nothing for identical strings" do
    str = "foo"
    diff = StringDiff.new(str, str)
    diff.ops.size.should eq 0
  end

  it "can handle a single addition" do
    str1 = "foo"
    str2 = "fofo"
    diff = StringDiff.new(str1, str2)
    # pp diff.ops
    diff.ops.size.should eq 1
    diff.ops.map(&.op.to_s).should eq %w(Insert)

    diff_with_copy = StringDiff.new str1, str2, include_copy: true

    diff_with_copy.ops.size.should eq 3
    diff_with_copy.ops.map(&.op.to_s).should eq %w(Copy Insert Copy)
  end

  it "can handle complex diffs" do
    str1 = ""
    str2 = <<-END_OF_DECLARATION_OF_INDEPENDENCE
      When in the Course of human events, it becomes necessary
      for one people to dissolve the political bands which have
      connected them with another, and to assume among the powers
      of the earth, the separate and equal station to which the
      Laws of Nature and of Nature's God entitle them, a decent
      respect to the opinions of mankind requires that they
      should declare the causes which impel them to the
      separation.
      END_OF_DECLARATION_OF_INDEPENDENCE

    diff = StringDiff.new str1, str2, include_copy: true, optimize: false
  end
end
