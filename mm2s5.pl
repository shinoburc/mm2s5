#!/usr/bin/perl -w
#
# FreeMind(mm) to S5 HTML converter
# Have fun!
# 
# $Id: mm2s5.pl 58 2008-11-12 22:55:05Z dot $
#
# Usage: perl mm2s5.pl FILE1.mm > FILE2.html
# 
use strict;
use XML::Simple;
use File::Copy 'copy';
use File::Basename;
use Data::Dumper;

&printUsageAndExit() if (@ARGV != 1);
&printS5(%{XML::Simple->new()->XMLin($ARGV[0])});

sub printS5(%){
  my %mm = @_;
  die "cannot parse mm format.\n" if !&hasChildren(%mm) or !&hasText(%{$mm{node}});

  my $title = $mm{node}{TEXT};

  &printS5Header($title);
  &printS5Layout($title);
  &printTopOfSlide($title);
  &printSlides(%mm);
  &printS5Footer;
}

sub printTopOfSlide($){
  my $title = shift;

  print &startSlide;
  print &heading($title);
  print &endSlide;
}

sub printSlides(%){
  my %mm = @_;
  return if (ref($mm{node}{node}) ne 'ARRAY');

  print &startPresentation;
  foreach (@{$mm{node}{node}}){
    &printSlide(%$_);
  }
  print &endPresentation;
}

sub printSlide(%){
  my %mm = @_;

  print &startSlide;
  print &heading($mm{TEXT}) if &hasText(%mm);
  &printItems(%mm) if &hasChildren(%mm);
  print &endSlide;
}

sub printItems(%){
  my %mm = @_;

  print &startItems;
  if(ref($mm{node}) eq 'ARRAY'){
    foreach (@{$mm{node}}){
      &printItem(%$_);
    }
  } elsif(ref($mm{node}) eq 'HASH'){
    &printItem(%{$mm{node}});
  } else {
    die "cannot parse mm format.\n";
  }
  print &endItems;
}

sub printItem(%){
  my %mm = @_;

  print &item(%mm) if &hasText(%mm);
  print &richcontent(%mm) if &hasRichContent(%mm);
  &printItems(%mm) if (&hasChildren(%mm));
}

sub hasChildren(%){
  my %mm = @_;
  return defined($mm{node});
}

sub hasText(%){
  my %mm = @_;
  return defined($mm{TEXT});
}

sub hasIcon(%){
  my %mm = @_;
  return defined($mm{icon});
}

sub hasRichContent(%){
  my %mm = @_;
  return defined($mm{richcontent}{html}{body}{img}{src});
}

sub imageCopy($){
  my $file = shift;

  copy $file, "s5/images/" . basename($file);
}

sub startPresentation(){
  return '<!-- start of presentation -->' . "\n" . '<div class="presentation">' . "\n\n";
}

sub endPresentation(){
  return '</div>' . "\n" . '<!-- end of presentation -->' . "\n\n";
}

sub startSlide(){
  return '<div class="slide">' . "\n";
}

sub endSlide(){
  return '</div>' . "\n\n";
}

sub startItems(){
  return '<ul>' . "\n";
}

sub endItems(){
  return '</ul>' . "\n";
}

sub heading($){
  my $str = shift;
  return '<h1>' . $str . '</h1>' . "\n";
}

sub item($){
  my %mm = @_;

  if(&hasIcon(%mm)){
    return '  <li style="background:url(images/icons/' . $mm{icon}{BUILTIN} . '.png); background-repeat: no-repeat; list-style: none; padding: 0 0 0 17px;">' . $mm{TEXT} . '</li>' . "\n";
  } else {
    return '  <li>' . $mm{TEXT} . '</li>' . "\n";
  }
}

sub richcontent($){
  my %mm = @_;

  &imageCopy($mm{richcontent}{html}{body}{img}{src});
  return "<img src='images/" . basename($mm{richcontent}{html}{body}{img}{src}) . "' />";
}


sub printS5Layout($){
  my $title = shift;

  print << "END_OF_LAYOUT";

    <div class="layout">
      <div id="controls"><!-- DO NOT EDIT --></div>
      <div id="currentSlide"><!-- DO NOT EDIT --></div>
      <div id="header"></div>

      <div id="footer">
        <h1>$title</h1>
      </div>
    </div>

END_OF_LAYOUT
}

sub printS5Header($){
  my $title = shift;
  print << "END_OF_HEADER";

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

        <html xmlns="http://www.w3.org/1999/xhtml">

        <head>
        <title>$title</title>
        <!-- metadata -->
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <meta name="generator" content="Presentacular_S5_scriptaculous" />
        <meta name="version" content="S5 1.1" />
        <meta name="presdate" content="20071221" />
        <meta name="author" content="Juan Manuel Caicedo" />

        <!-- configuration parameters -->
        <meta name="defaultView" content="slideshow" />
        <meta name="controlVis" content="hidden" />
        <!-- style sheet links -->
        <link rel="stylesheet" href="ui/default/slides.css" type="text/css" media="projection" id="slideProj" />
        <link rel="stylesheet" href="ui/default/outline.css" type="text/css" media="screen" id="outlineStyle" />
        <link rel="stylesheet" href="ui/default/print.css" type="text/css" media="print" id="slidePrint" />
        <link rel="stylesheet" href="ui/default/opera.css" type="text/css" media="projection" id="operaFix" />

        <!-- S5 JS -->
        <script src="ui/default/slides.js" type="text/javascript"></script>

        <!-- Presentacular theme -->
        <link rel="stylesheet" href="presentacular.css" type="text/css" />

        <!-- prototype + scriptaculous -->
        <script src="prototype/prototype.js" type="text/javascript"></script>
        <script src="scriptaculous/scriptaculous.js" type="text/javascript"></script>
        <!-- Presentaculous JS -->
        <script src="presentacular.js" type="text/javascript"></script>

        </head>
        <body>


END_OF_HEADER
}

sub printS5Footer(){
  print << "END_OF_FOOTER";
    </body>
    </html>
END_OF_FOOTER
}

sub printUsageAndExit(){
    die "perl mm2s5.pl FILE1.mm > FILE2.html\n";
}
