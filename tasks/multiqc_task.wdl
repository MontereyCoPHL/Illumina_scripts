version 1.0

task multiqc_task {
  meta {
  	description: "Aggregate outputs from multiple FastQC reports into one summary document (https://github.com/MultiQC/MultiQC)"
  }
  input {
    String docker = "us-docker.pkg.dev/general-theigen/staphb/multiqc:1.19"
    Int cpu = 4
    Int memory = 8
    Int disk_size = 100

    #multiqc params
    Array[File] reports
    String out_name
  }
  command <<<
    multiqc ~{sep = " " reports}
    mv multiqc_report.html ~{out_name}_multiqc_report.html
  >>>
  output {
  	File report = "~{out_name}_multiqc_report.html"
  	String multiqc_docker = docker
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