package MetaCPAN::Server::Model::CPAN;

use Moose;

use MetaCPAN::Config ();
use MetaCPAN::Model  ();

extends 'Catalyst::Model';

has esx_model => (
    is      => 'ro',
    lazy    => 1,
    builder => '_build_esx_model',
    handles => ['es'],
);

has index => (
    is      => 'ro',
    default => 'cpan',
);

has servers => (
    is      => 'ro',
    default => sub {
        return MetaCPAN::Config::config()->{elasticsearch_servers};
    },
);

sub _build_esx_model {
    MetaCPAN::Model->new( es => shift->servers );
}

sub type {
    my $self = shift;
    return $self->esx_model->index( $self->index )->type(shift);
}

sub BUILD {
    my ( $self, $args ) = @_;
    my $index = $self->esx_model->index( $self->index );
    my $class = ref $self;
    while ( my ( $k, $v ) = each %{ $index->types } ) {
        no strict 'refs';
        my $classname = "${class}::" . ucfirst($k);
        *{"${classname}::ACCEPT_CONTEXT"} = sub {
            return $index->type($k);
        };
    }
}

1;
