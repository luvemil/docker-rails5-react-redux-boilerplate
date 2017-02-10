require 'droplet_kit'

class Api::V1::BaseController < ApplicationController
  include ActionController::Serialization

  def hello
    render json: { title: 'React and Rails' }
  end

  def create
    @client = DropletKit::Client.new(access_token: Rails.application.secrets.digital_ocean_token)
  end

  def get_snapshots
    create unless @client
    @snapshots = @client.snapshots.all(resource_type: 'droplet')
    @snapshots.each {}
  end

  def list_snapshots
    get_snapshots unless @snapshots
    render json: @snapshots.to_json
  end
end
