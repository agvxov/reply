#!/usr/bin/perl
# This meta-script is for autogenerating README.md from lib/Reply.pm

# Init
use File::Slurp 'slurp';
my $pod = slurp('lib/Reply.pm');
#my $out = \*STDOUT;
open my $out, '>', 'README.md';

# Replace unknown directives
$pod =~ s/^=method/=head1/gm;

# Pod -> MD
use Pod::Markdown;
my $parser = Pod::Markdown->new;
$parser->output_fh($out);
$parser->parse_string_document($pod);
