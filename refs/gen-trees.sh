echo "Generating tree diagrams..."

pyang -p ../ -f tree --tree-line-length 69 ../iana-tls-cipher-suite-algs\@*.yang > iana-tls-cipher-suite-algs-tree.txt
pyang -p ../ -f tree --tree-line-length 69 ../ietf-tls-common\@*.yang > ietf-tls-common-tree.txt
pyang -p ../ -f tree --tree-line-length 69 --tree-no-expand-uses ../ietf-tls-common\@*.yang > ietf-tls-common-tree-no-expand.txt

#pyang -p ../ -f tree --tree-line-length 69 --tree-print-groupings ../ietf-tls-client\@*.yang > ietf-tls-client-tree.txt
#pyang -p ../ -f tree --tree-line-length 69 --tree-print-groupings ../ietf-tls-server\@*.yang > ietf-tls-server-tree.txt
#pyang -p ../ -f tree --tree-line-length 69 --tree-print-groupings ../ietf-tls-common\@*.yang > ietf-tls-common-tree.txt

#pyang -p ../ -f tree --tree-line-length 69 --tree-print-groupings --tree-no-expand-uses ../ietf-tls-client\@*.yang > ietf-tls-client-tree-no-expand.txt
#pyang -p ../ -f tree --tree-line-length 69 --tree-print-groupings --tree-no-expand-uses ../ietf-tls-server\@*.yang > ietf-tls-server-tree-no-expand.txt

extract_grouping_with_params() {
  # $1 name of module
  # $2 name of grouping
  # $3 addition CLI params
  # $4 output filename
  pyang -p ../ -f tree --tree-line-length 69 --tree-print-groupings $3 ../$1@*.yang > $1-groupings-tree.txt
  cat $1-groupings-tree.txt | sed -n "/^  grouping $2/,/^  grouping/p" > tmp
  c=$(grep -c "^  grouping" tmp)
  if [ "$c" -ne "1" ]; then
    ghead -n -1 tmp > $4
    rm tmp
  else
    mv tmp $4
  fi
}

extract_grouping() {
  # $1 name of module
  # $2 name of groupin
  #extract_grouping_with_params "$1" "$2" "" "tree-$2.expanded.txt"
  extract_grouping_with_params "$1" "$2" "--tree-no-expand-uses" "tree-$2.no-expand.txt"
}

extract_grouping ietf-tls-common hello-params-grouping
extract_grouping ietf-tls-client tls-client-grouping
extract_grouping ietf-tls-server tls-server-grouping

