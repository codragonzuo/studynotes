# 规则交换格式（Rule Interchange Format，RIF）

Rule Interchange Format (RIF)

Overview

The goal of RIF is to define a standard for exchanging rules among rule systems, in particular among Web rule engines. RIF focuses on exchange rather than defining a single one-fits-all rule language because, in contrast to other Semantic Web standards, such as RDF, OWL, and SPARQL, it was immediately clear that a single language would not cover all popular paradigms of using rules for knowledge representation and business modeling. Even rule exchange alone was quickly recognized to be a daunting task. Known rule systems fall into three broad categories: first-order, logic-programming, and action rules. These paradigms share little in the way of syntax and semantics. Moreover, there are large differences between systems even within the same paradigm.

The approach taken by the RIF Working Group is to design a family of languages, called dialects, with rigorously specified syntax and semantics. The family of RIF dialects is intended to be uniform and extensible. RIF uniformity means that dialects are expected to share as much as possible of the existing syntactic and semantic apparatus. Extensibility here means that it should be possible for motivated experts to define a new RIF dialect as a syntactic extension to an existing RIF dialect, with new elements corresponding to desired additional functionality. These new RIF dialects would be non-standard when defined, but might eventually become standards.


Standard RIF Dialects

The standard RIF dialects are Core, BLD and PRD. These dialects depend on an extensive list of datatypes with builtin functions and predicates on those datatypes.

Relations of various RIF dialects are shown in the following Venn diagram.[5]

DTB

Datatypes and Built-Ins (DTB) specifies a list of datatypes, built-in functions and built-in predicates expected to be supported by RIF dialects. Some of the datatypes are adapted from XML Schema Datatypes,[6] XPath functions[7] and rdf:PlainLiteral functions.[8]

Core

The Core dialect comprises a common subset of most rule dialect. RIF-Core is a subset of both RIF-BLD and RIF-PRD.

FLD

Framework for Logic Dialects (FLD) describes mechanisms for specifying the syntax and semantics of logic RIF dialects, including the RIF-BLD and RIF-Core, but not RIF-PRD which is not a logic-based RIF dialect.

BLD

The Basic Logic Dialect (BLD) adds features to the Core dialect that are not directly available such as: logic functions, equality in the then-part and named arguments. RIF BLD corresponds to positive datalogs, that is, logic programs without functions or negations.

RIF-BLD has a model-theoretic semantics.

The frame syntax of RIF BLD is based on F-logic, but RIF BLD doesn't have the non-monotonic reasoning features of F-logic.[9]

PRD

The Production Rules Dialect (PRD) can be used to model production rules. Features that are notably in PRD but not BLD include negation and retraction of facts (thus, PRD is not monotonic). PRD rules are order dependent, hence conflict resolution strategies are needed when multiple rules can be fired. The PRD specification defines one such resolution strategy based on forward chaining reasoning.

RIF-PRD has an operational semantics, whereas the condition formulas also have a model-theoretic semantics.

Example (Example 1.2 in [10])
