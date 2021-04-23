package ru.lala.kotlin.client.model


data class OptionalExecutionResult(
    val isSuccess: Boolean,
    val message: String,
    val result: ExecutionResult?
) {
    data class ExecutionResult(
        val errors: Map<String, List<ErrorDescriptor>>,
        val exception: ExceptionDescriptor?,
        val text: String,
    )
}
