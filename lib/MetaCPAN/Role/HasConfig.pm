package MetaCPAN::Role::HasConfig;

use Moose::Role;

use MetaCPAN::Config          ();
use MetaCPAN::Types::TypeTiny qw( HashRef );

# Done like this so can be required by a role
sub config {
    return $_[0]->_config;
}

has _config => (
    is      => 'ro',
    isa     => HashRef,
    lazy    => 1,
    builder => '_build_config',
);

sub _build_config {
    my $self = shift;
    return MetaCPAN::Config::config();
}

1;
