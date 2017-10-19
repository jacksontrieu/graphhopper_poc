class HomeController < ApplicationController
  require 'swagger_client'


  def index
    SwaggerClient.configure do |c|
      c.scheme = 'https'
      c.host = 'graphhopper.com'
      c.base_path = '/api/1'
    end

    api_instance = SwaggerClient::VrpApi.new

    # Request | Request object that contains the problem to be solved
    body = SwaggerClient::Request.new(
      vehicles: vehicles,
      vehicle_types: vehicle_types,
      services: services
    )

    begin
      # Solves vehicle routing problems
      @result = api_instance.post_vrp(KEY, body)
      puts '-------------------------------------------------'
      puts '-------------------------------------------------'
      puts @result
      puts '-------------------------------------------------'
      puts '-------------------------------------------------'
      render json: @result.to_json
    rescue SwaggerClient::ApiError => e
      byebug
      puts "Exception when calling VrpApi->post_vrp: #{e}"
      puts e.response_body unless e.response_body.blank?
    end
  end

  def solution
    raise 'No job_id provided' if params[:job_id].blank?

    SwaggerClient.configure do |c|
      c.scheme = 'https'
      c.host = 'graphhopper.com'
      c.base_path = '/api/1'
    end

    api_instance = SwaggerClient::SolutionApi.new

    begin
      # Return the solution associated to the jobId
      @result = api_instance.get_solution(KEY, params[:job_id])
      render json: @result.to_json
    rescue SwaggerClient::ApiError => e
      byebug
      puts "Exception when calling SolutionApi->get_solution: #{e}"
    end
  end

  def vehicles
    [
      SwaggerClient::Vehicle.new(
        vehicle_id: '1',
        type_id: 'hino',
        start_address: SwaggerClient::Address.new(
          location_id: 'Start',
          lat: -33.863494,
          lon: 151.106119
        ),
        end_address: SwaggerClient::Address.new(
          location_id: 'Finish',
          lat: -33.876821,
          lon: 150.977317
        )
      )
    ]
  end

  def vehicle_types
    [
      SwaggerClient::VehicleType.new(
        type_id: 'hino',
        profile: 'small_truck',
        capacity: [50]
      )
    ]
  end

  def services
    [
      SwaggerClient::Service.new(
        id: 'Auburn',
        address: SwaggerClient::Address.new(
          location_id: 'Auburn',
          lat: -33.860684,
          lon: 151.024731
        ),
        size: [20]
      ),
      SwaggerClient::Service.new(
        id: 'Newtown',
        address: SwaggerClient::Address.new(
          location_id: 'Newtown',
          lat: -33.899956,
          lon: 151.174598
        ),
        size: [20]
      ),
      # SwaggerClient::Service.new(
      #   id: 'Abbotsford',
      #   address: SwaggerClient::Address.new(
      #     location_id: 'Abbotsford',
      #     lat: -33.853625,
      #     lon: 151.135991
      #   ),
      #   size: [20]
      # ),
      SwaggerClient::Service.new(
        id: 'Cabramatta',
        address: SwaggerClient::Address.new(
          location_id: 'Cabramatta',
          lat: -33.894398,
          lon: 150.931007
        ),
        size: [20]
      )
    ]
  end
end
