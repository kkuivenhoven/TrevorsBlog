// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import * as bootstrap from "bootstrap"

window.initMap = function () {
  const mapElement = document.getElementById("map");
  if (mapElement) {
    const map = new google.maps.Map(mapElement, {
      center: { lat: 37.7749, lng: -122.4194 },
      zoom: 5,
    });

    new google.maps.Marker({
      position: { lat: 37.7749, lng: -122.4194 },
      map: map,
      title: "Example Scam Report",
    });
  }
};
