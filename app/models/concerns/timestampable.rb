module Timestampable
  extend ActiveSupport::Concern

  included do
    extend ClassMethods
  end

  module ClassMethods
    def last_timestamp
      reorder('created_at DESC').limit(1).first.created_at
    end
  end
end