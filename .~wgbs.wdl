version 1.0

# Experimental bismark workflow

task bismark {
    input {
        File fastq_file1
        File fastq_file2
        String inputDir
        String base = basename(fastq_file1, ".fastq.gz")
        String dockerImage = "quay.io/biocontainers/bismark:0.24.2--hdfd78af_0"
    }

    command {
        /usr/local/bin/bismark \
        --genome ${inputDir} \
        -1 ${fastq_file1} \
        -2 ${fastq_file2} \ 
        bismark2summary
    }

    output {
        File bismark_output = "${base}_bismark.bam"
    }

    runtime {
        docker: dockerImage
    }
}

task FastQC {
    input {
        File fastqFile
        String outdirPath = "."
        String dockerImage = "quay.io/biocontainers/fastqc:0.12.1--hdfd78af_0"
    }

    command {
        /usr/local/bin/fastqc -o ${outdirPath} ${fastqFile}
    }

    output {
        File fastqc_report = "${outdirPath}/${basename(fastqFile, ".fastq.gz")}_fastqc.html"
    }

    runtime {
        docker: dockerImage
    }
}

workflow wgbs_workflow {
    input {
        Array[File] fastq_filesR1
        Array[File] fastq_filesR2
        String inputDir
        String fastqc_outdir
    }

    scatter (pair in zip(fastq_filesR1, fastq_filesR2)) {
        call bismark {
            input:
                fastq_file1 = pair.left,
                fastq_file2 = pair.right,
                inputDir = inputDir
        }

        call FastQC as FastQC1 {
            input:
                fastqFile = pair.left,
                outdirPath = fastqc_outdir
        }

        call FastQC as FastQC2 {
            input:
                fastqFile = pair.right,
                outdirPath = fastqc_outdir
        }
    }

    output {
        Array[File] bismark_outputs = bismark.bismark_output
        Array[File] fastqc_reports1 = FastQC1.fastqc_report
        Array[File] fastqc_reports2 = FastQC2.fastqc_report
    }
}
