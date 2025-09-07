# OpenLinkHub API Usage

```bash
# List all devices with just ID and name
curl -s http://127.0.0.1:27003/api/devices/ | jq '.devices | keys[] as $id | {deviceId: $id, name: .[$id].Product}'
```

```bash
# Get specific device channels
curl -s http://127.0.0.1:27003/api/devices/ | jq '.devices."DEVICE_ID".GetDevice.devices | map_values({name, rpm, profile})'
```

```bash
# Quick device overview
curl -s http://127.0.0.1:27003/api/devices/ | jq '.devices | to_entries[] | {deviceId: .key, product: .value.Product, channels: [.value.GetDevice.devices | keys[]]}'
```
