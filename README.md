# sboot-gen

This CLI tool transforms your Spring Boot development workflow, making it as efficient and user-friendly as modern frontend frameworks while maintaining the robustness and patterns.

<img width="300" height="300" alt="image" src="https://github.com/user-attachments/assets/4fe352aa-0ebd-4754-8839-59afb361b389" />

Just as a Swiss Army knife consolidates multiple essential tools into one compact, reliable instrument, sboot-gen consolidates all the repetitive coding tasks that Spring Boot developers face daily. Rather than manually creating entities, services, controllers, repositories, DTOs, and mappers—each requiring careful attention to boilerplate code and architectural patterns—developers can generate complete, production-ready modules with a single command.

---

## Complete Module Generation

<img width="2400" height="1600" alt="image" src="https://github.com/user-attachments/assets/b18c838f-632f-459d-ab20-e6201165a604" />

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

## Individual Component Generation

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

<img width="2400" height="1600" alt="image" src="https://github.com/user-attachments/assets/8f1c709e-d080-445d-86d2-03f48b461d45" />


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

## Conclusion

This UX/UI developer-friendly demonstration positions sboot-gen as an indispensable tool that embodies the Swiss Army knife philosophy—providing everything Spring Boot developers need in one elegant, powerful package. The combination of interactive demonstration, compelling visual evidence, and comprehensive documentation creates a persuasive case for adoption while showcasing the tool's professional quality and practical benefits.

The demonstration package successfully transforms a technical CLI tool into an approachable, desirable productivity enhancement that developers will want to integrate into their daily workflow. By emphasizing both immediate practical benefits and long-term architectural advantages, it appeals to developers, team leads, and technical decision-makers alike.

---

