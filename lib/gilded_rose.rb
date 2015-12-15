def update_quality(items)
  items.each do |item|
    if item.name == 'Aged Brie' || item.name == 'Backstage passes to a TAFKAL80ETC concert'
      # handle items that increase in quality as time goes on
      if item.quality < 50
        item.quality += 1
        if item.name == 'Backstage passes to a TAFKAL80ETC concert'
          if item.quality < 50
            if item.sell_in < 11
              item.quality += 1
            end
            if item.sell_in < 6
              item.quality += 1
            end
          end
        end
      end
    else
      # handle items that decrease in quality as time goes on
      if item.quality > 0 && !legendary?(item)
        item.quality -= 1
      end
    end

    # update days in time
    unless legendary? item
      item.sell_in -= 1
    end

    # handle items that have expired
    if item.sell_in < 0
      if item.name == "Aged Brie"
        if item.quality < 50
          item.quality += 1
        end
      else
        if item.name != 'Backstage passes to a TAFKAL80ETC concert'
          if item.quality > 0
            unless legendary? item
              item.quality -= 1
            end
          end
        else
          item.quality = item.quality - item.quality
        end
      end
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
