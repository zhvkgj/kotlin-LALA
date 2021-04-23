package ru.lala.kotlin.client.model

import com.fasterxml.jackson.annotation.JsonIgnoreProperties

@JsonIgnoreProperties(ignoreUnknown = true)
data class ErrorDescriptor(
    val interval: TextInterval,
    val message: String,
    val severity: ProjectSeverity,
    val className: String?
)
