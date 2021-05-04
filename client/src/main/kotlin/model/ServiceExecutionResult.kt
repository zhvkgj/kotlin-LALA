package ru.lala.kotlin.client.model

data class ServiceExecutionResult(
    val errors: Map<String, List<ErrorDescriptor>>,
    val exception: ExceptionDescriptor?,
    val text: String,
)
