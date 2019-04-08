module Presentable
  class BasePresenter
    attr_reader :record

    class PresenterRecordMismatchError < StandardError
      def initialize(record_name, presenter_name)
        super("Record name #{record_name} does not match expected record name #{presenter_name} based on presenter class name")
      end
    end

    def self.model_class(class_of_model = nil)
      @model_class ||= class_of_model || self.name[0...self.name.index('Presenter')]
    end

    def self.model
      model_class.constantize
    end

    def self.method_missing(method, *args, &block)
      model.send(method, *args, &block)
    rescue NoMethodError
      super
    end

    def self.respond_to_missing?(method_name, include_private = false)
      model.respond_to?(method_name, include_private) || super
    end

    def self.virtual_columns(*args)
      args.extract_options! # throw out the options hash in case it was supplied

      args.each do |virtual_column|
        define_method virtual_column do
          record.send(virtual_column)
        end
      end
    end

    def initialize(record)
      @record = record
      raise PresenterRecordMismatchError.new(record.class.name, self.class.name) unless record_matches_presenter
    end

    def model
      self.class.model
    end

    def is?(other_record)
      record && other_record && record.id == other_record.id && record.class == other_record.class
    end

    protected

    def record_matches_presenter
      record.is_a?(BasePresenter) ? record.record_matches_presenter : record.is_a?(model)
    end

    private

    def method_missing(method, *args, &block)
      record.send(method, *args, &block)
    rescue NoMethodError
      super
    end

    def respond_to_missing?(method_name, include_private = false)
      record.respond_to?(method_name, include_private) || super
    end
  end
end

