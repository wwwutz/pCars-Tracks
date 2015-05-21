#!/usr/bin/perl -w
use Data::Dumper;

my $x = 0;
my $y = 0;
my $dx = 256;
my $dy = 256;

my @TRACKS;
open I,'<','tracks.data' or die "$?: $!";
while (<I>) {
    chomp;
    my ($f) = split(/\//,$_);
    push @TRACKS,$f;
}
close I;
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
  print "### [$tp] $TRACKS[$tp] $x / $y\n";
  my $tx = int ($x * 0.1171875);
  my $ty = int ($y * 0.1171875) + 150;
#  print O '\begin{textblock*}{\Logo}('.$tx.'mm,'.$ty.'mm)%'."\n";
#  print O '\includegraphics[width=\Logo]{LG/'.$TRACKS[$tp].'}'."\n";
  print O '\begin{textblock*}{30mm}('.$tx.'mm,'.$ty.'mm)%'."\n";
  print O '\includegraphics[width=30mm]{LG/'.$TRACKS[$tp].'}'."\n";
  print O '\end{textblock*}'."\n";
}


__DATA__
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


