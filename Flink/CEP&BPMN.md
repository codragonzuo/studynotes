
### BPM TT 08: CEP augmenting BPMS for agility

https://www.tibco.com/blog/2008/10/07/bpmi-tt-08-cep-augmenting-bpms-for-agility/

![](https://www.tibco.com/blog/wp-content/uploads/2008/10/tt08.gif)


## How does CEP fit into BPM and SOA environments?

https://www.tibco.com/blog/2010/03/04/how-does-cep-fit-into-bpm-and-soa-environments/

There were some customer discussions recently on the conceptual relationships between the CEP and BPM and SOA “software stacks”. This coincided with the announcement of the OMG-backed Event Processing Consortium being set up (alongside the merger of the SOA and BPM consortia), events which themselves can be interpreted as that event processing has some special role to play alongside BPM and SOA.

[Disclosure: note TIBCO is not a member of either the OMG’s EP or BPMSOA consortia – they seem to be focused on end-user rather than vendor participation – but is an OMG member and participant in standards development. We currently see the EPTS as the main advocacy group across vendors, academics, analysts and end-users, but will be monitoring the progress of the EP Consortium].

So here are a few simplistic patterns on how CEP (event processing) relates to BPM (processes) and SOA (services)…

CEP Pattern	Example	Diagram

### 1a. Standalone CEP
This is a bit of a misnomer – you don’t identify event patterns without some intent to use them, and at the very least such a use would be in a BAM type role displaying interesting correlations for some business person – who of course is engaged in some kind of business process, which may or may not be managed by BPM…

Monitor a production process to provide an “additional view” or dashboard for the process control manager.	cep-pattern-1a-standalone-cep

![](https://www.tibco.com/blog/wp-content/uploads/2010/03/cep-pattern-1a-standalone-cep.png)

### 1b. CEP enriching BPM processes and/or  SOA services.
This is the conventional view of CEP, detecting the complex events that are of interest to, and useful in, appropriate processes and services.

Complex events in these cases can be as straightforward as deducing that a deliverable has been completed, or some process truly initiated. Typically the CEP system is transforming source events into business events, for onward use in (the) business processes.

Identifying exception events in a business that need to handed to a workflow or case management system for resolution.	cep-pattern-1b-event-enrichment

![](https://www.tibco.com/blog/wp-content/uploads/2010/03/cep-pattern-1b-event-enrichment.png)

### 2a. CEP monitoring processes and services
This is where the sources of events are the managed processes and services themselves. This process and service monitoring is used to detect exceptions, disparities across systems, and system performance…

Note that effectively this pattern is a combination of patterns 1a and 1b above.

Detect when response times exceed some metrics and suggest corrective actions such as reallocating resources.	cep-pattern-2a-event-monitoring

![](https://www.tibco.com/blog/wp-content/uploads/2010/03/cep-pattern-2a-event-monitoring.png)

### 2b. CEP-based decisions for processes and services
This is where I need to make intelligent decisions for the process and service layers, using the CEP layer as a monitoring, shared decision management component.

Note that effectively this is a slight extension of pattern 2a above.

A BPMN “rule activity” sends a decision request to the CEP engine to get a valid decision for a process decision point; the CEP engine monitors the decisions made.	cep-pattern-2b-event-based-descisioning

![](https://www.tibco.com/blog/wp-content/uploads/2010/03/cep-pattern-2b-event-based-descisioning.png)

### 3a. Dynamic process and service control
This is where the events from processes and services, and external services, are combined to select which processes and services are relevant to use for the current context.

In effect, the CEP engine becomes the controlling agent for the business processes and service engine, handling for example dynamic process selection.

Note that this pattern is a further evolution of patterns 2a and 2b.

In a complex business process for ever-changing fulfillment problems, CEP-based rules determine which sub-processes are valid based on incoming information.	cep-pattern-3a-dynamic-control

![](https://www.tibco.com/blog/wp-content/uploads/2010/03/cep-pattern-3a-dynamic-control.png)

### 3b. Embedded processes and services within CEP

The final evolution of the above is when you argue that the functions of the BPM and SOA stacks can be subsumed into the CEP layer.

In reality this is usually only a partial subsumption, as otherwise the centralization of services into just 1 layer could be perceived as contrary to the very idea of SOA! So this covers things like event-based policy implementations being embedded as CEP rules rather than as external services, but alongside some external services such as an operational database. Indeed, one could argue that in this case the CEP event processing agents are themselves really part of the SOA layer, not the other way round!

A service gateway controlling access to existing services, but embedding decisions, service policies, and business rules.

![](https://www.tibco.com/blog/wp-content/uploads/2010/03/cep-pattern-3b-dynamic-processes-and-services.png)


