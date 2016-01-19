unit module Diviner;

use File::Find;

grammar Divinants {

  regex Symbol {
    <:Letter>[<[ ' - ]><?before <:Letter>>|<:Letter + :Number + [ _ : ]>]*
  }

  regex PackedSymbol {
    <Symbol>['::'<Symbol>]*
  }

  token TOP { [<line> <nl>?]+ }

  token line {
    ^^
    [ <module>
    || <class>
    || <role>
    || <sub>
    || <method>
    || <variable>
    || <gibberish> ]?
    $$
  }

  token nl { \n? }

  token gibberish { <-[\n]>* }

  token module {
    \s* [unit \s+]? module \s+ <PackedSymbol>
  }

  token class {
    \s* [unit \s+]? class \s+ <PackedSymbol>
  }

  token role {
    \s* role \s+ <PackedSymbol>
  }

  token sub {
    \s* [multi \s+]? sub \s+ <Symbol>
  }

  token method {
    \s* [multi \s+]? method \s+ <Symbol>
  }

  token variable {
    \s* [my|our|has|state|temp|let] \s+ (<[ $ @ % & ]>)<Symbol>
  }
}

class Divinations {

  has $.file;
  has $!ln = 1;

  method nl($/ is copy) { say 'nl'; $!ln++ }

  method module($/ is copy) {
    take {
      file => $!file,
      name => $<PackedSymbol>.Str,
      kind => 'module',
      line => $!ln
    }
  }

  method class($/ is copy) {
    take {
      file => $!file,
      name => $<PackedSymbol>,
      kind => 'class',
      line => $!ln
    }
  }

  method role($/ is copy) {
    take {
      file => $!file,
      name => $<PackedSymbol>,
      kind => 'role',
      line => $!ln
    }
  }

  method sub($/ is copy) {
    take {
      file => $!file,
      name => $<Symbol>,
      kind => 'sub',
      line => $!ln
    }
  }

  method method($/ is copy) {
    take {
      file => $!file,
      name => $<Symbol>,
      kind => 'method',
      line => $!ln
    }
  }

  method variable($/ is copy) {
    take {
      file => $!file,
      name => $1 ~ $<Symbol>,
      kind => 'variable',
      line => $!ln
    }
  }

}

my @files = find( :dir('.'), :type('file'), :name(rx!(\.p[m|l]?6?)$!) )».IO.flat.list;
my @completions;

for @files -> $io {
  my $file = $io.absolute.Str;
  my $text = slurp($file);
  @completions.append: gather Divinants.parse($text, :actions(Divinations.new( :$file )));
}

say @completions;
