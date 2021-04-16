package com.lala.kotlin.client.model

data class ErrorDescriptor(
    val interval: TextInterval,
    val message: String,
    val severity: ProjectSeverity,
    val className: String?
)
