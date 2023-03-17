class Item
  attr_accessor :itemid, :name, :price, :ref, :package_id, :warranty, :duration

  def initialize(itemid, name, price, ref, package_id, warranty, duration)
    @itemid = itemid
    @name = name
    @price = price
    @ref = ref
    @package_id = package_id
    @warranty = warranty
    @duration = duration
  end
end