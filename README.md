# Setup

	echo "user:pass" > ftp-users.txt

These user and passwords correspond to the [FTP push upload settings of your
Webcams](https://www.youtube.com/watch?v=6G1iGSypZGk).

## How to monitor logs

	docker logs -f ftp

## How to serve /var/www/cam from Apache

Ensure Digest authentication module is enabled:

	/etc/httpd/conf/httpd.conf:LoadModule auth_digest_module modules/mod_auth_digest.so

In Apache to protect the file listings, but not the _somewhat unguessable file_ (TODO: Make them random)
names:

	tee newfile <<EOF
	<Files .>
	AuthType Digest
	AuthName "cam"
	AuthBasicProvider file
	AuthUserFile "/etc/httpd/digest-password"
	Require valid-user
	</Files>
	EOF

To create `/etc/httpd/digest-password`:

	# htdigest -c /etc/httpd/digest-password cam letmein

This approach allows you to link to the filenames so that you won't get a [constant authentication modal from IOS Safari](https://www.youtube.com/watch?v=ymq8wN59ggY) :(
