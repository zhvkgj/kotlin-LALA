allprojects {
    repositories {
        jcenter()
    }
}

subprojects {
    version = "1.0"
}

task<Exec>("compileRuntimeResources") {
    group = "generation"
    workingDir("${rootDir}/out/runtime")
    commandLine("./compile_all.sh")
}

task<Exec>("translateSpec") {
    group = "generation"
    workingDir("$rootDir")
    val command = "./translate_spec.sh --spec spec/kotlin.ls --maxDepth 15 --toJava out/kotlin.java"
    commandLine(command.split(" "))
}

task<Exec>("compileSpec") {
    group = "generation"
    dependsOn("translateSpec", "compileRuntimeResources")
    workingDir("${rootDir}/out")
    commandLine("./compile.sh", "kotlin.java")
}

task<Exec>("generateExamples") {
    group = "generation"
    dependsOn("compileSpec")
    workingDir("$rootDir")
    commandLine("./generate_examples.sh")
}
