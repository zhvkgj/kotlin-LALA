package ru.lala.kotlin

import ru.lala.kotlin.client.KotlinCompileClient
import ru.lala.kotlin.utils.FileHarvester
import ru.lala.kotlin.utils.ReportBuilder
import java.io.File
import java.io.FileWriter

class TestExecutor {
    companion object {
        private const val src = "examples"
        private const val out = "compile_results"
        private const val generalReportFilename = "general_report"

        private const val batchCount = 100

        @JvmStatic
        fun main(args: Array<String>) {
            val inputDir: String = if (args.isNotEmpty()) {
                args[0]
            } else src
            val outputDir: String = if (args.size > 1) {
                args[1]
            } else out
            val batches: Int = if (args.size > 2) {
                args[2].toInt()
            } else batchCount

            val client = KotlinCompileClient()
            for (i in 0..batches) {
                val reportBuilder = ReportBuilder(generalReportFilename + "_${i}.txt")
                FileHarvester.readFiles(inputDir + File.separator + "batch_$i").forEach {
                    reportBuilder.append(client.executeFileCode(it))
                }
                val generalCompileReport = reportBuilder.buildReport()
                writeToFile(
                    generalCompileReport.generalReport.fileName,
                    generalCompileReport.generalReport.content,
                    i, outputDir
                )
                generalCompileReport.filesReports.forEach { report ->
                    writeToFile(report.fileName, report.content, i, outputDir)
                }
            }
        }

        private fun writeToFile(fileName: String, content: String,
                                batchNum: Int, outDir: String) {
            val dirName = outDir + File.separator + "batch_$batchNum"
            val dir = File(dirName)
            if (!dir.exists()) {
                dir.mkdir()
            }
            FileWriter("$dirName/$fileName").use {
                it.write(content)
            }
        }
    }
}
