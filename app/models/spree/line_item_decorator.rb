Spree::LineItem.class_eval do
  def to_conekta
    {
      'name'        => variant.name,
      'description' => variant.description,
      'sku'         => variant.sku,
      'unit_price'  => variant.price.to_s,
      'quantity'    => quantity
    }
  end
end
