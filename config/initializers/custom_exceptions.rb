module CustomExceptions
  class NotEnoughParams < StandardError
    def message
      I18n.t(:not_enough_parameters)
    end
  end
end