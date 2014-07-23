my $hostname    = $config->getResolveOrNull( 'site.hostname' );
my $context     = $config->getResolveOrNull( 'appconfig.context' );
my $hiddenpath  = "$context/_";
my $rewriteBase = $config->getResolveOrNull( 'appconfig.contextorslash' );

# Unfortunately, Alias directories cannot be used in .htaccess files

my $ret = <<RET;
#
# Apache config file fragment for app Mediawiki at $hostname$context
#

php_value upload_max_filesize 10M
php_value post_max_size 10M

RewriteEngine on
Options +FollowSymLinks
Options -Indexes
# this does not inhibit index.php, just the subdirectories
DirectoryIndex index.php

# RewriteBase $rewriteBase

RewriteCond %{REQUEST_URI} ^$context/_/indie-images/logo.png\$
RewriteCond %{REQUEST_FILENAME} !-f
RewriteRule ^(.\*)\$ _/indie-images/mediawiki.png

# RewriteCond %{REQUEST_URI} ^$context/_/index\.php
# RewriteRule ^(.\*)\$ index.php [L,QSA]

# RewriteCond %{REQUEST_URI} ^$context/_/
# RewriteRule ^(.\*)\$ - [L,QSA]

# Don't rewrite again
RewriteCond %{REQUEST_URI} !^/wiki/index.php
RewriteCond %{REQUEST_FILENAME} !-f
RewriteRule ^(.\*)\$ index.php?title=\$1 [PT,L,QSA]

RET

$ret;
