#                                doom@kzsu.stanford.edu
#                                25 Oct 2018

use Symbol::Scan;
class Augur {
    method in_repl {
        # checking ($*PROGRAM-NAME eq 'interactive') is also good,
        # but could be confused by a script named 'interactive'
        return ($?FILE eq '<unknown file>');
    }

    method recompose_core {
        my @type_objects = SymbolScan.list_core_type_objects();
        for @type_objects -> $type_object {
            my $type_object_name = $type_object.^name;
            try {
                my $nada = $type_object.gist;  # The Mystery Line (see NOTES)
                $type_object.^compose;
                # If there's no ^compose method we want to skip to next type symbol object
                CATCH {
                    when X::Method::NotFound {
                        my $mess = .Str;
                        given $mess {
                            my $match = m/^No \s+ such \s+ method \s+ \' (.*?) \' \s+ for/; #'
                            when ( $match ) {
                                my $method = $match[0] || ''; 
                                given ($method) {
                                    when ('compose') {  }
                                    when ('gist')    {  }
                                    default {
                                        say "Unexpected complaint about no such method: $method"; 
                                    }
                                }
                            }
                            default {
                                say $mess;
                            }
                        }
                    }
                    when X::AdHoc {
                        say "known case: ", .Str;
                    }
                    default { say "DANGER: ", .^name, .Str }
                }
            }
        }
    }
}



=begin pod

=head1 NAME

Augment::Util - utilities to work with the augment feature

=head1 SYNOPSIS

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

=head1 DESCRIPTION

This module makes the C<Augur> class available, which provides methods
useful for working with the perl6 "augment" feature:

=item C<recompose_core> runs the ".^compose" method on everything
defined in CORE.

=item C<inside_repl>  checks if runnning inside the repl

This covers for a known bug in the use of augment: you can use
it to add methods to a class, and they *should* be automatically
visible in all child classes, but often are not because the
augment can't effect things that were created before you made
the change... unless you run the ".^compose" method on them, to
force a re-initialization.

Someday the need for C<recompose_core> will probably go away once
this bug has been addressed, but for now it's a useable workaround.

Another issue with augment is that it's use is strongly
discouraged because it's the kind of thing that works fine once,
but when it's being used a lot by many people there are potential
conflicts.  Don't do it unless you know what you're doing, and
even then...

=head1 MOTIVATION

I'm after a way to make the Object::Examine method "menu" readily
available in my repl sessions, without needing to manually add a
role to anything I'd like to run it on.

=head1 NOTES

=head2 The Mystery Line

There is a line in this code marked with the comment "The Mystery Line", 
which looks like it shouldn't do anything, but without it (or something like
it) I've seen this code crash with errors like:

   ===SORRY!===
   Cannot look up attributes in a VMNull type object

The Mystery Line does a gist call and does nothing with the response:

   my $nada = $type_object.gist;

Presumbably what's going on is the code for ".gist" is better
excercised than ".^compose", and does a better job of checking 
for problems and throwing a trappable error, .e.g. if the methods
are being called on an NQP object.

See this discussion by Brandon Allerby:

  https://www.mail-archive.com/perl6-users@perl.org/msg06266.html


=head1 AUTHOR

Joseph Brenner, doomvox@gmail.com

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2018 by Joseph Brenner

Released under "The Artistic License 2.0".

=end pod

