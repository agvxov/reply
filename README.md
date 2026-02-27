# SYNOPSIS

    use Reply;

    Reply->new(config => "$ENV{HOME}/.replyrc")->run;

# DESCRIPTION

NOTE: This is an early release, and implementation details of this module are
still very much in flux. Feedback is welcome!

Reply is a lightweight, extensible REPL for Perl. It is plugin-based (see
[Reply::Plugin](https://metacpan.org/pod/Reply%3A%3APlugin)), and through plugins supports many advanced features such as
coloring and pretty printing, readline support, and pluggable commands.

# CONFIGURATION

Configuration uses an INI-style format similar to the configuration format of
[Dist::Zilla](https://metacpan.org/pod/Dist%3A%3AZilla). Section names are used as the names of plugins, and any options
within a section are passed as arguments to that plugin. Plugins are loaded in
order as they are listed in the configuration file, which can affect the
results in some cases where multiple plugins are hooking into a single callback
(see [Reply::Plugin](https://metacpan.org/pod/Reply%3A%3APlugin) for more information).

In addition to plugin configuration, there are some additional options
recognized. These must be specified at the top of the file, before any section
headers.

- script\_file

    This contains a filename whose contents will be evaluated as perl code once the
    configuration is done being loaded.

- script\_line<_n_>

    Any options that start with `script_line` will be sorted by their key and then
    each value will be evaluated individually once the configuration is done being
    loaded.

    NOTE: this is currently a hack due to the fact that [Config::INI](https://metacpan.org/pod/Config%3A%3AINI) doesn't
    support multiple keys with the same name in a section. This may be fixed in the
    future to just allow specifying `script_line` multiple times.

# new(%opts)

Creates a new Reply instance. Valid options are:

- config

    Name of a configuration file to load. This should contain INI-style
    configuration for plugins as described above.

- plugins

    An arrayref of additional plugins to load.

# run

Runs the repl. Will continue looping until the `read_line` callback returns
undef (typically when the user presses `Ctrl+D`), or the `loop` callback
returns false (by default, the `#q` command quits the repl in this way).

# step($line, $verbose)

Runs a single iteration of the repl. If `$line` is given, it will be used as
the string to evaluate (and the `prompt` and `read_line` callbacks will not
be called). If `$verbose` is true, the prompt and line will be displayed as
though they were typed. Returns true if the repl can continue, and false if it
was requested to quit.

# BUGS

No known bugs.

Please report any bugs to GitHub Issues at
[https://github.com/doy/reply/issues](https://github.com/doy/reply/issues).

# SEE ALSO

[Devel::REPL](https://metacpan.org/pod/Devel%3A%3AREPL)

# SUPPORT

You can find this documentation for this module with the perldoc command.

    perldoc Reply

You can also look for information at:

- MetaCPAN

    [https://metacpan.org/release/Reply](https://metacpan.org/release/Reply)

- Github

    [https://github.com/doy/reply](https://github.com/doy/reply)

- RT: CPAN's request tracker

    [http://rt.cpan.org/NoAuth/Bugs.html?Dist=Reply](http://rt.cpan.org/NoAuth/Bugs.html?Dist=Reply)

- CPAN Ratings

    [http://cpanratings.perl.org/d/Reply](http://cpanratings.perl.org/d/Reply)
