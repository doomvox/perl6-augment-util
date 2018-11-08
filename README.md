NAME
====

Augment::Util - utilities to work with the augment feature

SYNOPSIS
========

    use Augment::Util;
    use MONKEY-TYPING;

    my @array = <aaa bbb ccc>;

    augment class Any {
        method hiccup {
            say "hic!";
        }
        Augur.recompose_core;
    }

    @array.hiccup; # hic!

DESCRIPTION
===========

This module makes the `Augur` class available, which provides methods useful for working with the perl6 "augment" feature:

  * `recompose_core` runs the ".^compose" method on everything defined in CORE.

  * `inside_repl` checks if runnning inside the repl

This covers for a known bug in the use of augment: you can use it to add methods to a class, and they *should* be automatically visible in all child classes, but often are not because the augment can't effect things that were created before you made the change... unless you run the ".^compose" method on them, to force a re-initialization.

Someday the need for `recompose_core` will probably go away once this bug has been addressed, but for now it's a useable workaround.

Another issue with augment is that it's use is strongly discouraged because it's the kind of thing that works fine once, but when it's being used a lot by many people there are potential conflicts. Don't do it unless you know what you're doing, and even then...

MOTIVATION
==========

I'm after a way to make the Object::Examine method "menu" readily available in my repl sessions, without needing to manually add a role to anything I'd like to run it on.

NOTES
=====

The Mystery Line
----------------

There is a line in this code marked with the comment "The Mystery Line", which looks like it shouldn't do anything, but without it (or something like it) I've seen this code crash with errors like:

    ===SORRY!===
    Cannot look up attributes in a VMNull type object

The Mystery Line does a gist call and does nothing with the response:

    my $nada = $type_object.gist;

Presumbably what's going on is the code for ".gist" is better excercised than ".^compose", and does a better job of checking for problems and throwing a trappable error, .e.g. if the methods are being called on an NQP object.

See this discussion by Brandon Allerby:

    https://www.mail-archive.com/perl6-users@perl.org/msg06266.html

AUTHOR
======

Joseph Brenner, doomvox@gmail.com

COPYRIGHT AND LICENSE
=====================

Copyright (C) 2018 by Joseph Brenner

Released under "The Artistic License 2.0".
