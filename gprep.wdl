version 1.0

task bismark {
    input {
        File genome_file
        String genome_dir = dirname(genome_file)
        String dockerImage = "quay.io/biocontainers/bismark:0.24.2--hdfd78af_0"
    }

    command {
        /usr/local/bin/bismark_genome_preparation ${genome_dir}
    }

    output {
        File bismark_output = "${genome_dir}/Bisulfite_Genome"
    }

    runtime {
        docker: dockerImage
    }
}
