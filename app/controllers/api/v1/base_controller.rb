require 'droplet_kit'

class Api::V1::BaseController < ApplicationController
  include ActionController::Serialization

  @@disktoram = {
    20 => '512mb',
    30 => '1gb',
    40 => '2gb',
    60 => '4gb',
    80 => '8gb',
    160 => '16gb',
    320 => '32gb',
    480 => '48gb',
    640 => '64gb'
  }

  def hello
    render json: { title: 'React and Rails' }
  end

  def list_snapshots
    get_snapshots unless @snapshots
    render json: @snapshots.to_json
  end

  def list_droplets
    get_droplets unless @droplets
    render json: @droplets.to_json
  end

  def create_droplet
    get_snapshots unless @snapshots
    render json: {} and return unless params[:snap_id]
    snaps = @snapshots.select {|snap| snap.id == params[:snap_id]}
    render json: {} and return if snaps == []
    snap = snaps.first
    params = update_snapshot_params snap
    droplet = DropletKit::Droplet.new params
    action = @client.droplets.create(droplet)
    render json: action.to_json
  end

  def shutdown_droplet
    get_droplets unless @droplets
    render json: {"Error": "No parameter given"} and return unless params[:droplet_id]
    droplets = @droplets.select {|drop| drop.id == params[:droplet_id].to_i}
    render json: {"Error": "Not a valid droplet ID"} and return if droplets == []
    droplet = droplets.first
    action = @client.droplet_actions.shutdown(droplet_id: droplet.id)
    render json: action.to_json
  end

  def poweroff_droplet
    get_droplets unless @droplets
    render json: {} and return unless params[:droplet_id]
    droplets = @droplets.select {|drop| drop.id == params[:droplet_id].to_i}
    render json: {} and return if droplets == []
    droplet = droplets.first
    action = @client.droplet_actions.power_off(droplet_id: droplet.id)
    render json: action.to_json
  end

  def snapshot_droplet
    get_droplets unless @droplets
    render json: {} and return unless params[:droplet_id]
    droplets = @droplets.select {|drop| drop.id == params[:droplet_id].to_i}
    render json: {} and return if droplets == []
    droplet = droplets.first
    action = @client.droplet_actions.snapshot(droplet_id: droplet.id, name: droplet.name)
    render json: action.to_json
  end

  def destroy_droplet
    get_droplets unless @droplets
    render json: {} and return unless params[:droplet_id]
    droplets = @droplets.select {|drop| drop.id == params[:droplet_id].to_i}
    render json: {} and return if droplets == []
    droplet = droplets.first
    action = @client.droplets.delete(id: droplet.id)
    render json: action.to_json
  end

  protected
  def create
    @client = DropletKit::Client.new(access_token: Rails.application.secrets.digital_ocean_token)
  end

  def get_snapshots
    create unless @client
    @snapshots = @client.snapshots.all(resource_type: 'droplet')
    @snapshots.each {}
  end

  def get_droplets
    create unless @client
    @droplets = @client.droplets.all
    @droplets.each
  end

  def update_snapshot_params snap
    m = snap.name.match('(.*)-(\d*)-\d*')
    params = {
      name: "#{m[1]}-#{(m[2].to_i + 1).to_s.rjust(3,'0')}-#{Date::today.strftime '%Y%m%d'}",
      region: snap.regions.first,
      size: @@disktoram[snap.min_disk_size],
      image: snap.id.to_i
    }
  end
end
