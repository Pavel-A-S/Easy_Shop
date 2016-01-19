function googlemap(text) {
  function initialize() {
    var mapCanvas = document.getElementById('map');
    var mapOptions = {
      center: new google.maps.LatLng(55.605178, 37.351423),
      zoom: 15,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    }
    var map = new google.maps.Map(mapCanvas, mapOptions)

  var marker = new google.maps.Marker({
    position: new google.maps.LatLng(55.605178, 37.351423),
    map: map,
    title: text
  });

  }

  google.maps.event.addDomListener(window, 'load', initialize);
}
