package ru.lala.kotlin

data class GeneralCompileReport(
    val generalReport: DetailedFileCompileReport,
    val filesReports: List<DetailedFileCompileReport>
)
