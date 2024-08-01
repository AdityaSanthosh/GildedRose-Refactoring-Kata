# frozen_string_literal: true

class NormalItems
  attr_accessor :quality, :sell_in

  def initialize(quality, sell_in)
    @quality = quality
    @sell_in = sell_in
  end
  def update_quality
    return unless item.quality.positive? && item.quality <= 50
    item.quality -= (!item.sell_in.positive? ? 2 : 1)
  end
end

class AgedBrie
  attr_accessor :quality, :sell_in

  def initialize(quality, sell_in)
    @quality = quality
    @sell_in = sell_in
  end
  def update_quality
    return unless item.quality >= 0 && item.quality < 50
    item.quality += 1
  end
end

class Sulfuras
  attr_accessor :quality, :sell_in

  def initialize(quality, sell_in)
    @sell_in = sell_in
    @quality = quality
  end

  def update_quality
  end
end

class BackStagePasses
  attr_accessor :quality, :sell_in

  def initialize(quality, sell_in)
    @sell_in = sell_in
    @quality = quality
  end

  def update_quality
    return unless item.quality >= 0 && item.quality <= 50

    if !item.sell_in.positive?
      item.quality = 0
    elsif item.sell_in > 5 && item.sell_in < 11
      item.quality += 2
    elsif item.sell_in <= 5
      item.quality += 3
    else
      item.quality += 1
    end
  end
end

# module QualityDegradation
#   def self.normal_items(item)
#     return unless item.quality.positive? && item.quality <= 50
#
#     item.quality -= (!item.sell_in.positive? ? 2 : 1)
#   end
#
#   def self.aged_brie(item)
#     return unless item.quality >= 0 && item.quality < 50
#     item.quality += 1
#   end
#
#   def self.sulfuras(_item); end
#
#   def self.backstage_passes(item)
#     return unless item.quality >= 0 && item.quality <= 50
#
#     if !item.sell_in.positive?
#       item.quality = 0
#     elsif item.sell_in > 5 && item.sell_in < 11
#       item.quality += 2
#     elsif item.sell_in <= 5
#       item.quality += 3
#     else
#       item.quality += 1
#     end
#   end
# end

class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      case item.name
      when 'Aged Brie'
        AgedBrie.new(item.quality, item.sell_in)
      when 'Backstage passes to a TAFKAL80ETC concert'
        BackStagePasses.new(item.quality, item.sell_in)
      when 'Sulfuras, Hand of Ragnaros'
        Sulfuras.new(item.quality, item.sell_in)
      else
        NormalItems.new(item.quality, item.sell_in)
      end
    end
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
