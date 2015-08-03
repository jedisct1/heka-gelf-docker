from loggerglue import emitter, logger
from loggerglue.constants import *
from loggerglue.rfc5424 import SDElement

em = emitter.TCPSyslogEmitter(address=('192.168.59.103', 6514),
                              octet_based_framing=False)
lg = logger.Logger(emitter=em, hostname='testhostname', app_name='appname',
                   procid=69)

lg.log(msg='da message', msgid=42, prival=LOG_DEBUG | LOG_MAIL,
       structured_data=[
       SDElement("origin@123", [("software","test script"), ("swVersion","0.0.1")])
       ])

# header = pri + version + sp + timestamp + sp + hostname + sp +
# app_name + sp + procid + sp + msgid

lg.log(msg='da message', msgid=42, prival=69,
       structured_data=[
       SDElement("origin@123", [("software","[test]script"), ("swVersion","0.0.1")])
       ])
