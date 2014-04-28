package Bot::Backbone::Bot;
{
  $Bot::Backbone::Bot::VERSION = '0.141180';
}
use v5.10;
use Moose;

use Bot::Backbone::Types qw( EventLoop ServiceList );
use POE qw( Loop::AnyEvent );

# ABSTRACT: Provides backbone services to your bot


has event_loop => (
    is          => 'ro',
    isa         => EventLoop,
    required    => 1,
    default     => 'POE::Kernel',
);


has services => (
    is          => 'ro',
    isa         => ServiceList,
    required    => 1,
    default     => sub { +{} },
    traits      => [ 'Hash' ],
    handles     => {
        add_service      => 'set',
        list_services    => 'values',
        destroy_services => 'clear',
        has_service      => 'defined',
        get_service      => 'get',
    },
);


sub bot { $_[0] }


sub construct_services {
    my $self = shift;

    my $my_name = $self->meta->name;

    for my $name ($self->meta->list_services) {
        my $service_config = $self->meta->services->{$name};
        next if defined $self->services->{$name};

        my $class_name = $service_config->{service};
        my $service = $class_name->new(
            %$service_config,
            name => $name,
            bot  => $self,
        );

        $self->add_service($name, $service);
    }
}


sub run {
    my $self = shift;

    $self->construct_services;
    $_->initialize for ($self->list_services);

    $self->event_loop->run;
}


sub shutdown {
    my $self = shift;

    $_->shutdown for ($self->list_services);
    $self->destroy_services;
}


__PACKAGE__->meta->make_immutable;

__END__

=pod

=head1 NAME

Bot::Backbone::Bot - Provides backbone services to your bot

=head1 VERSION

version 0.141180

=head1 SYNOPSIS

  my $bot = My::Bot->new;
  $bot->run;

=head1 DESCRIPTION

When you use L<Bot::Backbone> in your code, you get a bot implementing this
role. It provides tools for constructing, executing, and shutting down services.

=head1 ATTRIBUTES

=head2 event_loop

Bots do all their work using an event loop. Usually, this is either L<POE> or
L<AnyEvent>. Fortunately, these event loops tend to work well together in case
you need both. Just in case you need specialized startup for your bot's event
loop, though, this is attribute is provided to allow the event loop startup to
be customized.

This is an object or class on which you may call a C<run> with no arguments. It
will be called to start the event loop. By default, this is just
"L<POE::Kernel>". It is expected that this method will block until the bot is
shutdown.

=head2 services

This is a hash of constructed services used by this bot. There should be a key
in this hash matching every key in the same attribute in
L<Bot::Backbone::Meta::Class>, once L</run> has been called.

=head1 METHODS

=head2 bot

Returns itself.

=head2 construct_services

  $bot->construct_services;

This method iterates through the service configurations of the meta class and constructs each service from that configuration.

You may run this prior to L</run> to construct your services prior to running. Normally, though, this method is called within L</run>.

=head2 run

  $bot->run;

This starts your bot running. It constructs the services if they have not yet been constructed. Then, it initializes each service. Finally, it starts the L<POE> event loop. This last part really isn't it's business and might go away in the future.

This method will not return until the event loop terminates. The usual way to do this is to call L</shutdown>.

=head2 shutdown

  $bot->shutdown;

You may call this at any time while your bot is running to shutdown all the services. This notifies each service that it should shutdown (i.e., finish or terminate any pending jobs in the event loop). It then clears the L</services> hash, which should cause all services to be destroyed.

=head1 CAVEATS

This thing sort of kind of needs L<POE> to be any kind of useful. However, L<POE> seems to have weird drawbacks. I have some planned work-arounds for this being an explicit and required dependency, but it's there for now.

Second, if you use the Jabber chat service, you need L<AnyEvent>. Mostly, L<AnyEvent> and L<POE> seem to get along, but it's slow and I've found that timers, in particular, just plain don't work quite right.

=head1 AUTHOR

Andrew Sterling Hanenkamp <hanenkamp@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Qubling Software LLC.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
