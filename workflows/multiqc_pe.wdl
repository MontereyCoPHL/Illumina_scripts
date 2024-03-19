version 1.0

import "../tasks/fastqc_task.wdl" as fastqc
import "../tasks/multiqc_task.wdl" as multiqc

workflow multi_qc_pe {
  meta {
    description: "Generate and aggregate QC metrics for paired end reads across multiple samples"
  }
  input {
    Array[File] read1
    Array[File] read2
    Array[String] samplenames
    String out_name
    String r1_out_name = out_name + "_read1"
    String r2_out_name = out_name + "_read2"
  }
  scatter (file1 in zip(read1, samplenames)) {
    call fastqc.fastqc_task as fqc1 {
  	  input: 
  	    read = file1.left,
  	    samplename = file1.right
    }
  }
  scatter (file2 in zip(read2, samplenames)) {
    call fastqc.fastqc_task as fqc2 {
  	  input: 
  	    read = file2.left,
  	    samplename = file2.right
	}
  }
  call multiqc.multiqc_task as r1_aggregate {
    input: 
      reports = fqc1.report_zip, 
      out_name = r1_out_name
  }
  call multiqc.multiqc_task as r2_aggregate {
    input: 
      reports = fqc2.report_zip, 
      out_name = r2_out_name
  }
  output {
    File read1_multiqc_report = r1_aggregate.report
    File read2_multiqc_report = r2_aggregate.report
    String fastqc_docker = fqc1.fastqc_docker[0]
    String multiqc_docker = r1_aggregate.multiqc_docker
  }
}