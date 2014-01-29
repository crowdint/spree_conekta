module SpreeConekta
  module Generators
    class InstallGenerator < Rails::Generators::Base

      class_option :auto_run_migrations, type: :boolean, default: false

      def add_javascripts
        append_file 'app/assets/javascripts/store/all.js', "\n//= require spree_conekta\n"
        append_file 'app/assets/javascripts/admin/all.js', "\n//= require spree_conekta\n"
      end

      def add_stylesheets
        inject_into_file 'app/assets/stylesheets/store/all.css', "\n *= require spree_conekta\n", before: /\*\//, verbose: true
        inject_into_file 'app/assets/stylesheets/admin/all.css', "\n *= require spree_conekta\n", before: /\*\//, verbose: true
      end

      def add_migrations
        run 'bundle exec rake railties:install:migrations'
      end

      def run_migrations
         res = ask 'Would you like to run the migrations now? [Y/n]'
         if res == '' || res.downcase == 'y'
           run 'bundle exec rake db:migrate'
         else
           puts 'Skipping rake db:migrate, don\'t forget to run it!'
         end
      end

    end
  end
end
