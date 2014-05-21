require 'pact_broker/configuration'
require 'pact_broker/db'
require 'pact_broker/project_root'
require 'rack/hal_browser'

module PactBroker

  class App

    attr_accessor :configuration

    def initialize &block
      @configuration = Configuration.default_configuration
      yield configuration
      post_configure
      build_app
    end

    def call env
      @app.call env
    end

    private

    def logger
      PactBroker.logger
    end

    def post_configure
      PactBroker.logger = configuration.logger

      if configuration.auto_migrate_db
        logger.info "Migrating database"
        PactBroker::DB.run_migrations configuration.database_connection
      else
        logger.info "Skipping database migrations"
      end
    end

    def build_app
      @app = Rack::Builder.new

      @app.use Rack::Static, :urls => ["/stylesheets", "/images", "/css", "/fonts", "/js", "/javascripts"], :root => PactBroker.project_root.join("public")

      logger.info "Mounting UI"
      require 'pact_broker/ui/controllers/relationships'

      ui = Rack::Builder.new {
        map "/ui/relationships" do
          run PactBroker::UI::Controllers::Relationships
        end

        map '/network-graph' do
          run Rack::File.new("#{PactBroker.project_root}/public/network-graph.html")
        end

        map "/" do
          run lambda { |env|
            if (env['PATH_INFO'] == "/" || env['PATH_INFO'] == "") && !env['HTTP_ACCEPT'].include?("json")
              [303, {'Location' => 'ui/relationships'},[]]
            else
              [404, {},[]]
            end
          }
        end
      }

      if configuration.use_hal_browser
        logger.info "Mounting HAL browser"
        @app.use Rack::HalBrowser::Redirect, :exclude => ['/trace', '/network-graph', '/ui']
      else
        logger.info "Not mounting HAL browser"
      end

      logger.info "Mounting PactBroker::API"
      require 'pact_broker/api'

      apps = [ui, PactBroker::API]

      @app.map "/" do
        run Rack::Cascade.new(apps)
      end

    end
  end

end