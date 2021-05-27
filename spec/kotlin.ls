use KeywordsStorage;

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
    withoutType("${modifiers: OptionalFunctionModifierList} fun ${name: SimpleIdentifier}
                    ${params: OptionalFunctionValueParameterList} ${body: FunctionBody}") {

    }

    @weight(2)
    withType("${modifiers: OptionalFunctionModifierList} fun ${name: SimpleIdentifier}
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
    @weight(5)
    block("${body: Block}") {

    }
    @weight(2)
    singleExpression("= ${expression: Expression}") {

    }
}

@copy
class Block {
    block("{\+${statements: OptionalStatementList}\-}") {

    }
}

@copy
class PropertyDeclaration {
    valDeclaration("${modifiers: OptionalModifierList} val ${declaration : SingleOrMultiVariableDeclaration} = ${expression : Expression}") {

    }

    varDeclaration("${modifiers: OptionalModifierList} var ${declaration : SingleOrMultiVariableDeclaration} = ${expression : Expression}") {

    }
}

@copy
class SingleOrMultiVariableDeclaration {
    single("${decl: VariableDeclaration}") {

    }

    multi("(${decls: VariableDeclarationList})") {

    }
}

@copy
class VariableDeclarationList {
    @weight(1)
    single("${varDecl: VariableDeclaration}") {

    }

    @weight(2)
    multi("${varDecl: VariableDeclaration}, ${rest: VariableDeclarationList}") {

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
@list(100)
class StatementList {
    @weight(1)
    single("${stmt: Statement}") {

    }

    @weight(5)
    multiple("${stmt: Statement}\n${rest: StatementList}") {

    }
}


class Statement {
    @weight(2)
    assigment("${assign: Assignment}") {

    }
    @weight(1)
    declaration("${decl: Declaration}") {

    }
    @weight(5)
    expression("${expr: Expression}") {

    }
    @weight(10)
    loopStatement("${stmt: LoopStatement}") {

    }
}

@copy
class LoopStatement {
    forStatement("${stmt: ForStatement}") {

    }

    whileStatement("${stmt: WhileStatement}") {

    }

    doWhileStatement("${stmt: DoWhileStatement}") {

    }
}

@copy
class ForStatement {
    @weight(1)
    withoutBody("for (${decl: SingleOrMultiVariableDeclaration} in ${expr: Expression})") {

    }

    @weight(3)
    withBody("for (${decl: SingleOrMultiVariableDeclaration} in ${expr: Expression}) ${body: ControlStructureBody}") {

    }
}

@copy
class WhileStatement {
    @weight(1)
    withoutBody("while (${expr: Expression});") {

    }

    @weight(3)
    withBody("while (${expr: Expression}) ${body: ControlStructureBody}") {

    }
}

@copy
class DoWhileStatement {
    @weight(1)
    withoutBody("do while (${expr: Expression})") {

    }

    @weight(3)
    withBody("do ${body: ControlStructureBody} while (${expr: Expression})") {

    }
}

@copy
class ControlStructureBody {
    block("${block: Block}") {

    }

    statement("${stmt: Statement}") {

    }
}

@copy
class Assignment {
    directAssign("${directlyAssignExpr: DirectlyAssignableExpression} = ${expr: Expression}") {

    }

    assignAndOp("${assignableExpr: AssignableExpression} ${assignAndOp: AssignmentAndOperator} ${expr: Expression}") {

    }
}

@copy
class DirectlyAssignableExpression {
    simpleIdent("${ident: SimpleIdentifier}") {

    }

    parenthesizedDirectlyAssignableExpression("(${expr: DirectlyAssignableExpression})") {

    }
}

@copy
class AssignableExpression {
    prefixUnaryExpression("${expr: PrefixUnaryExpression}") {

    }

    parenthesizedAssignableExpression("${expr: ParenthesizedAssignableExpression}") {

    }
}

@copy
class ParenthesizedAssignableExpression {
    assignableExpr("(${expr: AssignableExpression})") {

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

    ifExpression("${expr: IfExpression}") {

    }
}

@copy
class IfExpression {
    withoutElse("if (${cond: Expression}) ${then: IfBody}") {

    }

    withElse("if (${cond: Expression}) ${then: IfBody} else ${alt: IfBody}") {

    }
}

@copy
class IfBody {
    empty(";") {

    }

    nonEmpty("${body: ControlStructureBody}") {

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
class OptionalFunctionModifierList {
    @weight(1)
    empty("") {

    }

    @weight(3)
    nonEmpty("${modifiers: FunctionModifierList}") {

    }
}

@copy
class FunctionModifierList {
    single("${modifier: FunctionModifier}") {

    }

    multiple("${modifier: FunctionModifier} ${rest: FunctionModifierList}") {

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
    functionModifier("${modifier: FunctionModifier}") {

    }

    propertyModifier("${modifier: PropertyModifier}") {

    }

    parameterModifier("${modifier: ParameterModifier}") {

    }
}

class FunctionModifier("tailrec|operator|infix|inline|external|suspend");

class PropertyModifier("const");

class ParameterModifier("vararg|noinline|crossinline");


# Section: operators
class PrefixUnaryOperator("++|--");
class PostfixUnaryOperator("++|--");
class EqualityOperator("==|!=");
class ComparisonOperator(">|<|>=|<=");
class AdditiveOperator("+|-");
class MultiplicativeOperator("*|/|%");
class BooleanLiteral("true|false");

class AssignmentAndOperator {
    addAssignment("${op: AddAssignment}") {

    }

    subAssignment("${op: SubAssignment}") {

    }

    multAssignment("${op: MultAssignment}") {

    }

    divAssignment("${op: DivAssignment}") {

    }

    modAssignment("${op: ModAssignment}") {

    }
}

class AddAssignment("+=");
class SubAssignment("-=");
class MultAssignment("*=");
class DivAssignment("/=");
class ModAssignment("%=");

# Section: identifier
class SimpleIdentifier {
    syn name : String;

    grd not_keyword;

    identifier("${identifier : IDENTIFIER}") {
        loc keywords_storage = (KeywordsStorage:getInstance);
        this.name = identifier.str;
        this.not_keyword = (KeywordsStorage:isNotKeyword .keywords_storage identifier.str);
    }
}

@count(1000)
class IDENTIFIER("([A-Za-z]|_)([A-Za-z]|_|[0-9]){2,5}");

class IntegerLiteral("[1-9][0-9_]{0,5}[0-9]|[0-9]");
class PRIMITIVE("Short|Int|Long|Boolean");
