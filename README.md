Docker/Heka/RFC 5424/Kafka-GELF
===============================

A Docker image leveraging Heka that:
- Accepts RFC 5424 formatted message on TCP port 6514, optionally using TLS
- Puts them into Kafka as GELF messages

Usage
-----

- Edit the `Dockerfile` environment variables to fit your needs.
- In order to use TLS, replace `heka.pem` with a suitable certificate + key
- By default, messages will be printed to `stdout`. In order to enable
logging to Kafka, uncomment the `[KafkaOutput]` section in
`hekad.toml.in`, and comment out the `[LogOutput]` section.
- Build the image and run the container.

Heka's dashboard is exposed on port 4352.

To create a self-signed certificate for TLS:

```bash
openssl req -x509 -nodes -newkey rsa:2048 -sha256 -keyout heka.pem -out heka.pem
```
