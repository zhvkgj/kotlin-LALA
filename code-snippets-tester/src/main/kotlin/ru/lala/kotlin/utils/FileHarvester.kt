package ru.lala.kotlin.utils

import ru.lala.kotlin.client.model.KotlinFile
import java.io.File
import java.nio.charset.Charset
import java.nio.file.*
import java.util.*
import kotlin.system.exitProcess

object FileHarvester {
    fun readFiles(directory: String): List<KotlinFile> {
        val path: Path = Paths.get(directory)
        if (Files.notExists(path) || !Files.isDirectory(path)) {
            System.err.println("Directory not exists or is file.")
            exitProcess(1);
        }

        val files: MutableList<KotlinFile> = LinkedList()
        val fileTree = File(directory).walk()
        fileTree.maxDepth(1).filter { it.isFile }.forEach {
            files.add(KotlinFile(it.name, readFile(it)))
        }

        if (files.isEmpty()) {
            System.err.println("Directory is empty.")
            exitProcess(1);
        }
        return files
    }

    private fun readFile(file: File): String = file.readText(Charset.defaultCharset())
}
