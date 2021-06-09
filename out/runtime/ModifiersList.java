package runtime;

import java.util.HashSet;
import java.util.Set;

public final class ModifiersList {
    public final Set<String> modifiers;
    public final ModifiersListTarget target;
    public final boolean isTopLevel;

    public static final ModifiersList getInstance(final ModifiersListTarget target,
                                                  final boolean isTopLevel) {
        return new ModifiersList(target, isTopLevel);
    }

    public ModifiersList(final ModifiersListTarget target, final boolean isTopLevel) {
        this.modifiers = new HashSet<>();
        this.target = target;
        this.isTopLevel = isTopLevel;
    }

    public static final boolean isModifierValid(final ModifiersList modifiersList,
                                                final String modifierName,
                                                final boolean insideInlineFun) {
        boolean isValid = false;
        switch (modifierName) {
            case "const":
                isValid = modifiersList.isTopLevel && modifiersList.onVal();
                break;
            case "external":
                isValid = modifiersList.onFun() && modifiersList.isEmpty();
                break;
            case "inline":
            case "tailrec":
            case "suspend":
            case "operator":
                isValid = modifiersList.onFun() && ModifiersList.notContains(modifiersList,"external");
                break;
            case "vararg":
                isValid = modifiersList.onParam();
                break;
            case "noinline":
                isValid = modifiersList.onParam() && insideInlineFun && ModifiersList.notContains(modifiersList,"crossinline");
                break;
            case "crossinline":
                isValid = modifiersList.onParam() && insideInlineFun && ModifiersList.notContains(modifiersList,"inline");
                break;
        }
        return isValid && ModifiersList.notContains(modifiersList, modifierName);
    }

    private boolean onVal() {
        return this.target == ModifiersListTarget.Val;
    }

    private boolean onFun() {
        return this.target == ModifiersListTarget.Fun;
    }

    private boolean onParam() {
        return this.target == ModifiersListTarget.Param;
    }

    private boolean isEmpty() {
        return this.modifiers.isEmpty();
    }

    public static final boolean notContains(final ModifiersList modifiersList,
                                            final String modifier) {
        return !modifiersList.modifiers.contains(modifier);
    }


    public static final ModifiersList put(final ModifiersList symbolTable, final String modifier) {
        final ModifiersList clone = symbolTable.clone();

        clone.modifiers.add(modifier);

        return clone;
    }

    public final ModifiersList clone() {
        final ModifiersList clone = new ModifiersList(this.target, this.isTopLevel);

        clone.modifiers.addAll(this.modifiers);

        return clone;
    }

    @Override
    public final boolean equals(final Object other) {
        if (!(other instanceof ModifiersList)) {
            return false;
        }

        final ModifiersList otherModifiersList = (ModifiersList) other;
        return this.modifiers.equals(otherModifiersList.modifiers);
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
        for (String keyword : modifiers) {
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

