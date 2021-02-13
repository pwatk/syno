#!/bin/bash

address=
port=
server=
ovpn=../$address.ovpn
ca=./pki/ca.crt
ta=./pki/ta.key

cat <<- EOF > $ovpn
	client
	dev tun
	proto udp
	remote $address $port
	verify-x509-name "$server" name
	remote-cert-tls server
	redirect-gateway def1
	resolv-retry infinite
	nobind
	persist-key
	persist-tun
	comp-lzo adaptive
	auth-user-pass
	#cryptoapicert "THUMB:XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX"
	key-direction 1
	tls-version-min 1.2
	cipher AES-256-CBC
	#ncp-ciphers AES-256-GCM:AES-128-GCM
	auth SHA256
EOF

if [ -f $ca ]; then
	cat <<- EOF >> $ovpn
		<ca>
		$(cat $ca)
		</ca>
	EOF
else
	echo "$(basename $0): CA certificate not found" 
	exit 1
fi 
 
if [ -f $ta ]; then
	cat <<- EOF >> $ovpn
		<tls-auth>
		$(cat $ta | sed '/^#/d')
		</tls-auth>
	EOF
else
	echo "$(basename $0): tls-auth key not found" 
	exit 1
fi

echo "Done"
