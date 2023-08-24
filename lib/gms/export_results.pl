use Genome;
use LWP::UserAgent;
use JSON::XS qw(encode_json);

use feature qw(say);

my $url = $ENV{'META_API_PATH'};
my $api_key = $ENV{'META_API_KEY'}
my $ua  = LWP::UserAgent->new();

my @ids = (
  "2838281342c14a4595e9c8cefff53657",
  "2653967ab4ec4f9489767753160e66c8",
  "4225fe9456484883ac722a106f408565",
  "9935cd0d25eb4d1bb708e223492007e8",
  "875a64abeac54f73a6078388799d3b27",
  "bd1444c14f41415a9da6e94e6865582c",
  "c779229375fd489c94584f1f3d2cace6",
  "c6cd0caf7ee74ef3a1d56df9c351d540",
  "fc389b4e1cbc4129a29483bf9bf36ac9"
);

foreach $id (@ids) {

  my $anp = Genome::Config::AnalysisProject->get($id);
  my @builds = map {$_->builds } $anp->models

  for(@builds) {
    my %json;
    $json{'projectName'} = $anp->name
    $json{'platform'} = 'GMS';
    $json{'platformIdentifier'} = $_->id;
    $json{'pipelineName'} = $_->model->class;
    $json{'pipelineVersion'} = $_->model->processing_profile->name;
    $json{'note'} = $_->model->name;
    $json{'dataLocation'} = $_->data_directory
    $json{'inputPaths'} = map {
      my @allocations = $_->disk_allocations;
      if ($_->bam_path) {
        push(@cols, $_->bam_path);
      } elsif (@allocations) {
        push(@cols, $allocations[0]->absolute_path || '');
      } elsif ($_->archive_path)  {
        push(@cols, $_->archive_path);
      } else {
        push(@cols, '')
      }
    } $_->instrument_data


    my $req = HTTP::Request->new('POST', $url);
    $req->header(
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer $api_key"
    )
    $req->content(encode_json(\%json))

    my $res = $ua->request($req)
    if ($res->is_success) {
      say "Result saved";
    } else { 
      say "Failed..."
    }
  }
}
