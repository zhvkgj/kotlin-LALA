use KeywordsStorage;
use Symbol;
use SymbolTable;
use ModifiersList;

class KotlinFile {
    topLevelObject ("${decls : TopLevelObjectList}") {
        decls.symbols_before = (SymbolTable:empty);
    }
}

@copy
@list(100)
class TopLevelObjectList {
    inh symbols_before : SymbolTable;
    syn symbols_after : SymbolTable;

    @weight(1)
    single_declaration("${decl : TopLevelObject}") {
        this.symbols_after = decl.symbols_after;
    }

    @weight(3)
    multiple_declaration("${decl : TopLevelObject}\n${rest : TopLevelObjectList}") {
        rest.symbols_before = decl.symbols_after;
        this.symbols_after = rest.symbols_after;
    }
}

@copy
class TopLevelObject {
    inh symbols_before : SymbolTable;
    syn symbols_after : SymbolTable;

    declaration("${decl : Declaration}") {
        this.symbols_after = decl.symbols_after;
    }
}

# Section: declarations
@copy
class OptionalDeclarationList {
  inh symbols_before : SymbolTable;
  syn symbols_after : SymbolTable;

  empty("") {
      this.symbols_after = this.symbols_before;
  }

  @weight(100)
  decls("${decls : DeclarationList}\n") {
      this.symbols_after = decls.symbols_after;
  }
}

@copy
@unit
@list(10)
class DeclarationList {
  inh symbols_before : SymbolTable;
  syn symbols_after : SymbolTable;

  @weight(1)
  oneDecl("${decl : Declaration}") {
    this.symbols_after = decl.symbols_after;
  }

  @weight(3)
  multDecl("${decl : Declaration}\n${rest : DeclarationList}") {
    rest.symbols_before = decl.symbols_after;
    this.symbols_after = rest.symbols_after;
  }
}

@copy
class Declaration {
    inh symbols_before : SymbolTable;
    syn symbols_after : SymbolTable;

    @weight(1)
    propertyDeclaration("${propertyDecl : PropertyDeclaration}") {
        this.symbols_after = propertyDecl.symbols_after;
    }

    @weight(3)
    functionDeclaration("${functionDecl: FunctionDeclaration}") {
        this.symbols_after = (SymbolTable:put this.symbols_before functionDecl.symbol);
    }
}

@copy
class FunctionDeclaration {
    syn symbol : Symbol;
    inh symbols_before : SymbolTable;

    @weight(1)
    withoutType("${modifiers: OptionalFunctionModifierList} fun ${name: SimpleIdentifier}${params: OptionalFunctionValueParameterList} ${body: FunctionBody}\n") {
        modifiers.modifiers_before = (ModifiersList:getInstance);
        params.symbols_before = (SymbolTable:enterScope this.symbols_before);
        body.symbols_before = params.symbols_after;
        this.symbol = (Symbol:create name.name);
    }

    @weight(2)
    withType("${modifiers: OptionalFunctionModifierList} fun ${name: SimpleIdentifier}${params: OptionalFunctionValueParameterList} : ${type: Type} ${body: FunctionBody}\n") {
        modifiers.modifiers_before = (ModifiersList:getInstance);
        params.symbols_before = (SymbolTable:enterScope this.symbols_before);
        body.symbols_before = params.symbols_after;
        this.symbol = (Symbol:create name.name);
    }
}

@copy
class OptionalFunctionValueParameterList {
    inh symbols_before : SymbolTable;
    syn symbols_after : SymbolTable;

    @weight(1)
    emptyParameterList("()") {
        this.symbols_after = this.symbols_before;
    }

    @weight(2)
    nonEmptyParameterList("(${params: FunctionValueParameterList})") {
        params.symbols_before = this.symbols_before;
        this.symbols_after = params.symbols_after;
    }
}

@copy
@list(10)
class FunctionValueParameterList {
    inh symbols_before : SymbolTable;
    syn symbols_after : SymbolTable;

    @weight(1)
    singleParameter("${param: FunctionValueParameter}") {
        param.symbols_before = this.symbols_before;
        this.symbols_after = param.symbols_after;
    }

    @weight(3)
    multipleParameters("${param: FunctionValueParameter}, ${rest: FunctionValueParameterList}") {
        param.symbols_before = this.symbols_before;
        rest.symbols_before = param.symbols_after;
        this.symbols_after = rest.symbols_after;
    }
}

@copy
class FunctionValueParameter {
    inh symbols_before : SymbolTable;
    syn symbols_after : SymbolTable;

    withDefaultValue("${modifiers: OptionalParameterModifierList} ${param: Parameter} = ${expr : Expression}") {
        loc new_symbols = (SymbolTable:put this.symbols_before param.symbol);
        modifiers.modifiers_before = (ModifiersList:getInstance);
        expr.symbols_before = .new_symbols;
        expr.inside_loop = false;
        this.symbols_after = .new_symbols;
    }

    withoutDefaultValue("${modifiers: OptionalParameterModifierList} ${param: Parameter}") {
        modifiers.modifiers_before = (ModifiersList:getInstance);
        this.symbols_after = (SymbolTable:put this.symbols_before param.symbol);
    }
}

class Parameter {
    syn symbol : Symbol;

    inh symbols_before : SymbolTable;

    @copy
    parameter("${name: SimpleIdentifier} : ${type: Type}") {
        this.symbol = (Symbol:create name.name);
    }
}

@copy
@unit
class FunctionBody {
    inh symbols_before : SymbolTable;

    @weight(5)
    block("{\+${body: Block}\-}") {
        body.inside_loop = false;
    }

    @weight(2)
    singleExpression("= ${expr: Expression}") {
        expr.inside_loop = false;
    }
}

class Block {
    inh symbols_before : SymbolTable;
    inh inside_loop : boolean;

    @copy
    block("${decls: OptionalDeclarationList}${statements: OptionalStatementList}") {
        statements.symbols_before = decls.symbols_after;
    }
}

@copy
class PropertyDeclaration {
    inh symbols_before : SymbolTable;
    syn symbols_after : SymbolTable;

    valDeclaration("${modifiers: OptionalModifierList} val ${decl : SingleOrMultiVariableDeclaration} = ${expr : Expression}") {
        modifiers.modifiers_before = (ModifiersList:getInstance);
        expr.inside_loop = false;
        this.symbols_after = decl.symbols_after;
    }

    varDeclaration("${modifiers: OptionalModifierList} var ${decl : SingleOrMultiVariableDeclaration} = ${expr : Expression}") {
        modifiers.modifiers_before = (ModifiersList:getInstance);
        expr.inside_loop = false;
        this.symbols_after = decl.symbols_after;
    }
}

@copy
class SingleOrMultiVariableDeclaration {
    inh symbols_before : SymbolTable;
    syn symbols_after : SymbolTable;

    @weight(1)
    single("${decl: VariableDeclaration}") {
        this.symbols_after = (SymbolTable:put this.symbols_before decl.symbol);
    }

    @weight(3)
    multi("(${decls: VariableDeclarationList})") {
        this.symbols_after = decls.symbols_after;
    }
}

@copy
@unit
@list(5)
class VariableDeclarationList {
    inh symbols_before : SymbolTable;
    syn symbols_after : SymbolTable;

    @weight(3)
    single("${varDecl: VariableDeclaration}") {
        this.symbols_after = (SymbolTable:put this.symbols_before varDecl.symbol);
    }

    @weight(1)
    multi("${varDecl: VariableDeclaration}, ${rest: VariableDeclarationList}") {
        rest.symbols_before = (SymbolTable:put this.symbols_before varDecl.symbol);
        this.symbols_after = rest.symbols_after;
    }
}

@copy
class VariableDeclaration {
    syn symbol : Symbol;
    inh symbols_before : SymbolTable;

    declarationWithType("${identifier : SimpleIdentifier} : ${type : Type}") {
        this.symbol = (Symbol:create identifier.name);
    }

    declarationWithoutType("${identifier : SimpleIdentifier}") {
        this.symbol = (Symbol:create identifier.name);
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
    inh inside_loop : boolean;
    inh symbols_before : SymbolTable;

    empty("") {

    }

    @weight(100)
    nonEmpty("${stmts: StatementList}") {

    }
}

@copy
@list(100)
class StatementList {
    inh symbols_before : SymbolTable;
    inh inside_loop : boolean;

    @weight(1)
    single("${stmt: Statement}") {

    }

    @weight(5)
    multiple("${stmt: Statement}\n${rest: StatementList}") {
        rest.symbols_before = stmt.symbols_after;
    }
}

@copy
class Statement {
    inh symbols_before : SymbolTable;
    syn symbols_after : SymbolTable;
    inh inside_loop : boolean;

    @weight(2)
    assigment("${assign: Assignment}") {
        this.symbols_after = this.symbols_before;
    }

    @weight(5)
    expression("${expr: Expression}") {
        this.symbols_after = this.symbols_before;
    }

    @weight(5)
    loopStatement("${stmt: LoopStatement}") {
        this.symbols_after = this.symbols_before;
    }
}

@copy
class LoopStatement {
    inh symbols_before : SymbolTable;
    inh inside_loop : boolean;

    forStatement("${stmt: ForStatement}") {

    }

    whileStatement("${stmt: WhileStatement}") {

    }

    doWhileStatement("${stmt: DoWhileStatement}") {

    }
}

@copy
class ForStatement {
    inh symbols_before : SymbolTable;
    inh inside_loop : boolean;

    @weight(1)
    withoutBody("for (${decl: SingleOrMultiVariableDeclaration} in ${expr: Expression})") {
        decl.symbols_before = (SymbolTable:enterScope this.symbols_before);
        expr.symbols_before = decl.symbols_after;
        expr.inside_loop = false;
    }

    @weight(3)
    withBody("for (${decl: SingleOrMultiVariableDeclaration} in ${expr: Expression}) ${body: ControlStructureBody}") {
        decl.symbols_before = (SymbolTable:enterScope this.symbols_before);
        expr.symbols_before = decl.symbols_after;
        expr.inside_loop = false;
        body.symbols_before = (SymbolTable:enterScope decl.symbols_after);
        body.inside_loop = true;
    }
}

@copy
class WhileStatement {
    inh symbols_before : SymbolTable;
    inh inside_loop : boolean;

    @weight(1)
    withoutBody("while (${expr: Expression});") {
        expr.inside_loop = false;
    }

    @weight(3)
    withBody("while (${expr: Expression}) ${body: ControlStructureBody}") {
        body.inside_loop = true;
        expr.inside_loop = false;
    }
}

@copy
class DoWhileStatement {
    inh symbols_before : SymbolTable;
    inh inside_loop : boolean;

    @weight(1)
    withoutBody("do while (${expr: Expression})") {
        expr.inside_loop = false;
    }

    @weight(3)
    withBody("do ${body: ControlStructureBody} while (${expr: Expression})") {
        body.inside_loop = true;
        expr.inside_loop = false;
    }
}

@copy
class ControlStructureBody {
    inh symbols_before : SymbolTable;
    inh inside_loop : boolean;

    @weight(5)
    block("{\+${block: Block}\-}") {

    }

    @weight(1)
    statement("${stmt: Statement}") {

    }
}

@copy
class Assignment {
    inh symbols_before : SymbolTable;
    inh inside_loop : boolean;

    directAssign("${directlyAssignExpr: DirectlyAssignableExpression} = ${expr: Expression}") {
        expr.inside_loop = false;
    }

    assignAndOp("${assignableExpr: AssignableExpression} ${assignAndOp: AssignmentAndOperator} ${expr: Expression}") {
        expr.inside_loop = false;
    }
}

@copy
class DirectlyAssignableExpression {
    inh symbols_before : SymbolTable;

    @weight(3)
    simpleIdent("${ident: UseSimpleIdentifier}") {

    }

    @weight(1)
    parenthesizedDirectlyAssignableExpression("(${expr: DirectlyAssignableExpression})") {

    }
}

@copy
class AssignableExpression {
    inh symbols_before : SymbolTable;
    inh inside_loop : boolean;

    prefixUnaryExpression("${expr: PrefixUnaryExpression}") {
        expr.inside_loop = false;
    }

    parenthesizedAssignableExpression("(${expr: AssignableExpression})") {

    }
}

# Section: expressions
@copy
class Expression {
    inh symbols_before : SymbolTable;
    inh inside_loop : boolean;

    singleDisjunction("${disjunction : Disjunction}") {

    }
}

@copy
class Disjunction {
    inh symbols_before : SymbolTable;
    inh inside_loop : boolean;

    @weight(3)
    singleConjunction("${conjunction : Conjunction}") {

    }

    @weight(1)
    twoConjunction("${left : Conjunction} || ${right : Conjunction}") {

    }
}

@copy
class Conjunction {
    inh symbols_before : SymbolTable;
    inh inside_loop : boolean;

    @weight(3)
    singleEquality("${equality : Equality}") {

    }

    @weight(1)
    twoEquality("${left : Equality} && ${right : Equality}") {

    }
}

@copy
class Equality {
    inh symbols_before : SymbolTable;
    inh inside_loop : boolean;

    @weight(3)
    singleComparison("${comp : Comparison}") {

    }

    @weight(1)
    twoComparison("${left : Comparison} ${eqOp : EqualityOperator} ${right : Comparison}") {

    }
}

@copy
class Comparison {
    inh symbols_before : SymbolTable;
    inh inside_loop : boolean;

    @weight(3)
    singleGenericCallLikeComparison("${genCall : GenericCallLikeComparison}") {

    }

    @weight(1)
    twoGenericCallLikeComparison("${left : GenericCallLikeComparison} ${compOp : ComparisonOperator} ${right : GenericCallLikeComparison}") {

    }
}

@copy
class GenericCallLikeComparison {
    inh symbols_before : SymbolTable;
    inh inside_loop : boolean;

    singleInfixFunctionCall("${funcCall : InfixFunctionCall}") {

    }
}

@copy
class InfixFunctionCall {
    inh symbols_before : SymbolTable;
    inh inside_loop : boolean;

    additiveExpression("${addExpr : AdditiveExpression}") {

    }
}

@copy
@list(50)
class AdditiveExpression {
    inh symbols_before : SymbolTable;
    inh inside_loop : boolean;

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
    inh symbols_before : SymbolTable;
    inh inside_loop : boolean;

    @weight(1)
    singlePrefixUnaryExpression("${pref : PrefixUnaryExpression}") {

    }
    @weight(3)
    multiplePrefixUnaryExpression("${pref : PrefixUnaryExpression} ${mulOp : MultiplicativeOperator} ${rest : MultiplicativeExpression}") {

    }
}

class PrefixUnaryExpression {
    inh symbols_before : SymbolTable;
    inh inside_loop : boolean;

    @copy
    postfixUnaryExpression("${pref : UnaryPrefix}${post : PostfixUnaryExpression}") {

    }
}

class PostfixUnaryExpression {
    inh symbols_before : SymbolTable;
    inh inside_loop : boolean;

    @copy
    primaryExpression("${primeExpr : PrimaryExpression}${post : UnarySuffix}") {

    }
}

@copy
class PrimaryExpression {
    inh symbols_before : SymbolTable;
    inh inside_loop : boolean;

    parenthesizedExpression("(${expr : Expression})") {

    }

    simpleIdentifier("${identifier : UseSimpleIdentifier}") {

    }

    literalConstant("${lit : LiteralConstant}") {

    }

    ifExpression("${expr: IfExpression}") {

    }

    jumpExpression("${expr: JumpExpression}") {

    }
}

@copy
class JumpExpression {
    inh symbols_before : SymbolTable;
    inh inside_loop : boolean;

    grd possible;

    return_void("return") {
        this.possible = true;
    }

    return("return ${expr: Expression}") {
        this.possible = true;
    }

    break("break") {
        this.possible = this.inside_loop;
    }

    continue("continue") {
        this.possible = this.inside_loop;
    }
}

@copy
class IfExpression {
    inh symbols_before : SymbolTable;
    inh inside_loop : boolean;

    withoutElse("if (${cond: Expression}) ${then: IfBody}") {
        cond.inside_loop = false;
    }

    withElse("if (${cond: Expression}) ${then: IfBody} else ${alt: IfBody}") {
        cond.inside_loop = false;
    }
}

@copy
class IfBody {
    inh symbols_before : SymbolTable;
    inh inside_loop : boolean;

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
    inh modifiers_before : ModifiersList;
    syn modifiers_after : ModifiersList;

    empty("") {
        this.modifiers_after = this.modifiers_before;
    }

    nonEmpty("${modifiers: ParameterModifierList}") {
        this.modifiers_after = modifiers.modifiers_after;
    }
}

@copy
@list(5)
class ParameterModifierList {
    inh modifiers_before : ModifiersList;
    syn modifiers_after : ModifiersList;

    single("${modifier: ParameterModifier}") {
        this.modifiers_after = (ModifiersList:put this.modifiers_before modifier.name);
    }

    multiple("${modifier: ParameterModifier} ${rest: ParameterModifierList}") {
        rest.modifiers_before = (ModifiersList:put this.modifiers_before modifier.name);
        this.modifiers_after = rest.modifiers_after;
    }
}

@copy
class OptionalFunctionModifierList {
    inh modifiers_before : ModifiersList;
    syn modifiers_after : ModifiersList;

    @weight(1)
    empty("") {
        this.modifiers_after = this.modifiers_before;
    }

    @weight(3)
    nonEmpty("${modifiers: FunctionModifierList}") {
        this.modifiers_after = modifiers.modifiers_after;
    }
}

@copy
class FunctionModifierList {
    inh modifiers_before : ModifiersList;
    syn modifiers_after : ModifiersList;

    single("${modifier: FunctionModifier}") {
        this.modifiers_after = (ModifiersList:put this.modifiers_before modifier.name);
    }

    multiple("${modifier: FunctionModifier} ${rest: FunctionModifierList}") {
        rest.modifiers_before = (ModifiersList:put this.modifiers_before modifier.name);
        this.modifiers_after = rest.modifiers_after;
    }
}

@copy
class OptionalModifierList {
    inh modifiers_before : ModifiersList;
    syn modifiers_after : ModifiersList;

    @weight(1)
    empty("") {
        this.modifiers_after = this.modifiers_before;
    }

    @weight(3)
    nonEmpty("${modifiers: ModifierList}") {
        this.modifiers_after = modifiers.modifiers_after;
    }
}

@copy
@list(5)
class ModifierList {
    inh modifiers_before : ModifiersList;
    syn modifiers_after : ModifiersList;

    single("${modifier: Modifier}") {
        this.modifiers_after = (ModifiersList:put this.modifiers_before modifier.name);
    }

    multiple("${modifier: Modifier} ${rest: ModifierList}") {
        rest.modifiers_before = (ModifiersList:put this.modifiers_before modifier.name);
        this.modifiers_after = rest.modifiers_after;
    }
}

@copy
class Modifier {
    inh modifiers_before : ModifiersList;
    syn name : String;

    grd modifier_unique;

    functionModifier("${modifier: FunctionModifierName}") {
        this.name = modifier.str;
        this.modifier_unique = (ModifiersList:notContains this.modifiers_before modifier.str);
    }

    propertyModifier("${modifier: PropertyModifierName}") {
        this.name = modifier.str;
        this.modifier_unique = (ModifiersList:notContains this.modifiers_before modifier.str);
    }

    parameterModifier("${modifier: ParameterModifierName}") {
        this.name = modifier.str;
        this.modifier_unique = (ModifiersList:notContains this.modifiers_before modifier.str);
    }
}

class FunctionModifier {
    inh modifiers_before : ModifiersList;
    syn name : String;

    grd modifier_unique;

    functionModifier("${modifier: FunctionModifierName}") {
        this.name = modifier.str;
        this.modifier_unique = (ModifiersList:notContains this.modifiers_before modifier.str);
    }
}

class ParameterModifier {
    inh modifiers_before : ModifiersList;
    syn name : String;

    grd modifier_unique;

    parameterModifier("${modifier: ParameterModifierName}") {
        this.name = modifier.str;
        this.modifier_unique = (ModifiersList:notContains this.modifiers_before modifier.str);
    }
}

class FunctionModifierName("tailrec|operator|infix|inline|external|suspend");

class PropertyModifierName("const");

class ParameterModifierName("vararg|noinline|crossinline");


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
    inh symbols_before : SymbolTable;

    grd not_keyword;
    grd name_unique;

    identifier("${identifier : IDENTIFIER}") {
        loc keywords_storage = (KeywordsStorage:getInstance);
        this.name = identifier.str;
        this.not_keyword = (KeywordsStorage:isNotKeyword .keywords_storage identifier.str);
        this.name_unique = (SymbolTable:mayDefine this.symbols_before identifier.str);
    }
}

class UseSimpleIdentifier {
    inh symbols_before : SymbolTable;
    syn symbol : Symbol;

    useIdentifier(SymbolTable:visibleIdentifiers this.symbols_before) : String {
        this.symbol = (SymbolTable:get this.symbols_before $);
    }
}

@count(1000)
class IDENTIFIER("([A-Za-z]|_)([A-Za-z]|_|[0-9]){2,5}");

class IntegerLiteral("[1-9][0-9_]{0,5}[0-9]|[0-9]");
class PRIMITIVE("Short|Int|Long|Boolean");
