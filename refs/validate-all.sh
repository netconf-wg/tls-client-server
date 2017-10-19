echo "Testing YANG module syntax..."
pyang --ietf --max-line-length=70 -p ../ ../ietf-tls-client\@*.yang
pyang --ietf --max-line-length=70 -p ../ ../ietf-tls-server\@*.yang
pyang --ietf --max-line-length=70 -p ../ ../ietf-tls-common\@*.yang
yanglint -p ../ ../ietf-tls-client\@*.yang
yanglint -p ../ ../ietf-tls-server\@*.yang
yanglint -p ../ ../ietf-tls-common\@*.yang


echo "Testing ex-tls-common.xml..."
yanglint -p ../ -s ../ietf-tls-common\@*.yang ex-tls-common.xml

echo "Testing ex-tls-client.xml..."
yanglint -m -p ../ -s ../ietf-tls-client\@*.yang ex-tls-client.xml ../../keystore/refs/ex-keystore.xml

echo "Testing ex-tls-server.xml..."
yanglint -m -p ../ -s ../ietf-tls-server\@*.yang ex-tls-server.xml ../../keystore/refs/ex-keystore.xml

