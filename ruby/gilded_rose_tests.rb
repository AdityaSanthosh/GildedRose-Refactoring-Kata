# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'gilded_rose'

class TestGildedRose < Minitest::Test
  def test_quality_degradation_for_normal_items_everyday
    items = [Item.new('foo', 10, 20)]
    GildedRose.new(items).update_quality
    assert_equal 19, items[0].quality
  end

  def test_quality_degradation_per_day_for_normal_items_past_sellin_date
    items = [Item.new('foo', 0, 10)]
    GildedRose.new(items).update_quality
    assert_equal 8, items[0].quality
  end

  def test_positive_only_quality_for_all_items
    sellin_days = 10
    items = [Item.new('foo', 10, 2), Item.new('Aged Brie', 1, 1)]
    sellin_days.times do
      GildedRose.new(items).update_quality
    end
    assert_equal 0, items[0].quality
  end

  def test_aged_brie_quality_increase
    items = [Item.new('Aged Brie', 1, 44)]
    GildedRose.new(items).update_quality
    assert_equal 45, items[0].quality
  end

  def test_updated_quality_less_than_50_for_all_items
    items = [Item.new('Aged Brie', 1, 44), Item.new('Aged Brie', -1,50), Item.new('foo', 10, 2), Item.new('foo', -1, 47)]
    GildedRose.new(items).update_quality
    failed_items = items.select { |item| item.quality > 50 }
    assert_empty failed_items
  end

  def test_constant_sulfuras_quality
    original_quality = 80
    items = [Item.new('Sulfuras, Hand of Ragnaros', 1, original_quality)]
    GildedRose.new(items).update_quality
    assert_equal original_quality, items[0].quality
  end

  def test_backstage_passes_quality_increases_by_2_when_sellin_days_between_6_and_10
    # [6,10]
    item_name = 'Backstage passes to a TAFKAL80ETC concert'
    items = [Item.new(item_name, 10, 10), Item.new(item_name, 6, 4)]
    GildedRose.new(items).update_quality
    assert_equal 12, items[0].quality
    assert_equal 6, items[1].quality
  end
  def test_backstage_passes_quality_becomes_zero_after_the_concert
    items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 0, 10)]
    GildedRose.new(items).update_quality
    assert_equal 0, items[0].quality
  end
  def test_backstage_passes_quality_increases_by_3_less_than_5_days_to_concert
    items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 1, 10),Item.new('Backstage passes to a TAFKAL80ETC concert', 5, 0)]
    GildedRose.new(items).update_quality
    assert_equal 13, items[0].quality
    assert_equal 3, items[1].quality
  end

  def test_backstage_passes_quality_increases_by_1_default
    items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 100, 10)]
    GildedRose.new(items).update_quality
    assert_equal items[0].quality, 11
  end
end
