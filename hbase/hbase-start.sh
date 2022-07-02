# start ssh server
/etc/init.d/ssh start

# startng hbase
$HBASE_HOME/bin/start-hbase.sh

$HBASE_HOME/bin/hbase rest start -p 3010

# keep container running
tail -f /dev/null