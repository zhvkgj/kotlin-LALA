import org.gradle.jvm.tasks.Jar
import java.lang.Thread.sleep

plugins {
    kotlin("jvm") version "1.4.21"
    id("com.palantir.docker") version "0.26.0"
    id("com.palantir.docker-run") version "0.25.0"
}

group = "com.lala.kotlin"
version = "unspecified"

repositories {
    mavenCentral()
}

dependencies {
    testRuntimeOnly("org.junit.jupiter:junit-jupiter-engine:5.7.1")
    testImplementation("org.junit.jupiter:junit-jupiter-api:5.7.1")

    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8")

    implementation("org.slf4j:slf4j-api:2.0.0-alpha1")
    implementation("org.slf4j:slf4j-log4j12:2.0.0-alpha1")

    implementation(files("build/libs/StarSmith.jar"))
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

task<Exec>("translateSpec") {
    group = "generation"
    workingDir("$rootDir")
    val command = "./translate_spec.sh --spec spec/kotlin.ls --maxDepth 15 --toJava out/kotlin.java"
    commandLine(command.split(" "))
}

task<Exec>("compileSpec") {
    group = "generation"
    dependsOn("translateSpec")
    workingDir("${rootDir}/out")
    commandLine("./compile.sh", "kotlin.java")
}

task<Exec>("generateExamples") {
    group = "generation"
    dependsOn("compileSpec")
    workingDir("$rootDir")
    commandLine("./generate_examples.sh")
}
