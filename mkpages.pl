#!/usr/bin/perl -w
use strict;
use Data::Dumper;

my $x = 0;
my $y = 0;
my $dx = 256;
my $dy = 256;

# my @LOCATIONS;
my $TRACKS;
my $LOCATIONS;
open I,'<','tracks.data' or die "$?: $!";
my $loc = '';
my $lc = 0;
while (<I>) {
    /^\s*$/ and next;
    
    chomp;
    if (/^\-(.*)/) {
      my ($f,$name,@r) = split(/\//,$1);
      map { $TRACKS->{$loc}->{$name}->{$_} = shift @r } qw( type miles turns year );
      $TRACKS->{$loc}->{$name}{img} = $f;
      my ($l) = $TRACKS->{$loc}->{$name}->{miles} =~ m/(\d+\.\d+)/;
      $TRACKS->{$loc}->{$name}->{km} = sprintf("%0.2f",$l * 1.609344);
      $TRACKS->{$loc}->{$name}->{mi} = sprintf("%0.2f",$l);
    }
    else {
      my ($f,$location,$country) = split(/\//,$_);
      $LOCATIONS->{$location}->{img} = $f;
      $LOCATIONS->{$location}->{country} = $country;
      $lc++;
      $loc = $location;
    }
}
close I;
print Dumper(\$TRACKS);

# @LOCATIONS = sort { rand(1) > 0.5 } @LOCATIONS;
my @LOCATIONS = sort { rand(1) > 0.5 } keys %{$LOCATIONS};

print Dumper(\$LOCATIONS);
print Dumper(\@LOCATIONS);

for ( my $i=0; $i < @LOCATIONS; $i++) {
  my $j = rand(@LOCATIONS);
  my ($a,$b) = ( $LOCATIONS[$i], $LOCATIONS[$j] );
  ( $LOCATIONS[$i], $LOCATIONS[$j] ) = ( $b, $a );
}
print "XXX\n";
print Dumper(\@LOCATIONS);

open O,'>','logos-fp.tex' or die "$?: $!";

my $tp = 0;
while(<DATA>) {
  chomp;
  /^\s*$/ and last;
  my @x = split(//, $_);
  #print Dumper(\@x);
  $x = 0;
  while ( my $g = shift @x) {
    if ($g eq 'x') {
       incgra($x,$y,$tp);  
       $tp++;
    }
    else {
        
    }
    $x += $dx;
  }
  $y += $dy;
}
close O;
#
# pages
#
my %TYPEMAP = (
 'C' => '\Huge$\circlearrowleft$',
 'P' => 'A $\rightsquigarrow$ B',
);
open O,'>','all-tracks.tex' or die "$?:$!";
my $r = 3;
my $c = 0;
my $bs = 80;
my ($x1,$y1) = (15,15);
my $printlogo = 1;
for my $loc (sort @LOCATIONS) {
  my $printlogo = 1;
  for my $track ( sort keys %{$TRACKS->{$loc}} ) {
    if (++$r >= 3 ) {
      print O "\\null\\newpage\n\n";
      $r = $c = 0;
      $printlogo = 1;
    }
    if ($printlogo) {
      $c = 0;
      printf O "\\begin{textblock*}{%dmm}(%dmm,%dmm)%%\n",60, $x1 ,($y1 + $r * 90 );;
      printf O "\\includegraphics[width=%dmm]{LG/%s}\n",50,$LOCATIONS->{$loc}->{img};
      printf O "\\par %s\\\\ %s\n",$loc,$LOCATIONS->{$loc}->{country};
      print  O "\\end{textblock*}\n";
      $printlogo = 0;
    }
    $c = 1;
    printf O "\\begin{textblock*}{%dmm}(%dmm,%dmm)%%\n",$bs,( $x1 + 70 ),($y1 + $r * 90 );
    printf O "\\includegraphics[width=%dmm]{TR/%s}\n",$bs,$TRACKS->{$loc}->{$track}->{img};
    printf O "\\centerline{%s}\n",$track;
    print  O "\\end{textblock*}\n";
    printf O "\\begin{textblock*}{%dmm}(%dmm,%dmm)%%\n",30,( $x1 + 70 + $bs +5 ),($y1 + $r * 90 );
    printf O "\\par %s\n",$TYPEMAP{$TRACKS->{$loc}->{$track}->{type}};
    print  O "\\Large\n";
    printf O "\\par\$\\mapsto\$ %s mi.\n",$TRACKS->{$loc}->{$track}->{mi};
    printf O "\\par\$\\mapsto\$ %s km\n",$TRACKS->{$loc}->{$track}->{km};
    printf O "\\par\$\\looparrowright\$ %s\n",$TRACKS->{$loc}->{$track}->{turns};
    print  O "\\end{textblock*}\n";
  }
}
close O;
exit;

sub incgra {
  my ($x, $y, $tp) = @_;
  print "### [$tp] $LOCATIONS[$tp] $x / $y\n";
  my $tx = int ($x * 0.1171875);
  my $ty = int ($y * 0.1171875) + 0;
  printf O "\\begin{textblock*}{30mm}(%dmm,%dmm)%%\n",$tx,$ty;
  printf O "\\includegraphics[width=30mm]{LG/%s}\n",$LOCATIONS->{$LOCATIONS[$tp]}->{img};
  printf O "\\end{textblock*}\n";
}


__DATA__
xxxxxxx
x.....x
x.....x
x.....x
x.....x
.x.x.x.
x.x.x.x
.x.x.x.
x.x.x.x



xxxxxxx
x.....x
x.....x
x.....x
x.....x
.......
x.x.x.x
.x.x.x.
x.x.x.x
.x.x.x.


xxxxxxx
x.....x
x.....x
x.....x
x.....x
x.....x
x.....x
x.....x
x.....x
xxx.xxx


xxx.xxx
xxxxxxx
..xxx..
xxxxxxx
xxx.xxx

xxxxxxx
x.x.x.x
xxxxxxx
x.x.x.x
xxxxxxx


