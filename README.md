> Bring your Perl 6 workflow to the next level!

<div align="center">
  <a href="http://github.com/madcapjake/p6dx">
    <img width=250px src="https://raw.githubusercontent.com/MadcapJake/p6dx/master/workout-camelia.png">
  </a>
</div>
<br>

## About

_P6Dx_ provides a platform for leveraging language workflow tools in any text editor.  The included `p6dx` bin script provides several flags with easy access to:

  * Code completions (per file, per package, even required packages)
  * Syntax checking (cascading rule declarations)
  * And more? (Code coverage? ctags? let me know!)

## Usage
### Install

```
panda install p6dx
```
```
zef install p6dx
```
### Config

Mostly TBD.  You will be able to specify syntax rules in either a user's home folder, the project's base path, a manually supplied file, or via a special comment syntax.

### Command Line
```shell
p6dx # displays help
p6dx -d $file_or_dir "$part_of_string" # completions
p6dx -x $file_or_dir # syntax check
```

### Editors

Currently no editors are using P6Dx, however after I've finalized some of this I plan to integrate this into `linter-perl6` for Atom Editor and then I'll try my hand at writing a Gedit plugin.

# Contributing

I'm gonna try and keep some high-level issues for each feature.  Right now, I mostly need help hashing out conventions and solving bugs in my really early code.  Feel free to submit PRs too though!

# Ideas

  * code coverage
  * ctags generation
  * code formatter

# Acknowledgements

* [Camelia](https://github.com/perl6/mu/blob/master/misc/camelia.txt)
* [Kettlebell by TMD from the Noun Project](https://thenounproject.com/term/kettlebell/253682)
