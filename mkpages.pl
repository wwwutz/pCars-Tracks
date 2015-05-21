#!/usr/bin/perl -w
use Data::Dumper;

my $x = 0;
my $y = 0;
my $dx = 256;
my $dy = 256;

my @LOCATIONS;
open I,'<','tracks.data' or die "$?: $!";
while (<I>) {
    /^\-/ and next; # skip tracks
    /^\s*$/ and next;
    chomp;
    
    my ($f) = split(/\//,$_);
    push @LOCATIONS,$f;
}
close I;

@LOCATIONS = sort { rand(1) > 0.5 } @LOCATIONS;

for ( my $i=0; $i < @LOCATIONS; $i++) {
  my $j = rand(@LOCATIONS);
  my ($a,$b) = ( $LOCATIONS[$i], $LOCATIONS[$j] );
  ( $LOCATIONS[$i], $LOCATIONS[$j] ) = ( $b, $a );
}

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

exit;

sub incgra {
  my ($x, $y, $tp) = @_;
  print "### [$tp] $LOCATIONS[$tp] $x / $y\n";
  my $tx = int ($x * 0.1171875);
  my $ty = int ($y * 0.1171875) + 0;
  print O '\begin{textblock*}{30mm}('.$tx.'mm,'.$ty.'mm)%'."\n";
  print O '\includegraphics[width=30mm]{LG/'.$LOCATIONS[$tp].'}'."\n";
  print O '\end{textblock*}'."\n";
}


__DATA__
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


