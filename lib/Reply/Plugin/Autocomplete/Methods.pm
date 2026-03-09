package Reply::Plugin::Autocomplete::Methods;
use strict;
use warnings;
# ABSTRACT: tab completion for methods

use base 'Reply::Plugin';

use Scalar::Util 'blessed';

use Reply::Util qw($ident_rx $fq_ident_rx $fq_varname_rx methods);

=head1 SYNOPSIS

  ; .replyrc
  [ReadLine]
  [Autocomplete::Methods]

=head1 DESCRIPTION

This plugin registers a tab key handler to autocomplete method names in Perl
code.

=cut

sub tab_handler {
    my $self = shift;
    my ($line) = @_;

    my ($invocant, $method_prefix) = $line =~ /($fq_varname_rx|$fq_ident_rx)->($ident_rx)?$/;
    return unless $invocant;
    # XXX unicode
    return unless $invocant =~ /^[\$A-Z_a-z]/;

    $method_prefix = '' unless defined $method_prefix;

    my $class;
    if ($invocant =~ /^\$/) {
        my $env = {
            global_environment($invocant),
            map { %$_ } $self->publish('lexical_environment'),
        };

        my $var = $env->{$invocant};
        return unless $var;

        if (ref($var) eq 'REF' && blessed($$var)) {
            $class = blessed($$var);
        }
        elsif (ref($var) eq 'SCALAR') {
            $class = $$var;
        }
        else {
            return;
        }
    }
    else {
        $class = $invocant;
    }

    my @results;
    for my $method (methods($class)) {
        push @results, $method if index($method, $method_prefix) == 0;
    }

    return sort @results;
}

sub global_environment {
    my ($fq_symbol) = @_;

    my ($sigil, $fq_name) = $fq_symbol =~ /^(.)(.*)/;
    return unless defined $sigil;

    my @parts = split /::/, $fq_name;
    return if grep /:/, @parts;
    my $varname    = pop @parts;
    my $symbol     = $sigil . $varname;
    my $stash_name = @parts ? join '::', @parts : 'main';

    my $stash = Package::Stash->new($stash_name);
    return unless $stash->has_symbol($symbol);
    my $value = $stash->get_symbol($symbol);
    return $fq_symbol => $value;
}
1;
