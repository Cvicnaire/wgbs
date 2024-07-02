version 1.0


# Experimental bismark full workflow

import "tasks/fastqc.wdl" as fastqc
import "tasks/bismark.wdl" as bismark

workflow wgbs_workflow {
    input {
        Array[File] fastq_filesR1
        Array[File] fastq_filesR2
        String inputDir
        String fastqc_outdir
    }

    scatter (pair in zip(fastq_filesR1, fastq_filesR2)) {
        call bismark.bismark {
            input:
                fastq_file1 = pair.left,
                fastq_file2 = pair.right,
                inputDir = inputDir
        }

        call fastqc.FastQC as FastQC1 {
            input:
                fastqFile = pair.left,
                outdirPath = fastqc_outdir
        }

        call fastqc.FastQC as FastQC2 {
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
