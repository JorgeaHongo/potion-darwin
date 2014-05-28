#!/usr/local/bin/perl

use strict;
use warnings;

use Bio::SeqIO;
use Bio::AlignIO;
use Cwd;
use File::chdir;
use File::Copy;
use POSIX;
use Statistics::Distributions qw(chisqrprob);
use Statistics::Multtest qw(BY qvalue);
use Tie::File;
use Try::Tiny;
use Data::Dumper;
use File::Spec::Functions qw(rel2abs);
use File::Basename;
use FindBin;
use Capture::Tiny ':all';
use Getopt::Long;
use lib "$FindBin::Bin/.";
require 'module_latest.pm';

chomp $ARGV[0] if defined;

if ((defined $ARGV[0])&&($ARGV[0] eq "--create_conf")) { #creating configuration file if asked to
  create_conf_file();
  exit;
}

if ((!defined $ARGV[0])||(!-e $ARGV[0])||($ARGV[0] eq "-h")||(($ARGV[0] eq "--help"))) { #checking if users are asking for help
  help();
  exit;
}

my $start_time = time(); # used to measure total execution time

my $project_config_file = $ARGV[0];

my $potion_path = dirname(rel2abs($0));

my $parameters = read_config_files(\$project_config_file, \$potion_path);  # stores the configuration in a hash reference
check_parameters($parameters);

# creating the needed directories if they don't exist
if (!-e $parameters->{project_dir}) { mkdir ($parameters->{project_dir}) || die ("Couldn't create the directory specified as '$parameters->{project_dir}', check if you are trying to create a subdirectory in a non-existent directory or if you don't have permission to create a directory there.\n"); }
if (!-e "$parameters->{project_dir}/results") { mkdir ("$parameters->{project_dir}/results") || die ("Couldn't create the directory with the results of Potion's analysis.\nDetails: $!\n"); }
if (!-e "$parameters->{project_dir}/intermediate_files") { mkdir ("$parameters->{project_dir}/intermediate_files") || die ("Couldn't create the directory with the steps of Potion's analysis.\nDetails: $!\n"); }
copy($project_config_file, "$parameters->{project_dir}/project_config");
copy($parameters->{cluster_file}, "$parameters->{project_dir}/cluster_file");


open (LOG, ">", "$parameters->{project_dir}/log") || die ('Could not create log file in ', $parameters->{project_dir}, '. Please check writing permission in your current directory', "\n");
open (LOG_ERR, ">", "$parameters->{project_dir}/log.err") || die ('Could not create log.err file in ', $parameters->{project_dir}, '. Please check writing permission in your current directory', "\n");
open (SUMMARY, ">", "$parameters->{project_dir}/results/$parameters->{summary}") || die ('Could not create summary file. Please check writing permission in your current directory', "\n");


# internal information collected to validate and create codon alignment files
my ($sequences_ref, $id2tmp_id_ref, $tmp_id2id_ref, $translation_ref) = parse_genome_files ($parameters);
my $hash_of_groups_ref = select_ortholog_groups($parameters); 

# select range of homologous groups to analyze
my $clusters_ref = parse_cluster_file ($hash_of_groups_ref, $sequences_ref, $translation_ref,  $parameters);

# trim clusters removing sequences and groups according to user-defined criteria
trim_cluster ($clusters_ref, $sequences_ref, $parameters);
print SUMMARY ('Number of Clusters: ', scalar keys %{$clusters_ref}, "\n");

# nt or aa files for phylogenetic analysis
my $seq_type;
if ($parameters->{phylogenetic_tree} =~ /proml/i) { $seq_type = 'aa'; }
elsif ($parameters->{phylogenetic_tree} =~ /dnaml/i) { $seq_type = 'nt'; }

# variables needed to control the number of processes running simultaneously

# number of processes
my $n_process = 0;

# lines used to decide which task to prioritize
my @id_rec_to_process;
my @f_tree_to_process;
my @model8_to_process;
my @model7_to_process;
my @model2_to_process;
my @model1_to_process;
my %pid_to_ortholog_group; #linking pids to groups

# variables for recombination pvalues
my %phi_pvalues;
my %nss_pvalues;
my %maxchi2_pvalues;

# preparing the phylogenetic trees
foreach my $ortholog_group (keys %{$clusters_ref}) {
  push (@id_rec_to_process, "$ortholog_group;id_rec"); # assign to produce the recombination analysis (id_rec)
}

while (@id_rec_to_process > 0 || @f_tree_to_process > 0 || @model8_to_process > 0 || @model7_to_process > 0 || @model2_to_process > 0 || @model1_to_process > 0 || $n_process > 0) { #defining which task will start when a free processor is available
  my $ortholog_group;

  if ($n_process == $parameters->{max_processes}) { #if a processor is available, start a new task
    manage_task_allocation(\%pid_to_ortholog_group, \$n_process, \%phi_pvalues, \%nss_pvalues, \%maxchi2_pvalues, $parameters, \@id_rec_to_process, \@f_tree_to_process, \@model8_to_process, \@model7_to_process, \@model2_to_process, \@model1_to_process, \$seq_type);
  }

  # handling paralelism and managing tasks to be processed
  # removing groups from lines 
  if    (@id_rec_to_process) { $ortholog_group = shift(@id_rec_to_process); }
  elsif (@f_tree_to_process) { $ortholog_group = shift(@f_tree_to_process); }
  elsif (@model8_to_process) { $ortholog_group = shift(@model8_to_process); }
  elsif (@model7_to_process) { $ortholog_group = shift(@model7_to_process); }
  elsif (@model2_to_process) { $ortholog_group = shift(@model2_to_process); }
  elsif (@model1_to_process) { $ortholog_group = shift(@model1_to_process); }
  else {
    manage_task_allocation(\%pid_to_ortholog_group, \$n_process, \%phi_pvalues, \%nss_pvalues, \%maxchi2_pvalues, $parameters, \@id_rec_to_process, \@f_tree_to_process, \@model8_to_process, \@model7_to_process, \@model2_to_process, \@model1_to_process, \$seq_type);
    next;
  }
  my $task = substr($ortholog_group, -6, 6); # either id_rec, f_tree, model8, model7, model2 or model1
  $ortholog_group = substr($ortholog_group, 0, -7); # removing the task assigned

  # creating processes to run the given task
  my $pid = fork();

  # child process, analysis of positive selection in separated directories for each ortholog group
  if (!$pid) {
    srand();
    my $ortholog_dir = "$parameters->{project_dir}/intermediate_files/" . $ortholog_group . '/';
    mkdir ($ortholog_dir) unless (-e $ortholog_dir);
    local $CWD = $ortholog_dir;

    if ($task eq 'id_rec') {

      my $task_time = time();
      create_sequence_files ($clusters_ref, $sequences_ref, $translation_ref, $id2tmp_id_ref, \$ortholog_group);
      create_protein_alignment_files ($parameters, $clusters_ref, $tmp_id2id_ref, \$ortholog_group);
      filter_divergent_sequences ($parameters, $clusters_ref, $tmp_id2id_ref, $id2tmp_id_ref, \$ortholog_group); 
      create_codon_alignment_files ($sequences_ref, $tmp_id2id_ref, \$ortholog_group);
      trim_sequences ($parameters, \$ortholog_group);
      identify_recombination ($parameters, \$ortholog_group);
      print_task_time (\$ortholog_dir, \$task_time, 'time_id_rec');

    } elsif ($task eq 'f_tree') {

      my $task_time = time();
      
      create_bootstrap_files ($parameters, \$seq_type, \$ortholog_group);
      create_tree_files ($parameters, \$seq_type, \$ortholog_group);
      create_consensus_tree_files ($parameters, \$seq_type, \$ortholog_group);
      set_as_interleaved("$ortholog_group.cluster.aa.fa.aln.nt.phy.trim"); # necessary for PAML to interpret the nucleotide alignment file, just adds a 'I' to the header
      print_task_time(\$ortholog_dir, \$task_time, 'time_f_tree');

    } elsif ($task eq 'model8' || $task eq 'model7' || $task eq 'model2' || $task eq 'model1') {

      my $task_time = time();
      if ($task eq 'model8') { calculate_dn_ds($parameters, \$potion_path, \$seq_type, \$ortholog_group, '8'); print_task_time(\$ortholog_dir, \$task_time, 'time_model_8'); }
      elsif ($task eq 'model7') { calculate_dn_ds($parameters, \$potion_path, \$seq_type, \$ortholog_group, '7'); print_task_time(\$ortholog_dir, \$task_time, 'time_model_7'); }
      elsif ($task eq 'model2') { calculate_dn_ds($parameters, \$potion_path, \$seq_type, \$ortholog_group, '2'); print_task_time(\$ortholog_dir, \$task_time, 'time_model_2'); }
      elsif ($task eq 'model1') { calculate_dn_ds($parameters, \$potion_path, \$seq_type, \$ortholog_group, '1'); print_task_time(\$ortholog_dir, \$task_time, 'time_model_1'); }

    }
    exit(0);
  }

  # parent process
  elsif ($pid) {
    $pid_to_ortholog_group{$pid} = $ortholog_group if ($task eq 'f_tree' || $task eq 'id_rec'); # Prevents model tasks from generating further tasks
    $n_process++;
  }

  # error case
  else { die ("Could not proceed for group $ortholog_group: $!\n"); }
}

parse_dn_ds_results($parameters, $clusters_ref, $tmp_id2id_ref, $translation_ref);
write_summary($parameters, $clusters_ref, \$start_time);

print ("Analysis finished, closing POTION.\n") if $parameters->{verbose};

close(SUMMARY);
close(LOG_ERR);
close(LOG);
