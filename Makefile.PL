
use strict;
use warnings;

use 5.010000;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  'ABSTRACT' => 'Extensible framework for building bots',
  'AUTHOR' => 'Andrew Sterling Hanenkamp <hanenkamp@cpan.org>',
  'BUILD_REQUIRES' => {
    'Test::More' => '0'
  },
  'CONFIGURE_REQUIRES' => {
    'ExtUtils::MakeMaker' => '6.30'
  },
  'DISTNAME' => 'Bot-Backbone',
  'EXE_FILES' => [],
  'LICENSE' => 'perl',
  'NAME' => 'Bot::Backbone',
  'PREREQ_PM' => {
    'AnyEvent' => '0',
    'AnyEvent::XMPP::Client' => '0',
    'AnyEvent::XMPP::Ext::Disco' => '0',
    'AnyEvent::XMPP::Ext::MUC' => '0',
    'Bot::Backbone::Dispatcher::Predicate::Functor' => '0',
    'Bot::Backbone::Dispatcher::Predicate::Nesting' => '0',
    'Carp' => '0',
    'List::MoreUtils' => '0',
    'List::Util' => '0',
    'Moose' => '0',
    'Moose::Exporter' => '0',
    'Moose::Meta::Class' => '0',
    'Moose::Role' => '0',
    'Moose::Util' => '0',
    'MooseX::Types' => '0',
    'MooseX::Types::Moose' => '0',
    'POE' => '0',
    'Scalar::Util' => '0',
    'namespace::autoclean' => '0'
  },
  'VERSION' => '0.112400',
  'test' => {
    'TESTS' => 't/*.t'
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



