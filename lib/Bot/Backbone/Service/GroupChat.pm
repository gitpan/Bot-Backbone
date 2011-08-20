package Bot::Backbone::Service::GroupChat;
BEGIN {
  $Bot::Backbone::Service::GroupChat::VERSION = '0.112320';
}
use v5.10;
use Bot::Backbone::Service;

with qw(
    Bot::Backbone::Service::Role::Service
    Bot::Backbone::Service::Role::Dispatch
    Bot::Backbone::Service::Role::Chat
    Bot::Backbone::Service::Role::ChatConsumer
);

with_bot_roles qw(
    Bot::Backbone::Bot::Role::GroupChat
);

# ABSTRACT: A helper chat for performing group chats


has group => (
    is          => 'ro',
    isa         => 'Str',
    required    => 1,
);


sub initialize {
    my $self = shift;
    $self->chat->join_group($self->group);
}


sub send_reply {
    my ($self, $message, $text) = @_;
    $self->chat->send_reply($message, $text);
}


sub send_message {
    my ($self, %params) = @_;
    my $text = $params{text};
    $self->chat->send_message(
        group => $self->group,
        text  => $text,
    );
}


sub receive_message {
    my ($self, $message) = @_;

    return unless $message->is_group
              and $message->group eq $self->group;

    $self->resend_message($message);
    $self->dispatch_message($message);
}

__PACKAGE__->meta->make_immutable;

__END__
=pod

=head1 NAME

Bot::Backbone::Service::GroupChat - A helper chat for performing group chats

=head1 VERSION

version 0.112320

=head1 SYNOPSIS

  service group_foo => (
      service => 'GroupChat',
      chat    => 'jabber_chat',
      group   => 'foo',
  );

=head1 DESCRIPTION

This is a chat consumer that provides chat services to a specific group on the
consumed chat service.

=head1 ATTRIBUTES

=head2 group

This is the name of the group this chat will communicate with. It will not
perform chats in any other group or directly.

=head1 METHODS

=head2 initialize

Joins the L</group>.

=head2 send_reply

Replies to L</group> chats that were forwarded on.

=head2 send_message

Sends a message to the L</group>.

=head2 receive_message

If the message belongs to the L</group> this chat service works with, the
consumers will be notified and the dispatcher run. Otherwise, the message will
be ignored.

=head1 AUTHOR

Andrew Sterling Hanenkamp <hanenkamp@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Qubling Software LLC.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

