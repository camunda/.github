# Camunda

[Camunda](https://camunda.io) provides a scalable process automation and orchestration platform. It is available self-managed or on-demand as-a-service. Camunda brings powerful execution engines for BPMN processes and DMN decisions, paired with tools for collaborative modeling, operations, and analytics.

## Camunda Platform 8

The most recent version is [Camunda Platform 8](https://camunda.com/platform/). 

The core of Camunda Platform 8 is [source-available](https://camunda.com/legal/terms/cloud-terms-and-conditions/zeebe-license-overview-and-faq/); additional tools are free for non-production use. 

A free tier in [the Camunda SaaS offering](https://camunda.com/get-started) exists.

[Camunda Platform 8](https://github.com/camunda/camunda) is comprised of the following components:

* Zeebe - The cloud-native workflow and decision engine.
* Operate - Manage, monitor, and troubleshoot your processes through Operate.
* Optimize - Improve your processes by identifying constraints in your system with Optimize.
* Tasklist - Use Tasklist to complete tasks which need human input.
* Identity - Identity is the component within the Camunda 8 stack responsible for authentication and authorization.
* (The following components are part of Camunda 8, but are served as individual components / via individual repositories):
  * [Connectors](https://github.com/camunda-community-hub/camunda-8-connectors/) - Integrate external systems with reusable, pre-defined building blocks.
  * Console - Configure and deploy clusters in SaaS with Console.
  * Web Modeler - Collaborate and model processes, deploy and start new instances all without leaving Camunda Platform 8.
  * [Desktop Modeler](https://github.com/camunda/camunda-modeler) - Model BPMN and DMN on your local developer machine using files that are part of your normal version control.
  * [Camunda HELM Charts](https://github.com/camunda/camunda-platform-helm) - HELM Charts to set-up Camunda 8 Self-Managed in your k8s environment.

For releases and links to Self-Managed deployment and development options, visit our [Camunda Platform repo](https://github.com/camunda/camunda-platform).

## Get started and documentation

* [Getting started guides](https://docs.camunda.io/docs/guides/) - Use case getting started guides for onboarding to Camunda Platform 8.
* [Documentation](https://docs.camunda.io/) - Documentation for all components of Camunda Platform 8.
* [Camunda Academy](https://academy.camunda.com/) - Training content for Camunda Platform, BPMN, DMN, and more.

## Camunda's open source and source available projects and efforts

* [Camunda](https://github.com/camunda/camunda): The core Camunda components including Zeebe, Operate, Optimize, Tasklist, and Identity.
* [Connector SDK](https://github.com/camunda/connector-sdk): The development kit to create custom Connectors.
* [Desktop Modeler](https://github.com/camunda/camunda-modeler): An integrated modeling solution for BPMN, DMN, and Forms based on bpmn.io.
* [bpmn.io](https://github.com/bpmn-io): Web-based tooling for BPMN, DMN and Forms, see also https://bpmn.io/.
* [Camunda Platform 7](https://github.com/camunda/camunda-bpm-platform): The very successful predecessor of Camunda Platform 8, which is still under full development.
* [Camunda Community Hub](https://github.com/camunda-community-hub): Camunda's GitHub Organization for community contributed extensions and projects. 
