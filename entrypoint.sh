#! /bin/sh

nproc=$(nproc)
if [ $nproc -gt 1 ]; then
    threads=$(($nproc - 1))
else
    threads=1
fi

EXTRA_PROPERTIES=$(echo "$EXTRA_PROPERTIES" | sed -e 's/\\/\\\\\\\\/g' -e 's/"/\\\\"/g')

echo $EXTRA_PROPERTIES

sed -e "s/@THREADS@/${threads}/g" \
    -e "s/@USE_TLS@/${USE_TLS}/g" \
    -e "s/@KAFKA_BROKERS@/${KAFKA_BROKERS}/g" \
    -e "s/@KAFKA_TOPIC@/${KAFKA_TOPIC}/g" \
    -e "s/@EXTRA_PROPERTIES@/${EXTRA_PROPERTIES}/g" \
/etc/hekad.toml.in > /etc/hekad.toml

cat /etc/hekad.toml

exec /opt/heka/build/heka/bin/hekad
