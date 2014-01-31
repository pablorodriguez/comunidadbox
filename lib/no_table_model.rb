module NoTableModel
  class Base
    include ActiveModel::Conversion
    extend ActiveModel::Naming
    extend ActiveModel::Translation
    include ActiveModel::Validations
    include ActiveModel::AttributeMethods # 1) attribute methods behavior

    attribute_method_prefix 'clear_' # 2) clear_ is attribute prefix
    attribute_method_suffix '?'

    class_attribute :_attributes
    self._attributes = []

    def initialize(attributes = {})
      attributes.each do |attr, value|
      self.send("#{attr}=", value)
      end unless attributes.blank?
    end


    def self.attributes(*names)
      attr_accessor *names
      # 3) Ask to define the prefix methods for the given attributes names
      define_attribute_methods names
      self._attributes += names
    end

    def persisted?
      false
    end


    protected
    # 4) Since we declared a "clear_" prefix, it expects to have a
    # "clear_attribute" method defined, which receives an attribute
    # name and implements the clearing logic.
    def clear_attribute(attribute)
      self._attributes.inject({}) do |hash, attr|
        hash[attr.to_s] = send(attr)
        hash
      end
    end

    # 2) Implement the logic required by the '?' suffix
    def clear_attribute(attribute)
      send("#{attribute}=", nil)
    end

    def attribute?(attribute)
      send(attribute).present?
    end

  end
end