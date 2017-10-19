echo "Testing ietf-tls-client (pyang)..."
pyang --ietf --max-line-length=69 -p ../ ../ietf-tls-client\@*.yang

echo "Testing ietf-tls-client (yanglint)..."
yanglint -p ../ ../ietf-tls-client\@*.yang

echo "Testing ietf-tls-server (pyang)..."
pyang --ietf --max-line-length=69 -p ../ ../ietf-tls-server\@*.yang

echo "Testing ietf-tls-server (yanglint)..."
yanglint -p ../ ../ietf-tls-server\@*.yang

echo "Testing ietf-tls-common (pyang)..."
pyang --ietf --max-line-length=69 -p ../ ../ietf-tls-common\@*.yang

echo "Testing ietf-tls-common (yanglint)..."
yanglint -p ../ ../ietf-tls-common\@*.yang


echo "Testing ex-tls-common.xml..."
yanglint -p ../ -s ../ietf-tls-common\@*.yang ex-tls-common.xml

echo "Testing ex-tls-client.xml..."
yanglint -m -p ../ -s ../ietf-tls-client\@*.yang ex-tls-client.xml ../../keystore/refs/ex-keystore.xml

echo "Testing ex-tls-server.xml..."
yanglint -m -p ../ -s ../ietf-tls-server\@*.yang ex-tls-server.xml ../../keystore/refs/ex-keystore.xml

