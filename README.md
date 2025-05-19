# Blockchain-Based Supply Chain Dispute Resolution

A decentralized system for managing and resolving disputes in supply chains using smart contracts on the Stacks blockchain.

## Overview

This project implements a comprehensive dispute resolution system for supply chains using Clarity smart contracts. The system provides transparent, immutable record-keeping and standardized processes for handling disputes between supply chain participants.

## Architecture

The system consists of five core smart contracts:

1. **Entity Verification Contract**: Validates and maintains records of legitimate supply chain participants.
2. **Transaction Recording Contract**: Documents commercial exchanges between parties.
3. **Dispute Registration Contract**: Allows parties to formally register claims of non-performance.
4. **Evidence Collection Contract**: Manages the submission and storage of supporting documentation.
5. **Resolution Contract**: Tracks the settlement process and outcomes of disputes.

## Smart Contracts

### Entity Verification Contract

Validates supply chain participants by storing and verifying their credentials. This ensures that only legitimate entities can participate in the system.

### Transaction Recording Contract

Records all commercial exchanges between verified entities. Each transaction includes details such as parties involved, goods/services exchanged, quantities, prices, and delivery terms.

### Dispute Registration Contract

Allows verified entities to register formal disputes when they believe a counterparty has failed to meet contractual obligations. The contract records the nature of the dispute, parties involved, and references to the original transaction.

### Evidence Collection Contract

Provides a structured way to submit and store evidence related to disputes. Evidence can include documents, images, or references to external data sources.

### Resolution Contract

Manages the dispute resolution process, including assignment of arbitrators, recording of decisions, and enforcement of outcomes.

## Getting Started

### Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet) - Development environment for Clarity smart contracts
- [Node.js](https://nodejs.org/) - Required for running tests

### Installation

1. Clone the repository:
