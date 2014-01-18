Spree::Admin::ResourceController.class_eval do
  def load_resource
    if member_action?
      @object ||= load_resource_instance

      # call authorize! a third time (called twice already in Admin::BaseController)
      # this time we pass the actual instance so fine-grained abilities can control
      # access to individual records, not just entire models.
      if @object.present?
        authorize! params[:action], @object
      elsif model_class.present?
        authorize! params[:action], model_class 
      end

      instance_variable_set("@#{object_name}", @object)
    else
      @collection ||= collection

      # note: we don't call authorize here as the collection method should use
      # CanCan's accessible_by method to restrict the actual records returned

      instance_variable_set("@#{controller_name}", @collection)
    end
  end
end

