# frozen_string_literal: true

class Fuzz
  def initialize
    # TODO
  end
  # singleton
  @@instance = Fuzz.new

  def self.instance
    @@instance
  end

  def fuzz_uri(data, payloads)
    # TODO
  end

  def fuzz_json(data, _payloads)
    surf data, nil, nil
  end

  private

  def inject(value, tree, index)
    if tree.class.to_s.eql? 'Hash'
      temp_t = {}
      JSON.parse(tree).each do |pair|
        temp_t.store(pair[0], pair[1])
      end
    else
      temp_t = []
      temp_t = JSON.parse(tree).clone
    end
    @output = temp_t
    key = index.pop
    index.each do |point|
      temp_t = if point.class.to_s == 'Hash'
                 temp_t[point[:arr_index]]
               else
                 temp_t[point]
               end
    end
    temp_t[key] = value + '">123'

    # TODO: puts to return format
    puts @output.to_json
    puts ''
    puts ''
  end

  # query의 원본 포맷과 현재 inject 할 구간의 index
  def surf(data, tree, argin)
    tree = JSON.parse data if tree.nil?
    index = if argin.nil?
              []
            else
              argin.clone
            end
    case data.class.to_s
    when 'Hash'
      data.keys.each do |key|
        surf data[key], tree, (index.push key)
        index.pop
      end
    when 'Array'
      data.each_with_index do |arr, aindex|
        surf arr, tree, index.push("arr_index": aindex)
      end
    when 'Integer'
      # Injection point (may be..)
      # puts 'Live1'
    when 'String'
      case data[0]
      when '['
        surf (JSON.parse data), tree, nil
      when '{'
        surf (JSON.parse data), tree, nil
      else
        # Injection point
        inject data, tree.to_json, index
        # puts "index => "+index.to_s+" : "+data
        return 0
        # puts tree
      end
    else
      # not proc
    end
  end
end
