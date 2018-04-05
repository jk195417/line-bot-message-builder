# abstract class
module Line
  module Bot
    module MessageBuilder
      class Base
        attr_accessor :type

        def initialize(type)
          @type = type
          yield
          verify_required
        end

        def self.required
          {
            'type' => String
          }
        end

        def to_h
          result = {}
          instance_values.each do |key, value|
            snake_case_key = key.gsub(/([a-z\d])([A-Z])/, '\1_\2').tr('-', '_').downcase
            result[snake_case_key] = value unless value.nil?
          end
          result
        end

        private

        def instance_values
          Hash[instance_variables.map { |name| [name[1..-1], instance_variable_get(name)] }]
        end

        def verify_required
          self.class.required.each { |key, value| verify_instance_value_type key, value }
        end

        def verify_instance_value_type(name, type)
          raise TypeError, "@#{name}: #{instance_values[name]}, expect to be #{type}" unless instance_values[name].is_a? type
        end
      end
    end
  end
end
