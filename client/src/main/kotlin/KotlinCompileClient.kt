package ru.lala.kotlin.client

import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import ru.lala.kotlin.client.api.KotlinCodeSnippetsExecutionService
import ru.lala.kotlin.client.model.*
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.jackson.JacksonConverterFactory
import retrofit2.converter.jaxb.JaxbConverterFactory
import java.io.IOException

class KotlinCompileClient {
    private val compilerService: KotlinCodeSnippetsExecutionService =
        Retrofit
            .Builder()
            .baseUrl(RequestConstant.COMPILER_SERVICE_URL)
            .addConverterFactory(JaxbConverterFactory.create())
            .addConverterFactory(JacksonConverterFactory.create(jacksonObjectMapper()))
            .build()
            .create(KotlinCodeSnippetsExecutionService::class.java)

    fun executeFilesCode(codeSnippet: List<KotlinFile>): OptionalExecutionResult {
        val project = Project("", codeSnippet)
        val response: Response<ServiceExecutionResult>
        var result: OptionalExecutionResult
        try {
            response = compilerService.executeCode(project).execute()
            result = if (response.isSuccessful) {
                val res = response.body()!!
                OptionalExecutionResult(true, "",
                    OptionalExecutionResult.ExecutionResult(
                        res.errors,
                        res.exception,
                        res.text
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
