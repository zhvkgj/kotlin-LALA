package ru.lala.kotlin.utils

import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import ru.lala.kotlin.CompileReport
import ru.lala.kotlin.client.model.*
import java.util.*

class ReportBuilder {
    companion object {
        private const val generalReportFilename = "general_report.txt"

        fun buildReport(executionResult: OptionalExecutionResult): List<CompileReport> {
            val report: LinkedList<CompileReport> = LinkedList()
            var successCount = 0
            var failedCount = 0
            if (executionResult.isSuccess) {
                if (executionResult.result != null) {
                    failedCount = executionResult.result!!.errors.size
                    executionResult.result!!.errors.forEach { (fileName, errors) ->
                        val res = buildFileReport(fileName, errors)
                        if (res.compiled) {
                            successCount++
                            failedCount--
                        }
                        report.add(res)
                    }
                }
            }
            report.addFirst(buildGeneralFileReport(successCount, failedCount, executionResult))
            return report
        }

        private fun buildFileReport(fileName: String, errors: List<ErrorDescriptor>): CompileReport {
            val message = StringBuilder()
            var compiled = false
            if (errors.isEmpty()) {
                compiled = true
                message.append("No compile errors occurred.\n")
            } else {
                val mapper = jacksonObjectMapper()
                val ident = "    "
                message.append("Errors:\n")
                errors.forEach {
                    message.append("\n${ident}${mapper.writeValueAsString(it.interval)}\n")
                    message.append("${ident}${it.message}\n")
                    message.append("${ident}${it.severity.name}\n")
                }
            }
            return CompileReport(compiled, fileName + "_report.txt", message.toString())
        }

        private fun buildGeneralFileReport(success: Int, failed: Int, execRes: OptionalExecutionResult): CompileReport {
            val message = StringBuilder()
            message.append("Success: ${success}\n").append("Failed: ${failed}\n")
            if (execRes.result != null) {
                val res = execRes.result!!
                message.append(res.text + "\n")
                if (res.exception != null) {
                    message.append(jacksonObjectMapper().writeValueAsString(res.exception) + "\n")
                }
            } else if (execRes.message.isNotBlank()) {
                message.append(execRes.message + "\n")
            } else {
                message.append("server return null result\n")
            }
            return CompileReport(
                true, generalReportFilename,
                message.toString()
            )
        }
    }
}
