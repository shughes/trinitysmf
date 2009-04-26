class ItemController < ApplicationController
  wsdl_service_name 'Item'

  def add(name, value)
		Item.create(:name => name, :value => value).id
  end

  def edit(id, name, value)
		Item.find(id).update_attributes(:name => name, :value => value)
  end

  def fetch(id)
		Item.find(id)
  end
end
