class Route < ActiveRecord::Base
  has_many :trains
  has_many :railway_stations, through: :railway_station_routes
  has_many :railway_station_routes

  validates :name, presence: true

  def sorted_stations
    RailwayStation.joins(:railway_station_routes)
    .where(["railway_station_routes.route_id=?", self])
    .order("railway_station_routes.station_index_in_route")
  end

  def update_stations_order(order)
    order.each do |station_id, new_index|
      station = railway_stations.where(id: station_id).first
      station.set_index_in_route(new_index, self)
    end
  end

end
