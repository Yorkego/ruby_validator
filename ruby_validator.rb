module RubyValidator
  class ValidationError < StandardError; end
  module ClassMethods
    def validators
      @validators ||= []
    end

    def validate(field, options)
      validators.push(field: field, options: options)
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end

  def validate!
    call_validation
  end

  def valid?
    call_validation(false)
  end

  private

  def call_validation(with_exeption = true)
    self.class.validators.each do |val|
      val[:options].each do |key, value|
        validate_result = send(key, val[:field], value)
        unless validate_result[:valid?]
          if with_exeption == true
            raise ValidationError, "#{val[:field]} #{validate_result[:errors]}"
          else
            return false
          end
        end
      end
    end
    true
  end

  def presence(field, value)
    return { valid?: true, errors: nil } unless send(field).nil? || send(field).empty?

    { valid?: false, errors: "can't be blank" }
  end

  def format(field, value)
    return { valid?: true, errors: nil } if send(field).nil? || send(field).match?(value)

    { valid?: false, errors: 'unexepted format'}
  end

  def type(field, value)
    return { valid?: true, errors: nil } if send(field).nil? || send(field).class == value

    { valid?: false, errors: 'unexepted type'}
  end
end
