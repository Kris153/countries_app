class CountriesController < ApplicationController
  require 'httpx'
  require 'json'
  def new
    @country = Country.new
  end
  def create
    country_name = params[:country][:name]
    response = HTTPX.get("https://restcountries.com/v3.1/name/#{country_name}")
    data = JSON.parse(response.to_s).first
    @country = Country.find_or_initialize_by(name: data['name']['common'])
    @country.capital = data['capital'] ? data['capital'][0] : nil
    @country.region = data['region']
    @country.population = data['population']
    if @country.save
      flash[:notice] = "#{@country.name} was added successfully."
      redirect_to root_path
    else
      render :new
    end
  rescue => e
    flash.now[:alert] = "Error: #{e.message}"
    render :new
  end
  def index
    @countries = Country.all
  end
end
