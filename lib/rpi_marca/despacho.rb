module RpiMarca
  class Despacho
    attr_reader :codigo, :descricao, :receipt, :complemento,
                :complementary_receipts

    # 850130127025 de 02/07/2013, 850130131596 de 08/07/2013
    PROTOCOLOS_TEXTO_COMPL = %r{
      (?<receipt>[0-9]{12,})            # 850130127025
      \s                                  # espaço
      de
      \s
      (?<data>[0-9]{2}/[0-9]{2}/[0-9]{4}) # 02/07/2013
    }x

    def initialize(codigo:, descricao:, complemento:, receipt:)
      @codigo = codigo or fail ParseError
      @descricao = descricao or fail ParseError
      @complemento = complemento
      @receipt = receipt
      @complementary_receipts = []

      parse_texto_complementar if @complemento
    end

    def self.parse(el)
      codigo = Helpers.get_attribute_value(el, 'codigo')

      new(
        codigo: codigo,
        descricao: Helpers.get_attribute_value(el, 'nome'),
        receipt: Receipt.parse(el.at_xpath('protocolo'), codigo),
        complemento: Helpers.get_element_value(
          el.at_xpath('texto-complementar')
        )
      )
    end

    private

    def parse_texto_complementar
      @complementary_receipts =
        @complemento.scan(PROTOCOLOS_TEXTO_COMPL).map do |number, date|
          Receipt.new(
            number: number,
            date: Helpers.parse_date(date)
          )
        end
    end
  end
end
