
pyang -p ../ -f tree --tree-line-length 69 --tree-print-groupings ../ietf-tls-client\@*.yang > ietf-tls-client-tree.txt
pyang -p ../ -f tree --tree-line-length 69 --tree-print-groupings ../ietf-tls-server\@*.yang > ietf-tls-server-tree.txt
pyang -p ../ -f tree --tree-line-length 69 --tree-print-groupings ../ietf-tls-common\@*.yang > ietf-tls-common-tree.txt

pyang -p ../ -f tree --tree-line-length 69 --tree-print-groupings --tree-no-expand-uses ../ietf-tls-client\@*.yang > ietf-tls-client-tree-no-expand.txt
pyang -p ../ -f tree --tree-line-length 69 --tree-print-groupings --tree-no-expand-uses ../ietf-tls-server\@*.yang > ietf-tls-server-tree-no-expand.txt

