package runtime;

public enum ModifiersListTarget {
    Val, Var, Fun, Param;

    public static final ModifiersListTarget getVal() {
        return ModifiersListTarget.Val;
    }

    public static final ModifiersListTarget getVar() {
        return ModifiersListTarget.Var;
    }

    public static final ModifiersListTarget getFun() {
        return ModifiersListTarget.Fun;
    }

    public static final ModifiersListTarget getParam() {
        return ModifiersListTarget.Param;
    }
}
