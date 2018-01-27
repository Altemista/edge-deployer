{
	"service_template": {
	  "id": "anki_undeploy_template",
	  "is_public": true,
	  "name": "AnkiSoftwareStackPartialDeploy",
	  "requires_license_key": false,
	  "service_category_id": "VirtualAppliance",
	  "service_type": "virtual_appliance",
	  "version": "v1.0.0",
	  "virtualization_data": "version: \"2\"\nservices:\n\n  # car 1\n  edge-anki-controller-1:\n    image: sappelt/edge-anki-controller\n    restart: unless-stopped\n    network_mode: \"host\"\n    environment:\n      - KAFKA_EDGE_SERVER=__HOSTNAME__\n      - HTTP_WEBSOCKET=__HOSTNAME__:8003\n    volumes:\n      - car1config:/usr/src/app/mounted-config\n\n  # car 2\n  edge-anki-controller-2:\n    image: sappelt/edge-anki-controller\n    restart: unless-stopped\n    network_mode: \"host\"\n    environment:\n      - KAFKA_EDGE_SERVER=__HOSTNAME__\n      - HTTP_WEBSOCKET=__HOSTNAME__:8003\n    volumes:\n      - car2config:/usr/src/app/mounted-config\n\n  edge-anki-adas:\n    image: sappelt/edge-anki-adas\n    network_mode: \"host\"\n    environment:\n      - KAFKA_SERVER=__HOSTNAME__\n\n  edge-kafka:\n    image: spotify/kafka\n    network_mode: \"host\"\n    environment:\n      - ADVERTISED_HOST=__HOSTNAME__\n      - ADVERTISED_PORT=9092\n\n  edge-anki-twin:\n    image: sappelt/edge-anki-twin\n    network_mode: \"host\"\n    environment:\n      - KAFKA_SERVER=__HOSTNAME__\nvolumes:\n  data:\n  car1config:\n  car2config:\n",
	  "virtualization_type": "docker-compose",
	  "vpn_template": {
		"interfaces": [
		  {
			"name": "LAN",
			"is_default_gateway": true
		  }
		]
	  },
	  "is_vpn_service": true,
	  "service_tag": "dummy"
	}
}
