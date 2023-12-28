#!/bin/bash

run_unix_cmd() {
  # $1 is the line number
  # $2 is the cmd to run
  # $3 is the expected exit code
  output=`$2 2>&1`
  exit_code=$?
  if [[ $exit_code -ne $3 ]]; then
    printf "failed (incorrect exit status code) on line $1.\n"
    printf "  - exit code: $exit_code (expected $3)\n"
    printf "  - command: $2\n"
    if [[ -z $output ]]; then
      printf "  - output: <none>\n\n"
    else
      printf "  - output: <starts on next line>\n$output\n\n"
    fi
    exit 1
  fi
}

# IANA Modules

printf "Testing iana-tls-cipher-suite-algs (pyang)..."
command="pyang -Werror --max-line-length=69 -p ../ ../iana-tls-cipher-suite-algs\@*.yang"
run_unix_cmd $LINENO "$command" 0
printf "okay.\n"

printf "Testing iana-tls-cipher-suite-algs (yanglint)..."
command="yanglint -p ../ ../iana-tls-cipher-suite-algs\@*.yang"
run_unix_cmd $LINENO "$command" 0
printf "okay.\n"


# IETF Modules

printf "Testing ietf-tls-common (pyang)..."
command="pyang -Werror --ietf --max-line-length=69 -p ../ ../ietf-tls-common\@*.yang"
run_unix_cmd $LINENO "$command" 0
printf "okay.\n"

printf "Testing ietf-tls-common (yanglint)..."
command="yanglint -p ../ ../ietf-tls-common\@*.yang"
run_unix_cmd $LINENO "$command" 0
printf "okay.\n"

printf "Testing ietf-tls-client (pyang)..."
command="pyang -Werror --ietf --max-line-length=69 -p ../ ../ietf-tls-client\@*.yang"
run_unix_cmd $LINENO "$command" 0
printf "okay.\n"

printf "Testing ietf-tls-client (yanglint)..."
command="yanglint -ii -p ../ ../ietf-tls-client\@*.yang"
run_unix_cmd $LINENO "$command" 0
printf "okay.\n"

printf "Testing ietf-tls-server (pyang)..."
command="pyang -Werror --ietf --max-line-length=69 -p ../ ../ietf-tls-server\@*.yang"
run_unix_cmd $LINENO "$command" 0
printf "okay.\n"

printf "Testing ietf-tls-server (yanglint)..."
command="yanglint -ii -p ../ ../ietf-tls-server\@*.yang"
run_unix_cmd $LINENO "$command" 0
printf "okay.\n"


# IANA EXAMPLES
printf "Testing ex-cipher-suite-algs.xml..."
command="yanglint ../iana-tls-cipher-suite-algs\@*.yang ex-cipher-suite-algs.xml"
run_unix_cmd $LINENO "$command" 0
printf "okay.\n"


# IETF EXAMPLES

printf "Testing ex-tls-common.xml..."
name=`ls -1 ../ietf-tls-common\@*.yang | sed 's/\.\.\///'`
sed 's/^}/container hello-params { uses hello-params-grouping; }}/' ../ietf-tls-common\@*.yang > $name
command="yanglint ../ietf-crypto-types\@*.yang ../ietf-truststore\@*.yang ../ietf-keystore\@*.yang ../iana-tls-cipher-suite-algs\@*.yang $name ex-tls-common.xml"
run_unix_cmd $LINENO "$command" 0
printf "okay.\n"
rm $name

printf "Testing ex-generate-public-key-rpc.xml..."
command="yanglint -t nc-rpc -O ../../keystore/refs/ex-keystore.xml ../ietf-crypto-types\@*.yang ../ietf-truststore\@*.yang ../ietf-keystore\@*.yang ../iana-tls-cipher-suite-algs\@*.yang ../ietf-tls-common\@*.yang ex-generate-public-key-rpc.xml"
run_unix_cmd $LINENO "$command" 0
printf "okay.\n"

printf "Testing ex-generate-public-key-rpc-reply.xml..."
command="yanglint -t nc-reply -O ../../keystore/refs/ex-keystore.xml -R ex-generate-public-key-rpc.xml ../ietf-crypto-types\@*.yang ../ietf-truststore\@*.yang ../ietf-keystore\@*.yang ../iana-tls-cipher-suite-algs\@*.yang ../ietf-tls-common\@*.yang ex-generate-public-key-rpc-reply.xml"
run_unix_cmd $LINENO "$command" 0
printf "okay.\n"



printf "Testing ex-tls-client-inline.xml..."
name=`ls -1 ../ietf-tls-client\@*.yang | sed 's/\.\.\///'`
sed 's/^}/container tls-client { uses tls-client-grouping; }}/' ../ietf-tls-client\@*.yang > $name
command="yanglint -m ../ietf-crypto-types\@*.yang ../ietf-truststore\@*.yang ../ietf-keystore\@*.yang ../ietf-tls-common\@*.yang ./ietf-origin.yang $name ex-tls-client-inline.xml ../../trust-anchors/refs/ex-truststore.xml ../../keystore/refs/ex-keystore.xml"
run_unix_cmd $LINENO "$command" 0
printf "okay.\n"
rm $name

printf "Testing ex-tls-client-keystore.xml..."
name=`ls -1 ../ietf-tls-client\@*.yang | sed 's/\.\.\///'`
sed 's/^}/container tls-client { uses tls-client-grouping; }}/' ../ietf-tls-client\@*.yang > $name
command="yanglint -m ../ietf-crypto-types\@*.yang ../ietf-truststore\@*.yang ../ietf-keystore\@*.yang ../ietf-tls-common\@*.yang ./ietf-origin.yang $name ex-tls-client-keystore.xml ../../trust-anchors/refs/ex-truststore.xml ../../keystore/refs/ex-keystore.xml"
run_unix_cmd $LINENO "$command" 0
printf "okay.\n"
rm $name

printf "Testing ex-tls-server-inline.xml..."
name=`ls -1 ../ietf-tls-server\@*.yang | sed 's/\.\.\///'`
sed 's/^}/container tls-server { uses tls-server-grouping; }}/' ../ietf-tls-server\@*.yang > $name
command="yanglint -m ../ietf-crypto-types\@*.yang ../ietf-truststore\@*.yang ../ietf-keystore\@*.yang ../ietf-tls-common\@*.yang ./ietf-origin.yang $name ex-tls-server-inline.xml ../../trust-anchors/refs/ex-truststore.xml ../../keystore/refs/ex-keystore.xml"
run_unix_cmd $LINENO "$command" 0
printf "okay.\n"
rm $name

printf "Testing ex-tls-server-keystore.xml..."
name=`ls -1 ../ietf-tls-server\@*.yang | sed 's/\.\.\///'`
sed 's/^}/container tls-server { uses tls-server-grouping; }}/' ../ietf-tls-server\@*.yang > $name
command="yanglint -m ../ietf-crypto-types\@*.yang ../ietf-truststore\@*.yang ../ietf-keystore\@*.yang ../ietf-tls-common\@*.yang ./ietf-origin.yang $name ex-tls-server-keystore.xml ../../trust-anchors/refs/ex-truststore.xml ../../keystore/refs/ex-keystore.xml"
run_unix_cmd $LINENO "$command" 0
printf "okay.\n"
rm $name

