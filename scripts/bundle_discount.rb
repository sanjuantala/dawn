# Applies a 25% discount to items added from the bundle page
# when more than three qualifying items from the target collection are in the cart.

COLLECTION_ID = 1234567890 # Replace with the ID of the target collection

class BundleDiscount
  def run(cart)
    bundle_items = cart.line_items.select do |line_item|
      line_item.product.collections.map(&:id).include?(COLLECTION_ID) &&
        line_item.properties['added_from'] == 'bundle'
    end

    total_qty = bundle_items.map(&:quantity).reduce(0, :+)
    return if total_qty <= 3

    bundle_items.each do |line_item|
      line_item.change_line_price(line_item.line_price * 0.75, message: 'Bundle discount')
    end
  end
end

campaign = BundleDiscount.new
campaign.run(Input.cart)
Output.cart = Input.cart
