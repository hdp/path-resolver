use strict;
use warnings; # stupid CPANTS!
package Path::Resolver;
# ABSTRACT: go from "file" names to things

=head1 DESCRIPTION

Path::Resolver is a set of libraries for resolving virtual file paths into
entities that may be found at those paths.  Here's a trivial example:

  use Path::Resolver::Resolver::FileSystem;

  # Create a resolver that looks at the filesystem, starting in /etc
  my $fs = Path::Resolver::Resolver::FileSystem->new({ root => '/etc' });

  my $file = $fs->entity_at('/postfix/main.cf');

Assuming it exists, this will return an object representing the file
F</etc/postfix/main.cf>.  Using the code above, C<$file> would be a
C<Path::Resolver::SimpleEntity> object, which has a C<content_ref> method.  We
could print the contents of the file to screen like this:

  my $content_ref = $file->content_ref;
  print $$content_ref;

=head1 WHAT'S THE POINT?

Path::Resolver lets you use a simple, familiar notation for accessing all kinds
of hierarchical data.  It's also distributed with resolvers that act as
multiplexers for other resolvers.  Since all resolvers share one mechanism for
addressing content, they can easily be mixed and matched.  Since resolvers know
what kind of object they'll return, and can be fitted with translators, it's
easy to ensure that all your multiplexed resolvers will resolve names to the
same kind of object.

For example, we could overlay two search paths like this:

  my $resolver = Path::Resolver::Resolver::Mux::Ordered->new({
    resolvers => [
      Path::Resolver::Resolver::FileSystem->new({ root => './config' }),
      Path::Resolver::Resolver::Archive::Tar->new({ archive => 'config.tgz' }),
    ],
  });

  $resolver->entity_at('/foo/bar.txt');

This will return an entity representing F<./config/foo/bar.txt> if it exists.
If it doesn't, it will look for F<foo/bar.txt> in the contents of the archive.
If that's found, an entity will be returned.  Finally, if neither is found, it
will return false.

=head1 WHERE DO I GO NEXT?

If you want to read about how to write a resolver, look at
L<Path::Resolver::Role::Resolver|Path::Resolver::Role::Resolver>.

If you want to read about the interfaces to the existing resolvers look at
their documentation:

=over

=item * L<Path::Resolver::Resolver::AnyDist>

=item * L<Path::Resolver::Resolver::Archive::Tar>

=item * L<Path::Resolver::Resolver::DataSection>

=item * L<Path::Resolver::Resolver::DistDir>

=item * L<Path::Resolver::Resolver::FileSystem>

=item * L<Path::Resolver::Resolver::Hash>

=item * L<Path::Resolver::Resolver::Mux::Ordered>

=item * L<Path::Resolver::Resolver::Mux::Prefix>

=back

=cut

1;
