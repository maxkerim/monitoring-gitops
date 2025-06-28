require_relative "config/environment"

run Rack::Builder.new {
  map "/health" do
    run proc { [200, { "Content-Type" => "text/plain" }, ["OK"]] }
  end

  run Rails.application
}

