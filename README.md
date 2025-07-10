# sboot-gen

This CLI tool transforms your Spring Boot development workflow, making it as efficient and user-friendly as modern frontend frameworks while maintaining the robustness and patterns.

---

## Complete Module Generation

```bash
# Generate a complete user module
sboot-gen module user
```

```bash
## Generate a product management module
sboot-gen module product_management
```

```bash
# Generate a nested module
sboot-gen module admin/user_management
```

Individual Component Generation

```bash
# Generate just a service
sboot-gen service user/UserService
```

```bash
# Generate just an entity
sboot-gen entity product/Product
```

```bash
# Generate just a controller
sboot-gen controller order/OrderController
```

```bash
# Generate just a DTO
sboot-gen dto payment/Payment
```

---

## Configuration

```bash
# Set default package name
sboot-gen-config package com.mycompany.myapp
```

```bash
# View current configuration
sboot-gen-config
```

---

## Features

- 🎯 User-Friendly CLI
-- Intuitive commands similar to Angular CLI
-- Clear error messages with usage examples
-- Progress indicators for module generation
-- Helpful emoji indicators for different operations

- 🚀 Component Generation
-- Complete modules with all necessary components
-- Individual components for granular control
-- Automatic directory creation
-- Proper package structure

- 📋 Generated Components
-- Entity classes with JPA annotations and builder pattern
-- Repository classes with common CRUD operations
-- Service classes with async CompletableFuture support
-- REST Controllers with full CRUD endpoints
-- DTOs with validation and multiple operation types
-- Mappers with interface and implementation
-- Custom exceptions with proper error handling
-- Loggers with emoji support and async logging

- ⚙️ Smart Naming
-- Automatic case conversion (snake_case ↔ PascalCase)
-- Package structure management
-- Consistent naming conventions

- 🔧 Customizable
-- Configurable package names
-- Adjustable directory structure
-- Template customization support

---
