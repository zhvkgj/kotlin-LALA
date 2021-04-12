# my first, initial step on the path to build kotlin LaLa spec
class KotlinFile {
    topLevelObject ("${declarations : OptionalTopLevelObjectList}") {

    }
}

class OptionalTopLevelObjectList {
    no_declarations("") {

    }

    @weight(100)
    declarations("${declarations : TopLevelObjectList}\n") {

    }
}

@list(100)
class TopLevelObjectList {
    @weight(1)
    single_declaration("${declaration : TopLevelObject}") {

    }

    @weight(3)
    multiple_declaration("${declaration : TopLevelObject}\n${rest : TopLevelObjectList}") {

    }
}

class TopLevelObject {
    declaration("${declaration : Declaration}") {

    }
}

class Declaration {
    propertyDeclaration("${propertyDeclaration : PropertyDeclaration}") {

    }
}

class PropertyDeclaration {
    declaration("var ${declaration : VariableDeclaration} = ${expression : Expression}") {

    }
}

class VariableDeclaration {
    declarationWithType("${identifier : SimpleIdentifier} : ${type : Type}") {

    }

    declarationWithoutType("${identifier : SimpleIdentifier}") {

    }
}

class Type {
    simpleUserType("${simpleUserType : SimpleUserType}") {

    }
}

class SimpleUserType {
    # intentionally simplified rule
    primitiveType("${type : PRIMITIVE}") {

    }
}

class Expression {
    singleDisjunction("${disjunction : Disjunction}") {

    }
}

class Disjunction {
    @weight(3)
    singleConjunction("${conjunction : Conjunction}") {

    }

    @weight(1)
    twoConjunction("${left : Conjunction} || ${right : Conjunction}") {

    }
}

class Conjunction {
    @weight(3)
    singleEquality("${equality : Equality}") {

    }

    @weight(1)
    twoEquality("${left : Equality} && ${right : Equality}") {

    }
}

class Equality {
    @weight(3)
    singleComparison("${comp : Comparison}") {

    }

    @weight(1)
    twoComparison("${left : Comparison} ${eqOp : EqualityOperator} ${right : Comparison}") {

    }
}

class Comparison {
    @weight(3)
    singleGenericCallLikeComparison("${genCall : GenericCallLikeComparison}") {

    }

    @weight(1)
    twoGenericCallLikeComparison("${left : GenericCallLikeComparison} ${compOp : ComparisonOperator} ${right : GenericCallLikeComparison}") {

    }
}

class GenericCallLikeComparison {
    singleInfixFunctionCall("${funcCall : InfixFunctionCall}") {

    }
}

class InfixFunctionCall {
    additiveExpression("${addExpr : AdditiveExpression}") {

    }
}

class AdditiveExpression {
    singleMultiplicativeExpression("${mulExpr : MultiplicativeExpression}") {

    }

    multipleMultiplicativeExpression("${mulExpr : MultiplicativeExpression} ${addOp : AdditiveOperator} ${rest : AdditiveExpression}") {

    }
}

class MultiplicativeExpression {
    singlePrefixUnaryExpression("${pref : PrefixUnaryExpression}") {

    }

    multiplePrefixUnaryExpression("${pref : PrefixUnaryExpression} ${mulOp : MultiplicativeOperator} ${rest : MultiplicativeExpression}") {

    }
}

class PrefixUnaryExpression {
    postfixUnaryExpression("${pref : UnaryPrefix}${post : PostfixUnaryExpression}") {

    }
}

class PostfixUnaryExpression {
    primaryExpression("${primeExpr : PrimaryExpression}${post : UnarySuffix}") {

    }
}

class PrimaryExpression {
    parenthesizedExpression("(${expr : Expression})") {

    }

    simpleIdentifier("${identifier : SimpleIdentifier}") {

    }

    literalConstant("${lit : LiteralConstant}") {

    }
}

class LiteralConstant {
    booleanLiteral("${boolLit : BooleanLiteral}") {

    }

    integerLiteral("${intLit : IntegerLiteral}") {

    }

    longLiteral("${longLit : LongLiteral}") {

    }
}

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

class SimpleIdentifier {
    identifier("${identifier : IDENTIFIER}") {

    }
    # not only identifier but keyword?
}

class PrefixUnaryOperator("++|--");
class PostfixUnaryOperator("++|--");
class EqualityOperator("==|!=");
class ComparisonOperator(">|<|>=|<=");
class AdditiveOperator("+|-");
class MultiplicativeOperator("*|/|%");
class BooleanLiteral("true|false");

@count(1000)
class IDENTIFIER("([A-Za-z]|_)([A-Za-z]|_|[0-9]){0,5}");

class IntegerLiteral("[1-9][0-9_]{0,5}[0-9]|[0-9]");
class PRIMITIVE("Short|Int|Long|Boolean");
