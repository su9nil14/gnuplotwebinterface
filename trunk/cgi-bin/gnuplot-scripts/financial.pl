#!/usr/bin/perl
use strict;
use warnings;

use lib "./gnuplot-scripts";
use Common;

my $company = shift or die "no company";
my $mode = shift or die "no mode";
my $start_date = shift or die "no start date";
my $end_date = shift or die "no end date";

my $png = Common->new->gnuplot_png_settings();
my $time_series = Common->new->gnuplot_timeseries_settings();


my $plot_cmd = get_plot_cmd($company, $mode, $start_date, $end_date);

print "
  $png
  $time_series
  $plot_cmd
";




sub get_plot_cmd {
  my $company = shift or die "no company";
  my $mode = shift or die "no mode";
  my $start_date = shift or die "no start date";
  my $end_date = shift or die "no end date";

  my $company_file = get_company_file($company) or die "no company file";

  my $title = get_title($company, $mode) or die "no title";
  my $style = get_style($mode) or die "no style";

  my $fields = get_fields($mode);

  return   "plot [\"$start_date\":\"$end_date\"] 'data/$company_file' using $fields with $style title $title";
}


sub get_company_file {
  my $company = shift or die "no company";

  return "ibm.dat" if $company eq "ibm";
  return "cisco.dat" if $company eq "cisco";
  die "no company file for company: $company";

}

sub get_title {
  my $company = shift or die "no company";
  my $mode = shift or die "no mode";

  return "\"$company opening prices\"" if $mode eq 'points';
  return "\"$company daily prices\"" if $mode eq 'candles';
  die "bad mode: $mode";
}

sub get_fields {
  my $mode = shift or die "no mode";
  return '1:2' if $mode eq 'points';
  return '1:($2+$3+$4+$5)/4:4:3' if $mode eq 'candles';
  die "bad mode: $mode";
}

sub get_style {
  my $mode = shift or die "no mode";
  return "linespoints" if $mode eq 'points';
  return "yerrorbars" if $mode eq 'candles';
  die "bad mode: $mode";
}
