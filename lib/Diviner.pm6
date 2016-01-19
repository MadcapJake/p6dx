unit module Diviner;

use File::Find;

grammar Divinants {

  regex Symbol {
    <:Letter>
    [
    |<[ ' - ]><?before <:Letter>>
    |<:Letter + :Number + [ _ : ]>
    ]*
    [ <?after ':'> <-[ { ( ]>+ <?before \s* <[ { ( ]> > ]?
  }

  regex PackedSymbol {
    <Symbol>['::'<Symbol>]*
  }

  token TOP { [ <line> <nl>? ]+ }

  token line {
    ^^
    [
    | <module>
    | <class>
    | <role>
    | <named-re>
    | <sub>
    | <method>
    | <variable>
    ]?
    <gibberish>?
    $$
  }

  token nl { \n }

  token gibberish { <-[\n]>+ }

  token module {
    \s* [unit \s+]? module \s+ <PackedSymbol>
  }

  token class {
    \s* [unit \s+]? class \s+ <PackedSymbol>
  }

  token role {
    \s* role \s+ <PackedSymbol>
  }

  token named-re {
    \s* (regex|rule|token) \s+ <PackedSymbol>
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

class Completion {
  has $.file;
  has $.name;
  has $.kind;
  has $.line;

  method infix:<cmp>(Completion:D $a, Completion:D $b) {
    $a.name <=> $b.name;
  }
}

class Divinations {

  has $.file;
  has $!ln = 1;

  method nl($/ is copy) { $!ln++ }

  method module($/ is copy) {
    take Completion.new(
      file => $!file,
      name => $<PackedSymbol>.Str,
      kind => 'module',
      line => $!ln
    )
  }

  method class($/ is copy) {
    take Completion.new(
      file => $!file,
      name => $<PackedSymbol>.Str,
      kind => 'class',
      line => $!ln
    )
  }

  method role($/ is copy) {
    take Completion.new(
      file => $!file,
      name => $<PackedSymbol>.Str,
      kind => 'role',
      line => $!ln
    )
  }

  method named-re($/ is copy) {
    take Completion.new(
      file => $!file,
      name => $<PackedSymbol>.Str,
      kind => $0.Str,
      line => $!ln
    )
  }

  method sub($/ is copy) {
    take Completion.new(
      file => $!file,
      name => $<Symbol>.Str,
      kind => 'sub',
      line => $!ln
    )
  }

  method method($/ is copy) {
    take Completion.new(
      file => $!file,
      name => $<Symbol>.Str,
      kind => 'method',
      line => $!ln
    )
  }

  method variable($/ is copy) {
    take Completion.new(
      file => $!file,
      name => ($0 ~ $<Symbol>.Str),
      kind => 'variable',
      line => $!ln
    )
  }

}

my @files = find( :dir('.'), :type('file'), :name(rx!(\.p[m|l]?6?)$!) )».IO.flat.list;
my @completions;

for @files -> $io {
  my $file = $io.absolute.Str;
  my $text = slurp($file);
  @completions = gather Divinants.parse($text, :actions(Divinations.new( :$file )));
}

for @completions { .say }
