Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get :hello, to: 'base#hello'
      # Put your routes here!
      get :snapshots, to: 'base#list_snapshots'
      get :droplets, to: 'base#list_droplets'
      get 'droplet/create/:snap_id', to: 'base#create_droplet'
      get 'droplet/shutdown/:droplet_id', to: 'base#shutdown_droplet'
      get 'droplet/poweroff/:droplet_id', to: 'base#poweroff_droplet'
      get 'droplet/snapshot/:droplet_id', to: 'base#snapshot_droplet'
      get 'droplet/destroy/:droplet_id', to: 'base#destroy_droplet'
    end
  end
end
