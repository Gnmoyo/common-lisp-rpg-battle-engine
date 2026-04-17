# Common Lisp RPG Battle Engine

> Object-oriented combat engine built in Common Lisp using CLOS, mixins, and polymorphic battle logic.

---

## Overview

This project implements a modular RPG battle engine in **Common Lisp** using the **Common Lisp Object System (CLOS)**.

It models interactions between players, monsters, and weapons using inheritance, generic functions, and mixins to create flexible and extensible combat behavior.

This project was developed from internship work and organized into a portfolio-ready repository to highlight software design and Common Lisp programming skills.

---

## Key Features

- Object-oriented design using CLOS  
- Generic functions and polymorphic behavior  
- Multiple inheritance and mixins  
- Extensible weapon and entity systems  
- Rule-based combat mechanics  
- Healing, regeneration, and leveling systems  
- Assertion-based test functions  

---

## Technologies Used

- Common Lisp  
- CLOS (Common Lisp Object System)  

---

## Core Components

### Beings
Base entities in the system, including players and monsters.

### Weapons
Base weapon types with extensions for:
- magical
- epic
- holy
- defensive

### Combat Logic
Combat behavior is implemented through generic functions such as:
- `hit`
- `compute-damage`
- `heal`

### Specialized Entities
The engine supports different entity-specific behaviors, including:
- ghosts
- zombies
- ogres
- undead enemies

---

## Advanced Concepts Demonstrated

- Multiple inheritance  
- Mixins for behavior composition  
- Method combinations  
- Dynamic dispatch  
- Rule-based system design  
- Test-oriented validation  

---

## Example Behaviors

- Ghosts can only be damaged by magical weapons  
- Zombies regenerate after attacks  
- Ogres transform into ghosts on defeat  
- Holy weapons deal increased damage to undead enemies  

---

## Project Structure

```text
.
├── src/         # Core battle engine implementation
├── docs/        # Design explanation
├── notes/       # Project context and reconstruction notes
├── examples/    # Example combat scenarios
└── README.md