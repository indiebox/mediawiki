#!/usr/bin/perl
#
# Upgrade Mediawiki installation.
#

use strict;

use IndieBox::Logging;
use IndieBox::Utils;

my $ret = 1;

if( 'upgrade' eq $operation ) {
    my $appConfigDir = $config->getResolveOrNull( 'appconfig.apache2.dir' );

    my $cmd = "TERM=vt100";
    $cmd .= " php";
    $cmd .= " -d open_basedir='$appConfigDir:/usr/share/'"; # would be nice if this was stricter, but accessories!
    $cmd .= " /usr/share/indie-mediawiki/mediawiki/maintenance/update.php";
    $cmd .= " --conf '$appConfigDir/LocalSettings.php'";
    $cmd .= " --quick";

    my $out = '';
    my $err = '';

    # pipe PHP in from stdin
    debug( 'About to execute PHP:', $cmd );

    if( IndieBox::Utils::myexec( $cmd, undef, \$out, \$err ) != 0 ) {
        error( "Upgrading MediaWiki failed: $err\n $out" );
        $ret = 0;
    }
}

$ret;
