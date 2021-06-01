package ru.lala.kotlin

data class ShallowFileCompileReport(
    val fileName: String,
    val successfullyCompiled: Boolean,
    val produceServerError: Boolean,
    val message: String,
    val countOfErrors: Long = 0,
    val countOfTypeMismatchErrors: Long = 0,
    val countOfUnresolvedReferenceErrors: Long = 0,
    val countOfModifiersError: Long = 0
)
