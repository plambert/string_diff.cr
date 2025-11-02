# A single operation in the sequence

class StringDiff
  record OpToken, op : OpType, rep : String, text : String do
    def self.new(op, text)
      new op: op, text: text, rep: ""
    end
  end
end
