class KotlinFile {
    topLevelObject ("${declarations : TopLevelObjectList}") {

    }
}

@copy
@list(100)
class TopLevelObjectList {
    @weight(1)
    single_declaration("${declaration : TopLevelObject}") {

    }

    @weight(3)
    multiple_declaration("${declaration : TopLevelObject}\n${rest : TopLevelObjectList}") {

    }
}

@copy
class TopLevelObject {
    declaration("${declaration : Declaration}") {

    }
}

# Section: declarations
@copy
class Declaration {
    @weight(1)
    propertyDeclaration("${propertyDeclaration : PropertyDeclaration}") {

    }

    @weight(2)
    functionDeclaration("${functionDeclaration: FunctionDeclaration}") {

    }
}

@copy
class FunctionDeclaration {
    @weight(1)
    withoutType("${modifiers: OptionalModifierList} fun ${name: SimpleIdentifier}
                    ${params: OptionalFunctionValueParameterList} ${body: FunctionBody}") {

    }

    @weight(2)
    withType("${modifiers: OptionalModifierList} fun ${name: SimpleIdentifier}
                ${params: OptionalFunctionValueParameterList} : ${type: Type} ${body: FunctionBody}") {

    }
}

@copy
class OptionalFunctionValueParameterList {
    @weight(1)
    emptyParameterList("()") {

    }

    @weight(5)
    nonEmptyParameterList("(${params: FunctionValueParameterList})") {

    }
}

@copy
@list(10)
class FunctionValueParameterList {
    @weight(1)
    singleParameter("${param: FunctionValueParameter}") {

    }

    @weight(3)
    multipleParameters("${param: FunctionValueParameter}, ${rest: FunctionValueParameterList}") {

    }
}

@copy
class FunctionValueParameter {
    withDefaultValue("${modifiers: OptionalParameterModifierList} ${param: Parameter} = ${expression : Expression}") {

    }

    withoutDefaultValue("${modifiers: OptionalParameterModifierList} ${param: Parameter}") {

    }
}

class Parameter {
    @copy
    parameter("${name: SimpleIdentifier} : ${type: Type}") {

    }
}

@copy
class FunctionBody {
    block("${body: Block}") {

    }

    singleExpression("= ${expression: Expression}") {

    }
}

class Block {
    @copy
    block("{\+${statements: OptionalStatementList}\-}") {

    }
}

@copy
class PropertyDeclaration {
    valDeclaration("${modifiers: OptionalModifierList} val ${declaration : VariableDeclaration} = ${expression : Expression}") {

    }

    varDeclaration("${modifiers: OptionalModifierList} var ${declaration : VariableDeclaration} = ${expression : Expression}") {

    }
}

@copy
class VariableDeclaration {
    declarationWithType("${identifier : SimpleIdentifier} : ${type : Type}") {

    }

    declarationWithoutType("${identifier : SimpleIdentifier}") {

    }
}

# Section: types
class Type {
@copy
    simpleUserType("${simpleUserType : SimpleUserType}") {

    }
}

class SimpleUserType {
    # intentionally simplified rule
    @copy
    primitiveType("${type : PRIMITIVE}") {

    }
}

# Section: statements
@copy
class OptionalStatementList {
    @weight(1)
    empty("") {

    }

    @weight(5)
    nonEmpty("${stmts: StatementList}") {

    }
}

@copy
@list(50)
class StatementList {
    @weight(1)
    single("${stmt: Statement}") {

    }

    @weight(5)
    multiple("${stmt: Statement}\n${rest: StatementList}") {

    }
}

@copy
class Statement {
    declaration("${decl: Declaration}") {

    }

    expression("${expr: Expression}") {

    }
}

# Section: expressions
@copy
class Expression {
    singleDisjunction("${disjunction : Disjunction}") {

    }
}

@copy
class Disjunction {
    @weight(3)
    singleConjunction("${conjunction : Conjunction}") {

    }

    @weight(1)
    twoConjunction("${left : Conjunction} || ${right : Conjunction}") {

    }
}

@copy
class Conjunction {
    @weight(3)
    singleEquality("${equality : Equality}") {

    }

    @weight(1)
    twoEquality("${left : Equality} && ${right : Equality}") {

    }
}

@copy
class Equality {
    @weight(3)
    singleComparison("${comp : Comparison}") {

    }

    @weight(1)
    twoComparison("${left : Comparison} ${eqOp : EqualityOperator} ${right : Comparison}") {

    }
}

@copy
class Comparison {
    @weight(3)
    singleGenericCallLikeComparison("${genCall : GenericCallLikeComparison}") {

    }

    @weight(1)
    twoGenericCallLikeComparison("${left : GenericCallLikeComparison} ${compOp : ComparisonOperator} ${right : GenericCallLikeComparison}") {

    }
}

@copy
class GenericCallLikeComparison {
    singleInfixFunctionCall("${funcCall : InfixFunctionCall}") {

    }
}

@copy
class InfixFunctionCall {
    additiveExpression("${addExpr : AdditiveExpression}") {

    }
}

@copy
@list(50)
class AdditiveExpression {
    @weight(1)
    singleMultiplicativeExpression("${mulExpr : MultiplicativeExpression}") {

    }

    @weight(3)
    multipleMultiplicativeExpression("${mulExpr : MultiplicativeExpression} ${addOp : AdditiveOperator} ${rest : AdditiveExpression}") {

    }
}

@copy
@list(50)
class MultiplicativeExpression {
    @weight(1)
    singlePrefixUnaryExpression("${pref : PrefixUnaryExpression}") {

    }
    @weight(3)
    multiplePrefixUnaryExpression("${pref : PrefixUnaryExpression} ${mulOp : MultiplicativeOperator} ${rest : MultiplicativeExpression}") {

    }
}

class PrefixUnaryExpression {
    @copy
    postfixUnaryExpression("${pref : UnaryPrefix}${post : PostfixUnaryExpression}") {

    }
}

class PostfixUnaryExpression {
    @copy
    primaryExpression("${primeExpr : PrimaryExpression}${post : UnarySuffix}") {

    }
}

@copy
class PrimaryExpression {
    parenthesizedExpression("(${expr : Expression})") {

    }

    simpleIdentifier("${identifier : SimpleIdentifier}") {

    }

    literalConstant("${lit : LiteralConstant}") {

    }
}

@copy
class LiteralConstant {
    booleanLiteral("${boolLit : BooleanLiteral}") {

    }

    integerLiteral("${intLit : IntegerLiteral}") {

    }

    longLiteral("${longLit : LongLiteral}") {

    }
}

@copy
class LongLiteral {
    integerLiteral1("${intLit : IntegerLiteral}l") {

    }

    integerLiteral2("${intLit : IntegerLiteral}L") {

    }
}

class UnarySuffix {
    no_suffix("") {

    }

    postfixUnaryOperator("${postOp : PostfixUnaryOperator}") {

    }
}

class UnaryPrefix {
    no_prefix("") {

    }

    prefixUnaryOperator("${prefOp : PrefixUnaryOperator}") {

    }
}

# Section: modifiers
@copy
class OptionalParameterModifierList {
    empty("") {

    }

    nonEmpty("${modifiers: ParameterModifierList}") {

    }
}

@copy
@list(5)
class ParameterModifierList {
    single("${modifier: ParameterModifier}") {

    }

    multiple("${modifier: ParameterModifier} ${rest: ParameterModifierList}") {

    }
}

@copy
class OptionalModifierList {
    @weight(1)
    empty("") {

    }

    @weight(3)
    nonEmpty("${modifiers: ModifierList}") {

    }
}

@copy
@list(5)
class ModifierList {
    single("${modifier: Modifier}") {

    }

    multiple("${modifier: Modifier} ${rest: ModifierList}") {

    }
}

@copy
class Modifier {
    classModifier("${modifier: ClassModifier}") {

    }

    memberModifier("${modifier: MemberModifier}") {

    }

    visibilityModifier("${modifier: VisibilityModifier}") {

    }

    functionModifier("${modifier: FunctionModifier}") {

    }

    propertyModifier("${modifier: PropertyModifier}") {

    }

    inheritanceModifier("${modifier: InheritanceModifier}") {

    }

    parameterModifier("${modifier: ParameterModifier}") {

    }

    platformModifier("${modifier: PlatformModifier}") {

    }
}

class ClassModifier("enum|sealed|annotation|data|inner");

class MemberModifier("override|lateinit");

class VisibilityModifier("public|private|internal|protected");

class FunctionModifier("tailrec|operator|infix|inline|external|suspend");

class PropertyModifier("const");

class InheritanceModifier("abstract|final|open");

class ParameterModifier("vararg|noinline|crossiline");

class PlatformModifier("expect|actual");

# Section: operators
class PrefixUnaryOperator("++|--");
class PostfixUnaryOperator("++|--");
class EqualityOperator("==|!=");
class ComparisonOperator(">|<|>=|<=");
class AdditiveOperator("+|-");
class MultiplicativeOperator("*|/|%");
class BooleanLiteral("true|false");

# Section: identifier
@copy
class SimpleIdentifier {
    identifier("${identifier : IDENTIFIER}") {

    }
    # not only identifier but keyword?
}

@count(1000)
class IDENTIFIER("([A-Za-z]|_)([A-Za-z]|_|[0-9]){0,5}");

class IntegerLiteral("[1-9][0-9_]{0,5}[0-9]|[0-9]");
class PRIMITIVE("Short|Int|Long|Boolean");
