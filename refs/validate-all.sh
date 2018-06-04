#!/bin/bash

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
name=`ls -1 ../ietf-tls-common\@*.yang | sed 's/\.\.\///'`
sed 's/^}/container hello-params { uses hello-params-grouping; }}/' ../ietf-tls-common\@*.yang > $name
yanglint -s ../ietf-crypto-types\@*.yang ../ietf-trust-anchors\@*.yang ../ietf-keystore\@*.yang $name ex-tls-common.xml
rm $name

echo "Testing ex-tls-client-local.xml..."
name=`ls -1 ../ietf-tls-client\@*.yang | sed 's/\.\.\///'`
sed 's/^}/container tls-client { uses tls-client-grouping; }}/' ../ietf-tls-client\@*.yang > $name
yanglint -m -s ../ietf-crypto-types\@*.yang ../ietf-trust-anchors\@*.yang ../ietf-keystore\@*.yang ../ietf-tls-common\@*.yang ./ietf-origin.yang $name ex-tls-client-local.xml ../../trust-anchors/refs/ex-trust-anchors.xml ../../keystore/refs/ex-keystore.xml
rm $name

echo "Testing ex-tls-client-keystore.xml..."
name=`ls -1 ../ietf-tls-client\@*.yang | sed 's/\.\.\///'`
sed 's/^}/container tls-client { uses tls-client-grouping; }}/' ../ietf-tls-client\@*.yang > $name
yanglint -m -s ../ietf-crypto-types\@*.yang ../ietf-trust-anchors\@*.yang ../ietf-keystore\@*.yang ../ietf-tls-common\@*.yang ./ietf-origin.yang $name ex-tls-client-keystore.xml ../../trust-anchors/refs/ex-trust-anchors.xml ../../keystore/refs/ex-keystore.xml
rm $name

echo "Testing ex-tls-server-local.xml..."
name=`ls -1 ../ietf-tls-server\@*.yang | sed 's/\.\.\///'`
sed 's/^}/container tls-server { uses tls-server-grouping; }}/' ../ietf-tls-server\@*.yang > $name
yanglint -m -s ../ietf-crypto-types\@*.yang ../ietf-trust-anchors\@*.yang ../ietf-keystore\@*.yang ../ietf-tls-common\@*.yang ./ietf-origin.yang $name ex-tls-server-local.xml ../../trust-anchors/refs/ex-trust-anchors.xml ../../keystore/refs/ex-keystore.xml
rm $name

echo "Testing ex-tls-server-keystore.xml..."
name=`ls -1 ../ietf-tls-server\@*.yang | sed 's/\.\.\///'`
sed 's/^}/container tls-server { uses tls-server-grouping; }}/' ../ietf-tls-server\@*.yang > $name
yanglint -m -s ../ietf-crypto-types\@*.yang ../ietf-trust-anchors\@*.yang ../ietf-keystore\@*.yang ../ietf-tls-common\@*.yang ./ietf-origin.yang $name ex-tls-server-keystore.xml ../../trust-anchors/refs/ex-trust-anchors.xml ../../keystore/refs/ex-keystore.xml
rm $name

