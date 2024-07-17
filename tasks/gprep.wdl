version 1.0
# this should work
workflow bismark_workflow {
    input {
        File genome_file
        String dockerImage = "quay.io/biocontainers/bismark:0.24.2--hdfd78af_0"
    }

    call prepare_genome {
        input:
            genome_file = genome_file,
            dockerImage = dockerImage
    }

    output {
        File bisulfite_genome_file = prepare_genome.bisulfite_genome_file
    }
}

task prepare_genome {
    input {
        File genome_file
        String dockerImage
    }

    command {
        
        /usr/local/bin/bismark_genome_preparation ${genome_file}
    }

    output {
        File bisulfite_genome_file = "${genome_file}/Bisulfite_Genome/"
    }

    runtime {
        docker: dockerImage
    }
}
