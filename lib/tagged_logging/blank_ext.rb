#Copied from ActiveSupport
class Object
  # An object is blank if it's false, empty, or a whitespace string.
  # For example, "", "   ", +nil+, [], and {} are all blank.
  #
  # This simplifies:
  #
  #   if address.nil? || address.empty?
  #
  # ...to:
  #
  #   if address.blank?
  unless method_defined? :blank?
    def blank?
      respond_to?(:empty?) ? empty? : !self
    end
  end
end

class NilClass
  # +nil+ is blank:
  #
  #   nil.blank? # => true
  #
  unless method_defined? :blank?
    def blank?
      true
    end
  end
end

class FalseClass
  # +false+ is blank:
  #
  #   false.blank? # => true
  #
  unless method_defined? :blank?
    def blank?
      true
    end
  end
end

class TrueClass
  # +true+ is not blank:
  #
  #   true.blank? # => false
  #
  unless method_defined? :blank?
    def blank?
      false
    end
  end
end

class Array
  # An array is blank if it's empty:
  #
  #   [].blank?      # => true
  #   [1,2,3].blank? # => false
  #
  unless method_defined? :blank?
    alias_method :blank?, :empty?
  end
end

class Hash
  # A hash is blank if it's empty:
  #
  #   {}.blank?                # => true
  #   {:key => 'value'}.blank? # => false
  #
  unless method_defined? :blank?
    alias_method :blank?, :empty?
  end
end

class String
  if defined?(Encoding) && "".respond_to?(:encode)
    def encoding_aware?
      true
    end
  else
    def encoding_aware?
      false
    end
  end
  # 0x3000: fullwidth whitespace
  NON_WHITESPACE_REGEXP = %r![^\s#{[0x3000].pack("U")}]!

  # A string is blank if it's empty or contains whitespaces only:
  #
  #   "".blank?                 # => true
  #   "   ".blank?              # => true
  #   "　".blank?               # => true
  #   " something here ".blank? # => false
  #
  def blank?
    # 1.8 does not takes [:space:] properly
    if encoding_aware?
      self !~ /[^[:space:]]/
    else
      self !~ NON_WHITESPACE_REGEXP
    end
  end
end

class Numeric #:nodoc:
  # No number is blank:
  #
  #   1.blank? # => false
  #   0.blank? # => false
  #
  unless method_defined? :blank?
    def blank?
      false
    end
  end
end
