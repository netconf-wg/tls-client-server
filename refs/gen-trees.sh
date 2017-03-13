
pyang -p ../ -f tree --tree-line-length 71 --tree-print-groupings ../ietf-tls-client\@*.yang > ietf-tls-client-tree.txt
pyang -p ../ -f tree --tree-line-length 71 --tree-print-groupings ../ietf-tls-server\@*.yang > ietf-tls-server-tree.txt
pyang -p ../ -f tree --tree-line-length 71 --tree-print-groupings ../ietf-tls-common\@*.yang > ietf-tls-common-tree.txt
