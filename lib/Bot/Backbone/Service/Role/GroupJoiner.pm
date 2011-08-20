package Bot::Backbone::Service::Role::GroupJoiner;
BEGIN {
  $Bot::Backbone::Service::Role::GroupJoiner::VERSION = '0.112320';
}
use v5.10;
use Moose::Role;

# ABSTRACT: Chat services that can join a chat group


requires 'join_group';

1;

__END__
=pod

=head1 NAME

Bot::Backbone::Service::Role::GroupJoiner - Chat services that can join a chat group

=head1 VERSION

version 0.112320

=head1 DESCRIPTION

This is only useful to chat services (probably).

=head1 REQUIRED METHODS

=head2 join_group

  $chat->join_group('foo');

Given the name of a group to join, this performs the operations required to join
the group.

=head1 AUTHOR

Andrew Sterling Hanenkamp <hanenkamp@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Qubling Software LLC.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

