require 'rails/generators/active_record/model/model_generator'

module Presentable
  class PresenterGenerator < ActiveRecord::Generators::ModelGenerator
    source_root File.expand_path('../templates', __FILE__)

    def generate_presenter
      template 'model_presenter_template.template', "app/presenters/#{file_name}_presenter.rb"
    end
  end
end
