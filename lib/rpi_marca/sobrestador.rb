module RpiMarca
  class Sobrestador
    attr_reader :processo, :marca

    def initialize(processo:, marca:)
      @processo = processo
      @marca = marca
    end

    def self.parse(el)
      return unless el

      new(
        processo: Helpers.get_attribute_value(el, "processo"),
        marca: Helpers.get_attribute_value(el, "marca")
      )
    end
  end
end
