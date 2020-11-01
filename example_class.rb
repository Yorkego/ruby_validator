require './ruby_validator'

class User; end

class ExampleClass
  include RubyValidator

  def initialize(attributes)
    @name = attributes[:name]
    @number = attributes[:number]
    @owner = attributes[:owner]
  end

  validate :name, presence: true
  validate :number, format: /A-Z{0,3}/
  validate :owner, type: User

  attr_accessor :name, :number, :owner
end

o = ExampleClass.new(name: 'test name', number: 'A-Z897', owner: User.new)
p o.valid?
p o.validate!
