package ru.lala.kotlin.utils

import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import ru.lala.kotlin.*
import ru.lala.kotlin.client.model.*
import java.util.*

class ReportBuilder(private val generalReportFilename: String) {
    private var totalCountOfFiles = 0L
    private var countOfSuccessfullyCompiledFiles = 0L
    private var countOfFilesProducesServerError = 0L
    private var totalCountOfErrors = 0L
    private var totalCountOfTypeMismatchErrors = 0L
    private var totalCountOfUnresolvedReferenceErrors = 0L
    private var totalCountOfModifierUsageErrors = 0L

    private val filesReports: MutableList<DetailedFileCompileReport> = LinkedList()

    fun append(compileResult: OptionalExecutionResult): ReportBuilder {
        val compileReport = executionResultToCompileReport(compileResult)
        countOfSuccessfullyCompiledFiles +=
            if (compileReport.successfullyCompiled) 1L else 0L
        countOfFilesProducesServerError +=
            if (compileReport.produceServerError) 1L else 0L
        totalCountOfFiles++
        totalCountOfTypeMismatchErrors += compileReport.countOfTypeMismatchErrors
        totalCountOfUnresolvedReferenceErrors += compileReport.countOfUnresolvedReferenceErrors
        totalCountOfModifierUsageErrors += compileReport.countOfModifiersError
        totalCountOfErrors += compileReport.countOfErrors

        filesReports.add(
            buildFileReport(
                compileReport,
                compileResult.result?.errors?.filter { it.severity == ProjectSeverity.ERROR } ?: emptyList(),
                compileResult.result?.exception
            )
        )

        return this
    }

    private fun executionResultToCompileReport(compileResult: OptionalExecutionResult): ShallowFileCompileReport {
        if (!compileResult.isSuccess) {
            return ShallowFileCompileReport(
                compileResult.filename,
                successfullyCompiled = false,
                produceServerError = true,
                message = compileResult.message
            )
        }

        val result = compileResult.result!!
        val totalCountOfErrors = result.errors.size * 1L
        var countOfTypeMismatchErrors = 0L
        var countOfUnresolvedReferenceErrors = 0L
        var countOfModifierErrors = 0L

        result.errors.forEach {
            when {
                it.message.contains("type mismatch", true) -> {
                    countOfTypeMismatchErrors++
                }
                it.message.contains("unresolved reference", true) -> {
                    countOfUnresolvedReferenceErrors++
                }
                it.message.contains("Modifier") -> {
                    countOfModifierErrors++
                }
            }
        }

        return ShallowFileCompileReport(
            compileResult.filename,
            totalCountOfErrors == 0L,
            false,
            result.text,
            totalCountOfErrors,
            countOfTypeMismatchErrors,
            countOfUnresolvedReferenceErrors,
            countOfModifierErrors
        )
    }

    fun buildReport(): GeneralCompileReport {
        return GeneralCompileReport(buildGeneralFileReport(), filesReports)
    }

    private fun buildFileReport(
        shallowReport: ShallowFileCompileReport,
        errors: List<ErrorDescriptor>,
        exception: ExceptionDescriptor?
    )
        : DetailedFileCompileReport {

        val message = fillShallowReport(shallowReport)
        message.append("--".repeat(15) + "\n")

        val mapper = jacksonObjectMapper()
        val ident = "    "
        message.append("Errors:\n")
        if (errors.isNotEmpty()) {
            errors.forEach {
                message.append("\n${ident}${mapper.writeValueAsString(it.interval)}\n")
                message.append("${ident}${it.message}\n")
                message.append("${ident}${it.severity.name}\n")
            }
        }
        if (exception != null) {
            message.append("Exception:\n    ")
            message.append(mapper.writeValueAsString(exception))
        }
        return DetailedFileCompileReport(shallowReport.fileName + "_report.txt", message.toString())
    }

    private fun fillShallowReport(shallowReport: ShallowFileCompileReport): StringBuilder {
        val message = StringBuilder()
        message
            .append(shallowReport.fileName + "\n")
            .append("Successfully compiled: ${shallowReport.successfullyCompiled}\n")
            .append("Produce server error: ${shallowReport.produceServerError}\n")
            .append("Count of errors: ${shallowReport.countOfErrors}\n")
            .append("Count of type mismatch errors: ${shallowReport.countOfTypeMismatchErrors}\n")
            .append("Count of unresolved reference errors: ${shallowReport.countOfUnresolvedReferenceErrors}\n")
            .append("Count of modifier usage errors: ${shallowReport.countOfModifiersError}\n")
            .append("Message: ${shallowReport.message}\n")
        return message
    }

    private fun buildGeneralFileReport(): DetailedFileCompileReport {
        fun percentage(totalCount: Long, targetCount: Long): Double {
            return (targetCount * 100).toDouble() / totalCount
        }

        val message = StringBuilder()
        val countOfFailCompiledFiles = totalCountOfFiles - countOfSuccessfullyCompiledFiles - countOfFilesProducesServerError
        val countOfOtherErrors = totalCountOfErrors - totalCountOfUnresolvedReferenceErrors - totalCountOfTypeMismatchErrors - totalCountOfModifierUsageErrors
        message
            .append("Count of successfully compiled files: $countOfSuccessfullyCompiledFiles\n")
            .append("Count of fail compiled files: $countOfFailCompiledFiles\n")
            .append("Count of files produced server error: $countOfFilesProducesServerError\n")
            .append("Count of mismatch type errors: $totalCountOfTypeMismatchErrors\n")
            .append("Percentage: ${percentage(totalCountOfErrors, totalCountOfTypeMismatchErrors)} percents\n")
            .append("Count of unresolved reference errors: $totalCountOfUnresolvedReferenceErrors\n")
            .append("Percentage: ${percentage(totalCountOfErrors, totalCountOfUnresolvedReferenceErrors)} percents\n")
            .append("Count of modifier usage errors: $totalCountOfModifierUsageErrors\n")
            .append("Percentage: ${percentage(totalCountOfErrors, totalCountOfModifierUsageErrors)} percents\n")
            .append("Count of other errors: $countOfOtherErrors\n")
            .append("Percentage: ${percentage(totalCountOfErrors, countOfOtherErrors)} percents\n")
        return DetailedFileCompileReport(generalReportFilename, message.toString())
    }
}
