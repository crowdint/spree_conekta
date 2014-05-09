module SpreeConekta
  module Generators
    class InstallGenerator < Rails::Generators::Base

      class_option :auto_run_migrations, type: :boolean, default: false

      def add_javascripts
        append_file 'vendor/assets/javascripts/spree/frontend/all.js', "\n//= require spree/frontend/spree_conekta\n"
        append_file 'vendor/assets/javascripts/spree/backend/all.js', "\n//= require spree/backend/spree_conekta\n"
      end

      def add_stylesheets
        inject_into_file 'vendor/assets/stylesheets/spree/frontend/all.css', "\n *= require spree/frontend/spree_conekta\n", before: /\*\//, verbose: true
        inject_into_file 'vendor/assets/stylesheets/spree/backend/all.css', "\n *= require spree/backend/spree_conekta\n", before: /\*\//, verbose: true
      end

      def add_migrations
        run 'bundle exec rake railties:install:migrations'
      end

      def run_migrations
        run 'bundle exec rake db:migrate'
      end

    end
  end
end
