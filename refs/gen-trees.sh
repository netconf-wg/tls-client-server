
pyang -p ../ -f tree --tree-print-groupings ../ietf-tls-client\@*.yang > ietf-tls-client-tree.txt.tmp
pyang -p ../ -f tree --tree-print-groupings ../ietf-tls-server\@*.yang > ietf-tls-server-tree.txt.tmp

fold -w 71 ietf-tls-client-tree.txt.tmp > ietf-tls-client-tree.txt
fold -w 71 ietf-tls-server-tree.txt.tmp > ietf-tls-server-tree.txt

rm *-tree.txt.tmp
