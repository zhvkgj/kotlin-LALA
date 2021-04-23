import java.lang.Thread.sleep

plugins {
    application
    kotlin("jvm") version "1.4.21"
    id("com.palantir.docker") version "0.26.0"
    id("com.palantir.docker-run") version "0.25.0"
}

application {
    mainClassName = "ru.lala.kotlin.TestExecutor"
}

repositories {
    mavenCentral()
}

dependencies {
    testRuntimeOnly("org.junit.jupiter:junit-jupiter-engine:5.7.1")
    testImplementation("org.junit.jupiter:junit-jupiter-api:5.7.1")

    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8")
    implementation("com.fasterxml.jackson.module:jackson-module-kotlin:2.12.3")

    implementation(files("build/libs/StarSmith.jar"))
    implementation(project(":client"))
}

tasks {
    compileKotlin {
        kotlinOptions.jvmTarget = "1.8"
    }
    compileTestKotlin {
        kotlinOptions.jvmTarget = "1.8"
    }
}

val dockerImageName = "prendota/kotlin-compiler-server:latest"

docker {
    name = dockerImageName
    pull(true)
}

dockerRun {
    name = "kotlin-compiler-server"
    image = dockerImageName
    arguments("--network=host")
    clean = false
}

tasks.dockerRun {
    doLast {
        sleep(10 * 1000)
    }
}

tasks.test {
    dependsOn("dockerRun")
    useJUnitPlatform()
    finalizedBy("dockerStop", "dockerRemoveContainer")
}
