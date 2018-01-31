{
	"service_template": {
	  "id": "anki_noobjectdetection_template",
	  "is_public": true,
	  "name": "AnkiSoftwareStackPartialDeploy",
	  "requires_license_key": false,
	  "service_category_id": "VirtualAppliance",
	  "service_type": "virtual_appliance",
	  "version": "v1.0.0",
	  "virtualization_data": "__COMPOSE__",
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
