Docker/Heka/RFC 5424/Kafka-GELF
===============================

A Docker image leveraging Heka that:
- Accepts RFC 5424 formatted message on TCP port 6514, optionally using TLS
- Puts them into Kafka as GELF messages

Usage
-----

- Edit the `Dockerfile` environment variables to fit your needs.
- In order to use TLS, replace `heka.pem` with a suitable certificate + key
- Build the image and run the container.

Heka's dashboard is exposed on port 4352.
