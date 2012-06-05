module ActiveRecord
  class Base
    def is_liker?
      false
    end
  end
end

module Socialization
  module Liker
    extend ActiveSupport::Concern

    included do
      # Specifies if self can like {Likeable} objects.
      #
      # @return [Boolean]
      def is_liker?
        true
      end

      # Create a new {LikeStores like} relationship.
      #
      # @param [Likeable] likeable the object to be liked.
      # @return [Boolean]
      def like!(likeable)
        raise ArgumentError, "#{likeable} is not likeable!"  unless likeable.respond_to?(:is_likeable?) && likeable.is_likeable?
        Like.like!(self, likeable)
      end

      # Delete a {LikeStores like} relationship.
      #
      # @param [Likeable] likeable the object to unlike.
      # @return [Boolean]
      def unlike!(likeable)
        raise ArgumentError, "#{likeable} is not likeable!" unless likeable.respond_to?(:is_likeable?) && likeable.is_likeable?
        Like.unlike!(self, likeable)
      end

      # Toggles a {LikeStores like} relationship.
      #
      # @param [Likeable] likeable the object to like/unlike.
      # @return [Boolean]
      def toggle_like!(likeable)
        raise ArgumentError, "#{likeable} is not likeable!" unless likeable.respond_to?(:is_likeable?) && likeable.is_likeable?
        if likes?(likeable)
          unlike!(likeable)
          false
        else
          like!(likeable)
          true
        end
      end

      # Specifies if self likes a {Likeable} object.
      #
      # @param [Likeable] likeable the {Likeable} object to test against.
      # @return [Boolean]
      def likes?(likeable)
        raise ArgumentError, "#{likeable} is not likeable!" unless likeable.respond_to?(:is_likeable?) && likeable.is_likeable?
        Like.likes?(self, likeable)
      end

      # Returns all the likeables of a certain type that are liked by self
      #
      # @params [Likeable] klass the type of {Likeable} you want
      # @params [Hash] opts a hash of options
      # @return [Array<Likeable, Numeric>] An array of Likeable objects or IDs
      def likeables(klass, opts = {})
        Like.likeables(self, klass, opts)
      end

    end
  end
end
