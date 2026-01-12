class CountriesController < ApplicationController
  require 'httpx'
  require 'json'
  def new
    @country = Country.new
  end

  def create
    country_name = params[:country][:name]
    response = HTTPX.get("https://restcountries.com/v3.1/name/#{country_name}")
    case response.status
    when 200
      data = JSON.parse(response.to_s).first
      @country = Country.find_or_initialize_by(name: data['name']['common'])
      @country.capital = data['capital'] ? data['capital'][0] : nil
      @country.region = data['region']
      @country.population = data['population']
      if @country.save
        flash[:notice] = "#{@country.name} was added successfully."
        redirect_to root_path
      else
        flash.now[:alert] = "Failed to save country."
        render :new
      end

    when 404
      @country = Country.new(name: country_name)
      flash.now[:alert] = "Country not found. Please check the name and try again."
      render :new

    when 400
      @country = Country.new(name: country_name)
      flash.now[:alert] = "Bad request. Invalid input."
      render :new

    else
      @country = Country.new(name: country_name)
      flash.now[:alert] = "Unexpected API error (status #{response.status})."
      render :new
    end

    rescue JSON::ParserError => e
      @country = Country.new(name: country_name)
      flash.now[:alert] = "Invalid response from API."
      render :new

    rescue StandardError => e
      @country = Country.new(name: country_name)
      flash.now[:alert] = "Network error: #{e.message}"
      render :new
  end

  def index
    @countries = Country.all
  end
end