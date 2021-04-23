package ru.lala.kotlin.client.model

data class ExceptionDescriptor(
    val message: String?,
    val fullName: String?,
    val stackTrace: List<StackTraceElement>,
    val cause: ExceptionDescriptor?,
    val localizedMessage: String?
)
