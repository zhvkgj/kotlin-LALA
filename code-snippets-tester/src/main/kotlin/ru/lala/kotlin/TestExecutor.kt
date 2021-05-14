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
        private const val generalReportFilename = "general_report.txt"

        @JvmStatic
        fun main(args: Array<String>) {
            val directory: String = if (args.isNotEmpty()) {
                args[0]
            } else src

            val client = KotlinCompileClient()
            val reportBuilder = ReportBuilder(generalReportFilename)
            FileHarvester.readFiles(directory).forEach {
                reportBuilder.append(client.executeFileCode(it))
            }
            val generalCompileReport = reportBuilder.buildReport()
            writeToFile(
                generalCompileReport.generalReport.fileName,
                generalCompileReport.generalReport.content
            )
            generalCompileReport.filesReports.forEach { report ->
                writeToFile(report.fileName, report.content)
            }
        }

        private fun writeToFile(fileName: String, content: String) {
            val dir = File(out)
            if (!dir.exists()) {
                dir.mkdir()
            }
            FileWriter("$out/$fileName").use {
                it.write(content)
            }
        }
    }
}
