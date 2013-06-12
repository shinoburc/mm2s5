## mm2s5

mm2s5 is [FreeMind](http://freemind.sourceforge.net/wiki/index.php/Main_Page) to [S5 slide show](http://meyerweb.com/eric/tools/s5/) converter.

## Requirements

 * perl module 
   * XML::Simple (sudo apt-get install libxml-simple-perl)
 * comman for setup-s5.sh (you can setup s5 manually. reference setup-s5.sh.)
   * wget
   * unzip 

## install

1. Check out mm2s5

  ~~~ sh
  $ git clone git://github.com/shinoburc/mm2s5
  ~~~

2. Setup s5

  ~~~ sh
  $ cd mm2s5
  $ ./setup-s5.sh
  ~~~

## Convert Freemind to S5

  ~~~ sh
  $ ./mm2s5.pl mm2s5.mm > s5/test.html

  open s5/test.html in web browser.

  (Linux) s5/test.html
  $ xdg-open s5/test.html
  or
  $ gnome-open s5/test.html

  (Mac OS X)
  $ open s5/test.html
  ~~~

convert your original Freemind.

  ~~~ sh
  $ ./mm2s5.pl YOURFREEMIND.mm > s5/YOURFREEMIND.html
  open s5/YOURFREEMIND.html in web browser.
  ~~~

Have fun!

