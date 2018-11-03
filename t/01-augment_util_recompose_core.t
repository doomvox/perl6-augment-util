use v6;

use Test;

use Augment::Util;
use MONKEY-TYPING;

my @array = <aaa bbb ccc>;

augment class Any {
  method hiccup {
    return "hic!";
  }
    Recomposer.recompose_core;
}

# say @array.hiccup; # hic!

my $ret = @array.hiccup;
is( $ret, "hic!", "Augmenting Any adds method visible on existing array." );
