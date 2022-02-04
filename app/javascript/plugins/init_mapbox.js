import mapboxgl from 'mapbox-gl';
import 'mapbox-gl/dist/mapbox-gl.css';

const initMapbox = () => {
  const mapElement = document.getElementById('map');

  // Function to fit map to markers
  const fitMapToMarkers = (map, markers) => {
    const bounds = new mapboxgl.LngLatBounds();
    markers.forEach(marker => bounds.extend([marker.lng, marker.lat]));
    map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 });
  };

  if (mapElement) { // If no div 'map' then the code won't run
    mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;

    // Draw the Map
    const map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/streets-v10' // style can be changed later
    });

    // Draw the markers
    const markers = JSON.parse(mapElement.dataset.markers);
    markers.forEach((marker) => {

      const popup = new mapboxgl.Popup().setHTML(marker.info_window);

      new mapboxgl.Marker()
        .setLngLat([marker.lng, marker.lat])
        .setPopup(popup)
        .addTo(map);
    });

    // Fit map to markers
    fitMapToMarkers(map, markers);
  }
};

export { initMapbox };
