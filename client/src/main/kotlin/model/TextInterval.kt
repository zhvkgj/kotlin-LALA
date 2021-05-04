package ru.lala.kotlin.client.model

data class TextInterval(val start: TextPosition, val end: TextPosition) {
    data class TextPosition(val line: Int, val ch: Int)
}
