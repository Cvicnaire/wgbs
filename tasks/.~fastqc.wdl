version 1.0 

task FastQC {
    input {
        File fastqFile
        String outdirPath
        String dockerImage =  "quay.io/biocontainers/fastqc:0.12.1--hdfd78af_0"
    }
}

command <<<
     usr/local/opt/fastqc:0.12.1 fastqc -o ${outdirPath} ${fastqFile}

    >>>

runtime {
   
    docker: dockerImage
}

output {
    File fastqc_report 
}