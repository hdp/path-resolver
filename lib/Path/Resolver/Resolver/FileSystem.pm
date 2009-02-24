package Path::Resolver::Resolver::FileSystem;
use Moose;
with 'Path::Resolver::Role::Resolver';

use Carp ();
use File::Spec;

has root => (
  is => 'rw',
  required    => 1,
  initializer => sub {
    my ($self, $value, $set) = @_;
    my $abs_dir = File::Spec->abs2rel($value);
    $set->($abs_dir);
  },
);

sub content_for {
  my ($self, $path) = @_;

  my $abs_path = File::Spec->catfile(
    $self->root,
    @$path,
  );

  return unless -e $abs_path;

  open my $fh, '<', $abs_path or Carp::confess("can't open $abs_path: $!");
  my $content = do { local $/; <$fh> };
  return \$content;
}

no Moose;
__PACKAGE__->meta->make_immutable;