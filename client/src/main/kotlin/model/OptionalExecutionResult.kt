package com.lala.kotlin.client.model


data class OptionalExecutionResult(
    val isSuccess: Boolean,
    val message: String,
    val result: ExecutionResult?
) {
    data class ExecutionResult(
        val errors: List<ErrorDescriptor>,
        val exception: ExceptionDescriptor?,
        val text: String,
        val fileName: String
    )
}
