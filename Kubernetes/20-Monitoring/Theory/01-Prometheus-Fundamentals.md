# Prometheus Fundamentals

## Why Monitoring?

...

---

## What is Prometheus?

...

---

## Pull Model

diagram

---

## Architecture

diagram

---

## Components

Prometheus
Exporter
Alertmanager
Grafana

---

## Scraping

What is scraping?

How /metrics works

scrape_interval

---

## Jobs

Definition

Examples

---

## Targets

Definition

Target = IP:PORT/metrics

Examples

---

## Kubernetes Service Discovery

Deployment

↓

Pod

↓

Service

↓

EndpointSlice

↓

Target

↓

Prometheus

---

## Discovery Roles

role: pod

role: node

role: endpointslice

---

## Labels

Metric Name

+

Labels

=

Time Series

Important labels

job

instance

namespace

service

pod

node

Discovery labels

Metric labels

---

## Reading Metrics

How to read

up

How to read

scrape_duration_seconds

---

## Important Metrics

Prometheus

Node Exporter

kube-state-metrics

---

## Summary

Everything in one page
