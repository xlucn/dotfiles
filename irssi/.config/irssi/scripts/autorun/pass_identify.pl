# pass_identify.pl
#
# This script automatically queries passwords from `pass` command and
# executes 'msg nickserv identify <password>' command for the current
# network.
#
# Requirement:
# `pass` from passwordstore.org
#
# Setup:
# Passwords has to be saved with `pass` in 'irc/<server>/<nickname>',
# where <irc_server> is the address of the IRC server, and <nickname>
# is the nickname the password belongs to.
#
# Additional setup:
# If you have to run other commands automatically after nickserv
# identify, you can add them directly below the password line by
# editing the password file with `pass edit` command.
# This script will run those commands in irssi every 5 seconds.
#
# Example:
#
# Irssi configuration:
#   servers = ( { address = "irc.libera.chat"; chatnet = "Libera"; } );
#   chatnets = { Libera = { type = "IRC"; nick = "yournick" }; };
#
# Password management:
#   $ pass show irc/irc.libera.chat/yournick
#   yourpass

use strict;
use warnings;
use Irssi;
use vars qw($VERSION %IRSSI);

$VERSION = '0.0.1';
%IRSSI = (
  authors     => 'Lu Xu',
  contact     => 'oliver_lew@outlook.com',
  name        => 'pass_identify',
  description => 'Automatically identify with nickserv.',
  license     => 'MIT',
);

sub nickserv_identify_with_pass {
    my ($server) = @_;
    my $address = "$server->{address}";
    my $nick = "$server->{nick}";
    my @passwords = qx{pass show irc/$address/$nick};

    # identify in irc with nickserv
    my $password = $passwords[0];
    $password =~ s/^\s+|\s+$//g;
    if (length($password) > 0) {
        $server->command("^msg nickserv identify $password");
    }

    # execute rest lines in pass output as commands
    foreach my $n (1..$#passwords) {
        my $cmd = $passwords[$n];
        Irssi::timeout_add_once(5000 * $n, sub {
            my ($server, $cmd) = @{$_[0]};
            $server->command($cmd);
        }, [$server, $cmd]);
    }
}

Irssi::signal_add_last('event connected', 'nickserv_identify_with_pass');
