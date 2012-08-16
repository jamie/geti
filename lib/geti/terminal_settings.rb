require 'ostruct'

class Geti::TerminalSettings < OpenStruct
  def initialize(attributes)
    super(attributes[:terminal_settings])
  end

  
end
