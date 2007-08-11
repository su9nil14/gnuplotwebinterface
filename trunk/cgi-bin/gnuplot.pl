#!/usr/bin/perl -wt
use strict;
use warnings;

use CGI qw/:standard/;
use CGI::Carp qw(fatalsToBrowser);

my $mode = param( 'mode' ) or die "no mode";

my $DEBUG=0;

$ENV{"PATH"} = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/bin/X11";

my $host="64.22.71.11";
my $virtualdir="gnuplot/tmp";

my $outdir="../html/tmp";
my $outpng = "plot.png";

my $pngfile = "$outdir/$outpng";

my $ploturl="http://$host/$virtualdir/$outpng";

my $gnuplotScriptDir="gnuplot-scripts";
my $gnuplotScript="$gnuplotScriptDir/save-ibm-stock-price.plt";

# need to install these? on deb/utuntu
# ps2image: apt-get hyperlatex
# gnuplot: apt-get gnuplot

system("./clean.sh");
my $plot_cmd= get_plot_command($mode);

die "plot cmd: $plot_cmd\n" if $DEBUG;

system($plot_cmd);
print CGI->new->redirect("$ploturl");


# shell command to gnuplot
sub get_plot_command {
  my $mode = shift or die "no mode";

  if ( $mode =~ /math/ ) {
    my $function = param( 'thebox' ) or die "no function";
    return "$gnuplotScriptDir/plot_f_of_x.pl $mode \"$function\" | gnuplot > $pngfile ";
  }
  if ( $mode =~ /financial/ ) {
    my $company = param('company') or die "no company";
    my $mode = param('plot-style') or die "no mode";
    my $start_date = param('startdate') or die "no start date";
    my $end_date = param('enddate') or die "no end date";

    return "$gnuplotScriptDir/financial.pl $company $mode $start_date $end_date | gnuplot > $pngfile ";
  }

  die "bad mode: $mode";

}













