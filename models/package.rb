
class Package
  attr_accessor :package_id, :order_id

  def initialize(package_id, order_id)
    @package_id = package_id
    @order_id = order_id
  end
end