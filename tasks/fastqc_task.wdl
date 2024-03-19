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
    String samplename
    #String out_zip = sub(basename(read, ".gz"), "\\.fastq*", "_fastqc.zip")
    #String out_html = sub(basename(read, ".gz"), "\\.fastq*", "_fastqc.html")
  }
  command <<<
    fastqc ~{read}
  >>>
  output {
    #File report_zip = out_zip
    #File report_html = out_html
    File report_zip = "~{samplename}_fastqc.zip"
    File report_html = "~{samplename}_fastqc.html"
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