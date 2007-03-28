#!/usr/bin/perl
use strict;
use warnings;

use lib "./gnuplot-scripts";
use Common;

my $mode = shift or die "no mode";
my $function = shift or die "no function";

my $png_settings = Common->new->gnuplot_png_settings();
my $math_settings = Common->new->gnuplot_math_settings();
my $plot_cmd = get_plot_cmd($mode, $function);

print "
$png_settings
$math_settings
$plot_cmd
";

sub get_plot_cmd {
  my $mode = shift or die "no mode";
  my $function = shift or die "no function";

  return "plot $function" if $mode eq 'math-2d';
  return "splot $function" if $mode eq 'math-3d';
  die "bad mode: $mode";
}
