use strict;
use warnings;

# From comments in chansort_configurable.pl
sub {
    # We sort the "(status) window first before anything else
    ($b->{name} eq "(status)") <=> ($a->{name} eq "(status)")
    ||
    # Cluster chatnets alphabetically
    $a->{chatnet} cmp $b->{chatnet}
    ||
    # Put nickserv query first
    ($b->{name} =~ "nickserv") <=> ($a->{name} =~ "nickserv")
    ||
    # Put & channels like &bitlbee before normal channels
    ($b->{name} =~ /^&/) <=> ($a->{name} =~ /^&/)
    ||
    # We want "CHANNEL" at the beginning and "QUERY" at the end
    $a->{type} cmp $b->{type}
    ||
    # Default to sorting alphabetically
    $a->{name} cmp $b->{name}
};
