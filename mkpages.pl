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
   s/\015?\012/\n/g;
    chomp;
    /^\s*$/ and next;
    if (/^\-(.*)/) {
      my ($f,$trackid,@r) = split(/\//,$1);
      map { $TRACKS->{$loc}->{$trackid}->{$_} = shift @r } qw( name type miles turns year size );
      $TRACKS->{$loc}->{$trackid}{img} = $f;
      my ($l,$m) = $TRACKS->{$loc}->{$trackid}->{miles} =~ m/(\d+\.\d+)(m?)/;
      my ( $km, $mi );
      if ($m eq 'm') {
        $mi = $l;
        $km = $mi * 1.609344;
      }
      else {
        $l = $l / 1000;
        $km = $l;
        $mi = $l / 1.609344;
      }
      $TRACKS->{$loc}->{$trackid}->{km} = sprintf("%0.2f",$km);
      $TRACKS->{$loc}->{$trackid}->{mi} = sprintf("%0.2f",$mi);
      die "$_" unless defined($TRACKS->{$loc}->{$trackid}->{size});
    }
    else {
      my ($f,$nada,$location,$country) = split(/\//,$_);
      $LOCATIONS->{$location}->{img} = $f;
      $LOCATIONS->{$location}->{country} = $country;
      $lc++;
#      if ( $location eq '' ) {print "\n[[$.:$_]]\n"};
      $loc = $location;
    }
}
close I;

# @LOCATIONS = sort { rand(1) > 0.5 } @LOCATIONS;
my @LOCATIONS = sort { rand(1) > 0.5 } keys %{$LOCATIONS};

print Dumper(\$LOCATIONS);
print Dumper(\@LOCATIONS);

for ( my $i=0; $i < @LOCATIONS; $i++) {
  my $j = rand(@LOCATIONS);
  my ($a,$b) = ( $LOCATIONS[$i], $LOCATIONS[$j] );
  ( $LOCATIONS[$i], $LOCATIONS[$j] ) = ( $b, $a );
}
#print "XXX\n";
#print Dumper(\@LOCATIONS);

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
 'C' => '\huge$\circlearrowleft$',
 'P' => 'A $\rightsquigarrow$ B',
 'K' => '$\circledcirc\llcorner^{\rightthreetimes}\circledcirc$',
);
open O,'>','all-tracks.tex' or die "$?:$!";
my $r = 3;
my $c = 0;
my $bs = 80;
my ($x1,$y1) = (15,10);
my $printlogo = 1;
my %PAGE;
my $page=2; # page before tracks
for my $loc (sort @LOCATIONS) {
  my $printlogo = 1;
  for my $trackid ( sort keys %{$TRACKS->{$loc}} ) {
    my $track = $TRACKS->{$loc}->{$trackid}->{name};

    $page++;
    $PAGE{$trackid} = $page;
    $r = $c = 0;
    # logo
    printf O "\\begin{textblock*}{%dmm}(%dmm,%dmm)%%\n",50, $x1, $y1;
    printf O "\\includegraphics[width=%dmm]{LG/%s}\n",50,$LOCATIONS->{$loc}->{img};
    print  O "\\end{textblock*}\n";

    # title
    printf O "\\begin{textblock*}{%dmm}(%dmm,%dmm)%%\n",130, $x1+55, $y1;
    printf O "{\\fontsize{20}{20}\\selectfont %s\\\\}\n",$track;
    printf O "{\\fontsize{16}{16}\\selectfont %s\\hfill %s\\\\}\n",$loc,$TYPEMAP{$TRACKS->{$loc}->{$trackid}->{type}};
    printf O "{\\fontsize{12}{12}\\selectfont %s\\\\}\n",$LOCATIONS->{$loc}->{country};
    print  O "\\end{textblock*}\n";
    
    my $wd = 185; my $ht = 210;
    printf O "\\begin{textblock*}{%dmm}(%dmm,%dmm)%%\n",$wd,( $x1 ),($y1+55 );
    print  O "\\centering\n";
    printf O "\\mbox{\\includegraphics[width=%dmm,height=%dmm,keepaspectratio]{PT/%s.pdf}}\n", $wd, $ht, $trackid;
    print  O "\\end{textblock*}\n";
    
    printf O "\\begin{textblock*}{%dmm}(%dmm,%dmm)%%\n",40,( $x1 + 60 + $bs + 5 ),($y1 + 20);
    print  O "\\Large\n";
    printf O "\\par\$\\mapsto\$ %s mi.\n",$TRACKS->{$loc}->{$trackid}->{mi};
    printf O "\\par\$\\mapsto\$ %s km\n",$TRACKS->{$loc}->{$trackid}->{km};
    printf O "\\par\$\\looparrowright\$ %s\n",$TRACKS->{$loc}->{$trackid}->{turns};
    printf O "\\par\\hfill\\tiny\\tt %s\\\\\n",$trackid;
    print  O "\\end{textblock*}\n";

    printf O "\\begin{textblock*}{%dmm}(%dmm,%dmm)%%\n",20,200,5;
    printf O "\\fbox{\\thepage}\n";
    printf O "\\phantomsection\\label{$trackid}\n";
    print  O "\\end{textblock*}\n";
    printf O "\\begin{textblock*}{%dmm}(%dmm,%dmm)%%\n",20,200,285;
    printf O "\\fbox{\\thepage}\n";
    print  O "\\end{textblock*}\n";
    print  O "\n\\null\\newpage\n";
  }
}
close O;

open O,'>','all-toc.tex' or die "$?:$!";


print O "\\begin{compactitem}\n";
for my $loc (sort @LOCATIONS) {
  printf O "\\item $loc\n";
  print O " \\begin{compactitem}\n";
  for my $trackid ( sort keys %{$TRACKS->{$loc}} ) {
    print O " \\item \\hyperref[$trackid]{$TRACKS->{$loc}->{$trackid}->{name}\\dotfill}";
    print O " \$\\mapsto\$\\makebox[12mm][r]{$TRACKS->{$loc}->{$trackid}->{km}}\\,km / \n";
    print O " \\makebox[12mm][r]{$TRACKS->{$loc}->{$trackid}->{mi}}\\,mi \n";
    print O " \\makebox[10mm][r]{$TRACKS->{$loc}->{$trackid}->{turns}} \$\\looparrowright\$ \n";
    print O " \\makebox[15mm][c]{$TYPEMAP{$TRACKS->{$loc}->{$trackid}->{type}}}";
    print O " \\makebox[10mm][r]{\\pageref{$trackid}}\n";
  }
  print O " \\end{compactitem}\n";
}
print O "\\end{compactitem}\n";
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
x.xxx.x
x.x.x.x
x.x.x.x
xxx.xxx

xxxxxxx
x.....x
x.....x
x.....x
x.....x
.xxxxx.
.xxxxx.
.xxxxx.
x.x.x.x



xxxxxxx
x.....x
x.....x
x.....x
x.....x
xx.x.xx
x.x.x.x
xx.x.xx
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


