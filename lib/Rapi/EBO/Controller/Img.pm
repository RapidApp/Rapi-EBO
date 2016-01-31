package Rapi::EBO::Controller::Img;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }


sub index :Path {
    my ( $self, $c, $candidate ) = @_;
    
    my $Candidate = $c->model('DB::Candidate')->search_rs({ -or => [
      { 'me.id'   => $candidate },
      { 'me.name' => $candidate }
    ]})->first or die "Candidate '$candidate' not found";
    
    my $photo_cas = $Candidate->photo_cas or die "No image available";
    
    my $path = join('/','/simplecas/fetch_content',$photo_cas);
      
    return $c->redispatch_public_path($path)
}



__PACKAGE__->meta->make_immutable;

1;
