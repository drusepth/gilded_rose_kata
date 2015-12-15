def update_quality(items)
  items.each do |item|
    if aged? item
      # handle items that increase in quality as time goes on
      item.quality += degradation_with_modification(item, 1)

      # handle backstage passes with their wonderful logic
      if backstage_passes? item
        if item.sell_in < 11
          item.quality += degradation_with_modification(item, 1)
        end
        if item.sell_in < 6
          item.quality += degradation_with_modification(item, 1)
        end
      end
    else
      # handle items that decrease in quality as time goes on
      item.quality += degradation_with_modification(item, -1)
    end

    # update days until expiration date
    item.sell_in -= 1 unless legendary? item

    # handle item expiration quality updates
    if item.sell_in < 0
      case item.name
      when 'Aged Brie'
        item.quality += degradation_with_modification(item, 1)
      when 'Backstage passes to a TAFKAL80ETC concert'
        item.quality = 0
      else
        item.quality += degradation_with_modification(item, -1)
      end
    end

    # limit item to quality boundaries unless it's a legendary item
    unless legendary? item
      item.quality = [item.quality, 50].min
      item.quality = [0, item.quality].max
    end
  end
end

def legendary?(item)
  legendary_items = ['Sulfuras, Hand of Ragnaros']
  legendary_items.include? item.name
end

def aged?(item)
  aged_items = ['Backstage passes to a TAFKAL80ETC concert', 'Aged Brie']
  aged_items.include? item.name
end

def backstage_passes?(item)
  passes = ['Backstage passes to a TAFKAL80ETC concert']
  passes.include? item.name
end

def conjured?(item)
  item.name.start_with? 'Conjured'
end

def degradation_with_modification(item, amount)
  amount *= 2 if conjured?  item
  amount *= 0 if legendary? item
  amount
end


# DO NOT CHANGE THINGS BELOW -----------------------------------------

Item = Struct.new(:name, :sell_in, :quality)

# We use the setup in the spec rather than the following for testing.
#
# Items = [
#   Item.new("+5 Dexterity Vest", 10, 20),
#   Item.new("Aged Brie", 2, 0),
#   Item.new("Elixir of the Mongoose", 5, 7),
#   Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
#   Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
#   Item.new("Conjured Mana Cake", 3, 6),
# ]
