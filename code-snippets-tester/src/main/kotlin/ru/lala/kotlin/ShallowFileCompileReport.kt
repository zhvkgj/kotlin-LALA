package ru.lala.kotlin

data class ShallowFileCompileReport(
    val fileName: String,
    val successfullyCompiled: Boolean,
    val produceServerError: Boolean,
    val message: String,
    val countOfErrors: Int = 0,
    val countOfTypeMismatchErrors: Int = 0,
    val countOfUnresolvedReferenceErrors: Int = 0,
    val countOfModifiersError: Int = 0
)
