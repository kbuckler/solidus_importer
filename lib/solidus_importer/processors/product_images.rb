# frozen_string_literal: true

require 'down'
require 'fileutils'

module SolidusImporter
  module Processors
    class ProductImages < Base
      def call(context)
        @data = context.fetch(:data)
        return unless product_image?

        product = context.fetch(:product)
        process_images(product)
      end

      private

      def process_images(product)
        tempfile = Down.download(@data['Image Src'])
        attachment_path = "./#{tempfile.original_filename}"
        FileUtils.mv(tempfile.path, attachment_path)

        File.open(attachment_path) do |attachment|
          product.images << Spree::Image.new(attachment: attachment, alt: @data['Alt Text'])
        end

        File.delete(attachment_path)
      end

      def product_image?
        @product_image ||= @data['Image Src'].present?
      end
    end
  end
end
