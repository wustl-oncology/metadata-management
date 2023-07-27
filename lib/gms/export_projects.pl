use Genome;
use feature qw(say);

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
open(FH, '>', $id.".tsv") or die $!;

my $anp = Genome::Config::AnalysisProject->get($id);

for ($anp->instrument_data) {
  my @cols = ();

  #sample
  push(@cols, $_->sample->name || '');

  #species
  if ($_->sample->individual) {
    push(@cols, $_->sample->individual->species_name || '');
  } else {
    push(@cols, '');
  }

  #tissue (organ_name?)
  push(@cols, $_->sample->tissue_desc || '');

  #individual
  if ($_->sample->individual) {
    push(@cols, $_->sample->individual->id);
  } else {
    push(@cols, '');
  }

  #timepoint
  push(@cols, $_->sample->timepoint || '');

  #disease status
  push(@cols, $_->sample->common_name || '');

  #library prep
  push(@cols, $_->sample->extraction_type || '');

  #instrument (run name?)
  push(@cols, $_->sequencing_platform || '');

  #unaligned data path
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


  #flow cell id
  push(@cols, $_->flow_cell_id || '');

  say FH join("\t", @cols);
}

close(FH);

}

