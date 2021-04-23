package ru.lala.kotlin

import ru.lala.kotlin.client.KotlinCompileClient
import ru.lala.kotlin.client.model.OptionalExecutionResult
import ru.lala.kotlin.utils.FileHarvester
import java.io.FileWriter
import java.util.*

import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import ru.lala.kotlin.utils.ReportBuilder
import java.io.File

class TestExecutor {
    companion object {
        private const val src = "examples"
        private const val out = "compile_results"

        @JvmStatic
        fun main(args: Array<String>) {
            val directory: String = if (args.isNotEmpty()) {
                args[0]
            } else src

            val client = KotlinCompileClient()
            val result: OptionalExecutionResult = client.executeFilesCode(FileHarvester.readFiles(directory))
            ReportBuilder.buildReport(result).forEach {
                    report -> writeToFile(report.fileName, report.message)
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
