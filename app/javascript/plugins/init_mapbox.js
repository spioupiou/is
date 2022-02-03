import mapboxgl from 'mapbox-gl';
import 'mapbox-gl/dist/mapbox-gl.css';

const initMapbox = () => {
  const mapElement = document.getElementById('map');

  // Function to fit map to markers
  const fitMapToMarkers = (map, markers) => {
    const bounds = new mapboxgl.LngLatBounds();
    markers.forEach(marker => bounds.extend([marker.lng, marker.lat]));
    map.fitBounds(bounds, { padding: 90, maxZoom: 15, duration: 0 });
  };

  if (mapElement) { // If no div 'map' then the code won't run
    mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;

    // Draw the Map
    const map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/iskondo/ckz6xx3py001h15qr3quevfj1' // without road labels
    });

    // Draw the markers
    const markers = JSON.parse(mapElement.dataset.markers);
    markers.forEach((marker) => {

      const popup = new mapboxgl.Popup().setHTML(marker.info_window);

      // Create a HTML element for your custom marker
      const element = document.createElement('div');
      element.className = 'marker';
      element.style.backgroundImage = `url('${marker.image_url}')`;
      element.style.backgroundSize = 'cover';
      element.style.width = '40px';
      element.style.height = '31px';

      new mapboxgl.Marker(element)
        .setLngLat([marker.lng, marker.lat])
        .setPopup(popup)
        .addTo(map);
    });

    // Fit map to markers
    fitMapToMarkers(map, markers);
  }
};

export { initMapbox };
