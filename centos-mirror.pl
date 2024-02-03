#!/usr/bin/perl

use strict;
use warnings;

my $HTTPSRV = $ENV{HTTPSRV} // "http://httpd/cgi-bin/centos-mirror.pl";
my $REPOURL = $ENV{REPOURL} // "https://ftp.iij.ad.jp/pub/linux/centos-vault";

sub latest {
    my ($ver) = @_;
    return "2.1" if $ver eq "2";
    return "3.9" if $ver eq "3";
    return "4.9" if $ver eq "4";
    return "5.11" if $ver eq "5";
    return "6.10" if $ver eq "6";
    return "7.9.2009" if $ver eq "7";
    return "8.5.2111" if $ver eq "8";
    return $ver;
}

sub update {
    my ($url) = @_;
    if ($url =~ m!^http://mirrorlist\.centos\.org/\?(.*)$!) {
        my %kv = map {split(/=/, $_, 2)} (split(/&/, $1));
        my $os = $kv{'release'} =~ /^8/ ? "os/" : "";
        $url = "$HTTPSRV?http://mirror.centos.org/centos/$kv{'release'}/$kv{'repo'}/$kv{'arch'}/$os";
    } elsif ($url =~ m!^http://mirror\.centos\.org/centos/([^/]+)/(.*)$!) {
        $url = "$REPOURL/@{[latest($1)]}/$2" if $1 !~ /^7(|\.9\.2009)$/;
    }
    return "$url";
}

if (($ENV{QUERY_STRING} // "") =~ /(.+)/) {
    print "HTTP/1.1 200 OK\n";
    print "Content-Type: text/plain\n";
    print "\n";
    print "$1\n";
} else {
    local $| = 1; # disable buffering
    while (<>) {
        print "OK rewrite-url=@{[update((split(/\s+/))[0])]}\n";
    }
}
