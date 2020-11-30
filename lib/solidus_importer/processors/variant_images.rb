# frozen_string_literal: true

require 'down'
require 'fileutils'

module SolidusImporter
  module Processors
    class VariantImages < Base
      def call(context)
        @data = context.fetch(:data)
        return unless variant_image?

        variant = context.fetch(:variant)
        process_images(variant)
      end

      private

      def process_images(product)
        tempfile = Down.download(@data['Variant Image'])
        attachment_path = "./#{tempfile.original_filename}"
        FileUtils.mv(tempfile.path, attachment_path)

        File.open(attachment_path) do |attachment|
          product.images << Spree::Image.new(attachment: attachment, alt: @data['Alt Text'])
        end

        File.delete(attachment_path)
      end

      def variant_image?
        @variant_image ||= @data['Variant Image'].present?
      end
    end
  end
end
