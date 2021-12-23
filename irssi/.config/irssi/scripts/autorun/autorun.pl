use strict;
use warnings;
use Irssi;

# Specify autorun scripts through this script. This way, it is easier to
# manage dotfiles syncing since it's text instead of symlinks.

my @scripts = (
    '/usr/share/irssi/scripts/adv_windowlist.pl',
    '/usr/share/irssi/scripts/chansort_configurable.pl',
    '/usr/share/irssi/scripts/mouse.pl',
    '/usr/share/irssi/scripts/nickcolor.pl',
    '/usr/share/irssi/scripts/tmux-nicklist-portable.pl',
    '/usr/share/irssi/scripts/trackbar.pl',
    '/usr/share/irssi/scripts/usercount.pl',
);

foreach my $s (@scripts) {
    Irssi::command("script load $s");
    print "Script $s loaded.";
}
