package com.lala.kotlin.client.api

import com.lala.kotlin.client.model.ServiceExecutionResult
import com.lala.kotlin.client.model.Project
import retrofit2.Call
import retrofit2.http.Body
import retrofit2.http.Headers
import retrofit2.http.POST

internal interface KotlinCodeSnippetsRunnerService {
    @POST("/api/compiler/run")
    @Headers("Content-Type: application/json")
    fun executeCode(@Body body: Project): Call<ServiceExecutionResult>
}
