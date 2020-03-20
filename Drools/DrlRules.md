
## CREATING AND EXECUTING DRL RULES

https://access.redhat.com/documentation/en-us/red_hat_decision_manager/7.1/html/designing_a_decision_service_using_drl_rules/drl-rules-other-con

As an alternative to creating and managing DRL rules within the Decision Central interface, you can create DRL rule files in external standalone projects using Red Hat Developer Studio, Java objects, or Maven archetypes. These standalone projects can then be integrated as knowledge JAR (KJAR) dependencies in existing Red Hat Decision Manager projects in Decision Central. The DRL files in your standalone project must contain at minimum the required package specification, import lists, and rule definitions. Any other DRL components, such as global variables and functions, are optional. All data objects related to a DRL rule must be included with your standalone DRL project or deployment.

You can also use executable rule models in your Maven or Java projects to provide a Java-based representation of a rule set for execution at build time. The executable model is a more efficient alternative to the standard asset packaging in Red Hat Decision Manager and enables KIE containers and KIE bases to be created more quickly, especially when you have large lists of DRL (Drools Rule Language) files and other Red Hat Decision Manager assets.

6.1. Creating and executing DRL rules in Red Hat JBoss Developer Studio

6.2. Creating and executing DRL rules using Java

6.3. Creating and executing DRL rules using Maven

https://docs.jboss.org/drools/release/7.28.0.Final/drools-docs/html_single/index.html#executable-model-con_N&N-7.7

21.20. New and Noteworthy in Drools 7.7  
21.20.1. Executable rule models

## The Drools Executable Model is alive
Blog: Drools & jBPM Blog

https://www.businessprocessincubator.com/content/the-drools-executable-model-is-alive/


## Drools Tutorial - Getting started with the Drools Engine

http://www.mastertheboss.com/jboss-jbpm/drools/jboss-drools-tutorial

http://www.mastertheboss.com/jboss-jbpm/drools


