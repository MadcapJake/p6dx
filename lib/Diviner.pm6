unit module Diviner;

grammar Divinations {

  regex Symbol {
    <:Letter><:Letter + :Number + [ _ \- : ]>*
  }

  regex PackedSymbol {
    <Symbol>['::'<Symbol>]*
  }

  token TOP {
    ^ <module> | <class> | <role> | <sub> | <method> | <variable> $
  }

  token module {
    \s* [unit \s+]? module \s+ (<PackedSymbol>)
  }

  token class {
    \s* [unit \s+]? class \s+ (<PackedSymbol>)
  }

  token role {
    \s* role \s+ (<PackedSymbol>)
  }

  token sub {
    \s* [multi \s+]? sub \s+ (<Symbol>)
  }

  token method {
    \s* [multi \s+]? method \s+ (<Symbol>)
  }
}

class Spells {
  has $
}
