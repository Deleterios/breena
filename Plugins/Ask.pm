﻿package Plugins::Ask;
use strict qw(subs vars refs);
use warnings;
use POE;
use POE::Component::IRC::Plugin qw( :ALL );

my ($dirpath) = (__FILE__ =~ m{^(.*/)?.*}s);

# Plugin object constructor
sub new
{
    my ($package) = shift;
    return bless {}, $package;
}

sub PCI_register
{
    my ($self, $irc) = splice @_, 0, 2;
    $irc->plugin_register($self, 'SERVER', qw(public));
    return 1;
}

sub PCI_unregister
{
    return 1;
}

sub S_public
{
    my ($self, $irc) = splice @_, 0, 2;

# Parameters are passed as scalar-refs including arrayrefs.
    my ($who)    = (split /!/, ${$_[0]})[0];
    my ($channel) = ${$_[1]}->[0];
    my ($msg)     = ${$_[2]};

    if ($msg =~ /^\.ask (.*) or (.*)/i)
    {
        my $nb = int(rand(100)%2);
        if($nb == 0)
        {
            $irc->yield(privmsg => $channel => $who.": ".$1);
        }
        else
        {
            $irc->yield(privmsg => $channel => $who.": ".$2);
        }
        return PCI_EAT_PLUGIN;    # We don't want other plugins to process this
    }
    return PCI_EAT_NONE; # Default action is to allow other plugins to process it.
}

1;
