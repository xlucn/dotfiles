# based on mouse.pl from irssi scripts
use strict;
use Irssi qw(signal_stop signal_add_first);

my $INDEX_NOOP = -1;
my $INDEX_BUTTON = 0;
my $INDEX_MAX = 3;
my $index = $INDEX_NOOP;

signal_add_first("gui key pressed", sub {
    my ($key) = @_;
    if ($index != $INDEX_NOOP) {
        if ($index == $INDEX_BUTTON) {
            if ($key - 32 == 64) {
                Irssi::command("/scrollback goto -10");
            } elsif ($key - 32 == 65) {
                Irssi::command("/scrollback goto +10");
            }
        }
        $index ++;
        if ($index == $INDEX_MAX) {
            $index = $INDEX_NOOP;
        }
        # do not pollute the command line
        signal_stop();
    }
});

sub UNLOAD {
    print STDERR "\e[?1000l"; # stop tracking
}

Irssi::command_bind("mouse_xterm", sub { $index = 0; });

print STDERR "\e[?1000h"; # start tracking
