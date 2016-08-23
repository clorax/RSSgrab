#!/usr/bin/perl

#     RSSgrab
#     Version 0.1.0
#     Copyright (c) 2009 Simon Hastie

#     This program is free software: you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.

#     This program is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.

#     You should have received a copy of the GNU General Public License
#     along with this program.  If not, see <http://www.gnu.org/licenses/>.


# use modules
use XML::Simple;
use Getopt::Long;
use LWP::Simple;

# get options
my $verbose = '';
GetOptions ("v|verbose" => \$verbose);

# read config XML file
$xml = new XML::Simple;
$config = $xml->XMLin("config.xml");
$logfile = $config->{channel}->{config}->{logfile};
$tdir = $config->{channel}->{config}->{target_dir};

# read log file
open (LASTDOWNLOAD, $logfile);
$lastdownload = <LASTDOWNLOAD>;
close(LASTDOWNLOAD);
my @lastdldate = split(' ', $lastdownload);
my @lastdltime = split(':', @lastdldate->[4]);
$lastdlhour = @lastdltime->[0];
$lastdlminute = @lastdltime->[1];
$lastdlday = @lastdldate->[1];

foreach $f (@{$config->{channel}->{feed}}) {
    if ($verbose) { print "Looking for new files in " . $f->{title} . "\n"; }
    $data = $xml->XMLin(get($f->{url}));
    foreach $i (@{$f->{item}}) {
        foreach $t (@{$data->{channel}->{item}}) {
            if ($t->{title} =~ m/$i->{string}/i) {
                if ($t->{title} =~ m/$i->{exception}/i) {
                    if ($verbose) { print " - " . $t->{title} . "\n"; }
                } else {
                    my @pubdate = split(' ', $t->{pubDate});
                    my @pubtime = split(':', @pubdate->[4]);
                    $pubhour = @pubtime->[0];
                    $pubminute = @pubtime->[1];
                    $pubday = @pubdate->[1];
                    if ($pubday eq $lastdlday and $pubhour gt $lastdlhour or $pubday eq $lastdlday and $pubhour eq $lastdlhour and $pubminute gt $lastdlminute or $pubday gt $lastdlday) {
                        my @spliturl = split('/', $t->{enclosure}->{url});
                        print " + " . $t->{title} . "\n";
                        open FT, ">" . $tdir . $t->{title} . $f->{filetype};
                        flock FT, LOCK_EX;
                        print FT get($t->{enclosure}->{url});
                        close FT;
                        open FL, ">" . $logfile;
                        flock FL, LOCK_EX;
                        print FL $t->{pubDate};
                        close FL;
                    } else {
                        if ($verbose) { print " ~ " . $t->{title} . "\n"; }
                    }
                }
            }
        }
    }
}
