package Common;
use strict;
use warnings;

sub new {
  my $package=shift;
  my $self={};
  bless $self, $package;
  return $self;
}

sub gnuplot_png_settings {
  my $self = shift or die "no object";
  return   "set terminal png transparent nocrop enhanced size 600,400
  set pm3d implicit at s";
}

sub gnuplot_math_settings {
  my $self = shift or die "no object";
  return "set border 4095
  set xlabel \"x\"
  set ylabel \"y\""
}

sub gnuplot_timeseries_settings {
  return 'set xdata time  	# The x axis data is time
  set timefmt "%d-%b-%y"	# The dates in the file look like 10-Jun-04
  set format x "%b %d"	# On the x-axis, we want tics like Jun 10'
}


1;
