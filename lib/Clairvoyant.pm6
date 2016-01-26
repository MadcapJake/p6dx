unit module Clairvoyant;

use File::Find;

sub modules(Str:D $dir) {
  find( :dir($dir), :type('file'), :name(rx!(\.p[m|l]?6?)$!) )».IO.flat.list;
}

sub local-modules {
  modules: '.';
}

sub meta-info($depth = 2) is export {
  for [0..$depth] -> $i {
    if find(
      :dir('.' ~ '/..' x $i),
      :type('file'),
      :name( /META\.info|META6.json/ )
    ) -> $meta-file { return from-json slurp $meta-file }
  }
}
