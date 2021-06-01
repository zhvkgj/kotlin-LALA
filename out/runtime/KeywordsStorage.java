package runtime;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

public final class KeywordsStorage {
    public final Set<String> keywords;

    public static final KeywordsStorage getInstance() {
        return new KeywordsStorage();
    }

    public KeywordsStorage() {
        this.keywords = new HashSet<>(List.of(
                "as", "as?", "break", "class", "continue",
                "do", "else", "false", "for", "fun", "if",
                "in", "!in", "interface", "is", "!is", "null",
                "object", "package", "return", "super", "this",
                "throw", "true", "try", "typealias", "typeof",
                "val", "var", "when", "while")
        );
    }

    public static final boolean isNotKeyword(final KeywordsStorage storage,
                                             final String name) {
        return !storage.keywords.contains(name);
    }

    @Override
    public final boolean equals(final Object other) {
        if (!(other instanceof KeywordsStorage)) {
            return false;
        }

        final KeywordsStorage otherKeywordsStorage = (KeywordsStorage) other;
        return this.keywords.equals(otherKeywordsStorage.keywords);
    }

    @Override
    public final int hashCode() {
        throw new RuntimeException("hashCode() not supported");
    }

    @Override
    public final String toString() {
        final StringBuilder builder = new StringBuilder();
        builder.append("[");
        boolean firstEntry = true;
        for (String keyword : keywords) {
            if (!firstEntry) {
                builder.append(", ");
            }
            firstEntry = false;
            builder.append(keyword);
        }
        builder.append("]");
        return builder.toString();
    }
}
