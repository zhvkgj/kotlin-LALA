package com.lala.kotlin.client

import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import com.lala.kotlin.client.api.KotlinCodeSnippetsRunnerService
import com.lala.kotlin.client.model.*
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.jackson.JacksonConverterFactory
import retrofit2.converter.jaxb.JaxbConverterFactory
import java.io.IOException

class KotlinCompileServiceClient {
    private val compilerService: KotlinCodeSnippetsRunnerService =
        Retrofit
            .Builder()
            .baseUrl(RequestConstant.COMPILER_SERVICE_URL)
            .addConverterFactory(JaxbConverterFactory.create())
            .addConverterFactory(JacksonConverterFactory.create(jacksonObjectMapper()))
            .build()
            .create(KotlinCodeSnippetsRunnerService::class.java)

    fun executeCode(codeSnippet: CodeSnippet): OptionalExecutionResult {
        val project = Project("", listOf(KotlinFile(codeSnippet.filename, codeSnippet.code)))
        val response: Response<ServiceExecutionResult>
        var result: OptionalExecutionResult
        try {
            response = compilerService.executeCode(project).execute()
            result = if (response.isSuccessful) {
                val res = response.body()!!
                OptionalExecutionResult(true, "",
                    OptionalExecutionResult.ExecutionResult(
                        res.errors[codeSnippet.filename] ?: error("unexpected response structure"),
                        res.exception,
                        res.text,
                        codeSnippet.filename
                    )
                )
            } else {
                OptionalExecutionResult(false, (response.body() ?: "") as String, null)
            }
        } catch (e: IOException) {
            result = OptionalExecutionResult(false, e.localizedMessage, null)
        }
        return result
    }
}

object RequestConstant {
    const val COMPILER_SERVICE_URL = "http://localhost:8080"
}
