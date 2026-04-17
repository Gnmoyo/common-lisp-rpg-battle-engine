# Design Overview

## Overview

This project implements a modular RPG-style battle engine in **Common Lisp** using the **Common Lisp Object System (CLOS)**.

The system models interactions between:
- players
- monsters
- weapons
- special combat behaviors

The design focuses on extensibility, allowing new weapon types, enemy behaviors, and combat rules to be added with minimal changes to the existing code.

---

## Core Design Concepts

### 1. Object-Oriented Modeling with CLOS
The project uses classes and inheritance to represent:
- weapons
- beings
- players
- monsters
- specialized entities such as ghosts, zombies, and ogres

### 2. Generic Functions and Polymorphism
Combat behavior is implemented using generic functions such as:
- `hit`
- `compute-damage`
- `heal`

This allows behavior to change depending on:
- attacker type
- defender type
- weapon type
- special conditions

### 3. Mixins and Multiple Inheritance
The design uses mixins to compose behavior:
- `magical-mixin`
- `epic-mixin`
- `holy-mixin`
- `defensive-mixin`
- `ghost-inside-mixin`

This makes it possible to create flexible combinations such as:
- magical weapons
- epic weapons
- holy weapons
- entities with layered behaviors

### 4. Rule-Based Combat Logic
The combat system includes special rules such as:
- ghosts can only be damaged by magical weapons
- zombies regenerate health
- ogres transform into ghosts after defeat
- holy weapons deal extra damage to undead enemies

These rules demonstrate dynamic dispatch and extensible gameplay logic.

### 5. Testing and Validation
The project includes assertion-based test functions to verify combat behavior and edge cases, including:
- defensive weapons
- magical weapons against ghosts
- hitting ogres
- hitting zombies

This helps validate correctness and maintain system behavior as complexity increases.