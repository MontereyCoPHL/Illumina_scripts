version 1.0

task fastqc_task {
  meta {
    description: "Display QC metrics for reads in fastq format using FastQC (https://github.com/s-andrews/FastQC)"
  }
  input {
    String docker = "us-docker.pkg.dev/general-theigen/staphb/fastqc:0.12.1"
    Int cpu = 4
    Int memory = 8
    Int disk_size = 100

    #fastqc params
    File read
  }
  command <<<
    fastqc ~{read}
  >>>
  output {
    File report_zip = sub(basename(read, ".gz"), "\\.fastq*", "_fastqc.zip")
    File report_html = sub(basename(read, ".gz"), "\\.fastq*", "_fastqc.html")
    String fastqc_docker = docker
  }
  runtime {
    docker: docker
    cpu: cpu
    memory: memory + " GB"
    disks: "local-disk " + disk_size + " SSD"
    preemptible: 0
    maxRetries: 3
  }
}