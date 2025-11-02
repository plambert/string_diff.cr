# Find the shortest sequence of edits to get from A to B

require "colorize"
require "./colorize"
require "./op_type"
require "./op_token"
require "./array2d"

class StringDiff
  VERSION = "0.1.0"

  getter first : String
  getter second : String
  getter ops : Array(OpToken)
  getter? include_copy : Bool
  getter? optimize : Bool

  # ameba:disable Metrics/CyclomaticComplexity
  def initialize(@first, @second, @include_copy = false, @optimize = true)
    @ops = [] of OpToken
    simple_ops = [] of OpToken

    return simple_ops if @first == @second

    first_size = @first.size
    second_size = @second.size
    width = first_size + 1
    height = second_size + 1
    table = Array2D(Int32).new(width: width, height: height, default: -1)
    width.times do |x|
      table[x, 0] = x
    end
    height.times do |y|
      table[0, y] = y
    end

    (1..first_size).each do |x|
      (1..second_size).each do |y|
        if @first[x - 1] == @second[y - 1]
          table[x, y] = table[x - 1, y - 1]
        else
          rep = table[x - 1, y - 1] + 1
          del = table[x, y - 1] + 1
          ins = table[x - 1, y] + 1
          table[x, y] = {rep, del, ins}.min
        end
      end
    end

    x = first_size
    y = second_size
    while x > 0 || y > 0
      if x > 0 && y > 0 && first[x - 1] == second[y - 1]
        simple_ops << OpToken.new op: OpType::Copy, text: @second[y - 1, 1] if include_copy?
        x -= 1
        y -= 1
      elsif x > 0 && y > 0 && table[x, y] == table[x - 1, y - 1] + 1
        simple_ops << OpToken.new op: OpType::Replace, rep: @first[x - 1, 1], text: @second[y - 1, 1]
        x -= 1
        y -= 1
      elsif y > 0 && table[x, y] == table[x, y - 1] + 1
        simple_ops << OpToken.new op: OpType::Insert, text: second[y - 1, 1]
        y -= 1
      elsif x > 0 && table[x, y] == table[x - 1, y] + 1
        simple_ops << OpToken.new op: OpType::Delete, text: first[x - 1, 1]
        x -= 1
      end
    end

    if optimize?
      simple_ops.reverse!
      last = simple_ops.shift

      simple_ops.each do |entry|
        if entry.op == last.op
          last = OpToken.new op: entry.op, rep: last.rep + entry.rep, text: last.text + entry.text
        elsif entry.op.replace? && last.op.insert?
          last = OpToken.new op: entry.op, rep: last.rep + entry.rep, text: last.text + entry.text
        else
          @ops << last
          last = entry
        end
      end
      @ops << last
    else
      @ops = simple_ops.reverse!
    end
  end

  def each(&block)
    @ops.each(&block)
  end

  def to_s(io, *, enable_color : Bool? = nil)
    diffs = Diff.new(from, to).ops

    Colorize.with enable_color do
      io << "- "
      diffs.each do |entry|
        case entry.op
        in .copy?
          io << entry.text
        in .insert?
          # do nothing
        in .delete?
          io << entry.text.colorize.back(0x3f, 0, 0).fore(:red).bold
        in .replace?
          io << entry.rep.colorize.back(0x3f, 0x00, 0x00).fore(:red).bold
        end
      end
      io << '\n'

      io << "+ "
      diffs.each do |entry|
        case entry.op
        in .copy?
          io << entry.text
        in .insert?, .replace?
          io << entry.text.colorize.back(0x00, 0x1f, 0x00).fore(0x00, 0xff, 0x00).bold
        in .delete?
        end
      end
      io << '\n'
    end
  end
end
