use strict;
use warnings;

# the next two lines are turning off BioPerl warnings. I did this because of 
# this bug:
# http://bioperl.org/pipermail/bioperl-l/2010-December/034334.html
# http://web.archiveorange.com/archive/v/Nz9auiWLv8lzndHiEKAp 
# if you are developing, remember to comment the two lines below to see 
# eventual new real bugs in POTION

use Bio::Root::Root;
$Bio::Root::Root::DEBUG = -1; #turning off BioPerl warnings

sub create_conf_file {
  if (-e "potion_main.conf") {
    die ("A main potion configuration file (potion_main.conf) is in this directory.\nPlease remove or rename to create a new potion configuration file\n\n");
  } else {
    my $dummy_file = "../config_files/dummy_potion_user_config_file";
    my $conf_file = "potion_main.conf";
    copy($dummy_file, $conf_file);
    print "Configuration file created, check for file \"$conf_file\" and its parameters.\n"
  }
#  exit();
}

sub help {
  print "Use potion like that:\n\n";
  print "potion.pl <path to configuration file>\n";
  print "\n\n";
  print "OR\n\n\n";
  print "potion.pl --create_conf\n\n";
  print "to create an empty configuration file and\npopulate it with your data\n\n";
#  exit();
}



sub read_config_files { #read config files in the form element = value #comment
  my $project_config_file = shift;
  my $potion_path = shift;
  my %parameters;
  open(my $fh_user_config, "<", "$$project_config_file") || die ("Couldn't open the project configuration file, you may have to chech if the name or permission of the file are correct.\nDetails: $!\n");
  open(my $fh_potion_config, "<", "$$potion_path/../config_files/potion_config") || die ("The configuration file 'potion_config' couldn't be read, please check if the file exists and if its permissions are properly set.\n");

  # -=-=-= BASIC PARAMETER FOR LOCATION AND FILE NAME =-=-=-
  $parameters{potion_dir} = read_config_file_line('potion_dir', '', $fh_potion_config);

  # -=-=-= INPUT FILES =-=-=-
  $parameters{path_of_nt_files} = read_config_file_line('path_of_nt_files', $parameters{potion_dir}, $fh_user_config);
  $parameters{cluster_file} = read_config_file_line('cluster_file', $parameters{potion_dir}, $fh_user_config);
  $parameters{user_tree_file} = "";#must go to conf file

  # -=-=-= PROJECT NAME =-=-=-
  $parameters{project_dir} = read_config_file_line('project_dir', $parameters{potion_dir}, $fh_user_config);

  # -=-=-= PROJECT CONFIGURATION =-=-=-
  $parameters{reference_genome_files} = read_config_file_line('reference_genome_files', '', $fh_user_config);
  $parameters{groups_to_process} = read_config_file_line('groups_to_process', '', $fh_user_config);
  $parameters{codon_table} = read_config_file_line('codon_table', '', $fh_user_config);
  $parameters{additional_start_codons} = read_config_file_line('additional_start_codons', '', $fh_user_config);
  $parameters{additional_stop_codons} = read_config_file_line('additional_stop_codons', '', $fh_user_config);
  $parameters{recombination_qvalue} = read_config_file_line('recombination_qvalue', '', $fh_user_config);
  $parameters{rec_minimum_confirmations} = read_config_file_line('rec_minimum_confirmations', '', $fh_user_config);
  $parameters{rec_mandatory_tests} = read_config_file_line('rec_mandatory_tests', '', $fh_user_config);
  $parameters{behavior_about_paralogs} = read_config_file_line('behavior_about_paralogs', '', $fh_user_config);
  $parameters{minimum_gene_number_per_cluster} = read_config_file_line('minimum_gene_number_per_cluster', '', $fh_user_config);
  $parameters{maximum_gene_number_per_cluster} = read_config_file_line('maximum_gene_number_per_cluster', '', $fh_user_config);
  $parameters{minimum_specie_number_per_cluster} = read_config_file_line('minimum_specie_number_per_cluster', '', $fh_user_config); 
  $parameters{maximum_specie_number_per_cluster} = read_config_file_line('maximum_specie_number_per_cluster', '', $fh_user_config);
  $parameters{remove_gaps} = read_config_file_line('remove_gaps', '', $fh_user_config);
  $parameters{verbose} = read_config_file_line('verbose', '', $fh_user_config);
  $parameters{remove_identical} = read_config_file_line('remove_identical', '', $fh_user_config);
  $parameters{codeml_mode} = "site"; #must go to configuration file
  $parameters{minimum_taxa_background} = "4";#must go to conf file
  $parameters{minimum_taxa_foreground} = "2";#must go to conf file
  $parameters{maximum_taxa_background} = "30";#must go to conf file
  $parameters{maximum_taxa_foreground} = "10";#must go to conf file


# -=-=-= QUALITY AND PERFORMANCE =-=-=-
  
  $parameters{PAML_models} = read_config_file_line('PAML_models', '', $fh_user_config);
  $parameters{max_processes} = read_config_file_line('max_processes', '', $fh_user_config);
  $parameters{bootstrap} = read_config_file_line('bootstrap', '', $fh_user_config);
  $parameters{pvalue} = read_config_file_line('pvalue', '', $fh_user_config);
  $parameters{qvalue} = read_config_file_line('qvalue', '', $fh_user_config);
  $parameters{phylogenetic_tree_speed} = read_config_file_line('phylogenetic_tree_speed', '', $fh_user_config);
  $parameters{behavior_about_bad_clusters} = read_config_file_line('behavior_about_bad_clusters', '', $fh_user_config);
  $parameters{validation_criteria} = read_config_file_line('validation_criteria', '', $fh_user_config);
  $parameters{fix_excess_nt} = read_config_file_line('fix_excess_nt', '', $fh_user_config);

  $parameters{absolute_min_sequence_size} = read_config_file_line('absolute_min_sequence_size', '', $fh_user_config);
  $parameters{absolute_max_sequence_size} = read_config_file_line('absolute_max_sequence_size', '', $fh_user_config);
  $parameters{sequence_size_dispersion_measure} = read_config_file_line('sequence_size_dispersion_measure', '', $fh_user_config);
  $parameters{relative_min_sequence_size} = read_config_file_line('relative_min_sequence_size', '', $fh_user_config);
  $parameters{relative_max_sequence_size} = read_config_file_line('relative_max_sequence_size', '', $fh_user_config);
  $parameters{mean_divergence_identity_overall} = read_config_file_line('mean_divergence_identity_overall', '', $fh_user_config);
  $parameters{mean_divergence_identity_most_similar_sequence} = read_config_file_line('mean_divergence_identity_most_similar_sequence', '', $fh_user_config);
  $parameters{identity_most_similar_sequence} = read_config_file_line('identity_most_similar_sequence', '', $fh_user_config);
  $parameters{mean_sequence_identity} = read_config_file_line('mean_sequence_identity', '', $fh_user_config);

  # -=-=-= MODULES =-=-=-

  $parameters{multiple_alignment} = read_config_file_line('multiple_alignment', '', $fh_user_config);
  $parameters{phylogenetic_tree} = read_config_file_line('phylogenetic_tree', '', $fh_user_config);
#  $parameters{phylogenetic_tree} = "codonphyml_nt";


  close($fh_user_config);

  # -=-=-= PATH TO EXTERNAL PROGRAMS =-=-=-
  $parameters{codeml_path} = read_config_file_line('codeml', $parameters{potion_dir}, $fh_potion_config);
  $parameters{consense_path} = read_config_file_line('consense', $parameters{potion_dir}, $fh_potion_config);
  $parameters{dnaml_path} = read_config_file_line('dnaml', $parameters{potion_dir}, $fh_potion_config);
  $parameters{muscle_path} = read_config_file_line('muscle', $parameters{potion_dir}, $fh_potion_config);
  $parameters{phipack_path} = read_config_file_line('phipack', $parameters{potion_dir}, $fh_potion_config);
  $parameters{prank_path} = read_config_file_line('prank', $parameters{potion_dir}, $fh_potion_config);
  $parameters{proml_path} = read_config_file_line('proml', $parameters{potion_dir}, $fh_potion_config);
  $parameters{seqboot_path} = read_config_file_line('seqboot', $parameters{potion_dir}, $fh_potion_config);
  $parameters{trimal_path} = read_config_file_line('trimal', $parameters{potion_dir}, $fh_potion_config);
  $parameters{mafft_path} = read_config_file_line('mafft', $parameters{potion_dir}, $fh_potion_config);
  $parameters{codonphyml_path} = read_config_file_line('codonphyml', $parameters{potion_dir}, $fh_potion_config);

  # -=-=-= OUTPUT NAMES =-=-=-
  $parameters{result_table} = read_config_file_line('result_table', '', $fh_potion_config); 
  $parameters{result_uncertain} = read_config_file_line('result_uncertain', '', $fh_potion_config);
  $parameters{result_positive} = read_config_file_line('result_positive', '', $fh_potion_config);
  $parameters{result_recombinants} = read_config_file_line('result_recombinants', '', $fh_potion_config);
  $parameters{summary} = read_config_file_line('summary', '', $fh_potion_config);
  $parameters{result_recombinants} = "recombinants"; #hard coded, must go to config_file
  # -=-=-= EXTERNAL ERROR HANDLING =-=-=-
  $parameters{tries} = read_config_file_line('tries', '', $fh_potion_config);
  close($fh_potion_config);

  return \%parameters;
}


sub read_config_file_line { # file format element = value
  my ($parameter, $potion_dir, $fh_config_file) = @_;

  seek($fh_config_file, 0, 0);              # added to allow any order of parameters in the config files, preventing unfriendly error messages if the user changes the order
  while (my $line = <$fh_config_file>){
    if ($line =~ /^\s*$parameter\s*=/) {    # the string to be searched in the file
      chomp ($line);
      $line =~ s/^\s*$parameter\s*=\s*//;   # removing what comes before the user input
      $line =~ s/#.*$//;                    # removing what comes after the user input (commentaries)
      $line =~ s/\s*$//;                    # removing what comes after the user input (space caracteres)
      $line =~ s/\$potion_dir/$potion_dir/;     # allows the use of "$potion_dir" in the config file as a reference to the said parameter
      if ($line eq 'undef' || $line eq '') { return; }
      else { return $line; }
    }
  }
  return;
}


# function to identify errors in the configuration files and direct the user to the needed adjustments
sub check_parameters { #check for all parameters, 
  my $parameters = shift;

  my $config_path = getcwd();
  $config_path =~ s/\/\w+$/\/config_files/;


  # -=-=-= BASIC PARAMETER FOR LOCATION AND FILE NAME =-=-=-
  if (!defined $parameters->{potion_dir}) { die ("No path to Potion was specified in potion_config at $config_path, please open this file and fill the parameter 'potion_dir'.\n"); }
  if (!-d $parameters->{potion_dir}) { die ("The path to Potion isn't a valid directory, please check if the path in 'potion_dir' is correct: $parameters->{potion_dir}\n"); }
  if (!-w $parameters->{potion_dir}) { die ("You don't have permission to write in the Potion directory, please redefine your permissions for this directory.\n"); }

  # -=-=-= INPUT FILES =-=-=-
  if (!defined $parameters->{path_of_nt_files}) { die ("No path to the nucleotide files was specified in your project's configuration file, please fill the parameter 'path_of_nt_files'.\n"); }
  if (!-d $parameters->{path_of_nt_files}) { die ("The path to your project's nucleotide files isn't a valid directory, please check if the path in 'path_of_nt_files' is correct: $parameters->{path_of_nt_files}\n"); }
  if (!-r $parameters->{path_of_nt_files}) { die ("You don't have permission to read in your project's nucleotide directory, please redefine your permissions.\n"); }

  if (!defined $parameters->{cluster_file}) { die ("No orthology group file defined for this project, please fill the parameter 'cluster_file' in your project's configuration file.\n"); }
  if (!-s $parameters->{cluster_file}) { die ("The orthology group file defined in your project's configuration file doesn't exist, please check if the parameter 'cluster_file' is correct: $parameters->{cluster_file}\n"); }
  if (!-r $parameters->{cluster_file}) { die ("You don't have permission to read the orthology group file, please redefine your permissions for this file.\n"); }

  # -=-=-= PATH TO EXTERNAL PROGRAMS USED BY POTION =-=-=-
  if (!defined $parameters->{codeml_path}) { die ("No path to CODEML was specified in potion_config at $config_path, please open this file and fill the parameter 'codeml'.\n"); }
  if (!-s $parameters->{codeml_path}) { die ("The executable of CODEML wasn't found in the specified path, please check if the path is correct: $parameters->{codeml_path}\n"); }
  if (!-x $parameters->{codeml_path}) { die ("You don't have permission to execute the CODEML file specified at potion_config, please check permissions or replace the file\n"); }

  if (!defined $parameters->{consense_path}) { die ("No path to Consense was specified in potion_config at $config_path, please open this file and fill the parameter 'consense'.\n"); }
  if (!-s $parameters->{consense_path}) { die ("The executable of Consense wasn't found in the specified path, please check if the path is correct: $parameters->{consense_path}\n"); }
  if (!-x $parameters->{consense_path}) { die ("You don't have permission to execute the Consense file specified at potion_config, please check permissions or replace the file\n"); }

  if (defined $parameters->{phylogenetic_tree} && $parameters->{multiple_alignment} =~ /dnaml/i) {
    if (!defined $parameters->{dnaml_path}) { die ("No path to Dnaml was specified in potion_config at $config_path, please open this file and fill the parameter 'dnaml'.\n"); }
    if (!-s $parameters->{dnaml_path}) { die ("The executable of Dnaml wasn't found in the specified path, please check if the path is correct: $parameters->{dnaml_path}\n"); }
    if (!-x $parameters->{dnaml_path}) { die ("You don't have permission to execute the Dnaml file specified at potion_config, please check permissions or replace the file\n"); }
  }

  if (!defined $parameters->{multiple_alignment} || $parameters->{multiple_alignment} =~ /muscle/i) {
    if (!defined $parameters->{muscle_path}) { die ("No path to MUSCLE was specified in potion_config at $config_path, please open this file and fill the parameter 'muscle'.\n"); }
    if (!-s $parameters->{muscle_path}) { die ("The executable of MUSCLE wasn't found in the specified path, please check if the path is correct: $parameters->{muscle_path}\n"); }
    if (!-x $parameters->{muscle_path}) { die ("You don't have permission to execute the MUSCLE file specified at potion_config, please check permissions or replace the file\n"); }
  }

  if (!defined $parameters->{phipack_path}) { die ("No path to PhiPack was specified in potion_config at $config_path, please open this file and fill the parameter 'phipack'.\n"); }
  if (!-s $parameters->{phipack_path}) { die ("The executable of PhiPack wasn't found in the specified path, please check if the path is correct: $parameters->{phipack_path}\n"); }
  if (!-x $parameters->{phipack_path}) { die ("You don't have permission to execute the PhiPack file specified at potion_config, please check permissions or replace the file\n"); }

  if (defined $parameters->{multiple_alignment} && $parameters->{multiple_alignment} =~ /mafft/i) {
    if (!defined $parameters->{mafft_path}) { die ("No path to MAFFT was specified in potion_config at $config_path, please open this file and fill the parameter 'mafft'.\n"); }
    if (!-s $parameters->{mafft_path}) { die ("The executable of MAFFT wasn't found in the specified path, please check if the path is correct: $parameters->{mafft_path}\n"); }
    if (!-x $parameters->{mafft_path}) { die ("You don't have permission to execute the MAFFT file specified at potion_config, please check permissions or replace the file\n"); }
  }

  if (defined $parameters->{multiple_alignment} && $parameters->{multiple_alignment} =~ /prank/i) {
    if (!defined $parameters->{prank_path}) { die ("No path to Prank was specified in potion_config at $config_path, please open this file and fill the parameter 'prank'.\n"); }
    if (!-s $parameters->{prank_path}) { die ("The executable of Prank wasn't found in the specified path, please check if the path is correct: $parameters->{prank_path}\n"); }
    if (!-x $parameters->{prank_path}) { die ("You don't have permission to execute the Prank file specified at potion_config, please check permissions or replace the file\n"); }
  }

  if (!defined $parameters->{phylogenetic_tree} || $parameters->{multiple_alignment} =~ /proml/i) {
    if (!defined $parameters->{proml_path}) { die ("No path to Proml was specified in potion_config at $config_path, please open this file and fill the parameter 'proml'.\n"); }
    if (!-s $parameters->{proml_path}) { die ("The executable of Proml wasn't found in the specified path, please check if the path is correct: $parameters->{proml_path}\n"); }
    if (!-x $parameters->{proml_path}) { die ("You don't have permission to execute the Proml file specified at potion_config, please check permissions or replace the file\n"); }
  }

  if ((!defined $parameters->{user_tree_file} || -e $parameters->{user_tree_file})&&($parameters->{codeml_mode} eq "branch")) {
    if (!defined $parameters->{user_tree_file}) { die ("No path to user-defined tree file was specified in potion_config at $config_path, please open this file and fill the parameter 'proml'.\n"); }
    if (!-e $parameters->{user_tree_file}) { die ("The user-tree file wasn't found in the specified path, please check if the path is correct: $parameters->{user_tree_file}\n"); }
  }


  if (!defined $parameters->{seqboot_path}) { die ("No path to Seqboot was specified in potion_config at $config_path, please open this file and fill the parameter 'seqboot'.\n"); }
  if (!-s $parameters->{seqboot_path}) { die ("The executable of Seqboot wasn't found in the specified path, please check if the path is correct: $parameters->{seqboot_path}\n"); }
  if (!-x $parameters->{seqboot_path}) { die ("You don't have permission to execute the Seqboot file specified at potion_config, please check permissions or replace the file\n"); }

  if (!defined $parameters->{trimal_path}) { die ("No path to trimAl was specified in potion_config at $config_path, please open this file and fill the parameter 'trimal'.\n"); }
  if (!-s $parameters->{trimal_path}) { die ("The executable of TriamAl wasn't found in the specified path, please check if the path is correct: $parameters->{trimal_path}\n"); }
  if (!-x $parameters->{trimal_path}) { die ("You don't have permission to execute the TrimAl file specified at potion_config, please check permissions or replace the file\n"); }

  # -=-=-= MODULES =-=-=-
  if (!defined $parameters->{phylogenetic_tree}) { die ("No program specified for phylogenetic tree construction, please set the parameter 'phylogenetic_tree' in your project configuration file.\n"); }
  if (!defined $parameters->{multiple_alignment}) { die ("No program specified for multiple alignment, please set the parameter 'multiple_alignment' in your project configuration file.\n"); }

  # -=-=-= PROJECT CONFIGURATION =-=-=-
  if (!defined $parameters->{codon_table}) { die ("Codon table not specified, please set the parameter 'codon_table' in your project configuration file.\n"); }
  if (!defined $parameters->{verbose}) { $parameters->{verbose} = 0; } # default value


  # -=-=-= EXTERNAL ERROR HANDLING =-=-=-
  if (!defined $parameters->{tries} || $parameters->{tries} !~ /^\d+$/) { $parameters->{tries} = 3; } # must be a number, and not a negative one; also must be an integer

  if (!defined $parameters->{project_dir}) {die "Project directory not configured. Please set project_dir element in configuration file\n";}

  if (!defined $parameters->{recombination_qvalue}) {die "Recombination q-value not setted (zero for no recombiation search). Please set recombination_qvalue element in configuration file\n";}

  if (!defined $parameters->{rec_minimum_confirmations}) {die "Minimum number of independent tests for recombination detection not setted (1, 2, 3 or N.A.). Please set recombination_qvalue element in configuration file\n";}

  if (!defined $parameters->{rec_mandatory_tests}) {die "Minimum number of mandatory tests for recombination detection not setted (Any combination of phi nss maxchi2 or N.A.). Please set rec_mandatory_tests element in configuration file\n";}

}

# This function checks whether the nucleotide sequence:
# 1- has any of the specified start codons
# 2- has either of the specified stop codons
# 3- has a sequence that is multiple of 3
# 4- has non-standard nucleotides
# If the method find any inconsistency, it is added in $validation variable according to the pattern above and reported in the LOG
sub validate_sequence {
  my ($parameters, $accession_number, $file_name, $nt_sequence) = @_;
  my $codon_table = Bio::Tools::CodonTable -> new (-id => $parameters->{codon_table});

  my $validation;  # output with the errors found

  # Condition 1 - Check validity of start codon
  my $codon = substr($$nt_sequence, 0, 3);
  if (defined $parameters->{validation_criteria} && $parameters->{validation_criteria} =~ /(1|all)/ && !($codon_table -> is_start_codon($codon))) {
    if ($parameters->{additional_start_codons} !~ /$codon/) {
      $validation .= '1 ';
      print LOG ("REMOVE_SEQUENCE_FLAG\tQUALITY\t$$accession_number\t$$file_name:invalid start codon\t$codon\n");
    }
  }
  # Condition 2 - Check validity of stop codon
  $codon = substr($$nt_sequence, -3, 3);
  if (defined $parameters->{validation_criteria} && $parameters->{validation_criteria} =~ /(2|all)/ && !($codon_table -> is_ter_codon($codon))) {
    if ($parameters->{additional_stop_codons} !~ /$codon/) {
      $validation .= '2 ';
      print LOG ("REMOVE_SEQUENCE_FLAG\tQUALITY\t$$accession_number\t$$file_name:invalid stop codon\t$codon\n");
#      print LOG ('Invalid sequence (', $$accession_number, '): invalid stop codon ', $codon, "\n");
    }
  }
  # Condition 3 - Check length of sequence and if multiple of 3
  if (defined $parameters->{validation_criteria} && $parameters->{validation_criteria} =~ /(3|all)/ && length($$nt_sequence) % 3) {
    if (defined $parameters->{fix_excess_nt} && $parameters->{fix_excess_nt}) {
      substr($$nt_sequence, -(length($$nt_sequence) % 3), length($$nt_sequence), '');

    }
    else {
      $validation .= '3 ';
#      print LOG ('Invalid sequence (', $$accession_number, '): number of nucleotides not multiple of 3, ', length($$nt_sequence), ' nucleotides found', "\n");
      my $tmp_length = length($$nt_sequence);
      print LOG ("REMOVE_SEQUENCE_FLAG\tQUALITY\t$$accession_number\t$$file_name:not multiple of three\t$tmp_length\n");
    }
  }
  # Condition 4 - Presence of 'T' and 'U' nucleotides
  if ($$nt_sequence =~ /[^TACG]/) {
#    if (defined $parameters->{validation_criteria} && $parameters->{validation_criteria} =~ /(4|all)/ && $$nt_sequence =~ /T/ && $$nt_sequence =~ /U/) {
#      $validation .= '4 ';
#      print LOG ('Invalid sequence (', $$accession_number, '): presence of both T and U nucleotides', "\n");
#    }
    # Condition 5 - Presence of non-canonical nucleotides
    if (defined $parameters->{validation_criteria} && $parameters->{validation_criteria} =~ /(4|all)/ && $$nt_sequence =~ /[^TUACG]/) {
      $validation .= '4 ';
      my $non_canonical_nt = $$nt_sequence;
      $non_canonical_nt =~ s/[TUACG]//g;  # preparing to print non-canonical nucleotides found in LOG
      print LOG ("REMOVE_SEQUENCE_FLAG\tQUALITY\t$$accession_number\t$$file_name:non standard nucleotides\t$non_canonical_nt\n");
#      print LOG ('Invalid sequence (', $$accession_number, '): presence of non-canonical nucleotides: ', $non_canonical_nt, "\n");
    }  
  }
  return $validation;
}

# Function to ensure control of the absolute size of the sequences
# Simple at the moment, kept as a function in case users request more types of filters
sub validate_absolute_size {
  my ($parameters, $accession_number, $tmp_file, $sequence) = @_;
#  print "\t=>\t$$sequence\n";
#  my $a = <STDIN>;
  if (defined $parameters->{absolute_min_sequence_size} && length($$sequence) < $parameters->{absolute_min_sequence_size})  {
    my $tmp_length = length($$sequence);
    print LOG ("REMOVE_SEQUENCE_FLAG\tQUALITY\t$$accession_number\t$$tmp_file : smaller than absolute length cutoff\t$tmp_length\n");
    return 1;
  } elsif (defined $parameters->{absolute_max_sequence_size} && length($$sequence) > $parameters->{absolute_max_sequence_size}) {
      my $tmp_length = length($$sequence);
      print LOG ("REMOVE_SEQUENCE_FLAG\tQUALITY\t$$accession_number\t$$tmp_file : greater than absolute length cutoff\t$tmp_length\n");
      return 1;
  }  else {
    return 0;
  }
}

# now the script loads all nucleotide sequence files to a hash structure,
# checks their validity and translates them to protein sequence
sub parse_genome_files {
  my ($parameters) = shift;

  opendir (my $nt_files_dir, $parameters->{path_of_nt_files}) || die ("Path to nucleotide files not found. Details: $!\n");
  my (%sequence_data, %id2tmp_id, %tmp_id2id);

  print ('Parsing genome files', "\n") if $parameters->{verbose};

  my $id_numeric_component = 1;  # set to generate unique IDs in phylip format for each sequence later on
  while (my $file = readdir ($nt_files_dir)) {
    if (($file eq '.') || ($file eq '..') || ($file =~ /^\./) || ($file =~ /~$/)) { next; }  # Prevents from reading hidden or backup files

    my $file_content = new Bio::SeqIO(-format => 'fasta',-file => "$parameters->{path_of_nt_files}/$file");
    print ('Reading file ', $file, "\n") if $parameters->{verbose};
    print LOG ('Reading file ', $file, "\n");
    while (my $gene_info = $file_content->next_seq()) {
      my $sequence = $gene_info->seq();
      my $accession_number = $gene_info->display_id;
#      print "$sequence\t$file\n";
#      my $a = <STDIN>;
      # validate the sequence before adding to %sequences
      if ($parameters->{behavior_about_bad_clusters}) {
        if (validate_sequence ($parameters, \$accession_number, \$file, \$sequence)) {    # This part prevents entry of invalid sequences in the hash
          $sequence_data{$accession_number}{status} = "NOTOK"; 
          print ('Warning: gene ', $accession_number, ' does not have a valid sequence, check the log file for more information', "\n") if $parameters->{verbose};
          next;
        }
        if (validate_absolute_size ($parameters, \$accession_number, \$file, \$sequence)) {
          $sequence_data{$accession_number}{status} = "NOTOK";
          print ('Warning: gene ', $accession_number, ' does not have a valid sequence, check the log file for more information', "\n") if $parameters->{verbose};
          next;
        }
      }
      if (!defined $sequence_data{$accession_number}{status}) {
        $sequence_data{$accession_number}{status} = "OK";
      }
      $sequence_data{$accession_number}{nuc_seq} = $sequence;

      # This variable is the internal unique ID for a given sequence.
      # It is needed since several programs used here (phylip
      # programs, mainly) have specific sequence name
      # constraints, which generated bugs sometimes.
      # Specifically, each sequence has to begin with a
      # letter and should have no more than 10 characters.
      # So we created an internal ID, which is used in all
      # intermediate files generated, in order to overcome those
      # problems. A dictionary linking each internal ID to the
      # is printed at log file for tracking purposes.      
      my $sequence_id = 'A'.$id_numeric_component;

      $id2tmp_id{$accession_number} = $sequence_id;
      $tmp_id2id{$sequence_id} = $accession_number;
      $id_numeric_component++;
      print LOG "ID2TMPID\t$accession_number\t$sequence_id\n" if $parameters->{verbose};
#      print "$accession_number\t$sequence_id\n";
#      my $a = <STDIN>;
      my $prot_obj = $gene_info->translate(-codontable_id => ($parameters->{codon_table}));
#      $translation{$accession_number} = $prot_obj->seq();
      $sequence_data{$accession_number}{prot_seq} = $prot_obj->seq();
    }
  }
  print ('Done', "\n") if $parameters->{verbose};
  closedir ($nt_files_dir);
  return (\%sequence_data, \%id2tmp_id, \%tmp_id2id);
}


sub select_ortholog_groups {
  my $parameters = shift;
  my %hash_of_groups;
  if (!defined $parameters->{groups_to_process}) { $parameters->{groups_to_process} = 'all'; }   # default case: analyze all groups
  my @groups = split(/(,|;)/, $parameters->{groups_to_process});
  foreach my $set (@groups) {
    if (!defined $parameters->{groups_to_process} || $set =~ /^\s*all\s*$/i) { $hash_of_groups{all} = 1; }     # setting 'all' option form the user
    elsif ($set =~ /!(\d+)-(\d+)/) {  # lines of the groups in the '3-50', or 'from 3 to 50', format
      foreach my $group ($1..$2) {
        $hash_of_groups{not_process}{$group} = 1;
      }
    }
    elsif ($set =~ /(\d+)-(\d+)/) { 
      foreach my $group ($1..$2) {
        $hash_of_groups{line}{$group} = 1; 
      }
    }
    # names of the ortholog groups
    elsif ($set =~ /!(\w+)/) { $hash_of_groups{not_process}{$1} = 1; }
    elsif ($set =~ /(\w+)/) { $hash_of_groups{line}{$1} = 1; }  
    else { next; }
  }
  return \%hash_of_groups;
}


# obtains the genes in each cluster set and the number of genes and species in it
# checks the presence of paralogies and validity of genes before populating the cluster
sub parse_cluster_file {
  my ($hash_of_groups_ref, $sequences_ref, $parameters) = @_;
  my %clusters;
  my %sequence_data = %{$sequences_ref}; #will store information about sequence, such as genome of origin, etc
                     #used so far to create phylogenetic trees using user-defined trees
                     #in codeml branch mode analysis

  print ('Parsing cluster file ', $parameters->{cluster_file}, "\n") if $parameters->{verbose};
  open (my $fh_cluster_file, "<", $parameters->{cluster_file}) || die ("Couldn't read the cluster file. Please check if the name of the file is correct and its permissions.\nDetails: $!\n");


  # this loop parses the cluster file in three steps to store the desired information about each cluster
  # will discard groups or genes according to behavior_about_bad_clusters and behavoir_about_paralogs
  my $line_number = 0;
  while (my $line = <$fh_cluster_file>) {
    chomp $line;
    $line_number++;

    # Step 1: Obtaining information about the cluster
    my @aux = split(/\t/, $line);
    my $cluster = parse_cluster_id($aux[0]);
    my @genes = split(/\s/, $aux[1]);
    # Checking if the line has one of the ortholog groups chosen by the user
    if (exists $hash_of_groups_ref->{not_process}{$line_number} || exists $hash_of_groups_ref->{not_process}{$cluster} || (!exists $hash_of_groups_ref->{all} && !exists $hash_of_groups_ref->{line}{$line_number} && !exists $hash_of_groups_ref->{line}{$cluster})) {
      print "LOG REMOVE_GROUP_FLAG\tUSER_CRITERIA\t$cluster : not in user-defined range of groups to process\n";
      delete ($clusters{$cluster});
      next;
    }
    # Step 2: storing genes in the cluster according to paralogies and sequence validity.
    # This step has four substeps
    my %specie_tracker;  # Keeps track of the number of genes of each specie in this cluster; used to identify paralogy
    foreach my $element (@genes) {
      if ($element eq '') { next; }
      my ($gene, $specie) = parse_gene_id($element);

      #%sequence_data will store metadata about sequences
      $sequence_data{$gene}{genome} = $specie;
      $sequence_data{$gene}{group} = $cluster;
      if (!defined $sequence_data{$gene}{status}) {
        $sequence_data{$gene}{status} = "OK";
      }
#      print "$sequence_data{$gene}{genome}\t$sequence_data{$gene}{group}\t$sequence_data{$gene}{status}\t$sequence_data{$gene}{nuc_seq}\n";
#      my $a = <STDIN>;
      #flagging as not-OK if sequence already removed.
      if (!$sequence_data{$gene}{nuc_seq}) {
        $sequence_data{$gene}{status} = "NOTOK";
#        print "$gene\t$sequence_data{$gene}{status}\n";
#        my $a = <STDIN>;
      }
      # Step 2.1: Keeping track of the genes of this specie
      if (!defined $specie_tracker{$specie}) {   # first time seeing this gene in the data if not defined; if defined, we have a paralogy
        $specie_tracker{$specie}{genes} = $gene;
        $specie_tracker{$specie}{occurences} = 1;      # Used to identify paralogs
        $specie_tracker{$specie}{invalid_genes} = 0;   # Used to identify genes with invalid sequence to subtract in $clusters{$cluster}{specie} count or to prevent this cluster from being processed, based on the behavior set

        # Used to track if it is a reference genome, 0 if not, 1 if with weak restrictions, 2 if strong
        if    (!defined $parameters->{reference_genome_files}) { $specie_tracker{$specie}{reference_genome} = 0; }
        elsif ($parameters->{reference_genome_files} !~ /$specie/) { $specie_tracker{$specie}{reference_genome} = 0; }
        elsif ($parameters->{reference_genome_files} =~ /(\(w\)|\(weak\))\s*$specie/) { $specie_tracker{$specie}{reference_genome} = 1; }
        elsif ($parameters->{reference_genome_files} =~ /(\(s\)|\(strong\))?\s*$specie/) { $specie_tracker{$specie}{reference_genome} = 2; }  # Here, the ausence of a (w), (s), (strong) or (weak) is interpreted as strong restriction by default

        print LOG ("REFERENCE_GENOME : $parameters->{reference_genome_files}; Specie: $specie\n") if ($specie_tracker{$specie}{reference_genome});

      } else {
        $specie_tracker{$specie}{occurences}++;
      }

      # Step 2.2: Sequence validity verification
      # Check if the sequence of the gene is valid by checking if it is in the sequence hash (previously filtered in parse_genome_files()) before adding the gene to the cluster
      # if not, take measure defined in behavior_about_bad_clusters (do not confuse with behavior_about_paralogs)
      # This check can be overriden by the presence of reference genomes in weak restriction mode
      if (!exists $sequences_ref->{$gene}{nuc_seq}) {
        if ($specie_tracker{$specie}{reference_genome} == 1) {
          print LOG ('Gene ', $gene, ' invalid, but added for being part of a reference genome in weak restriction mode (', $specie, ').', "\n");
        } elsif ($parameters->{behavior_about_bad_clusters} == 1) {   # do not use this gene
          $specie_tracker{$specie}{invalid_genes}++;
          print LOG "REMOVE_SEQUENCE_FLAG\tCONFIRMATION\t$gene\n";
          if ($specie_tracker{$specie}{occurences} == 1 || !$parameters->{behavior_about_paralogs}) { next; }  # cases in which no paralogy treatment is required
        } elsif ($parameters->{behavior_about_bad_clusters} == 2) {   # flags this cluster key as non-usable for function create_sequence_files
          undef %specie_tracker;
          delete ($clusters{$cluster});
          print LOG ('Invalid gene ', $gene, ', cluster removed ', $cluster, " \n");
          print LOG "REMOVE_GROUP_FLAG\tCONFIRMATION\t$cluster : removing group due to behavior_about_bad_clusters = 2. Gene that flagged group: $gene\n";
          last;
        }
      }

      # Step 2.3: Paralogy treatment
      if ($parameters->{behavior_about_paralogs} == 1 && $specie_tracker{$specie}{occurences} > 1) {  # species with paralogs are not added to analysis; any information present about the specie is removed
#        print LOG ('Paralogy identified in cluster ', $cluster, ', gene ', $gene, ' will not be added to cluster', "\n");
        if ($specie_tracker{$specie}{occurences} == 2) { # paralogy identified for this specie for the first time, must remove the gene added earlier in the cluster
          if (defined $clusters{$cluster}{cluster}) {
            $clusters{$cluster}{cluster} =~ s/$specie_tracker{$specie}{genes}//;
            $clusters{$cluster}{cluster} =~ s/^\*\*//;
            $clusters{$cluster}{cluster} =~ s/\*\*$//;
            $clusters{$cluster}{cluster} =~ s/\*(4)/\*(2)/;
            if ($clusters{$cluster}{cluster} eq '') { $clusters{$cluster}{cluster} = undef; } # keeping the cluster clear for populating in the lines below
          }
#          print LOG ('Paralogy identified in cluster ', $cluster, ', gene ', $specie_tracker{$specie}{genes}, ' removed', "\n");
          print LOG "REMOVE_SEQUENCE_FLAG\tPHYLOGENETIC\t$gene\t$cluster : gene have paralogs, behaviour_about_paralogs = 1\n";
        }
        next; 
      } elsif ($parameters->{behavior_about_paralogs} == 2 && $specie_tracker{$specie}{occurences} > 1) {  # remove ortholog groups with paralogs
        delete ($clusters{$cluster});
          print LOG "REMOVE_GROUP_FLAG\tPHYLOGENETIC\t$cluster : removing group due to behavior_about_paralogs = 2. Gene that flagged group: $gene\n";
#          print LOG ('Paralogy identified in cluster ', $cluster, ', orthology set removed (behavior_about_paralogs = 2)', "\n");
        last;
      } elsif ($parameters->{behavior_about_paralogs} == 3 && $specie_tracker{$specie}{occurences} == 1) {  # keep only paralogs
          print LOG "REMOVE_SEQUENCE_FLAG\tPHYLOGENETIC\t$gene\t$cluster : gene does not have paralogs, behaviour_about_paralogs = 3\n";
        next;
      } elsif ($parameters->{behavior_about_paralogs} == 3 && $specie_tracker{$specie}{occurences} > 1) {# keep only paralogs
#          print LOG "REMOVE_SEQUENCE_FLAG\tPHYLOGENETIC\t$gene\t$cluster : gene contain paralogs, behaviour_about_paralogs = 1\n";
#        print LOG ('Paralogy identified in cluster ', $cluster, ' (behavior_about_paralogs = 3)', "\n");
        if (!defined $clusters{$cluster}{cluster}) { $clusters{$cluster}{cluster} = $specie_tracker{$specie}{genes} }  # adds the genes of the specie to the cluster's list
      } elsif ($parameters->{behavior_about_paralogs} == 4 && $specie_tracker{$specie}{occurences} == 1) { #keep only paralogs
          print LOG "REMOVE_SEQUENCE_FLAG\tPHYLOGENETIC\t$gene\t$cluster : gene does not have paralogs, behaviour_about_paralogs = 4\n";
          next;
      } elsif ($parameters->{behavior_about_paralogs} == 4 && $specie_tracker{$specie}{occurences} > 1) {
#        print LOG ('Paralogy identified in cluster ', $cluster, ' for specie in file ', $specie, ' (behavior_about_paralogs = 4)', "\n");
        $specie_tracker{$specie}{genes} .= '**' . $gene;
        next;
      }

      # Step 2.4: Adding the gene to the cluster
      # This part is reached only if the gene passed the verifications of validity and paralogy
      # and is ignored by $behavior_about_paralogs == 4
      if (defined $clusters{$cluster}{cluster}) { $clusters{$cluster}{cluster} .= '**' . $gene; }
      else { $clusters{$cluster}{cluster} = $gene; }
    }

    # Step 3: Check for relative size of the sequences
#    if (!validate_relative_sequence_size (\%clusters, \%specie_tracker, $sequences_ref, $translation_ref, $parameters, $cluster)) {
#      print LOG ('Cluster ', $cluster, ' removed for containing sequences below the specified relative size within the group.', "\n");
#      print ('Cluster ', $cluster, ' removed for containing sequences below the specified relative size within the group.', "\n") if ($parameters->{verbose});
#      next;
#    }

    # Step 4: remove clusters that don't have any of the reference genomes chosen by the user and separate the gene of the reference genome in the cluster.
    # Applied only if the user defines any reference genome, skipped otherwise.
    # Also clean the cluster structure from unused or removed keys
    if (defined $parameters->{reference_genome_files}) {
      my $track_in_reference_genome = 0;
      foreach my $genome (keys %specie_tracker) {
        if ($specie_tracker{$genome}{reference_genome} == 1 || ($specie_tracker{$genome}{reference_genome} == 2 && $specie_tracker{$genome}{occurences} > $specie_tracker{$genome}{invalid_genes})) {
          $track_in_reference_genome = 1;
          if (!defined $clusters{$cluster}{reference_gene}) {$clusters{$cluster}{reference_gene} = $specie_tracker{$genome}{genes}; }  # keeping track of reference genes
          else { $clusters{$cluster}{reference_gene} .= '**' . $specie_tracker{$genome}{genes}; }
        }
      }
      if (!$track_in_reference_genome) {
        delete($clusters{$cluster});
        print LOG "REMOVE_GROUP_FLAG\tPHYLOGENETIC\t$cluster : removing group due to absence of gene from reference gene\n";
#        print LOG ('Cluster ', $cluster, ' removed for not having any gene belonging to the reference genomes.', "\n");
        next;
      }
    }
    # Step 5: count the number of genes and species in the cluster
    if (defined $clusters{$cluster}{cluster} && $parameters->{behavior_about_paralogs} != 4) {
      my @aux_gene_number = split(/\*\*/, $clusters{$cluster}{cluster});
      $clusters{$cluster}{gene_number} = @aux_gene_number;
      $clusters{$cluster}{specie} = scalar keys %specie_tracker;
      foreach my $specie_key (keys %specie_tracker) {
        if ($parameters->{behavior_about_bad_clusters} && ($specie_tracker{$specie_key}{invalid_genes} == $specie_tracker{$specie_key}{occurences})) {
          $clusters{$cluster}{specie}--;
        }
        elsif ($parameters->{behavior_about_paralogs} == 1 && $specie_tracker{$specie_key}{occurences} > 1) { $clusters{$cluster}{specie}--; }
        elsif ($parameters->{behavior_about_paralogs} == 3 && $specie_tracker{$specie_key}{occurences} == 1) { $clusters{$cluster}{specie}--; }
      }
    } elsif ($parameters->{behavior_about_paralogs} == 4) {
      my $specie_number = 1;
      foreach my $specie_key (keys %specie_tracker) {
        if (($specie_tracker{$specie_key}{occurences} - $specie_tracker{$specie_key}{invalid_genes}) <= 1) { next; }

        if (defined $parameters->{reference_genome_files}) {      # Checking if this specie has any reference gene in this paralogy set
          my @cluster_ref_genes = split (/\*\*/, $clusters{$cluster}{reference_gene});
          my $specie_ref_genes;
          foreach my $ref_gene (@cluster_ref_genes) {
            if ($specie_tracker{$specie_key}{genes} =~ /$ref_gene/) { $specie_ref_genes .= $ref_gene; }
          }
          if (!defined $specie_ref_genes) { next; }  # If we don't detect a reference gene in this specie, we move to the next specie
        } 

        my $cluster_name = $cluster . '_' . $specie_number;
        $clusters{$cluster_name}{cluster} = $specie_tracker{$specie_key}{genes};
        $clusters{$cluster_name}{gene_number} = $specie_tracker{$specie_key}{occurences} - $specie_tracker{$specie_key}{invalid_genes};
        $clusters{$cluster_name}{specie} = 1;
        $clusters{$cluster_name}{reference_gene} = $clusters{$cluster}{reference_gene};
        print LOG ("Cluster $cluster_name created for the specie in file $specie_key\n");
#       need to call this function here because cluster changes for cluster_name
        if (!validate_relative_sequence_size (\%clusters, \%specie_tracker, $sequences_ref, $parameters, $cluster_name)) {
          if ($parameters->{behavior_about_bad_clusters} == 2) {
            print LOG "REMOVE_GROUP_FLAG\tQUALITY\t$cluster_name : removed for containing sequences outside the specified relative size within the group\n";
            delete $clusters{$cluster_name};
          }
#         print LOG ('Cluster ', $cluster_name, ' removed for containing sequences outside the specified relative size within the group.', "\n");
#          print ('Cluster ', $cluster_name, ' removed for containing sequences outside the specified relative size within the group.', "\n") if ($parameters->{verbose});
        next;
        }
        $specie_number++;
      }
    }
    if (!defined $clusters{$cluster}{cluster}) {
      if ($parameters->{behavior_about_paralogs}  == 4) {
        print LOG "REMOVE_GROUP_FLAG\tPHYLOGENETIC\t$cluster : original group removed and splitted in paralogs subclusters\n";
#        print ('Cluster ', $cluster, ' splitted in paralogs and removed from analysis', "\n");
#        print LOG ('Cluster ', $cluster, ' splitted in paralogs and removed from analysis', "\n");
        delete ($clusters{$cluster});
      }
      else {
        print LOG "REMOVE_GROUP_FLAG\tQUALITY\t$cluster : empty\n";
#        print LOG ('Cluster ', $cluster, ' empty, removed from the analysis', "\n");
        print ('Cluster ', $cluster, ' empty, removed from the analysis', "\n") if $parameters->{verbose};
          delete ($clusters{$cluster});
      }
    }

    # Step 3: Check for relative size of the sequences
    
    if ($parameters->{behavior_about_paralogs} != 4 && !validate_relative_sequence_size (\%clusters, \%specie_tracker, $sequences_ref, $parameters, $cluster)) {
      if ($parameters->{behavior_about_bad_clusters} == 2) {
        print LOG "REMOVE_GROUP_FLAG\tQUALITY\t$cluster : removed for containing sequences outside the specified relative size within the group\n";
        delete $clusters{$cluster};
      }
#      print "Here $cluster!\n";
#      my $a = <STDIN>;
#      print LOG ('Cluster ', $cluster, ' removed for containing sequences outside the specified relative size within the group.', "\n");
#      print ('Cluster ', $cluster, ' removed for containing sequences outside the specified relative size within the group.', "\n") if ($parameters->{verbose});
      next;
    }

    #checking if gene from reference genome was filtered out during validate_relative_sequence_size
    #step. Must refatorate this soon.

    if (defined $parameters->{reference_genome_files}) {
      my $track_in_reference_genome = 0;
      foreach my $genome (keys %specie_tracker) {
        if ($specie_tracker{$genome}{reference_genome} == 1 || ($specie_tracker{$genome}{reference_genome} == 2 && $specie_tracker{$genome}{occurences} > $specie_tracker{$genome}{invalid_genes})) {
          $track_in_reference_genome = 1;
          if (!defined $clusters{$cluster}{reference_gene}) {$clusters{$cluster}{reference_gene} = $specie_tracker{$genome}{genes}; }  # keeping track of reference genes
          else { $clusters{$cluster}{reference_gene} .= '**' . $specie_tracker{$genome}{genes}; }
        }
      }
      if (!$track_in_reference_genome) {
        delete($clusters{$cluster});
        print LOG "REMOVE_GROUP_FLAG\tPHYLOGENETIC\t$cluster : removing group due to absence of gene from reference gene\n";
#        print LOG ('Cluster ', $cluster, ' removed for not having any gene belonging to the reference genomes.', "\n");
        next;
      }
    }
    $clusters{$cluster}{specie_tracker} = %specie_tracker; #storing information about species found within group, will be used in check_cluster subroutine
  }  # closing the "while" loop
  close($fh_cluster_file);
  print('Done', "\n") if $parameters->{verbose};
  return (\%clusters, \%sequence_data);
}


sub parse_cluster_id {
  my $line = shift;
  $line =~ s/:$//;
  $line =~ s/\(\s*\d*\s*gene[s]?\s*,\d*\s*tax(a|on)\s*\)$//;
  return $line;
}

sub parse_gene_id {
  my @aux = split (/\(/, $_[0]);
  my $specie = $aux[1];
  $specie =~ s/\)//g;
  return ($aux[0], $specie);  # aux[0] has the if o the gene
}

# remove sequences that fall outside the allowed relative range of sequence length
# calculates a dispersion measure (mean or median) and evaluates if sequence length
# falls outside [max|min] * dispersion measure
sub validate_relative_sequence_size {
  my ($clusters_ref, $specie_tracker, $sequences_ref, $parameters, $key) = @_;
  if (!defined $parameters->{relative_min_sequence_size} ||!defined $parameters->{relative_max_sequence_size} || !defined $parameters->{behavior_about_bad_clusters} || $parameters->{behavior_about_bad_clusters} == 0) { return 1; }
  if (!defined $clusters_ref->{$key}{cluster} || $clusters_ref->{$key}{cluster} eq '') { return 1; }

  my $dispersion_measure; #will be sequence length mean or median for group

  if ($parameters->{sequence_size_dispersion_measure} eq "mean") {
    $dispersion_measure = dispersion_measure($clusters_ref, $sequences_ref, $key, "mean");  
  }
  elsif ($parameters->{sequence_size_dispersion_measure} eq "median") {
    $dispersion_measure = dispersion_measure($clusters_ref, $sequences_ref, $key, "median");
  }
  else {return 1;}
  my $tmp = $parameters->{sequence_size_dispersion_measure};
  my @genes = split (/\*\*/, $clusters_ref->{$key}{cluster});

  for (my $i = 0; $i < scalar(@genes); $i++) {
    my $gene = $genes[$i];
    my $seq_up = $dispersion_measure * $parameters->{relative_max_sequence_size}; #upper limit for sequence length
    my $seq_low = $dispersion_measure * $parameters->{relative_min_sequence_size}; #lower limit for sequence length
    my $tmp = length($sequences_ref->{$gene}{nuc_seq});
    if (($seq_low > length($sequences_ref->{$gene}{nuc_seq})) #sequence length smaller than cutoff
       ||($seq_up < length($sequences_ref->{$gene}{nuc_seq}))) { #or greater
      if ($parameters->{behavior_about_bad_clusters} == 1) {
        foreach my $specie (keys %{$specie_tracker}) {
          if ($specie_tracker->{$specie}->{genes} eq $genes[$i]) {
            $sequences_ref->{$gene}{status} = "NOTOK";
            $specie_tracker->{$specie}->{invalid_genes}++;
            last;
          }
        }
#        my $rel_min = $parameters->{relative_min_sequence_size};
#        my $rel_max = $parameters->{relative_max_sequence_size};
        my $seq_len = length($sequences_ref->{$gene}{nuc_seq});
        print LOG "REMOVE_SEQUENCE_FLAG\tQUALITY\t$genes[$i]\t$key : gene greater/smaller than specified relative sequence size (length: $seq_len, upper for group: $seq_up, lower for group: $seq_low)\n";

#        print LOG ('Gene ', $genes[$i], ' removed for containing sequence greater/smaller than specified relative size (rel_min: ', $parameters->{relative_min_sequence_size},' rel_max: ', $parameters->{relative_max_sequence_size},') within the group (dispersion: ',$dispersion_measure,') (seq_len: ',length($sequences_ref->{$gene}{nuc_seq}),') (upper: ',$seq_up,') (lower: ',$seq_low,')).', "\n");
#        print 'Gene ', $genes[$i], ' removed for containing sequence greater/smaller than specified relative size (rel_min: ', $parameters->{relative_min_sequence_size},' rel_max: ', $parameters->{relative_max_sequence_size},') within the group (dispersion: ',$dispersion_measure,') (seq_len: ',length($sequences_ref->{$gene}{nuc_seq}),') (upper: ',$seq_up,') (lower: ',$seq_low,')).', "\n";
#        print 'Gene ', $genes[$i], ' removed for containing sequence greater/smaller than specified relative size (rel_min - ', $parameters->{relative_min_sequence_size},' rel_max - ', $parameters->{relative_max_sequence_size},') within the group (dispersion - ',$dispersion_measure,') (seq_len - ',length($sequences_ref->{$gene}{nuc_seq}),') (',$seq_up,') (',$seq_low,')).', "\n";

        splice(@genes, $i, 1);
        $i--;
      } elsif ($parameters->{behavior_about_bad_clusters} == 2) {
          my $seq_len = length($sequences_ref->{$gene}{nuc_seq});
          print LOG "REMOVE_GROUP_FLAG\tQUALITY\t$genes[$i]\t$key : group removed (behavior_about_bad_clusters = 2), gene greater/smaller than specified relative sequence size (length: $seq_len, upper for group: $seq_up, lower for group: $seq_low)\n";
        delete ($clusters_ref->{$key});
        return 0;
      }
    }
  }
  $clusters_ref->{$key}{cluster} = join('**', @genes);
#  print ($clusters_ref->{$key}{cluster},"\n");
#  my $a = <STDIN>;
  return 1;
}

sub dispersion_measure {
  my ($cluster_ref, $seq_ref, $key, $measure) = @_;
  if ($measure eq "mean") {
    my @genes = split (/\*\*/, $cluster_ref->{$key}{cluster});
#    print ("@genes\n");
#    my $a = <STDIN>;
    my $sum = 0;
    my $total = 0;
    foreach my $gene (@genes) {
#      print ("$gene\t",$seq_ref->{$gene},"\n");
#      my $a = <STDIN>;
      $sum = $sum + length($seq_ref->{$gene}{nuc_seq});
      $total++;
    }
    my $mean = $sum/$total;
    return $mean;
  }
  if ($measure eq "median") {
    my @genes = split (/\*\*/, $cluster_ref->{$key}{cluster});
    my @lengths; #will store gene lengths
    for (my $i = 0; $i <= $#genes; $i++) {
      $lengths[$i] = length($seq_ref->{$genes[$i]}{nuc_seq});
    }
    my @vals = sort {$a <=> $b} @lengths;
    my $len = @vals;
    if($len%2) { #odd
      return $vals[int($len/2)];
    }
    else { #even
      return ($vals[int($len/2)-1] + $vals[int($len/2)])/2;
    }
  }
}


# checks whether each ortholog group in the cluster is within the restrictions of gene and specie numbers, delete those who aren't
sub trim_cluster {
  my ($clusters_ref, $sequences_ref, $parameters) = @_;

  # Correcting the minimum number of genes for each cluster to 3 if lower than that.
  if ($parameters->{minimum_gene_number_per_cluster} < 3) {
    $parameters->{minimum_gene_number_per_cluster} = 3;
    print LOG ("Minimum number of gene must be at least 3 to allow proper generation of phylogenetic trees, parameter 'minimum_gene_number_per_cluster' adjusted to 3.\n");
  }

  # Correcting for the case of behavior_about_paralogs = 4, which has only one specie for each cluster
  if ($parameters->{behavior_about_paralogs} == 4) {
    $parameters->{minimum_specie_number_per_cluster} = 1;
    $parameters->{maximum_specie_number_per_cluster} = 1;
  }

  print LOG ('PARAMETER'."\t".'Minimum_gene_number_per_cluster: ', $parameters->{minimum_gene_number_per_cluster}, "\n");
  print LOG ('PARAMETER'."\t".'Maximum_gene_number_per_cluster: ', $parameters->{maximum_gene_number_per_cluster}, "\n");
  print LOG ('PARAMETER'."\t".'Minimum_specie_number_per_cluster: ', $parameters->{minimum_specie_number_per_cluster}, "\n");
  print LOG ('PARAMETER'."\t".'Maximum_specie_number_per_cluster: ', $parameters->{maximum_specie_number_per_cluster}, "\n");

  foreach my $key (keys %{$clusters_ref}) {
    if ((defined $clusters_ref->{$key}{gene_number})&&(defined $clusters_ref->{$key}{specie})&& #behaviour_about_paralogs=4 deletes clusters to create subclusters and remove these guys
        ((defined $parameters->{minimum_gene_number_per_cluster} && $clusters_ref->{$key}{gene_number} < $parameters->{minimum_gene_number_per_cluster}) || # number of genes smaller than cutoff
        (defined $parameters->{maximum_gene_number_per_cluster} && $clusters_ref->{$key}{gene_number} > $parameters->{maximum_gene_number_per_cluster}) || # number genes greater than cutoff
        (defined $parameters->{minimum_specie_number_per_cluster} && $clusters_ref->{$key}{specie} < $parameters->{minimum_specie_number_per_cluster}) || # same for species
        (defined $parameters->{maximum_specie_number_per_cluster} && $clusters_ref->{$key}{specie} > $parameters->{maximum_specie_number_per_cluster}))) {
          print LOG "REMOVE_GROUP_FLAG\tPHYLOGENETIC\t$key : does not match minimum maximum restrictions for #genes/#species: ";
          print LOG "species: ".$clusters_ref->{$key}{specie}.", genes: ".$clusters_ref->{$key}{gene_number}."\n";
#      print LOG ($key, ' does not match the restrictions of minimum and maximum number of genes and species (', $clusters_ref->{$key}{gene_number}, ' genes, ', $clusters_ref->{$key}{specie}, ' species)',  "\n");
#      print ($key, ' does not match the restrictions of minimum and maximum number of genes and species (', $clusters_ref->{$key}{gene_number}, ' genes, ', $clusters_ref->{$key}{specie}, ' species), removing from the analysis', "\n") if $parameters->{verbose};
      delete ($clusters_ref->{$key});
#      print LOG ($key, ' removed from cluster', "\n");
    } elsif (!defined $clusters_ref->{$key}{cluster}) { # in case of empty keys
      print LOG "REMOVE_GROUP_FLAG\tQUALITY\t$key : empty\n";
      delete ($clusters_ref->{$key});
    }
    elsif ((!defined $clusters_ref->{$key}{gene_number})||(!defined $clusters_ref->{$key}{specie})) {
      print LOG "REMOVE_GROUP_FLAG\tQUALITY\t$key : not defined #genes/#species\n";
      delete ($clusters_ref->{$key});
    }
  }
  if ($parameters->{remove_identical} eq "yes") { 
    trim_all_equal_sequences_groups($clusters_ref, $sequences_ref, $parameters);
  }
  # Printing the final state of the cluster
  print LOG ('Total number of valid clusters: ', scalar keys %{$clusters_ref}, "\n");
  print ('Total number of valid clusters: ', scalar keys %{$clusters_ref}, "\n") if $parameters->{verbose};
  foreach my $key (keys %{$clusters_ref}) {
    print LOG ('Nº of sequences in cluster ', $key, ' = ', $clusters_ref->{$key}{gene_number}, "\n");
    print ('Nº of sequences in cluster ', $key, ' = ', $clusters_ref->{$key}{gene_number}, "\n") if $parameters->{verbose};
  }

  if (scalar keys %{$clusters_ref} == 0) { print ("No valid groups under the defined parameters.\nClosing POTION.\n"); exit(0); }
  return;
}


# Remove groups where all sequences are identical
# This is done because CODEML rejects them as possible cases with positive selection, so no point to analyze them
sub trim_all_equal_sequences_groups {
  my ($clusters_ref, $sequences_ref, $parameters) = @_;

  open(my $fh_allvalid_enrichment, ">", "$parameters->{project_dir}/results/allvalid_for_enrichment");
  foreach my $key (keys %{$clusters_ref}) {
    my $all_equal = 1;
    my @genes = split (/\*\*/, $clusters_ref->{$key}{cluster});
    foreach my $gene (@genes) {
      if (defined $sequences_ref->{$gene}{nuc_seq} && $sequences_ref->{$gene}{nuc_seq} ne $sequences_ref->{$genes[0]}{nuc_seq}) {
        $all_equal = 0;
        last;
      }
    }
    if ($all_equal) {
      print LOG "REMOVE_GROUP_FLAG\tQUALITY\t$key : all sequences are identical\n";
      print LOG "Gene $genes[0] removed from analysis, identical to all other genes\n";
      print $fh_allvalid_enrichment (">$genes[0]\n$sequences_ref->{$genes[0]}{nuc_seq}\n\n");
      delete ($clusters_ref->{$key});
    }
  }
  close($fh_allvalid_enrichment);
}

sub create_sequence_files {
  my ($clusters_ref, $sequences_ref, $id2tmp_id_ref, $ortholog_group) = @_;

  if (-s "./$$ortholog_group.cluster.aa.fa" && -s "./$$ortholog_group.cluster.nt.fa") {
    print LOG ("Files $$ortholog_group.cluster.aa.fa and $$ortholog_group.cluster.nt.fa already exist, skipping the creation of sequence files for group $$ortholog_group.\n");
    return;
  }
  open (my $fh_out_nt, ">", "./$$ortholog_group.cluster.nt.fa.i") || die ("Couldn't create the nucleotide sequence files at the project directory, required for alignment, closing POTION.\n");
  open (my $fh_out_aa, ">", "./$$ortholog_group.cluster.aa.fa.i") || die ("Couldn't create the aminoacid sequence files at the project directory, required for alignment, closing POTION.\n");
  my @genes = split (/\*\*/, $clusters_ref->{$$ortholog_group}{cluster});


  # Giving priority for genes in reference genomes (if present) and, given it, the largest size of the gene. We do it to ease the processing of future result files.
  # Places the largest gene sequence of the group in the first position of the array. If there are any reference genes, it will be the largest reference gene instead.
  my @largest_gene = (-1, -1);   # (size, index)
  my $replacement_position = 1;
  for (my $i = 0; $i < @genes; $i++) {
    my $gene = $genes[$i];
    if ((length($sequences_ref->{$genes[$i]}{nuc_seq}) > $largest_gene[0] && defined $clusters_ref->{$$ortholog_group}{reference_gene} && $clusters_ref->{$$ortholog_group}{reference_gene} =~ /$gene/)
     || (length($sequences_ref->{$genes[$i]}{nuc_seq}) > $largest_gene[0] && !defined $clusters_ref->{$$ortholog_group}{reference_gene})) {
      $largest_gene[0] = length($sequences_ref->{$genes[$i]}{nuc_seq});
      $largest_gene[1] = $i;
    }
  }
  if ($largest_gene[1] > -1) {
    my $aux = $genes[0];
    $genes[0] = $genes[$largest_gene[1]];
    $genes[$largest_gene[1]] = $aux;

    # Permanently store this new order in the cluster hash, it is useful for keeping the ordering after the multiple alignment. Not essential, though.
    $clusters_ref->{$$ortholog_group}{cluster} = join('**', @genes);
  }
  print LOG ("$$ortholog_group: $genes[0] as first sequence in sequence files, $id2tmp_id_ref->{$genes[0]}\n");


  # Printing the genes and their sequences
  foreach my $gene (@genes) {
    print $fh_out_nt (">$id2tmp_id_ref->{$gene}\n$sequences_ref->{$gene}{nuc_seq}\n\n") if (defined $id2tmp_id_ref->{$gene} && defined $sequences_ref->{$gene}{nuc_seq});  # filling a file with the nucleotide sequences of the ortholog group, fasta format

    my $seq_aa_ungapped = $sequences_ref->{$gene}{prot_seq};  # same for aminoacid sequences, but filtering gaps
    $seq_aa_ungapped =~ s/\*//g if (defined $seq_aa_ungapped);
    print $fh_out_aa (">$id2tmp_id_ref->{$gene}\n$seq_aa_ungapped\n\n") if (defined $id2tmp_id_ref->{$gene} && defined $seq_aa_ungapped);
  }

  close ($fh_out_nt);
  close ($fh_out_aa);
  move("$$ortholog_group.cluster.nt.fa.i", "$$ortholog_group.cluster.nt.fa");
  move("$$ortholog_group.cluster.aa.fa.i", "$$ortholog_group.cluster.aa.fa");

  return;
}


sub create_protein_alignment_files {
  my ($parameters, $clusters_ref, $tmp_id2id_ref, $ortholog_group) = @_;

  if (-s "./$$ortholog_group.group_status") {#group_status file indicates error in some step. Existence indicate failure of task.
    return;
  } 

  if (-s "$$ortholog_group.cluster.aa.fa.aln" && -s 'id_names') {
    print LOG ("Files $$ortholog_group.cluster.aa.fa.aln and id_names already exist, skipping the creation of protein alignment file for group $$ortholog_group\n");
    return;
  }
  print ("Creating multiple alignment for $$ortholog_group\n") if $parameters->{verbose};

  # Execution of the multiple alignment and exception catching
  my $tries = 0;
  while ($tries < $parameters->{tries} && !-s "$$ortholog_group.cluster.aa.fa.aln.2.fas" && -s "$$ortholog_group.cluster.nt.fa" && -s "$$ortholog_group.cluster.aa.fa") {
    $tries++;
    try {
      if (!defined $parameters->{multiple_alignment} || $parameters->{multiple_alignment} =~ /muscle/i) {  # For now, MUSCLE is the default program to run
        print LOG ("$parameters->{muscle_path} -in ./$$ortholog_group.cluster.aa.fa -out ./$$ortholog_group.cluster.aa.fa.aln.2.fas' -log ./$$ortholog_group.cluster.aa.fa.aln.log -quiet\n");
        my $stderr = capture_stderr {system ("$parameters->{muscle_path} -in ./$$ortholog_group.cluster.aa.fa -out ./$$ortholog_group.cluster.aa.fa.aln.2.fas -log ./$$ortholog_group.cluster.aa.fa.aln.log -quiet")};
        if ($stderr) {
          open (OUTERR,">>$$ortholog_group.group_status");
          print OUTERR "STOP\nError during sequence alignment using muscle\n$stderr\n";
          close OUTERR;
        }
      } elsif ($parameters->{multiple_alignment} =~ /mafft/i) {
        print LOG ("$parameters->{mafft_path} --auto $$ortholog_group.cluster.aa.fa > ./$$ortholog_group.cluster.aa.fa.aln.2.fas\n");
        my $stderr = capture_stderr {system ("$parameters->{mafft_path} --auto $$ortholog_group.cluster.aa.fa > ./$$ortholog_group.cluster.aa.fa.aln.2.fas")};  # maybe 2>/dev/null as well  
        if ($stderr) {
#          open (OUTERR,">>$$ortholog_group.group_status");
#          print OUTERR "STOP\nError during sequence alignment using mafft\n$stderr\n";
#          close OUTERR;
        }
      }
      elsif ($parameters->{multiple_alignment} =~ /prank/i) {
        print LOG ("$parameters->{prank_path} -d=$$ortholog_group.cluster.aa.fa -o=$$ortholog_group.cluster.aa.fa.aln -quiet -twice -F\n");
        my $stderr = capture_stderr {system ("$parameters->{prank_path} -d=$$ortholog_group.cluster.aa.fa -o=./$$ortholog_group.cluster.aa.fa.aln -quiet -twice -F 1> /dev/null")};  # maybe 2>/dev/null as well  
        if ($stderr) {
          open (OUTERR,">>$$ortholog_group.group_status");
          print OUTERR "STOP\nError during sequence alignment using prank\n$stderr\n";
          close OUTERR;
        }
      }
    } catch { 
      if ($tries >= $parameters->{tries} && !-s "$$ortholog_group.cluster.aa.fa.aln.2.fas" && -s "$$ortholog_group.cluster.nt.fa" && -s "$$ortholog_group.cluster.aa.fa" && defined $_) {
        if (!defined $parameters->{multiple_alignment} || $parameters->{multiple_alignment} =~ /muscle/i) {
          print LOG_ERR ("Couldn't build a multiple alignment with MUSCLE for group $$ortholog_group, you may have to reexecute POTION later or process this group manually.\nError: $_\n\n");
        } elsif ($parameters->{multiple_alignment} =~ /prank/i) {
          print LOG_ERR ("Couldn't build a multiple alignment with PRANK for group $$ortholog_group, you may have to reexecute POTION later or process this group manually.\nError: $_\n\n");
        }
        die();
      }
    };
  }

  # Workaround to make the reference genes appear as the first sequences
  my %reference_genes;
  
  my %file_content;

  if (! -s "$$ortholog_group.cluster.aa.fa.aln.2.fas") {
    open (OUTERR,">>$$ortholog_group.group_status");
    print OUTERR "STOP\nError during sequence alignment using prank\nfile not created\n";
    close OUTERR;
  }

  if (-s "$$ortholog_group.group_status") {#if exists .group_status some error happened
    return;
  }

  my $in = Bio::SeqIO->new(-file => "./$$ortholog_group.cluster.aa.fa.aln.2.fas" , 
                           -format => 'fasta', -verbose => -1);

  while (my $aln = $in->next_seq()) {
    my $tmp_id = $aln->display_id();
    my $gene_id = $tmp_id2id_ref->{$tmp_id};
    if (defined $clusters_ref->{$$ortholog_group}{reference_gene} && $clusters_ref->{$$ortholog_group}{reference_gene} =~ /$gene_id/) {
      $reference_genes{$gene_id}{id} = $tmp_id;
      $reference_genes{$gene_id}{seq} = $aln->seq();
    } else {
      $file_content{$gene_id}{id} = $tmp_id;
      $file_content{$gene_id}{seq} = $aln->seq();
    }
  }

  # Printing the aligned genes in the same order from the sequence file
  my @genes = split (/\*\*/, $clusters_ref->{$$ortholog_group}{cluster});
  open(my $fh_aln_file, ">", "$$ortholog_group.cluster.aa.fa.aln.2.fas");
  foreach my $gene_id (@genes) {
    if (exists $reference_genes{$gene_id}{id}) { print $fh_aln_file (">$reference_genes{$gene_id}{id}\n$reference_genes{$gene_id}{seq}\n\n"); }
    else { if (defined $file_content{$gene_id}{seq}) { print $fh_aln_file (">$file_content{$gene_id}{id}\n$file_content{$gene_id}{seq}\n\n"); }}
  }
  close($fh_aln_file);
  move("$$ortholog_group.cluster.aa.fa.aln.2.fas", "$$ortholog_group.cluster.aa.fa.aln");

  # Adding identification of temporary ID for every gene in the group
  if (!-s 'id_names') {
    if (-s "$$ortholog_group.group_status") {
      return;
    }
    else {
      open(my $fh_tmp_id_identification, ">", 'id_names.i');
      foreach my $gene_id (@genes) {
        if (exists $reference_genes{$gene_id}{id}) { print $fh_tmp_id_identification ("$reference_genes{$gene_id}{id} => $tmp_id2id_ref->{$reference_genes{$gene_id}{id}} (from reference genome)\n"); }
        else {
          if ((defined $file_content{$gene_id}{id}) && (defined $tmp_id2id_ref->{$file_content{$gene_id}{id}})) {
            print $fh_tmp_id_identification ("$file_content{$gene_id}{id} => $tmp_id2id_ref->{$file_content{$gene_id}{id}}\n"); 
          }
          else {
            open (OUTERR,">>$$ortholog_group.group_status");
            print OUTERR "STOP\nError during sequence alignment reordering using prank\nfile id_names not created\n";
#            print OUTERR "DEBUGPRANK\t=>\t*".$$fh_tmp_id_identification."*\t*".$gene_id."*\t*".$$ortholog_group."*\t*".$file_content{$gene_id}{id}."*\t*".$tmp_id2id_ref->{$file_content{$gene_id}{id}}."\n";
            close OUTERR;
#            my $a = <STDIN>;
          }
        }
      }
      close($fh_tmp_id_identification);
      move('id_names.i', 'id_names');
    }
  }
  return;
}

sub filter_divergent_sequences {
  my ($parameters, $clusters_ref, $tmpid2id_ref, $id2tmp_id_ref, $ortholog_group) = @_;
  if ((!defined $parameters->{mean_sequence_identity})&&(!defined $parameters->{mean_divergence_identity_overall})&&(!defined $parameters->{mean_divergence_identity_most_similar_sequence})&&(!defined $parameters->{identity_most_similar_sequence})) {
    return;
  }
#  $parameters->{mean_divergence_identity_overall} = 80; #must go to configuration file!
#  $parameters->{mean_divergence_identity_most_similar_sequence} = 80;
#  $parameters->{identity_most_similar_sequence} = 90;
  if (-s "$$ortholog_group.group_status") {
    return;
  }
  if (-s "$$ortholog_group.cluster.aa.fa.aln.pairs") {
    print LOG ("File $$ortholog_group.cluster.aa.fa.aln.pairs already exists, skipping the creation of protein alignment pairs file for group $$ortholog_group\n");
    return;
  }
  print ("Creating alignment pairs for $$ortholog_group\n") if $parameters->{verbose};
  print LOG ("Creating alignment pairs for $$ortholog_group\n") if $parameters->{verbose};
   
  #executing trimAl to perform alignment of pairs of homologous and eliminate sequences that are highly divervent from all other sequences within group
  my $tries = 0;
  while ($tries < $parameters->{tries} && !-s "$$ortholog_group.cluster.aa.fa.aln.pairs") {
    $tries++;
    try {
#      $parameters->{mean_divergence_identity_overall} = 80; #must go to configuration file!
#      $parameters->{mean_divergence_identity_most_similar_sequence} = 80;
#      $parameters->{identity_most_similar_sequence} = 90;
      if ((defined $parameters->{mean_sequence_identity})||(defined $parameters->{mean_divergence_identity_overall})||(defined $parameters->{mean_divergence_identity_most_similar_sequence})||(defined $parameters->{identity_most_similar_sequence})) {
        my $stder = capture_stderr {system("$parameters->{trimal_path} -in $$ortholog_group.cluster.aa.fa.aln -sident > $$ortholog_group.cluster.aa.fa.aln.pairs")};
        print LOG ("$parameters->{trimal_path} -in $$ortholog_group.cluster.aa.fa.aln -sident > $$ortholog_group.cluster.aa.fa.aln.pairs");
      } else { #in this case nothing should happen since users chose none of the parameters
        next;
#        system("$parameters->{trimal_path} -in $$ortholog_group.cluster.aa.fa.aln -sident > $$ortholog_group.cluster.aa.fa.aln.pairs");
#        print LOG ("$parameters->{trimal_path} -in $$ortholog_group.cluster.aa.fa.aln -sident > $$ortholog_group.cluster.aa.fa.aln.pairs");
      }
    } catch {
      if ($tries >= $parameters->{tries} && !-s "$$ortholog_group.cluster.aa.fa.aln.pairs" && defined $_) {
        print LOG_ERR ("Couldn't build a multiple alignment of pairs with trimAl for group $$ortholog_group, you may have to reexecute POTION later or process this group manually.\nError: $_\n\n");
        die();
      }
    }
  }
#  move("$$ortholog_group.cluster.aa.fa.aln.pairs.i", "$$ortholog_group.cluster.aa.fa.aln.pairs");
  parse_pairs_file($parameters, $clusters_ref, $tmpid2id_ref, $id2tmp_id_ref, $ortholog_group); # will search .pairs files and eliminate highly divergent sequences and groups; deletes .aa.fa groups and create new ones
                                                                                # wihtout divergent sequences
  system ("rm $$ortholog_group.cluster.aa.fa.aln"); #removing the old alignment file, will create a new one below
  system ("rm id_names");
#  if (-e "./$ortholog_group.cluster.aa.fa") {
  create_protein_alignment_files ($parameters, $clusters_ref, $tmpid2id_ref, $ortholog_group);
#  }
  return;
}

sub parse_pairs_file {
  my ($parameters, $clusters_ref, $tmpid2id_ref, $id2tmp_id_ref, $tmp_ortholog_group) = @_;
  open (IN, "$$tmp_ortholog_group.cluster.aa.fa.aln.pairs") ||
    die ("Could not open file $$tmp_ortholog_group.cluster.aa.fa.aln.pairs!\n");
  my $mean_identity = 0; #will store mean group identity
  my $mean_identity_most_similar = 0; # will store mean gorup identity of each sequence to the most similar sequence
  my $identity_most_similar_sequence = 0; #will store individual identities for each sequence to the most similar sequence
  my $group_flag = 0;#will turn 1 if group contain highly divergent sequences
  my %seq_flags; #will store gene ids of divergente sequences
  while (my $line = <IN>) {
    chomp $line;
    if ($line =~ /^#Mean Percentage of identity:/) {
      $line =~ s/^#Mean Percentage of identity:\s+//;
      $mean_identity = $line;
      $mean_identity = $mean_identity * 100;
      print LOG ("Mean identity for cluster $$tmp_ortholog_group: $mean_identity\tCutoff: ".$parameters->{mean_divergence_identity_overall}."\n\n");
      if ($mean_identity < $parameters->{mean_divergence_identity_overall}) {
        print LOG "REMOVE_GROUP_FLAG\tQUALITY\t$$tmp_ortholog_group :mean group sequence identity ($mean_identity) smaller than cutoff:".$parameters->{mean_divergence_identity_overall}."\n";

#        print LOG ("Group $$tmp_ortholog_group removed, mean group sequence identity ($mean_identity) smaller than cutoff:".$parameters->{mean_divergence_identity_overall}."\n");
#        delete($clusters_ref->{$$tmp_ortholog_group});
        open (DUMMY,">>$$tmp_ortholog_group.group_status");
        print DUMMY ("STOP\n");
        close DUMMY;
#        return;
      }
    }
    if ($line =~ /^#Mean Percentage of identity with most similar sequence:/) {
      $line =~ s/^#Mean Percentage of identity with most similar sequence:\s+//;
      $mean_identity_most_similar = $line;
      $mean_identity_most_similar = $mean_identity_most_similar * 100;
      print LOG ("Mean identity most similar group: $mean_identity_most_similar\tCutoff: ".$parameters->{mean_divergence_identity_most_similar_sequence}."\n\n") if $parameters->{verbose};
      if ($mean_identity_most_similar < $parameters->{mean_divergence_identity_most_similar_sequence}) {
        print LOG "REMOVE_GROUP_FLAG\tQUALITY\t$$tmp_ortholog_group :mean identity of most similar sequences ($mean_identity_most_similar) smaller than cutoff:".$parameters->{mean_divergence_identity_most_similar_sequence}."\n";

#        print LOG ("Group $$tmp_ortholog_group removed, mean identity with most similar sequence ($mean_identity_most_similar) smaller than cutoff:".$parameters->{mean_divergence_identity_most_similar_sequence}."\n");
#        delete($clusters_ref->{$$tmp_ortholog_group});
        open (DUMMY,">>$$tmp_ortholog_group.group_status");
        print DUMMY ("STOP\n");
        close DUMMY;
#        return;
      }
    }
    if ($line =~ /^#Percentage of identity matrix:/) { #removing sequences or groups containning sequences with mean identity bellow user-defined cutoff
      my $count = 0;
      until ($line =~ /^\n$/) {
        
        $line = <IN>;
        last if ($line =~ /^\n$/);
        chomp $line;
        my @aux = split (/\t+/, $line);
        my $id = shift @aux;
        $id =~ s/\s+$//g;
        splice(@aux, $count, 1); #removing position $count, which is the position that contains identity of 
        $count++;
        my $mean = mean(\@aux);
        if ($mean < $parameters->{mean_sequence_identity}) { #removing sequence and groups if mean sequence identity with other sequences in groups are bellow user-defined cutoff
          $seq_flags{$id} = 1;
          print LOG "REMOVE_SEQUENCE_FLAG\tQUALITY\t"."$id (".$tmpid2id_ref->{$id}.")  excluded: mean identity with other member groups of $$tmp_ortholog_group ($mean) is smaller than cutoff (".$parameters->{mean_sequence_identity}.")\n";
          if (($tmpid2id_ref->{$id} eq $clusters_ref->{$$tmp_ortholog_group}{reference_gene})&&(defined $parameters->{reference_genome_files})) {#means that the actual gene id is equal to the gene from the reference genome for this group and that user have selected a reference genome, therefore removing this group
            print LOG "REMOVE_GROUP_FLAG\tQUALITY\t"."Group $$tmp_ortholog_group removed, mean identity of sequence $id ($mean) smaller than cutoff (".$parameters->{mean_divergence_identity_most_similar_sequence}.") and $id is the reference gene for this group\n";
            open (DUMMY,">>$$tmp_ortholog_group.group_status");
            print DUMMY ("STOP\n");
            close DUMMY;
#            return;
          }
          if ($parameters->{behavior_about_bad_clusters} == 2) {#will remove group if users selected a scrict group cutoff and group contains a highly divergent sequence
            print LOG "REMOVE_GROUP_FLAG\tQUALITY\t"."Group $$tmp_ortholog_group removed, mean identity of sequence $id ($mean) smaller than cutoff:".$parameters->{mean_divergence_identity_most_similar_sequence}." and behavior about bad clusters is on hard mode\n";
            if (defined $clusters_ref->{$$tmp_ortholog_group}) {
#              delete($clusters_ref->{$$tmp_ortholog_group});
              open (DUMMY,">>$$tmp_ortholog_group.group_status");
              print DUMMY ("STOP\n");
              close DUMMY;
#              return;
            }
          }
        }
      }
    }
    if ($line =~ /^#Percentage of identity with most similar sequence:/) {
      while ($line = <IN>) {
        next if ($line =~ /^\n$/);#skipping last line
        chomp $line;
        my @aux = split(/\t+/, $line);
        my $tmp_id = shift @aux;
        my $identity = shift @aux;
        $tmp_id =~ s/\s+//g;
        $identity =~ s/\s+//g;
        $identity_most_similar_sequence = $identity;
        if ($identity_most_similar_sequence < $parameters->{identity_most_similar_sequence}) {
          print LOG "REMOVE_SEQUENCE_FLAG\tQUALITY\t"."Sequence $tmp_id (".$tmpid2id_ref->{$tmp_id}.")  excluded: maximum identity with any other member of group $$tmp_ortholog_group ($identity_most_similar_sequence) is ismaller than cutoff (".$parameters->{identity_most_similar_sequence}.")\n";
          $seq_flags{$tmp_id} = 1;
          if (($tmp_id eq $clusters_ref->{$$tmp_ortholog_group}{reference_gene})&&(defined $parameters->{reference_genome_files})) {#means that the actual gene id is equal to the gene from the reference genome for this group and that user have selected a reference genome, therefore removing this group
            print LOG "REMOVE_GROUP_FLAG\tQUALITY\t"."Group $$tmp_ortholog_group removed, maximum identity of sequence $tmp_id ($identity_most_similar_sequence) with any other member smaller than cutoff (".$parameters->{identity_most_similar_sequence}.") and $tmp_id is the reference gene for this group\n";
            open (DUMMY,">>$$tmp_ortholog_group.group_status");
            print DUMMY ("STOP\n");
            close DUMMY;
#            return;
          }

          if ($parameters->{behavior_about_bad_clusters} == 2) {#will remove group if users selected a scrict group cutoff and group contains a highly divergent sequence
            print LOG "REMOVE_GROUP_FLAG\tQUALITY\t"."Group $$tmp_ortholog_group removed, mean identity with most similar sequence ($mean_identity_most_similar) bellow cutoff:".$parameters->{mean_divergence_identity_most_similar_sequence}."\n";
            if (defined $clusters_ref->{$$tmp_ortholog_group}) {
#              delete($clusters_ref->{$$tmp_ortholog_group});
              open (DUMMY,">>$$tmp_ortholog_group.group_status");
              print DUMMY ("STOP\n");
              close DUMMY;
#              return;
            }
          }
        }
        else {
        }
      }
    }
  }
  my $outseqio_obj = Bio::SeqIO->new(-file=>">./$$tmp_ortholog_group.cluster.aa.fa.i",-format=>"fasta", -verbose => -1); # will be the new .aa.fa file after removing the distantly related sequences
  my $inseqio_obj = Bio::SeqIO->new(-file=>"<./$$tmp_ortholog_group.cluster.aa.fa",-format=>"fasta", -verbose => -1); # used to pick up sequences
#  if (not defined $clusters_ref->{$$tmp_ortholog_group}{cluster}) {
#    open (DUMMY,">>$$tmp_ortholog_group.group_status");
#    print DUMMY ("STOP\n");
#    close DUMMY;
#    return;
#  }
  my @genes = split (/\*\*/, $clusters_ref->{$$tmp_ortholog_group}{cluster});
  my $count = 0;
  my @tmp_genes_2;
  foreach my $gene(@genes) {
    if (defined $seq_flags{$id2tmp_id_ref->{$gene}}) {
      #if flagged during identity check genes should be skipped
    } else { # otherwise they should be further analysed
      $tmp_genes_2[$count] = $gene;
      $count++;
    }
  }
  if ($count < $parameters->{minimum_gene_number_per_cluster}) {
    print LOG "REMOVE_GROUP_FLAG\tQUALITY\t"."Group $$tmp_ortholog_group removed, after removing divergent sequences it contains less sequences ($count) than the minimum number of genes per cluster:".$parameters->{minimum_gene_number_per_cluster}."\n";
    if (defined $clusters_ref->{$$tmp_ortholog_group}) {
        open (DUMMY,">>$$tmp_ortholog_group.group_status");
        print DUMMY ("STOP\n");
        close DUMMY;
#      delete($clusters_ref->{$$tmp_ortholog_group});
      return;
    }
#    next;
  } else {
    $clusters_ref->{$$tmp_ortholog_group}{cluster} = join("**", @tmp_genes_2);
#  if ($#tmp_genes_2 
#  print LOG "HEREHERE\t$$tmp_ortholog_group".$clusters_ref->{$$tmp_ortholog_group}{cluster}."\n";
    while(my $seq_obj = $inseqio_obj->next_seq) {
      if (defined $seq_flags{$seq_obj->display_id}) { #true if seq_obj id 
      #sequence flagged as too divergent, eliminated here
      } else {
        $outseqio_obj->write_seq($seq_obj);
      }
    }
  }
#  close OUT;
  if (-e "./$$tmp_ortholog_group.cluster.aa.fa.i") {
    system ("rm ./$$tmp_ortholog_group.cluster.aa.fa"); #removing old .aa.fa file
    system ("mv ./$$tmp_ortholog_group.cluster.aa.fa.i ./$$tmp_ortholog_group.cluster.aa.fa"); #creating the new
  }
  return:
}

sub mean {
  my @tmp = @{$_[0]};
  my $soma = 0;
  foreach my $value(@tmp) {
    $soma = $soma + $value;
  }
  my $mean = ($soma/($#tmp+1));
  return $mean;
}

sub create_codon_alignment_files {
  my ($sequences_ref, $tmp_id2id_ref, $ortholog_group) = @_;

  if (-s "./$$ortholog_group.cluster.aa.fa.aln.aa.phy" && -s "./$$ortholog_group.cluster.aa.fa.aln.nt.phy") {
    print LOG ("Files $$ortholog_group.cluster.aa.fa.aln.aa.phy and $$ortholog_group.cluster.aa.fa.aln.nt.phy already exist, skipping the creation of codon alignment files for group $$ortholog_group.\n");
    return;
  }

  if (-s "./$$ortholog_group.group_status") {
    return;
  }

  my $in = Bio::SeqIO->new(-file => "./$$ortholog_group.cluster.aa.fa.aln" , 
			   -format => 'fasta', , -verbose => -1);

  open (my $fh_out_aa_phy, ">", "./$$ortholog_group.cluster.aa.fa.aln.aa.phy.i");
  open (my $fh_out_nt_phy, ">", "./$$ortholog_group.cluster.aa.fa.aln.nt.phy.i");

  my $aln = $in->next_seq();
  my $length = length($aln->seq());
  my $length_nt = $length * 3;
  my $e = 1;
  while (my $aln = $in->next_seq()) { $e++; }
  print $fh_out_aa_phy ("$e  $length\n");
  print $fh_out_nt_phy ("$e  $length_nt\n");

  $in = Bio::SeqIO->new(-file => "./$$ortholog_group.cluster.aa.fa.aln", -format => 'fasta', -verbose => -1);

  # this part generates an phylip ID of valid length (10 characteres) for a phylip sequential file
  while (my $aln = $in->next_seq()) {
    my $acc = $aln->display_id();
    my $acc_tmp = $tmp_id2id_ref->{$acc};
    if (!defined $sequences_ref->{$acc_tmp}{nuc_seq}) { # error handling
      print LOG ("Sequence $acc_tmp isn't a valid nucleotide sequence, it can't be used in the codon alignment.\n");
      exit(0);
    }
    my @dna = split (//, $sequences_ref->{$acc_tmp}{nuc_seq});
    my $dna_count = 0;
    my @prot = split (//, $aln->seq());

    # Printing the ID and the sequence in the phylip sequential format
    print $fh_out_aa_phy ("$acc");
    print $fh_out_nt_phy ("$acc");
    for (my $a = length($acc); $a <= 9; $a ++) {  # calculating remaining size to fit as a phylip ID
      print $fh_out_aa_phy (' ');
      print $fh_out_nt_phy (' ');
    }
    print $fh_out_aa_phy ($aln->seq(), "\n");
    foreach my $aa (@prot) {
      if ($aa eq '-') {
        print $fh_out_nt_phy '---';
      } else {
        for (my $la = 0; $la <=2; $la++) {
          print $fh_out_nt_phy ($dna[$dna_count]);
          $dna_count++;
        }
      }
    }
    print $fh_out_nt_phy ("\n");
  }

  close ($fh_out_aa_phy);
  close ($fh_out_nt_phy);

  # code below creates cluster.aa.fa.aln.nt files, needed to trim codon sequences properly when using
  # the -strict or -strictplus parameters with trimAl

  move("$$ortholog_group.cluster.aa.fa.aln.aa.phy.i", "$$ortholog_group.cluster.aa.fa.aln.aa.phy");
  move("$$ortholog_group.cluster.aa.fa.aln.nt.phy.i", "$$ortholog_group.cluster.aa.fa.aln.nt.phy");
  
  $in  = Bio::AlignIO->new(-file => "$$ortholog_group.cluster.aa.fa.aln.nt.phy" ,
                               -format => 'phylip', -verbose => -1); #verbose setted to avoid an annoying warning

  
  my $out = Bio::AlignIO->new(-file => ">$$ortholog_group.cluster.aa.fa.aln.nt.fa",
                               -format => 'fasta', -verbose => -1); #same as above

  while ( my $aln = $in->next_aln ) {
      $out->write_aln($aln); 
  }
  return;
}




sub identify_recombination {
  my ($parameters, $ortholog_group) = @_;
   if (-s "./$$ortholog_group.group_status") {
     return;
   }

  if (!defined $parameters->{recombination_qvalue} || $parameters->{recombination_qvalue} <= 0) {
    if (!-s 'Phi') {                                  # check to avoid ovewriting a valid analysis from a prior execution
      open(my $fh_dummy_phi_file, ">", 'Phi');        # created only to indicate that the group went through the 'id_rec' task
      print $fh_dummy_phi_file ('No analysis for recombination executed, neutral value for PHI below', "\n", 'PHI (Normal):        1.00e+00', "\n");
      close($fh_dummy_phi_file);
    }
  } else {
    my $content;  # we want to look for recombination, so we check if an existing 'Phi' file is a dummy file to replace it for an actual analysis
    if (-s 'Phi') {
      open(my $fh_check_phi_content, "<", 'Phi');
      $content = <$fh_check_phi_content>;
      close($fh_check_phi_content);
    }
    if (defined $content && $content eq "No analysis for recombination executed, neutral value for PHI below\n") {
      unlink('Phi');
    }
    if (!-s 'Phi') {
      print ("Looking for recombination in group $$ortholog_group...\n") if $parameters->{verbose};
      my $tries = 0;
      while ($tries < $parameters->{tries} && !-s 'Phi') {
        $tries++;
        try {
          my $stderr = capture_stderr {system("$parameters->{phipack_path} -s $$ortholog_group.cluster.aa.fa.aln.nt.phy.trim -o 1>/dev/null 2>/dev/null")};
        } catch { 
          print LOG ("Warning: couldn't run the Maximum Chi-Square and NSS analysis for group $$ortholog_group, executing only PHI test.\n");
          my $stderr = capture_stderr {system("$parameters->{phipack_path} -s $$ortholog_group.cluster.aa.fa.aln.nt.phy.trim 1>/dev/null")};
        };
        move('Phi.log', 'Phi') || die ("Couldn't generate the Phi file for the recombination analysis of group $$ortholog_group\n");
      }
    }
  }
  return;
}

sub read_phi {
  my $phi_file_path = shift;

  open(my $fh_phi, "<", $phi_file_path);
  my ($phi_pvalue, $nss_pvalue, $maxchi2_pvalue);
  while (my $line = <$fh_phi>) {
    if ($line =~ /PHI\s*\(Normal\):\s*(\S+)/) {
      $phi_pvalue = $1;
      if ($phi_pvalue eq '--') { $phi_pvalue = 1; }
      $phi_pvalue = sprintf("%.5f", $phi_pvalue);
    }
    elsif ($line =~ /NSS:\s*(\S+)\s*\(/) {
      $nss_pvalue = $1;
      if ($nss_pvalue eq '--') { $nss_pvalue = 1; }
      $nss_pvalue = sprintf("%.5f", $nss_pvalue);
    }
    elsif ($line =~ /Max\sChi\^2:\s*(\S+)\s*\(/) {
      $maxchi2_pvalue = $1;
      if ($maxchi2_pvalue eq '--') { $maxchi2_pvalue = 1; }
      $maxchi2_pvalue = sprintf("%.5f", $maxchi2_pvalue);
    }
  }

  # Cases when a test couldn't compute properly, known cases are those when there's too little sequence variation
  if (!defined $phi_pvalue) { $phi_pvalue = 1; }
  if (!defined $nss_pvalue) { $nss_pvalue = 1; }
  if (!defined $maxchi2_pvalue) { $maxchi2_pvalue = 1; }

  return ($phi_pvalue, $nss_pvalue, $maxchi2_pvalue);
}


sub trim_sequences {
  my ($parameters, $ortholog_group) = @_;

  if (-s "./$$ortholog_group.group_status") {
    return;
  }

  if (-s "$$ortholog_group.cluster.aa.fa.aln.aa.phy.trim" && -s "$$ortholog_group.cluster.aa.fa.aln.nt.phy.trim") {
    print LOG ("Files $$ortholog_group.cluster.aa.fa.aln.aa.phy.trim and $$ortholog_group.cluster.aa.fa.aln.nt.phy.trim already exist, skipping the creation of trimmed sequences files for group $$ortholog_group.\n");
    return;
  } # no need to change what is already trimmed

  print ("Trimming alignments of $$ortholog_group\n") if $parameters->{verbose};

  my $tries = 0;
  while ($tries < $parameters->{tries} && !-s "$$ortholog_group.cluster.aa.fa.aln.aa.phy.trim.i") {
    $tries++;
    try {
      if ($parameters->{remove_gaps} =~/\D+/) {
        if ($parameters->{remove_gaps} eq "strictplus") {
          print LOG ("$parameters->{trimal_path} -in $$ortholog_group.cluster.aa.fa.aln.aa.phy -out $$ortholog_group.cluster.aa.fa.aln.aa.phy.trim.i -strictplus -colnumbering > $$ortholog_group.trimal_cols.aa\n");
          my $stder = capture_stderr {system("$parameters->{trimal_path} -in $$ortholog_group.cluster.aa.fa.aln.aa.phy -out $$ortholog_group.cluster.aa.fa.aln.aa.phy.trim.i -strictplus -colnumbering > $$ortholog_group.trimal_cols.aa")};
          #takes as input the $group.trimal_cols.aa file, which contais the columns positions trimmed and uses this to trim nucleotide aligned sequences
          create_trimmed_nucleotide_files($ortholog_group);
        }
        elsif ($parameters->{remove_gaps} eq "strict") {
          print LOG ("$parameters->{trimal_path} -in $$ortholog_group.cluster.aa.fa.aln.aa.phy -out $$ortholog_group.cluster.aa.fa.aln.aa.phy.trim.i -strict -colnumbering > $$ortholog_group.trimal_cols.aa\n");
          my $stderr = capture_stderr {system("$parameters->{trimal_path} -in $$ortholog_group.cluster.aa.fa.aln.aa.phy -out $$ortholog_group.cluster.aa.fa.aln.aa.phy.trim.i -strict -colnumbering > $$ortholog_group.trimal_cols.aa")};
          
          #takes as input the $group.trimal_cols.aa file, which contais the columns positions trimmed and uses this to trim nucleotide aligned sequences
          create_trimmed_nucleotide_files($ortholog_group); 
        }
        else {
          print LOG ("$parameters->{trimal_path} -in $$ortholog_group.cluster.aa.fa.aln.aa.phy -out $$ortholog_group.cluster.aa.fa.aln.aa.phy.trim.i -noallgaps\n");
          my $stderr = capture_stderr{system("$parameters->{trimal_path} -in $$ortholog_group.cluster.aa.fa.aln.aa.phy -out $$ortholog_group.cluster.aa.fa.aln.aa.phy.trim.i -noallgaps")};
          print LOG ("$parameters->{trimal_path} -in $$ortholog_group.cluster.aa.fa.aln.nt.phy -out $$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.i -noallgaps\n");
          $stderr = capture_stderr{system("$parameters->{trimal_path} -in $$ortholog_group.cluster.aa.fa.aln.nt.phy -out $$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.i -noallgaps")};
        }
      }
      else {
        if ($parameters->{remove_gaps} >= 1) {
          print LOG ("$parameters->{trimal_path} -in $$ortholog_group.cluster.aa.fa.aln.aa.phy -out $$ortholog_group.cluster.aa.fa.aln.aa.phy.trim.i -nogaps\n");
          my $stderr = capture_stderr{system("$parameters->{trimal_path} -in $$ortholog_group.cluster.aa.fa.aln.aa.phy -out $$ortholog_group.cluster.aa.fa.aln.aa.phy.trim.i -nogaps")};
          print LOG ("$parameters->{trimal_path} -in $$ortholog_group.cluster.aa.fa.aln.nt.phy -out $$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.i -nogaps\n");
          $stderr = capture_stderr{system("$parameters->{trimal_path} -in $$ortholog_group.cluster.aa.fa.aln.nt.phy -out $$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.i -nogaps")};
        } elsif ($parameters->{remove_gaps} < 1 && $parameters->{remove_gaps} > 0) {
          print LOG ("$parameters->{trimal_path} -in $$ortholog_group.cluster.aa.fa.aln.aa.phy -out $$ortholog_group.cluster.aa.fa.aln.aa.phy.trim.i -gt $parameters->{remove_gaps}\n");
          my $stderr = capture_stderr{system("$parameters->{trimal_path} -in $$ortholog_group.cluster.aa.fa.aln.aa.phy -out $$ortholog_group.cluster.aa.fa.aln.aa.phy.trim.i -gt $parameters->{remove_gaps}")};
          print LOG ("$parameters->{trimal_path} -in $$ortholog_group.cluster.aa.fa.aln.nt.phy -out $$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.i -gt $parameters->{remove_gaps}\n");
          $stderr = capture_stderr{system("$parameters->{trimal_path} -in $$ortholog_group.cluster.aa.fa.aln.nt.phy -out $$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.i -gt $parameters->{remove_gaps}")};
        } else {
          print LOG ("$parameters->{trimal_path} -in $$ortholog_group.cluster.aa.fa.aln.aa.phy -out $$ortholog_group.cluster.aa.fa.aln.aa.phy.trim.i -noallgaps\n");
          my $stderr = capture_stderr{system("$parameters->{trimal_path} -in $$ortholog_group.cluster.aa.fa.aln.aa.phy -out $$ortholog_group.cluster.aa.fa.aln.aa.phy.trim.i -noallgaps")};
          print LOG ("$parameters->{trimal_path} -in $$ortholog_group.cluster.aa.fa.aln.nt.phy -out $$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.i -noallgaps\n");
          $stderr = capture_stderr{system("$parameters->{trimal_path} -in $$ortholog_group.cluster.aa.fa.aln.nt.phy -out $$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.i -noallgaps")};
        }
      }
      move("$$ortholog_group.cluster.aa.fa.aln.aa.phy.trim.i", "$$ortholog_group.cluster.aa.fa.aln.aa.phy.trim");
      move("$$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.i", "$$ortholog_group.cluster.aa.fa.aln.nt.phy.trim");
    } catch {
      if ($tries >= $parameters->{tries} && !-s "$$ortholog_group.cluster.aa.fa.aln.aa.phy.trim" || !-s "$$ortholog_group.cluster.aa.fa.aln.nt.phy.trim" && defined $_) {
        print LOG_ERR ("Couldn't trim the sequences for group $$ortholog_group.\nError: $_\n\n");
        die();
      }
    };
  }

  return;
}

sub create_trimmed_nucleotide_files {
  my $file_root = $_[0];
  my $infile = "$$file_root.trimal_cols.aa";
  my $infile_2 = "$$file_root.cluster.aa.fa.aln.nt.fa";
  my $outfile = "$$file_root.cluster.aa.fa.aln.nt.trim.fa";
  my $outfile_2 = "$$file_root.cluster.aa.fa.aln.nt.phy.trim";
    open (IN, "$infile") ||
      die($!);
  my $lines;
    { #to get whole file content without \n changing $/ to a local non-defined value
      local $/;
      $lines = <IN>;
      close IN;
    }
          
  $lines =~ s/\s+//g;
  $lines =~ s/\n//g;
  my @indexes = split(/,/, $lines); # the collumn indexes to be taken from nucleotide aligned files
  open (OUT, ">$outfile") ||
    die;
  my $seqio_obj = Bio::SeqIO->new(-file => $infile_2, -verbose => -1);
  while (my $seq_obj = $seqio_obj->next_seq) {
    my $id = $seq_obj->display_id;
    my $seq = $seq_obj->seq;
    my @aux = split (//, $seq);
    print OUT ">$id\n";
    foreach my $index (@indexes) { #each index corresponds to an amino acid position trimmed, the for bellow is used to trim codons
      for (my $i = 0; $i <= 2; $i++) {
        my $index_2 = ($index*3) + $i;
        print OUT ("$aux[$index_2]");
      }
    }
    print OUT "\n";
  }
  close OUT;
  #need to make sure the sequence order is maintained
  my $in  = Bio::AlignIO->new( -file => "<$outfile" ,
                               -format => 'fasta', verbose => -1);
  
  my $out = Bio::AlignIO->new( -file => ">$outfile_2",
                               -format => 'phylip', verbose => -1);

  while ( my $aln = $in->next_aln ) {
    $out->write_aln($aln);
  }
}


sub store_user_phylogenetic_tree {
  my $infile = $_[0];
  my $phylo_tree_user = $infile;
  return $phylo_tree_user;
}

sub create_tree_files_branch_mode {
  my ($parameters, $sequence_data, $id2tmp_id, $ortholog_group) = @_;
  print "Creating phylogenetic tree for $$ortholog_group using user-defined tree as topological guide\n";
  open (OUTDIC,">$$ortholog_group.id2genome");
  foreach my $key (keys %{$sequence_data}) { #this will create an ID dictionary
    #genes belonging to this group of homologs and not filtered out
    if (($sequence_data->{$key}{group} eq "$$ortholog_group")&&($sequence_data->{$key}{status} eq "OK")) { #to print only
      print OUTDIC "$sequence_data->{$key}{genome} $id2tmp_id->{$key}\n";
    }
  }
  close OUTDIC;


  #changing the species names in user-defined tree for temporary gene names
#  my $stderr = capture_stderr {system ("/projects/POTION_2/programs/newick-utils-1.6/src/nw_rename /projects/POTION_2/bin/user_defined_tree $$ortholog_group.id2genome > $$ortholog_group.dummy_tree")};
  my $stderr = capture_stderr {system ("/projects/POTION_2/programs/newick-utils-1.6/src/nw_rename /projects/POTION_2/bin/primate_tree $$ortholog_group.id2genome > $$ortholog_group.dummy_tree")};
  print "$$ortholog_group\n\n";
  my $a = <STDIN>;
  print LOG ("/projects/POTION_2/programs/newick-utils-1.6/src/nw_rename /projects/POTION_2/bin/user_defined_tree $$ortholog_group.id2genome > $$ortholog_group.dummy_tree\n");
  if ($stderr) {
    open (OUTERR,">>$$ortholog_group.group_status");
    print OUTERR "STOP\nError during creation of tree file using user-defined tree as topological guide\n$stderr\n";
    close OUTERR;
  }
  return;
}


#this subroutine will, sequentially:

#1) substitute the user-defined species labels on tree for tmp gene IDs
#2) remove OTUs comprising genes removed by any gene-filtering step
#3) obtain background and foreground OTUs count
#4) remove any tree outside minimum-maximum OTUs cutoffs


sub trim_tree_file {
  #will remove species names from tmp ID 
  my ($clusters, $parameters, $sequence_data, $id2tmp_id, $ortholog_group) = @_;
  print "Trimming phylogenetic tree for $$ortholog_group\n";
  #obtaining tree labels
  
  my $stderr = capture_stderr {system ("/projects/POTION_2/programs/newick-utils-1.6/src/nw_labels $$ortholog_group.dummy_tree > $$ortholog_group.tree_labels")};

  #contains all names in 
  my @tmp_names;
  open (IN,"<$$ortholog_group.tree_labels");
  my $i = 0;

  while (my $line = <IN>) {
    chomp $line;
    $tmp_names[$i] = $line;
    $i++;
  }
  close IN;
  $i = 0;
  my @removed_names;

  #checking if tree labels are tmp IDs or label to indicate foreground branch
  #and removing them  if not
  foreach my $name (@tmp_names) {
    if (($name !~ /^A\d+$/)&&($name ne "#1")) {
      $removed_names[$i] = $name;
      $i++;
    }
  }
  
  open (OUT, ">$$ortholog_group.removed_OTUs");

  foreach my $name (@removed_names) {
    print OUT "$name\n";
  }

  close OUT;

  #removing species names
  if (@removed_names) {
    my $stderr = capture_stderr {system ("/projects/POTION_2/programs/newick-utils-1.6/src/nw_prune $$ortholog_group.dummy_tree @removed_names > $$ortholog_group.new_dummy_tree")};
    print LOG ("/projects/POTION_2/programs/newick-utils-1.6/src/nw_prune $$ortholog_group.dummy_tree @removed_names > $$ortholog_group.new_dummy_tree");
    print ("/projects/POTION_2/programs/newick-utils-1.6/src/nw_prune $$ortholog_group.dummy_tree @removed_names > $$ortholog_group.new_dummy_tree");
    move("$$ortholog_group.dummy_tree", "$$ortholog_group.old_dummy_tree");
    move("$$ortholog_group.new_dummy_tree", "$$ortholog_group.dummy_tree");
  }
  $stderr = capture_stderr {system ("/projects/POTION_2/programs/newick-utils-1.6/src/nw_clade $$ortholog_group.dummy_tree '#1' > $$ortholog_group.tmp_foreground_branch")};
  $stderr = capture_stderr {system ("/projects/POTION_2/programs/newick-utils-1.6/src/nw_labels $$ortholog_group.tmp_foreground_branch > $$ortholog_group.foreground_branch")};
  
  my @foreground_names;

  open (IN, "$$ortholog_group.foreground_branch");
  
  #obtaining foreground names
  $i = 0;
  while (my $line = <IN>) {
    next if ($line eq "#1"); #skipping codeml node name to indicate foreground
    chomp $line;
    $foreground_names[$i] = $line;
    $i++;
  }
  close IN;

  #obtaining background names
  my @background_names;
  $i = 0;
  foreach my $name (@tmp_names) { 
  my $flag = 0;
    #background should not contain removed names
    foreach my $rem_name (@removed_names) {
      if ($name eq $rem_name) {
        $flag = 1;
      }
    }
    #nor foreground names
    foreach my $for_name (@foreground_names) {
      if ($name eq $for_name) {
        $flag = 1;
      }
    }
    if ($flag ==0) {
      $background_names[$i] = $name;
      $i++;
    }
  }

  #comparing foreground and backgruond countings with cutoffs
  my $for_count = scalar(@foreground_names);
  my $back_count = scalar(@background_names);
#  print "$for_count\t$back_count\n";
#  my $a = <STDIN>;
  if (($for_count < $parameters->{minimum_taxa_foreground})||($for_count > $parameters->{maximum_taxa_foreground})) {
    print ("Group $$ortholog_group removed: the number of foreground taxa ($for_count) is outside user-defined cutoffs ($parameters->{minimum_taxa_foreground} - $parameters->{maximum_taxa_foreground})\n");
    if (defined $clusters->{$$ortholog_group}) {
      print LOG "REMOVE_GROUP_FLAG\tPHYLOGENETIC\t"."Group $$ortholog_group removed: the number of foreground taxa ($for_count) is outside user-defined cutoffs ($parameters->{minimum_taxa_foreground} - $parameters->{maximum_taxa_foreground})\n";
      open (DUMMY,">>$$ortholog_group.group_status");
      print DUMMY ("STOP\n");
      close DUMMY;
#      delete ($clusters->{$$ortholog_group});
    }
  }

  if (($back_count < $parameters->{minimum_taxa_background})||($back_count > $parameters->{maximum_taxa_background})) {
    if (defined $clusters->{$$ortholog_group}) {
      print LOG "REMOVE_GROUP_FLAG\tPHYLOGENETIC\t"."Group $$ortholog_group removed: the number of background taxa ($back_count) is outside user-defined cutoffs ($parameters->{minimum_taxa_background} - $parameters->{maximum_taxa_background})\n";
      open (DUMMY,">>$$ortholog_group.group_status");
      print DUMMY ("STOP\n");
      close DUMMY;
      delete ($clusters->{$$ortholog_group});
    }
  }
  print "foreground names: @foreground_names\nbackground names: @background_names\nremoved names: @removed_names\n\n";
#  my $a = <STDIN>;
}
 

sub create_bootstrap_files {
  my ($parameters, $seq_type, $ortholog_group) = @_;

  if (-s "$$ortholog_group.cluster.aa.fa.aln.$$seq_type.phy.trim.boot") {
    print LOG ("File $$ortholog_group.cluster.aa.fa.aln.$$seq_type.phy.trim.boot already exists, skipping the creation of bootstrap file for group $$ortholog_group.\n");
    return;
  }

  unlink('outfile') if (-e 'outfile');
  boot_file_configuration($parameters, $seq_type, $ortholog_group);

  print ("Generating bootstrap for $$ortholog_group...\n") if $parameters->{verbose};
  print LOG ("$parameters->{seqboot_path} < ./$$ortholog_group.cluster.aa.fa.aln.$$seq_type.phy.trim.conf.boot > ./$$ortholog_group.cluster.aa.fa.aln.$$seq_type.phy.trim.boot.log\n");

  my $tries = 0;
  while ($tries < $parameters->{tries} && !-s "$$ortholog_group.cluster.aa.fa.aln.$$seq_type.phy.trim.boot") {
    $tries++;
    try {
      my $stderr = capture_stderr{system ("$parameters->{seqboot_path} < ./$$ortholog_group.cluster.aa.fa.aln.$$seq_type.phy.trim.conf.boot > ./$$ortholog_group.cluster.aa.fa.aln.$$seq_type.phy.trim.boot.log")};
      move('outfile', "$$ortholog_group.cluster.aa.fa.aln.$$seq_type.phy.trim.boot") || die ("Problem at $$ortholog_group (bootstrap files): couldn't find or manipulate the bootstrap output file.\n");  # renaming output file
    } catch {
      if ($tries >= $parameters->{tries} && !-s "$$ortholog_group.cluster.aa.fa.aln.$$seq_type.phy.trim.boot" && defined $_) {
        print LOG_ERR ("Couldn't produce the bootstrap for group $$ortholog_group.\nError: $_\n\n");
        die();
      }
    };
  }
  return;
}


# creating bootstrap configuration file
sub boot_file_configuration {
  my ($parameters, $seq_type, $ortholog_group) = @_;
  my $rand = int(rand(10000000));
  until ($rand % 2) { $rand = int(rand(10000000)); }
  open (my $fh_conf_boot, ">", "$$ortholog_group.cluster.aa.fa.aln.$$seq_type.phy.trim.conf.boot") || die ("Couldn't configure for the production of the bootstrap file.\n"); 
  print $fh_conf_boot ("$$ortholog_group.cluster.aa.fa.aln.$$seq_type.phy.trim\n");
  print $fh_conf_boot ("R\n");
  print $fh_conf_boot ("$parameters->{bootstrap}\n");
  print $fh_conf_boot ("Y\n");
  print $fh_conf_boot ("$rand\n");
  close ($fh_conf_boot);
  return;
}
#  elsif (($parameters->{phylogenetic_tree} =~ /codonphyml_aa/i) || ($parameters->{phylogenetic_tree} =~ /codonphyml_nt/i)) {
#    open (my $fh_conf_boot, ">", "$$ortholog_group.cluster.aa.fa.aln.$$seq_type.phy.trim.conf.boot") || die ("Couldn't configure for the production of the bootstrap file.\n");
#    print $fh_conf_boot ("$$ortholog_group.cluster.aa.fa.aln.$$seq_type.phy.trim\n");
#    print $fh_conf_boot ("R\n");
#    print $fh_conf_boot ("$parameters->{bootstrap}\n");
#    print $fh_conf_boot ("Y\n");
#    print $fh_conf_boot ("$rand\n");
#    close ($fh_conf_boot);
#    return;
#  }
#   else (die $!."\n");
#}


sub create_tree_files {
  my ($parameters, $seq_type, $ortholog_group) = @_;

  if (-s "$$ortholog_group.cluster.aa.fa.aln.$$seq_type.phy.trim.tree") {
    print LOG ("File $$ortholog_group.cluster.aa.fa.aln.$$seq_type.phy.trim.tree already exists, skipping the creation of phylogenetic tree file for group $$ortholog_group.\n");
    return;
  }

  tree_file_configuration($parameters, $seq_type, $ortholog_group);

  print ("Constructing ML tree of $$ortholog_group...\n") if $parameters->{verbose};

  my $tries = 0;
  while ($tries < $parameters->{tries} && !-s "$$ortholog_group.cluster.aa.fa.aln.$$seq_type.phy.trim.tree") {
    $tries++;
    try {
      if ($parameters->{phylogenetic_tree} =~ /proml/i) {
        print LOG ("$parameters->{proml_path} < ./$$ortholog_group.cluster.aa.fa.aln.aa.phy.trim.conf.tree > ./$$ortholog_group.cluster.aa.fa.aln.aa.phy.trim.tree.log\n");
        my $stderr = capture_stderr{system("$parameters->{proml_path} < ./$$ortholog_group.cluster.aa.fa.aln.aa.phy.trim.conf.tree > ./$$ortholog_group.cluster.aa.fa.aln.aa.phy.trim.tree.log")};
        move('outtree', "$$ortholog_group.cluster.aa.fa.aln.$$seq_type.phy.trim.tree") || die ("Problem at $$ortholog_group (phylogenetic tree files): couldn't produce or manipulate the phylogenetic tree file.\n");  # renaming output file
} 
      elsif ($parameters->{phylogenetic_tree} =~ /dnaml/i) {
        print LOG ("$parameters->{dnaml_path} < ./$$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.conf.tree > ./$$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.tree.log\n");
        my $stderr = capture_stderr{system("$parameters->{dnaml_path} < ./$$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.conf.tree > ./$$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.tree.log")};
        move('outtree', "$$ortholog_group.cluster.aa.fa.aln.$$seq_type.phy.trim.tree") || die ("Problem at $$ortholog_group (phylogenetic tree files): couldn't produce or manipulate the phylogenetic tree file.\n");  # renaming output file
      }
      elsif ($parameters->{phylogenetic_tree} =~ /codonphyml_aa/i) {
        print LOG ("$parameters->{codonphyml_path} < ./$$ortholog_group.cluster.aa.fa.aln.aa.phy.trim.conf.tree > ./$$ortholog_group.cluster.aa.fa.aln.aa.phy.trim.tree.log\n");
        my $stderr = capture_stderr{system("$parameters->{codonphyml_path} < ./$$ortholog_group.cluster.aa.fa.aln.aa.phy.trim.conf.tree > ./$$ortholog_group.cluster.aa.fa.aln.aa.phy.trim.tree.log")};
        copy("$$ortholog_group.cluster.aa.fa.aln.aa.phy.trim.boot_codonphyml_tree.txt", "$$ortholog_group.cluster.aa.fa.aln.$$seq_type.phy.trim.tree") || die ("Problem at $$ortholog_group (phylogenetic tree files): couldn't produce or manipulate the phylogenetic tree file.\n");  # renaming output file
      }
      elsif ($parameters->{phylogenetic_tree} =~ /codonphyml_nt/i) {
        print LOG ("$parameters->{codonphyml_path} < ./$$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.conf.tree > ./$$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.tree.log\n");
        my $stderr = capture_stderr{system("$parameters->{codonphyml_path} < ./$$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.conf.tree > ./$$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.tree.log")};
        copy("$$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.boot_codonphyml_tree.txt", "$$ortholog_group.cluster.aa.fa.aln.$$seq_type.phy.trim.tree") || die ("Problem at $$ortholog_group (phylogenetic tree files): couldn't produce or manipulate the phylogenetic tree file.\n");  # renaming output file
      }
    } catch {
      if ($tries >= $parameters->{tries} && !-s "$$ortholog_group.cluster.aa.fa.aln.$$seq_type.phy.trim.tree" && defined $_) {
        print LOG_ERR ("Couldn't produce the phylogenetic tree for group $$ortholog_group.\nError: $_\n\n");
        die();
      }
    };
  }

  return;
}

sub tree_file_configuration {
  my ($parameters, $seq_type, $ortholog_group) = @_;

  # some phylip packages ask for an odd random number

  if (($parameters->{phylogenetic_tree} =~ /proml/i)||($parameters->{phylogenetic_tree} =~ /dnaml/i)) {
    my $rand = int(rand(10000000));
    until ($rand % 2) { $rand = int(rand(10000000)); }
    open (my $fh_conf_tree, ">", "$$ortholog_group.cluster.aa.fa.aln.$$seq_type.phy.trim.conf.tree") || die ("Couldn't configure for the production of the tree file.\n");
    print $fh_conf_tree ("$$ortholog_group.cluster.aa.fa.aln.$$seq_type.phy.trim.boot\n");
    print $fh_conf_tree ("M\n");
    print $fh_conf_tree ("D\n");
    print $fh_conf_tree ("$parameters->{bootstrap}\n");
    print $fh_conf_tree ("$rand\n");
    print $fh_conf_tree ("1\n"); # this line randomizes the input order of sequences. Change the number to change the randomize times.
    if ($parameters->{phylogenetic_tree_speed} =~ /slow/i) { print $fh_conf_tree ("S\n"); }
    print $fh_conf_tree ("Y\n");
    close ($fh_conf_tree);
    return;
  }
  if ($parameters->{phylogenetic_tree} =~ /codonphyml_aa/i) {
    open (my $fh_conf_tree, ">", "$$ortholog_group.cluster.aa.fa.aln.$$seq_type.phy.trim.conf.tree") || die ("Couldn't configure for the production of the tree file.\n");
    print $fh_conf_tree ("$$ortholog_group.cluster.aa.fa.aln.$$seq_type.phy.trim.boot\n");
    print $fh_conf_tree ("D\n");
    print $fh_conf_tree ("D\n");
    print $fh_conf_tree ("M\n");
    print $fh_conf_tree ("$parameters->{bootstrap}\n");
    print $fh_conf_tree ("Y\n");
    close ($fh_conf_tree);
    return;
  }
  if ($parameters->{phylogenetic_tree} =~ /codonphyml_nt/i) {
    open (my $fh_conf_tree, ">", "$$ortholog_group.cluster.aa.fa.aln.$$seq_type.phy.trim.conf.tree") || die ("Couldn't configure for the production of the tree file.\n");
    print $fh_conf_tree ("$$ortholog_group.cluster.aa.fa.aln.$$seq_type.phy.trim.boot\n");
    print $fh_conf_tree ("M\n");
    print $fh_conf_tree ("$parameters->{bootstrap}\n");
    print $fh_conf_tree ("Y\n");
    close ($fh_conf_tree);
    return;
  }
}

sub create_consensus_tree_files {
  my ($parameters, $seq_type, $ortholog_group) = @_;

  if (-s "$$ortholog_group.cluster.aa.fa.aln.$$seq_type.phy.trim.final_tree") {
    print LOG ("File $$ortholog_group.cluster.aa.fa.aln.$$seq_type.phy.trim.final_tree already exists, skipping the creation of consensus tree file for group $$ortholog_group.\n");
    return;
  }

  unlink('outfile') if (-e 'outfile');
  consensus_tree_file_configuration($seq_type, $ortholog_group);

  print ("Generating consensus tree of $$ortholog_group...\n") if $parameters->{verbose};
  print LOG ("$parameters->{consense_path} < ./$$ortholog_group.cluster.aa.fa.aln.$$seq_type.phy.trim.conf.final_tree > ./$$ortholog_group.cluster.aa.fa.aln.$$seq_type.phy.trim.final_tree.log\n");

  my $tries = 0;
  while ($tries < $parameters->{tries} && !-s "$$ortholog_group.cluster.aa.fa.aln.$$seq_type.phy.trim.final_tree") {
    $tries++;
    try {
      my $stder = capture_stderr{system ("$parameters->{consense_path} < ./$$ortholog_group.cluster.aa.fa.aln.$$seq_type.phy.trim.conf.final_tree > ./$$ortholog_group.cluster.aa.fa.aln.$$seq_type.phy.trim.final_tree.log")};
      move('outtree', "$$ortholog_group.cluster.aa.fa.aln.$$seq_type.phy.trim.final_tree") || die ("Problem at $$ortholog_group (consensus tree files) : couldn't produce or manipulate the consensus phylogenetic tree file.");  # renaming output file
    } catch {
      if ($tries >= $parameters->{tries} && !-s "$$ortholog_group.cluster.aa.fa.aln.$$seq_type.phy.trim.final_tree" && defined $_) {
        print LOG_ERR ("Couldn't produce the final phylogenetic tree for group $$ortholog_group.\nError: $_\n\n");
        die();
      }
    };
  }
  return;
}

sub consensus_tree_file_configuration {
  my ($seq_type, $ortholog_group) = @_;
  open (my $fh_conf_final_tree, ">", "$$ortholog_group.cluster.aa.fa.aln.$$seq_type.phy.trim.conf.final_tree") || die ("Couldn't configure for the production of the consensus tree file.\n");
  print $fh_conf_final_tree ("$$ortholog_group.cluster.aa.fa.aln.$$seq_type.phy.trim.tree\n");
  print $fh_conf_final_tree ("Y\n");
  close ($fh_conf_final_tree);
  return;
}


sub calculate_dn_ds {
  my ($parameters, $potion_path, $seq_type, $ortholog_group, $model) = @_;

#  print "model: $model\n";
  #presence of group_status file indicates a previous error 

  if (-s "./$$ortholog_group.group_status") {
    return;
  }

  # Checking if the model isn't already processed and with complete information
  if (-s "$$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.paml.model$model") {
    open(my $fh_paml, "<", "$$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.paml.model$model");
    my $ln_value = find_ln_value($fh_paml);
    my $BEB = exists_BEB($fh_paml) if (($model == 2) || ($model == 8) || ($model eq "H1"));
    close ($fh_paml);
    if (defined $ln_value && (($model == 1) || ($model == 7) || ($model eq "H0") || ($BEB))) {
      print LOG ("File $$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.paml.model$model already exist and has all needed values, skipping the creation of DN/DS file for this model for group $$ortholog_group.\n");
      return;
    } elsif (!defined $ln_value) {
      print LOG ("File $$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.paml.model$model already exist, but doesn't have the log-likelihood value of the model $model, calculating it for group $$ortholog_group.\n");
    } else {
      print LOG ("File $$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.paml.model$model already exist, but doesn't have the information of the Bayes Empirical Bayes (BEB) analysis, calculating it for group $$ortholog_group.\n");
    }
  }

  # Creating the DN/DS file
  if ($parameters->{codeml_mode} eq "branch") {
    if (((-s "$$ortholog_group.cluster.aa.fa.aln.nt.phy.trim") && (-s "$$ortholog_group.dummy_tree"))) {
#  if (((-s "$$ortholog_group.cluster.aa.fa.aln.nt.phy.trim") && (-s "$$ortholog_group.cluster.aa.fa.aln.$$seq_type.phy.trim.final_tree"))||((-s "$$ortholog_group.cluster.aa.fa.aln.nt.phy.trim") && (-s "$$ortholog_group.dummy_tree"))) {
#      next if (($model eq "m1")||($model eq "m2")||($model eq "m7")||($model eq "m8"));
      create_paml_config_files ($parameters, $potion_path, $seq_type, $ortholog_group, \$model);
      run_paml ($parameters, $ortholog_group, \$model);
    } elsif (!-e "$$ortholog_group.cluster.aa.fa.aln.nt.phy.trim") {
      die ("Problem with $$ortholog_group.cluster.aa.fa.aln.nt.phy.trim\n");
    } else {
      die ("Problem with $$ortholog_group.dummy_tree\n");
    }
  }
  elsif ($parameters->{codeml_mode} eq "site") {
    if ((-s "$$ortholog_group.cluster.aa.fa.aln.nt.phy.trim") && (-s "$$ortholog_group.cluster.aa.fa.aln.$$seq_type.phy.trim.final_tree")) {
      create_paml_config_files ($parameters, $potion_path, $seq_type, $ortholog_group, \$model);
      run_paml ($parameters, $ortholog_group, \$model);
    } elsif (!-e "$$ortholog_group.cluster.aa.fa.aln.nt.phy.trim") {
      die ("Problem with $$ortholog_group.cluster.aa.fa.aln.nt.phy.trim\n");
    } else {
      die ("Problem with $$ortholog_group.dummy_tree\n");
    }  
  }
  else {
    die ("POTION requires codeml_mode parameter to be defined as \"site\" or \"branch\", your setting is $parameters->{codeml_mode}\n");
  }
  return;
}


sub create_paml_config_files {
  my ($parameters, $potion_path, $seq_type, $ortholog_group, $model) = @_;

  open (my $fh_config_file, ">", "$$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.paml.model$$model.config.i") || die ("Couldn't find the model file produced by PAML (model $$model): $!\n");
  
  if ($parameters->{codeml_mode} eq "site") {
    if (-s "$$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.paml.model$$model.config") { return; }
    open (my $fh_config_model, "<", "$$potion_path/../config_files/codeml$$model.ctl") || die ("Couldn't find the model file $$model from codeml (codeml$$model.ctl): $!\n");
 
    print $fh_config_file ("seqfile = $$ortholog_group.cluster.aa.fa.aln.nt.phy.trim\n"); # .phy file used for sequence
    print $fh_config_file ("treefile = $$ortholog_group.cluster.aa.fa.aln.$$seq_type.phy.trim.final_tree\n"); # .final_tree file with the consensus tree generated by phylip, uses the aminoacid file
    print $fh_config_file ("outfile = $$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.paml.model$$model.i\n");

    foreach (1..3) { <$fh_config_model>; }

    while (my $line = <$fh_config_model>) {
      chomp $line;

      if ($line =~ /icode/) {
        my $icode = $parameters->{codon_table} - 1;
        print $fh_config_file ("icode = $icode\n");
      } elsif ($line =~ /cleandata/) {  # Option adjusted to speed up codeml; case mentioned by the author when the sequence has no gaps
        if ($parameters->{remove_gaps} =~ /\d+/) {
          if ($parameters->{behavior_about_bad_clusters} && $parameters->{remove_gaps} == 1) { print $fh_config_file ("cleandata = 1\n"); }
          else { print $fh_config_file ("cleandata = 0\n"); }
        }
        else {
          if ($parameters->{behavior_about_bad_clusters} && $parameters->{remove_gaps} eq "strictpus") { print $fh_config_file ("cleandata = 1\n"); }
          else { print $fh_config_file ("cleandata = 0\n"); }
        }
      }
      else { print $fh_config_file ("$line\n"); }
    }
    close ($fh_config_model);
    close ($fh_config_file);
    move("$$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.paml.model$$model.config.i", "$$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.paml.model$$model.config") || die ("Problem at creating codeml's configuration file for group $$ortholog_group (model $$model).\n");
  }
  elsif ($parameters->{codeml_mode} eq "branch") {
    if (-s "$$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.paml.model$$model.config") { return; }
    open (my $fh_config_model, "<", "$$potion_path/../config_files/codeml$$model.branch.ctl") || die ("Couldn't find the model file $$model from codeml (codeml$$model.branch.ctl): $!\n");                 
    print $fh_config_file ("seqfile = $$ortholog_group.cluster.aa.fa.aln.nt.phy.trim\n"); # .phy file used for sequence
    print $fh_config_file ("treefile = $$ortholog_group.dummy_tree\n"); # .final_tree file with the consensus tree generated by phylip, uses the aminoacid file
    print $fh_config_file ("outfile = $$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.paml.model$$model.i\n");

    foreach (1..3) { <$fh_config_model>; }

    while (my $line = <$fh_config_model>) {
      chomp $line;

      if ($line =~ /icode/) {
        my $icode = $parameters->{codon_table} - 1;
        print $fh_config_file ("icode = $icode\n");
      } elsif ($line =~ /cleandata/) {  # Option adjusted to speed up codeml; case mentioned by the author when the sequence has no gaps
        if ($parameters->{remove_gaps} =~ /\d+/) {
          if ($parameters->{behavior_about_bad_clusters} && $parameters->{remove_gaps} == 1) { print $fh_config_file ("cleandata = 1\n"); }
          else { print $fh_config_file ("cleandata = 0\n"); }
        }
        else {
          if ($parameters->{behavior_about_bad_clusters} && $parameters->{remove_gaps} eq "strictpus") { print $fh_config_file ("cleandata = 1\n"); }
          else { print $fh_config_file ("cleandata = 0\n"); }
        }
      }
      else { print $fh_config_file ("$line\n"); }
    }
    close ($fh_config_model);
    close ($fh_config_file);
    move("$$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.paml.model$$model.config.i", "$$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.paml.model$$model.config") || die ("Problem at creating codeml's configuration file for group $$ortholog_group (model $$model).\n");  
  }
    return;
}


# Function used to make Codeml identify the phylip file as interleaved; otherwise, it will assume it is sequential and return error
# All it needs is a letter 'I' in the end of the first line of the phylip file
sub set_as_interleaved {
  my $nt_phy_file_name = shift;
  print "$nt_phy_file_name\n";
#  my $a = <STDIN>;
  tie my @file, 'Tie::File', $nt_phy_file_name;
  if ($file[0] =~ /I/) { return; }
  $file[0] .= ' I';
  untie @file;
  return;
}


sub run_paml {
  my ($parameters, $ortholog_group, $model) = @_;

  print ("Calculating likelihood of model $$model for group $$ortholog_group...\n") if $parameters->{verbose};
  print LOG ("$parameters->{codeml_path} ./$$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.paml.model$$model.config > ./$$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.paml.model$$model.log\n");

  my $tries = 0;
  while ($tries < $parameters->{tries} && !-s "$$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.paml.model$$model") {
    $tries++;
    try { #capture_stderr uset to get ride of annoying STDERR messages
      my $stderr = capture_stderr { system ("$parameters->{codeml_path} ./$$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.paml.model$$model.config > ./$$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.paml.model$$model.log")};
      move ("$$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.paml.model$$model.i", "$$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.paml.model$$model");
    } catch {
      if ($tries >= $parameters->{tries} && !-s "$$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.paml.model$$model" && defined $_) {
        print LOG_ERR ("Couldn't analyze the likelihood of model $$model for group $$ortholog_group.\nError: $_\n\n");
        die();
      }
    };
  }


  return;
}



# Development note: chech variables $gene_id_2 and $gene_id_8, they should have the same value and, therefore, one could be removed
sub parse_dn_ds_results {
  my ($parameters, $clusters_ref, $tmp_id2id_ref) = @_;

  print ('Collecting log-likelihood info', "\n") if $parameters->{verbose};
  open (my $fh_table, ">", "$parameters->{project_dir}/results/$parameters->{result_table}");
  open (my $fh_positive, ">", "$parameters->{project_dir}/results/$parameters->{result_positive}");
  open (my $fh_uncertain, ">", "$parameters->{project_dir}/results/$parameters->{result_uncertain}");
  open (my $fh_positive_interleaved, ">", "$parameters->{project_dir}/results/$parameters->{result_positive}.interleaved");
  open (my $fh_uncertain_interleaved, ">", "$parameters->{project_dir}/results/$parameters->{result_uncertain}.interleaved");
  open (my $fh_m2_for_blast, ">", "$parameters->{project_dir}/results/$parameters->{result_positive}.m2_for_blast");
  open (my $fh_mH1_for_blast, ">", "$parameters->{project_dir}/results/$parameters->{result_positive}.mH1_for_blast");
  open (my $fh_m8_for_blast, ">", "$parameters->{project_dir}/results/$parameters->{result_positive}.m8_for_blast");
  open (my $fh_m28_for_blast, ">", "$parameters->{project_dir}/results/$parameters->{result_positive}.m28_for_blast");
  open (my $fh_m2_for_enrichment, ">", "$parameters->{project_dir}/results/$parameters->{result_positive}.m2_for_enrichment");
  open (my $fh_mH1_for_enrichment, ">", "$parameters->{project_dir}/results/$parameters->{result_positive}.mH1_for_enrichment");
  open (my $fh_m8_for_enrichment, ">", "$parameters->{project_dir}/results/$parameters->{result_positive}.m8_for_enrichment");
  open (my $fh_m28_for_enrichment, ">", "$parameters->{project_dir}/results/$parameters->{result_positive}.m28_for_enrichment");
  open (my $fh_recombinants, ">", "$parameters->{project_dir}/results/$parameters->{result_recombinants}");
  open (my $fh_recombinants_for_enrichment, ">", "$parameters->{project_dir}/results/$parameters->{result_recombinants}.for_enrichment");
  open (my $fh_uncertain_for_enrichment, ">", "$parameters->{project_dir}/results/$parameters->{result_uncertain}.for_enrichment");
  open (my $fh_valid_groups, ">", "$parameters->{project_dir}/results/valid_groups_for_enrichment");
  open (my $fh_non_recombinant_groups, ">", "$parameters->{project_dir}/results/non_recombinants_for_enrichment");

  open(my $fh_allvalid_enrichment, ">>", "$parameters->{project_dir}/results/allvalid_for_enrichment");

  if ($parameters->{codeml_mode} eq "site") {
    print $fh_table ("Cluster_name\tM12\tM78\tneutral(M1)\tpositive(M2)\tneutral(M7)\tpositive(M8)\tD(M1,M2)\tD(M7,M8)\tp_value(M1,M2)\tp_value(M7,M8)\tqvalue(M1,M2)\tqvalue(M7,M8)\n");
  }

  if ($parameters->{codeml_mode} eq "branch") {
    print $fh_table ("Cluster_name\tMH0H1\tnull_model(H0)\talternative_model(H1)\tD(MH0,MH1)\tp_value(MH0,MH1)\tqvalue(MH0,MH1)\n");
  }

  # Parsing temporary files for information about our ortholog groups and printing the nucleotide sequence of the valid groups for enrichment analysis files
  my %data;
  foreach my $ortholog_group (keys %{$clusters_ref}){
    my $ortholog_dir = "$parameters->{project_dir}/intermediate_files/" . $ortholog_group . '/';

    # obtaining info from the four codeml output files
    if (-e "$ortholog_dir$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.paml.model1") {
      open (my $fh_paml, "<", "$ortholog_dir$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.paml.model1");
      $data{$ortholog_group}{neutral_m1} = find_ln_value($fh_paml);
      close($fh_paml);
    }

    if (-e "$ortholog_dir$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.paml.model2") {
      open (my $fh_paml, "<", "$ortholog_dir$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.paml.model2");
      $data{$ortholog_group}{positive_m2} = find_ln_value($fh_paml);
      ($data{$ortholog_group}{gene_id}, $data{$ortholog_group}{temp_id}, $data{$ortholog_group}{selected_aminoacids_2}) = find_BEB_info($fh_paml, $tmp_id2id_ref, \$ortholog_dir);
      close($fh_paml);
    }

    if (-e "$ortholog_dir$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.paml.model7") {
      open (my $fh_paml, "<", "$ortholog_dir$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.paml.model7");
      $data{$ortholog_group}{neutral_m7} = find_ln_value($fh_paml);
      close($fh_paml);
    }

    if (-e "$ortholog_dir$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.paml.model8") {
      open (my $fh_paml, "<", "$ortholog_dir$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.paml.model8");
      $data{$ortholog_group}{positive_m8} = find_ln_value($fh_paml);
      ($data{$ortholog_group}{gene_id}, $data{$ortholog_group}{temp_id}, $data{$ortholog_group}{selected_aminoacids_8}) = find_BEB_info($fh_paml, $tmp_id2id_ref, \$ortholog_dir);
      close($fh_paml);
    }

    if (-e "$ortholog_dir$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.paml.modelH0") {
      open (my $fh_paml, "<", "$ortholog_dir$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.paml.modelH0");
      $data{$ortholog_group}{H0} = find_ln_value($fh_paml);
      close($fh_paml);
    }

    if (-e "$ortholog_dir$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.paml.modelH1") {
      open (my $fh_paml, "<", "$ortholog_dir$ortholog_group.cluster.aa.fa.aln.nt.phy.trim.paml.modelH1");
      $data{$ortholog_group}{H1} = find_ln_value($fh_paml);
      ($data{$ortholog_group}{gene_id}, $data{$ortholog_group}{temp_id}, $data{$ortholog_group}{selected_aminoacids_H1}) = find_BEB_info($fh_paml, $tmp_id2id_ref, \$ortholog_dir);
      close($fh_paml);
    }


    # reporting cases where no likelihood values were obtained
    if (!defined $data{$ortholog_group}{neutral_m1} || !defined $data{$ortholog_group}{positive_m2}) {
      $data{$ortholog_group}{no_value_m12} = 1;
    }
    if (!defined $data{$ortholog_group}{neutral_m7} || !defined $data{$ortholog_group}{positive_m8}) {
      $data{$ortholog_group}{no_value_m78} = 1;
    }

    if (!defined $data{$ortholog_group}{H0} || !defined $data{$ortholog_group}{H1}) {
      $data{$ortholog_group}{no_value_H0H1} = 1;
    }

    print_for_enrichment_analysis($fh_valid_groups, \$ortholog_group, $parameters, $tmp_id2id_ref);
    
    print_for_enrichment_analysis($fh_allvalid_enrichment, \$ortholog_group, $parameters, $tmp_id2id_ref);

    # obtain info of recombination analysis
    my $phi_qvalue = read_recombinant_qvalue("$ortholog_dir/recombinant_qvalue") if (-s "$ortholog_dir/recombinant_qvalue");
    if (defined $parameters->{recombination_qvalue} && defined $phi_qvalue && $phi_qvalue < $parameters->{recombination_qvalue}) {
      open (my $fh_aa_sequence_file, "<", "$ortholog_dir$ortholog_group.cluster.aa.fa");
      open (my $fh_nt_sequence_file, "<", "$ortholog_dir$ortholog_group.cluster.nt.fa");
      my $tmp_id = <$fh_aa_sequence_file>;
      <$fh_nt_sequence_file>;
      substr($tmp_id, 0, 1, '');
      chomp($tmp_id);
      my $aa_sequence = <$fh_aa_sequence_file>;
      my $nt_sequence = <$fh_nt_sequence_file>;
      chomp($aa_sequence);
      chomp($nt_sequence);
      print $fh_recombinants (">$tmp_id2id_ref->{$tmp_id} | $tmp_id | $ortholog_group (qvalue = $phi_qvalue)\n$aa_sequence\n\n");
      print $fh_recombinants_for_enrichment (">$tmp_id2id_ref->{$tmp_id} | $tmp_id | $ortholog_group (qvalue = $phi_qvalue)\n$nt_sequence\n\n");
    } elsif (defined $parameters->{recombination_qvalue}) {
      print_for_enrichment_analysis($fh_non_recombinant_groups, \$ortholog_group, $parameters, $tmp_id2id_ref);
    }
  }
  close ($fh_recombinants_for_enrichment);
  close ($fh_recombinants);


  # Processing information to obtain the statistical relevante for models 1 and 2
  my %p_value_m12;
  my $q_values_m12;
  my @no_value_m12;
  if ($parameters->{PAML_models} =~ /m12/i) {
    foreach my $ortholog_group (keys %data) {
      if ($data{$ortholog_group}{no_value_m12}) {
        push(@no_value_m12, $ortholog_group);
      } else {
        $data{$ortholog_group}{likelihood_ratio_m12} = 2*($data{$ortholog_group}{positive_m2} - $data{$ortholog_group}{neutral_m1});
        $p_value_m12{$ortholog_group} = Statistics::Distributions::chisqrprob(2, $data{$ortholog_group}{likelihood_ratio_m12});
      }
    }
    if (scalar keys %p_value_m12) {
      $q_values_m12 = eval 'qvalue(\%p_value_m12)';
      if($@) { $q_values_m12 = BY(\%p_value_m12); }
    }
  }

  # Processing information to obtain the statistical relevante for models 7 and 8
  my %p_value_m78;
  my $q_values_m78;
  my @no_value_m78;
  if ($parameters->{PAML_models} =~ /m78/i) {
    foreach my $ortholog_group (keys %data) {
      if ($data{$ortholog_group}{no_value_m78}) {
        push(@no_value_m78, $ortholog_group);
      } else {
        $data{$ortholog_group}{likelihood_ratio_m78} = 2*($data{$ortholog_group}{positive_m8} - $data{$ortholog_group}{neutral_m7});
        $p_value_m78{$ortholog_group} = Statistics::Distributions::chisqrprob(2, $data{$ortholog_group}{likelihood_ratio_m78});
      }
    }
    if (scalar keys %p_value_m78) {
      $q_values_m78 = eval 'qvalue(\%p_value_m78)';
      if($@) { $q_values_m78 = BY(\%p_value_m78); }
    }
  }

  my %p_value_H0H1;
  my $q_values_H0H1;
  my @no_value_H0H1;
  if ($parameters->{PAML_models} =~ /h0h1/i) {
    foreach my $ortholog_group (keys %data) {
      if ($data{$ortholog_group}{no_value_H0H1}) {
        push(@no_value_H0H1, $ortholog_group);
      } else {
        $data{$ortholog_group}{likelihood_ratio_H0H1} = 2*($data{$ortholog_group}{H1} - $data{$ortholog_group}{H0});
        $p_value_H0H1{$ortholog_group} = Statistics::Distributions::chisqrprob(2, $data{$ortholog_group}{likelihood_ratio_H0H1});
      }
    }
    if (scalar keys %p_value_H0H1) {
      $q_values_H0H1 = eval 'qvalue(\%p_value_H0H1)';
      if($@) { $q_values_H0H1 = BY(\%p_value_H0H1); }
    }
  }

  # For displaying cases when a group isn't properly computed
  # This part will keep groups with only one of the two comparisons completed together
  #  when displaying in the result file
  my @no_m12_has_m78;
  if ($parameters->{PAML_models} =~ /^m12/i && $parameters->{PAML_models} =~ /m78/i) {
    for (1..scalar(@no_value_m12)) {
      my $ortholog_group = shift(@no_value_m12);
      if (defined $q_values_m78->{$ortholog_group}) { push(@no_m12_has_m78, $ortholog_group); }
      else { push(@no_value_m12, $ortholog_group); }
    }
    @no_m12_has_m78 = sort {$q_values_m78->{$a} <=> $q_values_m78->{$b}} @no_m12_has_m78;
  }
  my @no_m78_has_m12;
  if ($parameters->{PAML_models} =~ /^m78/i && $parameters->{PAML_models} =~ /m12/i) {
    for (1..scalar(@no_value_m78)) {
      my $ortholog_group = shift(@no_value_m78);
      if (defined $q_values_m12->{$ortholog_group}) { push(@no_m78_has_m12, $ortholog_group); }
      else { push(@no_value_m78, $ortholog_group); }
    }
    @no_m78_has_m12 = sort {$q_values_m12->{$a} <=> $q_values_m12->{$b}} @no_m78_has_m12;
  }


  # Preparing to generate the output files with the groups sorted by their corrected values
  my @sorted_values;
  if ($parameters->{PAML_models} =~ /^m12/i && defined $q_values_m12) {
    foreach my $ortholog_group (sort {$q_values_m12->{$a} <=> $q_values_m12->{$b}} keys %{$q_values_m12}) {
      push(@sorted_values, $ortholog_group);
    }
    foreach my $ortholog_group (@no_m12_has_m78) {
      push(@sorted_values, $ortholog_group);
    }
    foreach my $ortholog_group (@no_value_m12) {
      push(@sorted_values, $ortholog_group);
    }
  } elsif ($parameters->{PAML_models} =~ /^m78/i && defined $q_values_m78) {
    foreach my $ortholog_group (sort {$q_values_m78->{$a} <=> $q_values_m78->{$b}} keys %{$q_values_m78}) {
      push(@sorted_values, $ortholog_group);
    }
    foreach my $ortholog_group (@no_m78_has_m12) {
      push(@sorted_values, $ortholog_group);
    }
    foreach my $ortholog_group (@no_value_m78) {
      push(@sorted_values, $ortholog_group);
    }
  } elsif ($parameters->{PAML_models} =~ /^h0h1/i && defined $q_values_H0H1) {
    foreach my $ortholog_group (sort {$q_values_H0H1->{$a} <=> $q_values_H0H1->{$b}} keys %{$q_values_H0H1}) {
      push(@sorted_values, $ortholog_group);
    }
    foreach my $ortholog_group (@no_m12_has_m78) {
      push(@sorted_values, $ortholog_group);
    }
    foreach my $ortholog_group (@no_value_m12) {
      push(@sorted_values, $ortholog_group);
    }

  }

  # Generating output files

  if ($parameters->{codeml_mode} eq "site") {
    foreach my $ortholog_group (@sorted_values) { 
      print $fh_table ($ortholog_group, "\t");
  
      if (!defined $data{$ortholog_group}{positive_m2} || !defined $data{$ortholog_group}{neutral_m1} || !defined $q_values_m12->{$ortholog_group}) {
        print $fh_table ('-', "\t");
      } elsif ($q_values_m12->{$ortholog_group} < $parameters->{qvalue}) {
        print $fh_table ('P', "\t");
        print_results($fh_positive, $fh_positive_interleaved, \$ortholog_group, $parameters, \$data{$ortholog_group}{gene_id}, \$data{$ortholog_group}{selected_aminoacids_2}, 'model 2');
        print_for_blast($fh_m2_for_blast, \$ortholog_group, $parameters, \$data{$ortholog_group}{temp_id}, \$data{$ortholog_group}{gene_id});
        print_for_enrichment_analysis($fh_m2_for_enrichment, \$ortholog_group, $parameters, $tmp_id2id_ref);
      } elsif ($p_value_m12{$ortholog_group} < $parameters->{pvalue}) {
        print $fh_table ('u', "\t");
        print_results($fh_uncertain, $fh_uncertain_interleaved, \$ortholog_group, $parameters, \$data{$ortholog_group}{gene_id}, \$data{$ortholog_group}{selected_aminoacids_2}, 'model 2');
        print_for_enrichment_analysis($fh_uncertain_for_enrichment, \$ortholog_group, $parameters, $tmp_id2id_ref);
      } else {
        print $fh_table ('n', "\t");
      }

      if (!defined $data{$ortholog_group}{positive_m8} || !defined $data{$ortholog_group}{neutral_m7} || !defined $q_values_m78->{$ortholog_group}) {
        print $fh_table ('-', "\t");
      } elsif ($q_values_m78->{$ortholog_group} < $parameters->{qvalue}) {
        print $fh_table ('P', "\t");
        print_results($fh_positive, $fh_positive_interleaved, \$ortholog_group, $parameters, \$data{$ortholog_group}{gene_id}, \$data{$ortholog_group}{selected_aminoacids_8}, 'model 8');
        print_for_blast($fh_m8_for_blast, \$ortholog_group, $parameters, \$data{$ortholog_group}{temp_id}, \$data{$ortholog_group}{gene_id});
        print_for_enrichment_analysis($fh_m8_for_enrichment, \$ortholog_group, $parameters, $tmp_id2id_ref);
        if (defined $q_values_m12->{$ortholog_group} && $q_values_m12->{$ortholog_group} < $parameters->{qvalue}) {
          print_for_blast($fh_m28_for_blast, \$ortholog_group, $parameters, \$data{$ortholog_group}{temp_id}, \$data{$ortholog_group}{gene_id});
          print_for_enrichment_analysis($fh_m28_for_enrichment, \$ortholog_group, $parameters, $tmp_id2id_ref);
        }
      } elsif ($p_value_m78{$ortholog_group} < $parameters->{pvalue}) {
        print $fh_table ('u', "\t");
        print_results($fh_uncertain, $fh_uncertain_interleaved, \$ortholog_group, $parameters, \$data{$ortholog_group}{gene_id}, \$data{$ortholog_group}{selected_aminoacids_8}, 'model 8');
      } else {
        print $fh_table ('n', "\t");
      }

      if (defined $data{$ortholog_group}{neutral_m1})  { print $fh_table (sprintf("%.6f", $data{$ortholog_group}{neutral_m1}), "\t"); }
      else { print $fh_table ("-\t"); }
      if (defined $data{$ortholog_group}{positive_m2}) { print $fh_table (sprintf("%.6f", $data{$ortholog_group}{positive_m2}), "\t"); }
      else { print $fh_table ("-\t"); }
      if (defined $data{$ortholog_group}{neutral_m7})  { print $fh_table (sprintf("%.6f", $data{$ortholog_group}{neutral_m7}), "\t"); }
      else { print $fh_table ("-\t"); }
      if (defined $data{$ortholog_group}{positive_m8}) { print $fh_table (sprintf("%.6f", $data{$ortholog_group}{positive_m8}), "\t"); }
      else { print $fh_table ("-\t"); }

      if (defined $data{$ortholog_group}{likelihood_ratio_m12}) {
        print $fh_table (sprintf("%.6f", $data{$ortholog_group}{likelihood_ratio_m12}), "\t");
      } else {
        print $fh_table ("-\t");
      } 
      if (defined $data{$ortholog_group}{likelihood_ratio_m78}) {
        print $fh_table (sprintf("%.6f", $data{$ortholog_group}{likelihood_ratio_m78}), "\t");
      } else {
        print $fh_table ("-\t");
      }

      if (defined $p_value_m12{$ortholog_group}) {
        print $fh_table (sprintf("%.6f", $p_value_m12{$ortholog_group}), "\t");
      } else {
        print $fh_table ("-\t");
      }
      if (defined $p_value_m78{$ortholog_group}) {
        print $fh_table (sprintf("%.6f", $p_value_m78{$ortholog_group}), "\t");
      } else {
        print $fh_table ("-\t");
      }

      if (defined $q_values_m12->{$ortholog_group}) {
        print $fh_table (sprintf("%.6f", $q_values_m12->{$ortholog_group}), "\t");
      } else {
        print $fh_table ("-\t");
      }
      if (defined $q_values_m78->{$ortholog_group}) {
        print $fh_table (sprintf("%.6f", $q_values_m78->{$ortholog_group}), "\n");
      } else {
        print $fh_table ("-\n");
      }
    }
  } 
  elsif ($parameters->{codeml_mode} eq "branch") {
    foreach my $ortholog_group (@sorted_values) {
      print $fh_table ($ortholog_group, "\t");
      if (!defined $data{$ortholog_group}{H0} || !defined $data{$ortholog_group}{H1} || !defined $q_values_H0H1->{$ortholog_group}) {
        print $fh_table ('-', "\t");
      } elsif ($q_values_H0H1->{$ortholog_group} < $parameters->{qvalue}) {
        print $fh_table ('P', "\t");
        print_results($fh_positive, $fh_positive_interleaved, \$ortholog_group, $parameters, \$data{$ortholog_group}{gene_id}, \$data{$ortholog_group}{selected_aminoacids_H1}, 'model H1');
        print_for_blast($fh_mH1_for_blast, \$ortholog_group, $parameters, \$data{$ortholog_group}{temp_id}, \$data{$ortholog_group}{gene_id});
        print_for_enrichment_analysis($fh_mH1_for_enrichment, \$ortholog_group, $parameters, $tmp_id2id_ref);
        if (defined $q_values_H0H1->{$ortholog_group} && $q_values_H0H1->{$ortholog_group} < $parameters->{qvalue}) {
          print_for_blast($fh_mH1_for_blast, \$ortholog_group, $parameters, \$data{$ortholog_group}{temp_id}, \$data{$ortholog_group}{gene_id});
          print_for_enrichment_analysis($fh_mH1_for_enrichment, \$ortholog_group, $parameters, $tmp_id2id_ref);
        }
      } elsif ($p_value_H0H1{$ortholog_group} < $parameters->{pvalue}) {
        print $fh_table ('u', "\t");
        print_results($fh_uncertain, $fh_uncertain_interleaved, \$ortholog_group, $parameters, \$data{$ortholog_group}{gene_id}, \$data{$ortholog_group}{selected_aminoacids_H1}, 'model H1');
      } else {
        print $fh_table ('n', "\t");
      }
      if (defined $data{$ortholog_group}{H0})  { print $fh_table (sprintf("%.6f", $data{$ortholog_group}{H0}), "\t"); }
      else { print $fh_table ("-\t"); }
      if (defined $data{$ortholog_group}{H1}) { print $fh_table (sprintf("%.6f", $data{$ortholog_group}{H1}), "\t"); }
      else { print $fh_table ("-\t"); }

      if (defined $data{$ortholog_group}{likelihood_ratio_H0H1}) {
        print $fh_table (sprintf("%.6f", $data{$ortholog_group}{likelihood_ratio_H0H1}), "\t");
      } else {
        print $fh_table ("-\t");
      }

      if (defined $p_value_H0H1{$ortholog_group}) {
        print $fh_table (sprintf("%.6f", $p_value_H0H1{$ortholog_group}), "\t");
      } else {
        print $fh_table ("-\t");
      }

      if (defined $q_values_H0H1->{$ortholog_group}) {
        print $fh_table (sprintf("%.6f", $q_values_H0H1->{$ortholog_group}), "\t");
      } else {
        print $fh_table ("-\t");
      }
      if (defined $q_values_H0H1->{$ortholog_group}) {
        print $fh_table (sprintf("%.6f", $q_values_H0H1->{$ortholog_group}), "\n");
      } else {
        print $fh_table ("-\n");
      }
    }
  }

  close ($fh_allvalid_enrichment);
  close ($fh_uncertain_for_enrichment);
  close ($fh_m28_for_enrichment);
  close ($fh_mH1_for_enrichment);
  close ($fh_m8_for_enrichment);
  close ($fh_m2_for_enrichment);
  close ($fh_m28_for_blast);
  close ($fh_mH1_for_blast);
  close ($fh_m8_for_blast);
  close ($fh_m2_for_blast);
  close ($fh_positive_interleaved);
  close ($fh_uncertain_interleaved);
  close ($fh_positive);
  close ($fh_uncertain);
  close ($fh_table);
  return;
}


sub read_recombinant_qvalue {
  my $recombinant_file_path = shift;

  open(my $fh_recombinant, "<", $recombinant_file_path);
  my $phi_qvalue;
  while (my $line = <$fh_recombinant>) {
    if ($line =~ /qvalue\s*=\s*(\S+)/) {
      $phi_qvalue = $1;
      if ($phi_qvalue eq '--') { $phi_qvalue = 1; }
      $phi_qvalue = sprintf("%.5f", $phi_qvalue);
      return $phi_qvalue;
    }
  }
  return 1;
}

# Searches the line with the log-likelihood, used by parse_dn_ds_results() and in the verification of completed PAML files
sub find_ln_value {
  my $fh_paml = shift;
  
  while (my $line = <$fh_paml>) {
    chomp $line;
    if ($line =~ /^lnL/){ 
      my $test = $1 if ( $line =~ /(-*\d+\.\d+)/ ); #example of $line: lnL(ntime:  8  np: 10):   -904.302036      +0.000000
      return $test;
    }
  }
  return;
}

sub exists_BEB {
  my $fh_paml = shift;

  while (my $line = <$fh_paml>) {
    if ($line =~ /grid/) {
      return 1;
    }
  }
  return 0;
}



# Searches for the Bayes Empirical Bayes information generated by Codeml, used by parse_dn_ds_results()
sub find_BEB_info {
  my ($fh_paml, $tmp_id2id_ref, $ortholog_dir) = @_;
  my $selected_aminoacids = '';
  
  # Find the name of the gene
  open(my $fh_id_names, "<", "$$ortholog_dir/id_names");
  my $gene_id = <$fh_id_names>;
  my $temp_id;

  if (defined $gene_id) {
    chomp($gene_id);
    $temp_id = $1 if ($gene_id =~ /\s*(\w+)\s*=>/);
    $gene_id = $1 if ($gene_id =~ /=>\s*(\w+)/);
  }
  close($fh_id_names);

  # Searching for aminoacids with (dN/dS) > 1 and marking '+' for those with P > 0.95, '*' with P> 0.99
  while (my $line = <$fh_paml>) {
    if ($line =~ /Bayes Empirical Bayes \(BEB\) analysis/) { <$fh_paml>; last; } # skips line explaining * >= 95%, ** >= 99%
  }

  while (my $line = <$fh_paml>) {
    if ($line =~ /\*/) {
      my $position = $1 if ($line =~ /(\d+)/);                                 # The position itself
      $position -= (length($selected_aminoacids) + 1);
      if ($line =~ /\*\*/) { $selected_aminoacids .= '-' x $position . '*'; }  # P > 0.99
      else { $selected_aminoacids .= '-' x $position . '+'; }                  # P > 0.95
    }
    if ($line =~ /grid/) { 
      last;
    }
  }
    return ($gene_id, $temp_id, $selected_aminoacids);
}


# Fills the result files (except the table file), used by parse_dn_ds_results()
# printing ortholog group, ID, aminoacid sequence of gene and evidences of non-synonimous selection in the positive result file
sub print_results {
  my ($fh_result_file, $fh_result_interleaved, $ortholog_group, $parameters, $gene_id, $selected_aminoacids, $model) = @_;

  my $ortholog_dir = "$parameters->{project_dir}/intermediate_files/" . $$ortholog_group . '/';
  open (my $fh_trim_file, "<", "$ortholog_dir$$ortholog_group.cluster.aa.fa.aln.aa.phy.trim");

  my $line = <$fh_trim_file>;
  my $n_sequences = $1 if ($line =~ /^\s(\d+)/);
  my $alignment_size = $1 if ($line =~ /(\d+)$/);

  $line = <$fh_trim_file>;
  chomp $line;
  my $aa_sequence = substr($line, 13);
  
  foreach (1..POSIX::floor($alignment_size / 60)) {
    foreach (1..($n_sequences)) { <$fh_trim_file>; }
    $line = <$fh_trim_file>;
    chomp $line;
    $aa_sequence .= $line;
  }
  $$selected_aminoacids .= '-' x ($alignment_size - length($$selected_aminoacids));

  # removing gaps by checking each charactere and removing if '-' in both the alignment and the sequence of selected aminoacids by BEB
  foreach (my $i = 0; $i < $alignment_size; $i++) {
    if (substr($aa_sequence, $i, 1) eq '-') {
      substr($aa_sequence, $i, 1, '');
      substr($$selected_aminoacids, $i, 1, '');
      $alignment_size--;                         # preventing substr from trying to read beyond the shortened string
      $i--;                                      # the next caractere now is where we just checked, we need to adjust the loop for that
    }
  }

  # printing in sequential format
  find_ortholog_group(\$ortholog_dir, $ortholog_group, $fh_result_file); 
  if (defined $$gene_id) { 
    print $fh_result_file (">$$gene_id ($model)\n");
    print $fh_result_file ("$aa_sequence", "\n");
    print $fh_result_file ("$$selected_aminoacids", "\n\n");
  }
  else { print LOG ("Warning: gene id not defined for model $model in group $$ortholog_group\n"); }


  # printing in interleaved format
  find_ortholog_group(\$ortholog_dir, $ortholog_group, $fh_result_interleaved); 
  if (defined $$gene_id) {
    print $fh_result_interleaved (">$$gene_id ($model)\n");
    for (my $i = 0; $i < length($aa_sequence); $i += 60) {
      print $fh_result_interleaved (substr("$aa_sequence", $i, 60), "\n");
      print $fh_result_interleaved (substr("$$selected_aminoacids", $i, 60), "\n");
    }
  }
  print $fh_result_interleaved ("\n");

  close ($fh_trim_file);
  return;
}



# Prints all genes of the ortholog group in the result files (except table file), used by print_results()
sub find_ortholog_group {
  my ($ortholog_dir, $ortholog_group, $fh_result_file) = @_;
  open (my $fh_id_names, "<", "$$ortholog_dir" . 'id_names') || die ($!);

  my $genes = "$$ortholog_group: ";
  my $line;
  while ($line = <$fh_id_names>) {
    if (!defined $line) { last; }
    $genes .= "$1 " if ($line =~ /=>\s(\w+)/ );
  }
  print $fh_result_file ("$genes\n");

  close ($fh_id_names);
}


sub print_for_blast {
  my ($fh_result_file, $ortholog_group, $parameters, $temp_id, $gene_id) = @_;

  my $ortholog_dir = "$parameters->{project_dir}/intermediate_files/" . $$ortholog_group . '/';
  open (my $fh_aa_file, "<", "$ortholog_dir$$ortholog_group.cluster.aa.fa");

  # Printing the aminoacid sequence in this group
  my $aa_sequence;
  while (my $aa_file_line  = <$fh_aa_file>) {
    if (defined $aa_file_line && defined $$temp_id && $aa_file_line =~ /$$temp_id$/) { # looking for the id of the gene
      $aa_sequence = <$fh_aa_file>;  # collecting the original sequence, present in the line after the id
      last;
    }
  }

  # printing in sequential format
  if (defined $$gene_id && defined $aa_sequence) {
    print $fh_result_file (">$$gene_id | $$ortholog_group\n");
    print $fh_result_file ("$aa_sequence", "\n");
  }
  else { print LOG ("Gene id not defined in group $$ortholog_group\n"); }

  close ($fh_aa_file);
  return;
}

sub print_for_enrichment_analysis {
  my ($fh_result_file, $ortholog_group, $parameters, $tmp_id2id_ref) = @_;

  my $ortholog_dir = "$parameters->{project_dir}/intermediate_files/" . $$ortholog_group . '/';
  open (my $fh_nt_file, "<", "$ortholog_dir$$ortholog_group.cluster.nt.fa");

  # Printing the nucleotide sequence in this group
  my $tmp_id = <$fh_nt_file>;
  substr($tmp_id, 0, 1, '');
  chomp($tmp_id);
  my $nt_sequence = <$fh_nt_file>;  # collecting the original sequence, present in the line after the id
  chomp ($nt_sequence);

  # printing in sequential format
  if (defined $nt_sequence && defined $tmp_id2id_ref->{$tmp_id}) {
    print $fh_result_file (">$tmp_id2id_ref->{$tmp_id} | $tmp_id | $$ortholog_group\n");
    print $fh_result_file ("$nt_sequence", "\n\n");
  }
  else { print LOG ("Gene id not defined in group $$ortholog_group for enrichment analysis file\n"); }

  close ($fh_nt_file);
  return;
}


# Prints the time taken by the tasks of the group before the codeml runs in a file. Used for summary
sub print_task_time {
  my ($ortholog_dir, $task_time, $name) = @_;

  my $f_tree_time = time() - $$task_time;
  open(my $fh_time_write, ">", "$$ortholog_dir/$name");
  print $fh_time_write ('Time taken by task: ', $f_tree_time, "\n");
  close ($fh_time_write);
  return;

}

sub write_summary {
  my ($parameters, $clusters_ref, $start_time) = @_;
  my ($f_tree, $model1, $model2, $model7, $model8) = (0,0,0,0,0);


  # printing time spent by the program to run
  my $total_time = time() - $$start_time;
  my ($hours, $minutes, $seconds) = divide_time(\$total_time);

  print SUMMARY ("Time spent: $hours:$minutes:$seconds ($total_time seconds)\n");
  foreach my $ortholog_group (keys %{$clusters_ref}) {
    if (-s "$parameters->{project_dir}/intermediate_files/$ortholog_group/time_id_rec") {
      open (my $fh_time_read, "<", "$parameters->{project_dir}/intermediate_files/$ortholog_group/time_id_rec");
      my $line = <$fh_time_read>;
      $f_tree += $1 if ($line =~ /:\s(\d+)/);
      close($fh_time_read);
    }

    if (-s "$parameters->{project_dir}/intermediate_files/$ortholog_group/time_f_tree") {
      open (my $fh_time_read, "<", "$parameters->{project_dir}/intermediate_files/$ortholog_group/time_f_tree");
      my $line = <$fh_time_read>;
      $f_tree += $1 if ($line =~ /:\s(\d+)/);
      close($fh_time_read);
    }

    if (-s "$parameters->{project_dir}/intermediate_files/$ortholog_group/time_model_1") {
      open (my $fh_time_read, "<", "$parameters->{project_dir}/intermediate_files/$ortholog_group/time_model_1");
      my $line = <$fh_time_read>;
      $model1 += $1 if ($line =~ /:\s(\d+)/);
      close($fh_time_read);
    }

    if (-s "$parameters->{project_dir}/intermediate_files/$ortholog_group/time_model_2") {
      open (my $fh_time_read, "<", "$parameters->{project_dir}/intermediate_files/$ortholog_group/time_model_2");
      my $line = <$fh_time_read>;
      $model2 += $1 if ($line =~ /:\s(\d+)/);
      close($fh_time_read);
    }

    if (-s "$parameters->{project_dir}/intermediate_files/$ortholog_group/time_model_7") {
      open (my $fh_time_read, "<", "$parameters->{project_dir}/intermediate_files/$ortholog_group/time_model_7");
      my $line = <$fh_time_read>;
      $model7 += $1 if ($line =~ /:\s(\d+)/);
      close($fh_time_read);
    }

    if (-s "$parameters->{project_dir}/intermediate_files/$ortholog_group/time_model_8") {
      open (my $fh_time_read, "<", "$parameters->{project_dir}/intermediate_files/$ortholog_group/time_model_8");
      my $line = <$fh_time_read>;
      $model8 += $1 if ($line =~ /:\s(\d+)/);
      close($fh_time_read);
    }
  }

  my $sequential_time = $f_tree+$model1+$model2+$model7+$model8;

  ($hours, $minutes, $seconds) = divide_time(\$sequential_time);
  print SUMMARY ("Total time (sequential run): $hours:$minutes:$seconds ($sequential_time seconds)\n");

  ($hours, $minutes, $seconds) = divide_time(\$f_tree);
  print SUMMARY (" - total time on building phylogenetic trees: $hours:$minutes:$seconds ($f_tree seconds)\n");

  ($hours, $minutes, $seconds) = divide_time(\$model1);
  print SUMMARY (" - total time on model 1: $hours:$minutes:$seconds ($model1 seconds)\n");

  ($hours, $minutes, $seconds) = divide_time(\$model2);
  print SUMMARY (" - total time on model 2: $hours:$minutes:$seconds ($model2 seconds)\n");

  ($hours, $minutes, $seconds) = divide_time(\$model7);
  print SUMMARY (" - total time on model 7: $hours:$minutes:$seconds ($model7 seconds)\n");

  ($hours, $minutes, $seconds) = divide_time(\$model8);
  print SUMMARY (" - total time on model 8: $hours:$minutes:$seconds ($model8 seconds)\n");

  return;
}

# # Deprecated due to changes to CODEML output file
# # reads a codeml file to obtain the time spent by that run
# sub return_total_time {
#   my $file_name = shift;
#   my ($hours, $minutes, $seconds) = (0,0,0);
# 
#   my @file;
#   if (-s $file_name) { tie (@file, 'Tie::File', $file_name); }
#   else { return 0; }
# 
#   my $time_line = @file - 1;
#   if (!defined $file[$time_line]) {  # exception handling
#     print LOG ("File $file_name isn't complete, please run CODEML again\n");
#     print ("File $file_name isn't complete, please run CODEML again\n");
#     return 0;
#   }
#   my $line = $1 if ($file[$time_line] =~ /Time\sused:\s*(\d*:?\d+:\d+)/);
#   untie @file;  # done accessing the codeml file
# 
#   if (!defined $line) { return 0; }
#   if ($line =~ /\d*:\d+:\d+/) { ($hours, $minutes, $seconds) = split(/:/, $line); }
#   else { ($minutes, $seconds) = split(/:/, $line); }
# 
#   my $total_time = 3600*$hours + 60*$minutes + $seconds;
#   return $total_time;
# }


sub divide_time {
  my $total_time = shift;

  my $hours = POSIX::floor( $$total_time / 3600 );
  my $minutes = POSIX::floor(($$total_time % 3600) / 60);
  if ($minutes < 10) { $minutes = '0' . $minutes; }
  my $seconds = $$total_time % 60;
  if ($seconds < 10) { $seconds = '0' . $seconds; }

  return ($hours, $minutes, $seconds);
}

sub manage_task_allocation {
  my ($pid_to_ortholog_group, $n_process, $phi_pvalues, $nss_pvalues, $maxchi2_pvalues, $parameters, $id_rec_to_process, $f_tree_to_process, $model8_to_process, $model7_to_process, $model2_to_process, $model1_to_process, $modelH1_to_process, $modelH0_to_process, $seq_type) = @_;

  my $completed_pid = waitpid(-1, 0);
  if (exists $pid_to_ortholog_group->{$completed_pid}) {

    # variable added just for human readability, terrible without it
    my $ortholog_group = $pid_to_ortholog_group->{$completed_pid};

    my $id_rec_file = "$parameters->{project_dir}/intermediate_files/" . $ortholog_group . '/' . 'Phi';

    my $tmp_path = "$parameters->{project_dir}/intermediate_files/" . $ortholog_group . '/' . "$ortholog_group.cluster.aa.fa.aln.$$seq_type.phy.trim.final_tree";
    
    my $f_tree_file;

    if (-e $tmp_path) {
      $f_tree_file = "$parameters->{project_dir}/intermediate_files/" . $ortholog_group . '/' . "$ortholog_group.cluster.aa.fa.aln.$$seq_type.phy.trim.final_tree";
    } else {
      $f_tree_file = "$parameters->{project_dir}/intermediate_files/" . $ortholog_group . '/' . "$ortholog_group.dummy_tree";
    }



    # Case when an id_rec has finished
    # We check if the analysis could complete the recombination analysis by checking if the 'Phi' file ($id_rec_file) exists and has more than zero bytes
    # If positive, we register its pvalues
    # If negative, we create a dummy 'Phi' file with pvalue=1 and register such value
    # If this group was the last id_rec in the queue, identified by an empty @id_rec_to_process, n_process=1 and no pvalues for this group,
    #  then we proceed to calculate the qvalues for recombination and remove groups that exhibit traces of recombination under the user's criteria

    if (!-s $id_rec_file) {                           # case when a group couldn't complete the analysis to the recombination point
      open(my $fh_dummy_phi_file, ">", $id_rec_file); 
      print $fh_dummy_phi_file ('No analysis for recombination executed, neutral value for PHI below', "\n", 'PHI (Normal):        1.00e+00', "\n");
      close($fh_dummy_phi_file);
    }

    if (!exists $phi_pvalues->{$ortholog_group}) {
      ($phi_pvalues->{$ortholog_group}, $nss_pvalues->{$ortholog_group}, $maxchi2_pvalues->{$ortholog_group}) = read_phi($id_rec_file);

      if ($$n_process == 1 && !@{$id_rec_to_process}) { # then, all groups had their recombination pvalue measured; proceeding with multiple hypothesis correction
 
        print ("Computing recombination qvalues...\n") if $parameters->{verbose};
        my $phi_qvalues = eval 'qvalue($phi_pvalues)';
        if($@) { $phi_qvalues = BY($phi_pvalues); }
        my $nss_qvalues = eval 'qvalue($nss_pvalues)';
        if($@) { $nss_qvalues = BY($nss_pvalues); }
        my $maxchi2_qvalues = eval 'qvalue($maxchi2_pvalues)';
        if($@) { $maxchi2_qvalues = BY($maxchi2_pvalues); }

        # Checking conditions set in the configuration file for qvalues and tests
        foreach my $group (keys %{$phi_qvalues}) {
          my $status_file = "$parameters->{project_dir}/intermediate_files/" . $group . '/' . "$group.group_status";
          # Check for number of confirmations
          my $recombination_count = 0;
          if (defined $parameters->{recombination_qvalue} && $phi_qvalues->{$group} < $parameters->{recombination_qvalue}) { $recombination_count += 1; }
          if (defined $parameters->{recombination_qvalue} && $nss_qvalues->{$group} < $parameters->{recombination_qvalue}) { $recombination_count += 1; }
          if (defined $parameters->{recombination_qvalue} && $maxchi2_qvalues->{$group} < $parameters->{recombination_qvalue}) { $recombination_count += 1; }

          # Check for any reproval in the mandatory tests
          my $reproved_mandatory_tests = 0;
          if (defined $parameters->{rec_mandatory_tests} && $parameters->{rec_mandatory_tests} =~ /phi/i && $phi_qvalues->{$group} >= $parameters->{recombination_qvalue}) { $reproved_mandatory_tests += 1; }
          if (defined $parameters->{rec_mandatory_tests} && $parameters->{rec_mandatory_tests} =~ /nss/i && $nss_qvalues->{$group} >= $parameters->{recombination_qvalue}) { $reproved_mandatory_tests += 1; }
          if (defined $parameters->{rec_mandatory_tests} && $parameters->{rec_mandatory_tests} =~ /maxchi2/i && $maxchi2_qvalues->{$group} >= $parameters->{recombination_qvalue}) { $reproved_mandatory_tests += 1; }

          # Checking whether the group must be removed from the analysis by the criteria in the parameters and taking the proper actions
          if (defined $parameters->{rec_minimum_confirmations} && $recombination_count >= $parameters->{rec_minimum_confirmations} && $reproved_mandatory_tests == 0) {
            print LOG ("Group $group has traces of recombination, removing from the analysis\nNSS = $nss_qvalues->{$group}\nMax chi^2 = $maxchi2_qvalues->{$group}\nPHI = $phi_qvalues->{$group}\n");
            print ("Group $group has traces of recombination, removing from the analysis\nNSS = $nss_qvalues->{$group}\nMax chi^2 = $maxchi2_qvalues->{$group}\nPHI = $phi_qvalues->{$group}\n") if $parameters->{verbose};

            my $rec_qvalue_file = "$parameters->{project_dir}/intermediate_files/" . $group . '/' . 'recombinant_qvalue';
            open (my $fh_recombinant_qvalue, ">", $rec_qvalue_file);
            print $fh_recombinant_qvalue ('qvalue = ', $phi_qvalues->{$group}, "\n");
            close ($fh_recombinant_qvalue);

          } elsif (-e $status_file) { # if there is a status file the group was removed in a previous step, so no tree job should take place

          } else { #the cases where there is no evidence of recombination will go to this vector of f_tree jobs to process.
            push(@{$f_tree_to_process}, "$group;f_tree");
          }
        }

      print ("Finished recombination analysis\n") if $parameters->{verbose};
      }

    # If a f_tree has finished instead
    } elsif (-s "$f_tree_file") {
#      if ($parameters->{codeml_mode} eq "site") {
        push(@{$model8_to_process}, "$ortholog_group;model8") if ($parameters->{PAML_models} =~ /m78/i);
        push(@{$model7_to_process}, "$ortholog_group;model7") if ($parameters->{PAML_models} =~ /m78/i);
        push(@{$model2_to_process}, "$ortholog_group;model2") if ($parameters->{PAML_models} =~ /m12/i);
        push(@{$model1_to_process}, "$ortholog_group;model1") if ($parameters->{PAML_models} =~ /m12/i);
#      }      
#      if ($parameters->{codeml_mode} eq "branch") {
        push(@{$modelH1_to_process}, "$ortholog_group;modeH1") if ($parameters->{PAML_models} =~ /h0h1/i);
        push(@{$modelH0_to_process}, "$ortholog_group;modeH0") if ($parameters->{PAML_models} =~ /h0h1/i);
#        print "@{$modelH1_to_process}\t$ortholog_group;modeH1\n";
#        my $a = <STDIN>;
#      }
        delete($pid_to_ortholog_group->{$completed_pid});
    }
  }
  $$n_process--;
}

1;
