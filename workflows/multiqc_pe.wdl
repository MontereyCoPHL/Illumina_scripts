version 1.0

import "../tasks/fastqc_task.wdl" as fastqc
import "../tasks/multiqc_task.wdl" as multiqc

workflow multi_qc_pe{
	input{
		Array[File] read1
		Array[File] read2
		String task_name
		String r1_task_name = task_name + "_read1"
		String r2_task_name = task_name + "_read2"

	}
	scatter (file1 in read1){
		call fastqc.fastqc_task as fqc1{
			input: read = file1
		}
	}
	scatter (file2 in read2){
		call fastqc.fastqc_task as fqc2{
			input: read = file2
		}
	}
	call multiqc.multiqc_task as r1_aggregate{
		input: reports = fqc1.report_zip, out_name = r1_task_name
	}
	call multiqc.multiqc_task as r2_aggregate{
		input: reports = fqc2.report_zip, out_name = r2_task_name
	}
	output{
		File read1_multiqc_report = r1_aggregate.report
		File read2_multiqc_report = r2_aggregate.report
	}
}