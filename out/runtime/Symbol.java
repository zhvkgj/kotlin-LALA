package runtime;

import i2.act.fuzzer.runtime.Printable;

import java.util.Objects;

public final class Symbol implements Printable {

    public static final Symbol create(final String name) {
        return new Symbol(name);
    }

    public static final String getName(final Symbol symbol) {
        return symbol.name;
    }

    // -----------------------------------------------------------------------------------------------

    public final String name;

    public Symbol(final String name) {
        this.name = name;
    }

    @Override
    public final boolean equals(final Object other) {
        if (!(other instanceof Symbol)) {
            return false;
        }

        final Symbol otherSymbol = (Symbol) other;

        return Objects.equals(this.name, otherSymbol.name);
    }

    @Override
    public final int hashCode() {
        return Objects.hash(this.name);
    }

    @Override
    public final String toString() {
        return String.format("(%s, %s)", this.name);
    }

    @Override
    public final String print() {
        return this.name;
    }

}
