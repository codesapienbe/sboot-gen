# ☕️ sboot – Enterprise Spring Boot Generator

[![Version](https://img.shields.io/badge/version-2.0.0-blue.svg)](https://github.com/codesapienbe/sboot-gen)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Bash](https://img.shields.io/badge/bash-5.0+-yellow.svg)](https://www.gnu.org/software/bash/)

A professional, enterprise-grade Spring Boot project generator with comprehensive tooling, security, and production-ready configurations.

## ✨ Features

### 🏗️ **Architectures**
- **Modulith**: Domain-driven modular monolith with Spring Modulith
- **Microservice**: Standalone microservice with cloud config
- **Monolith**: Traditional layered monolithic application
- **EDA-Kafka**: Event-driven architecture with Kafka integration

### 🤖 **AI Assistant Integration**
- **Cursor**: Default AI assistant rules and conventions
- **Copilot**: GitHub Copilot specific guidelines
- **Gemini**: Google Gemini specific guidelines
- **Claude**: Anthropic Claude specific guidelines
- **Custom**: Environment variable configurable

### 🛠️ **Enterprise Tooling**
- **Spring Boot 3.2.0** with Java 17
- **Structured JSON logging** with Logstash encoder
- **RFC 7807 Problem Details** for better error handling
- **Spring Security** for authentication & authorization
- **Spring Cache** with Caffeine for performance
- **Flyway** for database migrations
- **Testcontainers** for integration testing

### 🧪 **Comprehensive Testing Stack**
- **JUnit 5** - Modern testing framework
- **Mockito** - Mocking and stubbing
- **Spring Boot Test** - Integration testing
- **Testcontainers** - Database integration tests
- **H2 Database** - In-memory testing database
- **Java Faker** - Test data generation
- **Maven Surefire/Failsafe** - Test execution plugins
- **JaCoCo** - Code coverage reporting

### 📦 **Core Dependencies**
- **Spring Boot Validation** - Bean validation
- **Spring Data JPA** - Data persistence
- **Jackson Databind** - JSON processing
- **Commons Lang 3** - Utility functions
- **Configuration Processor** - Metadata generation
- **H2/PostgreSQL** - Database support

### 🏛️ **Architecture-Specific Project Structures**

#### **Modulith Architecture** (`sboot modulith my-app`)
```
my-app/
├── src/main/java/com/example/myapp/
│   ├── Application.java              # @SpringBootApplication + @Modulith
│   ├── config/
│   │   └── SecurityConfig.java       # Multi-context security
│   ├── exception/                    # Shared exceptions
│   ├── util/                        # Shared utilities
│   ├── model/shared/                # Shared entities
│   │   └── User.java
│   ├── dto/shared/                  # Shared DTOs
│   ├── user/                        # User bounded context
│   │   ├── controller/UserController.java
│   │   ├── service/UserService.java
│   │   ├── repository/UserRepository.java
│   │   ├── model/UserDetails.java
│   │   ├── dto/User*.java
│   │   └── event/UserEvents.java
│   ├── order/                       # Order bounded context
│   │   ├── controller/OrderController.java
│   │   ├── service/OrderService.java
│   │   └── ...
│   └── inventory/                   # Inventory bounded context
│       ├── controller/InventoryController.java
│       ├── service/InventoryService.java
│       └── ...
├── docs/
│   └── ai-coding-rules.md
└── [docker-compose.yml, Dockerfile, etc.]
```

#### **Microservice Architecture** (`sboot microservice user-service`)
```
user-service/
├── src/main/java/com/example/userservice/
│   ├── Application.java              # @EnableDiscoveryClient
│   ├── config/
│   │   └── SecurityConfig.java       # JWT-based security
│   ├── controller/UserController.java
│   ├── service/UserService.java
│   ├── repository/UserRepository.java
│   ├── model/User.java
│   ├── dto/                         # Request/Response DTOs
│   ├── exception/                   # Exception handling
│   ├── util/                        # Utilities
│   ├── client/                      # Feign clients
│   ├── resilience/                  # Circuit breakers
│   └── health/                      # Health indicators
└── [docker-compose.yml, Dockerfile, etc.]
```

#### **Monolith Architecture** (`sboot monolith my-app`)
```
my-app/
├── src/main/java/com/example/myapp/
│   ├── Application.java              # @EnableScheduling + @EnableAsync
│   ├── config/
│   │   └── SecurityConfig.java       # Form-based login
│   ├── controller/                   # REST controllers
│   ├── service/                      # Business services
│   ├── repository/                   # Data repositories
│   ├── model/                        # JPA entities
│   ├── dto/                          # Data transfer objects
│   ├── exception/                    # Exception handling
│   ├── util/                         # Utility classes
│   ├── aspect/                       # AOP aspects
│   ├── domain/                       # Domain services
│   └── scheduler/                    # Scheduled tasks
└── [docker-compose.yml, Dockerfile, etc.]
```

#### **EDA-Kafka Architecture** (`sboot eda-kafka event-system`)
```
event-system/
├── shared/                           # Shared entities & DTOs
│   ├── src/main/java/io/github/codesapienbe/shared/
│   │   ├── User.java                 # Shared User entity
│   │   ├── Role.java                 # Shared Role entity
│   │   ├── Message.java              # Shared Message entity
│   │   └── Topic.java                # Shared Topic entity
│   └── pom.xml
├── user-srv/                         # JWT Authentication Service
│   ├── src/main/java/io/github/codesapienbe/
│   │   ├── Application.java          # @SpringBootApplication
│   │   ├── config/SecurityConfig.java # JWT configuration
│   │   ├── controller/AuthController.java # Login endpoints
│   │   ├── service/AuthService.java  # JWT token handling
│   │   ├── util/JwtUtils.java        # JWT utilities
│   │   └── model/User.java           # User entity
│   └── pom.xml
├── producer-srv/                     # Message Producer Service
│   ├── src/main/java/io/github/codesapienbe/
│   │   ├── Application.java          # @SpringBootApplication
│   │   ├── config/
│   │   │   ├── SecurityConfig.java   # JWT validation
│   │   │   └── KafkaConfig.java      # Producer configuration
│   │   ├── controller/ProducerController.java # REST endpoints
│   │   ├── service/ProducerService.java # Message production
│   │   └── model/                    # Producer models
│   └── pom.xml
├── consumer-srv/                     # Message Consumer Service
│   ├── src/main/java/io/github/codesapienbe/
│   │   ├── Application.java          # @EnableKafka
│   │   ├── config/
│   │   │   ├── SecurityConfig.java   # JWT validation
│   │   │   └── KafkaConfig.java      # Consumer configuration
│   │   ├── listener/MessageEventListener.java # Kafka listeners
│   │   ├── service/ConsumerService.java # Message processing
│   │   └── model/                    # Consumer models
│   └── pom.xml
├── docker-compose.yml                 # All services + Kafka + Zookeeper
└── Dockerfile                         # Shared Dockerfile for all services
```

### 📁 **Common Structure Elements**
All architectures include:
- **Multi-profile configurations** (`application.yml`, `*-local.yml`, `*-docker.yml`, `*-prod.yml`)
- **Structured logging** (`logback-spring.xml`)
- **Comprehensive testing** (JUnit 5, Mockito, Testcontainers, H2, Java Faker)
- **Docker support** (Multi-stage builds, docker-compose)
- **API documentation** (OpenAPI/Swagger)
- **Code quality tools** (Spotless, Checkstyle, JaCoCo)
- **AI assistant guidelines** (`docs/ai-coding-rules.md`)

### 🔧 **Code Quality & Security**
- **Spotless** - Automated code formatting (Google Java Style)
- **Checkstyle** - Code style enforcement
- **Maven Enforcer** - Dependency and version rules
- **OWASP Dependency Check** - Security vulnerability scanning
- **SpotBugs** - Static analysis for bugs
- **JaCoCo** - Test coverage reporting

### 🐳 **Containerization**
- **Multi-stage Docker builds** (~200MB optimized images)
- **Docker Compose** with PostgreSQL and health checks
- **Security hardening** (non-root user, minimal attack surface)
- **Health checks** and graceful shutdown

### 📊 **Observability**
- **Micrometer + Prometheus** metrics
- **Spring Boot Actuator** endpoints
- **Structured logging** with configurable levels
- **Distributed tracing** support

### 🧪 **Testing & CI/CD**
- **Unit & Integration tests** with JUnit 5
- **Testcontainers** for database testing
- **Makefile** with common development tasks
- **Git integration** and workflow automation

## 🚀 Quick Start

### Prerequisites
```bash
# Required tools
brew install spring-boot-cli maven docker curl git  # macOS
# or
sudo apt-get install maven docker.io curl git  # Ubuntu

# Install spring boot CLI with sdkman
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"


# Verify installations
spring --version
mvn --version
docker --version
git --version
```

### Installation
Choose one of the following methods:

#### 🚀 **Quick Install (Recommended)**
```bash
# One-liner installation - downloads to /tmp and installs automatically
curl -s https://raw.githubusercontent.com/codesapienbe/sboot-gen/main/sbootgen.sh | bash
```
**Safe & Secure**: Downloads to `/tmp` first, then installs to avoid permission issues.

#### 📦 **Manual Installation**
```bash
# Download and source directly
source <(curl -s https://raw.githubusercontent.com/codesapienbe/sboot-gen/main/sbootgen.sh)

# Or download locally first
curl -s https://raw.githubusercontent.com/codesapienbe/sboot-gen/main/sbootgen.sh -o ~/.sbootgen.sh
echo 'source ~/.sbootgen.sh' >> ~/.bashrc && source ~/.bashrc
```

#### 🛠️ **Development Setup**
```bash
# Clone repository for development
git clone https://github.com/codesapienbe/sboot-gen.git
cd sboot-gen
source sbootgen.sh
```

### Generate Your First Project

#### Interactive Mode (Recommended)
```bash
# Prompts for project name and package interactively
sboot modulith          # Choose architecture, enter project name & package
sboot microservice      # Choose architecture, enter project name & package
sboot monolith         # Choose architecture, enter project name & package
sboot eda-kafka        # Choose architecture, enter project name & package
```

#### Direct Mode
```bash
# Specify everything on command line
sboot modulith my-awesome-app
sboot microservice user-service
sboot monolith legacy-app
sboot eda-kafka event-processor
```

#### Interactive Example
```bash
$ sboot modulith
╔════════════════════════════════════════════════════════╗
║  ☕️  Interactive Project Setup                   ║
╚════════════════════════════════════════════════════════╝

Available architectures:
  modulith      - Domain-driven modular monolith
  microservice  - Standalone microservice
  monolith      - Traditional layered monolith
  eda-kafka     - Event-driven architecture with Kafka

Choose architecture (modulith/microservice/monolith/eda-kafka): modulith
Enter project directory name: my-awesome-app
Enter base package name (e.g., com.example.myapp): [press enter for default]

Using default package: io.github.codesapienbe.myawesomeapp

Creating modulith project in directory: my-awesome-app
Using package: io.github.codesapienbe.myawesomeapp
```

### Script Management
```bash
# Check script version
sboot --version

# Get help
sboot --help

# Update to latest version
sboot --update

# Interactive installation menu
sboot --install
```

## 🔧 Installation Details

### How It Works

The script supports multiple installation and execution modes:

#### **Method 1: Quick Install (`curl | bash`)**
```bash
curl -s https://raw.githubusercontent.com/codesapienbe/sboot-gen/main/sbootgen.sh | bash
```
- Downloads script to `/tmp` (safe temporary location)
- Executes installer from temp location
- Moves script to `~/.sbootgen.sh` after validation
- Adds sourcing to your shell profile (`~/.bashrc` or `~/.zshrc`)
- sboot becomes available in all future shell sessions

#### **Method 2: Source Directly**
```bash
source <(curl -s https://raw.githubusercontent.com/codesapienbe/sboot-gen/main/sbootgen.sh)
```
- Downloads and sources script directly
- Available only in current shell session
- No permanent installation

#### **Method 3: Interactive Install**
```bash
curl -s https://raw.githubusercontent.com/codesapienbe/sboot-gen/main/sbootgen.sh | bash
# Then choose installation method when prompted
```

### Installation Options

When running the script directly, you'll see an interactive menu:

1. **Install to shell profile** - Adds permanent sourcing to `~/.bashrc`/`~/.zshrc`
2. **Download locally** - Downloads to `~/.sbootgen.sh` and installs
3. **Session only** - Available only for current shell session
4. **Show manual commands** - Displays installation commands for manual setup

### Automatic Profile Detection

The script automatically detects your shell:
- **Bash**: Uses `~/.bashrc` or `~/.bash_profile`
- **Zsh**: Uses `~/.zshrc`
- **Custom**: Respects existing profile configurations

## 📋 Usage

### Command Syntax
```bash
# Interactive mode - prompts for architecture, project name, and package
sboot

# Interactive mode with pre-selected architecture - prompts for project name and package
sboot <architecture>

# Direct mode - specify everything on command line
sboot <architecture> <project-directory>

# Examples
sboot                                   # Interactive: choose everything
sboot modulith                        # Interactive: prompts for project name & package
sboot modulith ecommerce-platform     # Direct: uses default package
sboot microservice payment-service     # Direct: uses default package
sboot monolith admin-portal           # Direct: uses default package
sboot eda-kafka event-processor       # Direct: uses default package
```

### Interactive Mode

The generator supports multiple levels of interactivity:

#### Full Interactive Mode
```bash
sboot  # No arguments - prompts for everything
```

#### Architecture-Preselected Mode
```bash
sboot modulith     # Prompts for project name and package
sboot microservice # Prompts for project name and package
sboot monolith     # Prompts for project name and package
sboot eda-kafka    # Prompts for project name and package
```

#### What Gets Prompted

**Full Interactive Mode** (`sboot`):
1. **Choose an architecture** from available options
2. **Enter a project directory name** (with validation)
3. **Enter a base package name** (optional, defaults to `io.github.codesapienbe.<project-name>`)

**Architecture-Preselected Mode** (`sboot <architecture>`):
1. **Enter a project directory name** (with validation)
2. **Enter a base package name** (optional, defaults to `io.github.codesapienbe.<project-name>`)

#### Interactive Features
- ✅ **Clear architecture descriptions**
- ✅ **Real-time input validation**
- ✅ **Smart default package names**
- ✅ **Package name format validation**
- ✅ **User-friendly error messages**
- ✅ **Guided setup process**
- ✅ **Duplicate directory detection**

#### Package Name Generation
When you leave the package name empty, it automatically generates:
```
io.github.codesapienbe.<cleaned-project-name>
```

**Examples:**
- `my-awesome-app` → `io.github.codesapienbe.myawesomeapp`
- `UserManagement` → `io.github.codesapienbe.usermanagement`
- `payment_service` → `io.github.codesapienbe.paymentservice`
- `E-commerce_Platform!` → `io.github.codesapienbe.ecommerceplatform`

**Transformation Rules:**
- Converts to lowercase
- Removes special characters
- Keeps only alphanumeric characters
- Trims whitespace

### Available Architectures

| Architecture | Description | Use Case |
|-------------|-------------|----------|
| `modulith` | Domain-driven modular monolith | Complex business domains with bounded contexts |
| `microservice` | Standalone microservice | Independent deployable services |
| `monolith` | Traditional layered monolith | Simple applications, legacy modernization |
| `eda-kafka` | Event-driven architecture | Kafka-based event processing and streaming |

### Project Structure
```
my-app/
├── src/
│   ├── main/
│   │   ├── java/com/battmobility/myapp/
│   │   ├── resources/
│   │   │   ├── application.yml      # Multi-profile config
│   │   │   └── db/migration/        # Flyway migrations
│   │   └── docker/                  # Docker assets
│   └── test/
├── target/                          # Build output
├── Dockerfile                       # Multi-stage build
├── docker-compose.yml              # Local development
├── Makefile                        # Development tasks
├── pom.xml                         # Maven configuration
├── README.md                       # Project documentation
└── .gitignore                      # Git ignore rules
```

## 🏭 Development Workflow

Once generated, your project comes with a comprehensive Makefile:

```bash
cd my-app

# See all available commands
make help

# Build the project
make build

# Run locally with H2 database
make run

# Run with Docker (PostgreSQL)
make docker-up

# Run tests
make test

# Check code quality
make verify

# Format code
make format

# Security scan
make security-check

# Generate coverage report
make coverage
```

## ⚙️ Configuration Profiles

### Local Development (`local`)
- **Database**: H2 in-memory
- **Logging**: Console output
- **Debug**: Enabled for development
- **Auto DDL**: Create-drop

### Docker Development (`docker`)
- **Database**: PostgreSQL via Docker Compose
- **Connection pooling**: HikariCP
- **Health checks**: Enabled
- **Migration**: Flyway validation

### Production (`prod`)
- **Database**: External PostgreSQL
- **Security**: Environment-based secrets
- **Monitoring**: Full observability
- **Performance**: Optimized settings

## 🔒 Security Features

### Container Security
- **Non-root user** execution
- **Minimal base image** (Alpine Linux)
- **No shell access** in production
- **Health checks** for container orchestration

### Application Security
- **OWASP dependency scanning** in CI/CD
- **Spring Security** integration ready
- **Environment-based configuration**
- **Secure defaults** (no debug in prod)

### Code Security
- **Static analysis** with SpotBugs
- **Dependency vulnerability checks**
- **Code style enforcement**
- **Automated formatting**

## 📊 Monitoring & Observability

### Endpoints
- **Health**: `GET /actuator/health`
- **Info**: `GET /actuator/info`
- **Metrics**: `GET /actuator/metrics`
- **Prometheus**: `GET /actuator/prometheus`
- **Loggers**: `GET /actuator/loggers`

### Metrics
- **HTTP request metrics**
- **Database connection pools**
- **JVM memory and GC**
- **Custom business metrics**

### Logging
- **Structured JSON** output
- **Configurable levels** per package
- **File and console** appenders
- **Logback configuration**

## 🐳 Docker Configuration

### Multi-Stage Build
```dockerfile
# Builder stage (discarded after build)
FROM maven:3.9.5-eclipse-temurin-17-alpine AS builder

# Runtime stage (production image)
FROM eclipse-temurin:17-jre-alpine
```

### Image Optimization
- **Base image**: Eclipse Temurin JRE (~40MB)
- **Additional tools**: curl, tini (~20MB)
- **Application JAR**: Your app (~20MB)
- **Total size**: ~200MB (vs 800MB+ single-stage)

### Health Checks
```yaml
healthcheck:
  test: ["CMD-SHELL", "curl -f http://localhost:8080/actuator/health/liveness"]
  interval: 30s
  timeout: 3s
  retries: 3
  start-period: 60s
```

## 🧪 Testing Strategy

### Unit Tests
```bash
mvn test
```

### Integration Tests
```bash
mvn verify  # Includes Testcontainers
```

### Test Coverage
```bash
make coverage
# Opens target/site/jacoco/index.html
```

### Testcontainers Setup
- **PostgreSQL** containers for database tests
- **Automatic cleanup** after tests
- **Reusable configurations**

### Testing with H2 Database
```java
@SpringBootTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
class MyServiceTest {

    @Autowired
    private MyService myService;

    @Test
    void testBusinessLogic() {
        // Test with H2 in-memory database
        // Automatically configured for local profile
    }
}
```

### Test Data Generation with Java Faker
```java
@SpringBootTest
class MyEntityTest {

    @Autowired
    private TestEntityManager entityManager;

    private Faker faker = new Faker();

    @Test
    void testEntityCreation() {
        MyEntity entity = MyEntity.builder()
            .name(faker.name().fullName())
            .email(faker.internet().emailAddress())
            .phone(faker.phoneNumber().phoneNumber())
            .build();

        entityManager.persist(entity);
        // Test entity persistence
    }
}
```

## 🔧 Advanced Configuration

### Environment Variables
```bash
# Database
DB_HOST=localhost
DB_NAME=myapp
DB_USER=myuser
DB_PASS=mypass

# Application
SPRING_PROFILES_ACTIVE=prod
LOG_LEVEL=DEBUG

# JVM
JAVA_OPTS="-Xmx2g -Xms512m"
```

### Custom Dependencies
Edit `pom.xml` to add project-specific dependencies:
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-redis</artifactId>
</dependency>
```

### Custom Configuration
Add to `application.yml`:
```yaml
myapp:
  custom:
    setting: value
```

## 🚀 CI/CD Integration

### GitHub Actions Example
```yaml
name: CI/CD Pipeline

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-java@v3
        with:
          java-version: 17
          distribution: 'temurin'

      - name: Build
        run: make build

      - name: Test
        run: make test

      - name: Quality Check
        run: make verify

      - name: Security Scan
        run: make security-check

      - name: Docker Build
        run: docker build -t myapp .
```

### Jenkins Pipeline
```groovy
pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh 'make build'
            }
        }

        stage('Test') {
            steps {
                sh 'make test'
            }
        }

        stage('Quality') {
            steps {
                sh 'make verify'
            }
        }

        stage('Security') {
            steps {
                sh 'make security-check'
            }
        }

        stage('Docker') {
            steps {
                sh 'docker build -t myapp .'
            }
        }
    }
}
```

## 🛠️ Customization

### Adding New Architectures
1. Add to `SUPPORTED_ARCHITECTURES` array
2. Create `get_artifact_id()` case
3. Add `get_extra_dependencies()` case
4. Update documentation

### Modifying Dependencies
Update version constants at the top of the script:
```bash
readonly SPRING_BOOT_VERSION="3.3.0"
readonly JAVA_VERSION="21"
```

### Custom Templates
The script generates files from embedded templates. To customize:
1. Modify the heredoc strings in functions
2. Test with different architectures
3. Update documentation

## 📈 Performance Considerations

### Build Performance
- **Parallel builds**: `mvn -T 4 clean install`
- **Dependency caching**: `.mvn` directory
- **Incremental compilation**: Enabled by default

### Runtime Performance
- **G1GC**: Optimized for containers
- **Memory limits**: Configurable via `JAVA_OPTS`
- **Connection pooling**: HikariCP tuning
- **Caching**: Caffeine configuration

### Docker Performance
- **Layer caching**: Dependencies first
- **Multi-stage builds**: Discard build artifacts
- **Health checks**: Fast failure detection

## 🔍 Troubleshooting

### Common Issues

**"Spring Boot CLI not found"**
```bash
# Install Spring Boot CLI
brew install spring-boot-cli  # macOS
sdk install springboot        # SDKMAN
```

**"Directory exists"**
```bash
# Remove existing directory or choose different name
rm -rf existing-dir
sboot modulith new-project-name
```

**"Build failures"**
```bash
# Clean and rebuild
make clean
make build

# Check Java version
java -version  # Should be 17+
```

**"Docker issues"**
```bash
# Check Docker daemon
docker info

# Clean up containers
make docker-down-volumes
make docker-up
```

### Debug Mode
Enable debug logging:
```bash
export LOG_LEVEL=DEBUG
sboot modulith my-app
```

### Health Checks
```bash
# Check application health
curl http://localhost:8080/actuator/health

# Check database connectivity
curl http://localhost:8080/actuator/health/db
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Update documentation
6. Submit a pull request

### Development Setup
```bash
# Clone and setup
git clone https://github.com/codesapienbe/sboot-gen.git
cd sboot-gen

# Test changes
bash -n sbootgen.sh
source sbootgen.sh
sboot modulith test-app
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Spring Boot Team** for the amazing framework
- **Spring Modulith** for modular monolith support
- **OWASP** for security best practices
- **Docker** for containerization excellence

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/codesapienbe/sboot-gen/issues)
- **Discussions**: [GitHub Discussions](https://github.com/codesapienbe/sboot-gen/discussions)
- **Documentation**: [Spring Boot Docs](https://docs.spring.io/spring-boot/docs/current/reference/html/)

## 🔄 Script Features

### Version Management
- **Automatic Updates**: `sboot --update` downloads the latest version
- **Version Checking**: Background version checks with notifications
- **Safe Updates**: Validates downloads before installation

### Safety & Validation
- **System Resource Checks**: Validates disk space, memory, and Java version
- **Project Validation**: Ensures all generated files are correct
- **Backup Creation**: Automatically backs up existing directories
- **Error Recovery**: Comprehensive cleanup on failure

### Git Integration
- **Automatic Initialization**: Creates Git repository for new projects
- **Initial Commit**: Commits all generated files with descriptive message
- **Git Config**: Sets up basic Git configuration

### Logging & Debugging
- **Multiple Log Levels**: DEBUG, INFO, WARN, ERROR, SUCCESS
- **Colored Output**: Color-coded log messages for better readability
- **Debug Mode**: `LOG_LEVEL=DEBUG sboot ...` for detailed logging

### Enterprise Features
- **Comprehensive Testing**: Unit tests, integration tests, and coverage
- **Security Scanning**: OWASP dependency vulnerability checks
- **Code Quality**: Spotless formatting, Checkstyle, SpotBugs
- **Performance Monitoring**: Micrometer metrics and tracing
- **Production Ready**: Multi-profile configuration for all environments

## 🔧 Advanced Configuration

### Environment Variables
```bash
# Logging
export LOG_LEVEL=DEBUG  # Enable debug logging

# Script behavior
export CI=true  # Disable update checks in CI
```

### Custom Architectures
The script supports extending with new architectures by modifying:
1. `SUPPORTED_ARCHITECTURES` array
2. `get_artifact_id()` function
3. `get_extra_dependencies()` function
4. Architecture-specific validation in `validate_generated_project()`

### Integration with CI/CD
```yaml
# .github/workflows/build.yml
name: Build
on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Generate Project
        run: |
          source sbootgen.sh
          sboot monolith test-app
      - name: Build
        run: |
          cd test-app
          make build
      - name: Test
        run: |
          cd test-app
          make test
```

## 🛡️ Security Considerations

### Container Security
- Non-root user execution
- Minimal base images
- No shell access in production
- Health check validation

### Application Security
- OWASP dependency scanning
- Spring Security integration ready
- Environment-based secrets management
- Secure defaults (debug disabled in prod)

### Script Security
- Input validation and sanitization
- Safe file operations with temporary files (`/tmp` downloads)
- Command injection prevention
- Update validation with checksums
- No direct writes to permanent locations during initial download

## 📊 Performance & Reliability

### Build Performance
- Parallel Maven builds (`mvn -T 4`)
- Dependency caching
- Incremental compilation
- Optimized Docker layers

### Runtime Performance
- G1GC garbage collection
- Connection pooling (HikariCP)
- Caffeine caching
- Configurable JVM options

### Reliability Features
- Comprehensive error handling
- Automatic cleanup on failure
- Project validation
- Backup and recovery

## 🤝 Contributing

### Development Setup
```bash
# Clone and test
git clone https://github.com/codesapienbe/sboot-gen.git
cd sboot-gen

# Test changes
source sbootgen.sh
sboot monolith test-project

# Run validation
bash -n sbootgen.sh
```

### Code Style
- Follows Google Shell Style Guide
- Comprehensive error handling
- Clear function naming and documentation
- Modular design with single responsibilities

### Testing
- Test all architectures: `modulith`, `microservice`, `monolith`
- Verify generated projects build successfully
- Test Docker functionality
- Validate all generated files and configurations

## 📈 Changelog

### Version 0.0.1 (Current)
- Initial release with basic Spring Boot project generation
- Support for three architectures
- Docker and monitoring setup
- Basic tooling integration
- Modular, SOLID-compliant design
- Comprehensive validation and error handling
- Automatic repository initialization
- Auto-update capability
- Multi-level colored logging system
- Ensures generated projects are complete and correct
- Automatic backup of existing directories
- System resource validation
- JUnit 5, Mockito, Testcontainers, H2, Java Faker
- Validation, JPA, Jackson, Commons Lang, Config Processor
- AI Assistant Integration (Cursor, Copilot, Gemini, Claude)
- Complete Enterprise Project Structure with proper packages
- Production-ready classes: Security, Exception Handling, DTOs
- Structured Logging Configuration with Logback
- Comprehensive API Documentation with OpenAPI
- Smart Package Name Generation (io.github.codesapienbe.* defaults)
- Enhanced Interactive Mode with optional package naming
- **EDA-Kafka Microservices**: Four-service architecture (gateway, user-srv, producer-srv, consumer-srv)
- **JWT Authentication**: Cross-service authentication with role-based access
- **JSON Message Processing**: String keys, JSON values with Kafka
- **Docker Orchestration**: Complete multi-service setup with Kafka/Zookeeper/Zipkin/Redis
- **Circuit Breaker**: Resilience4j Circuit Breaker for microservice HTTP communication (not Kafka)
- **Distributed Tracing**: Zipkin integration for observability across all services
- **API Gateway**: Spring Cloud Gateway with rate limiting, JWT validation, and OAuth2
- **OAuth2/OpenID Connect**: Enterprise-grade authentication with authorization server
- **Service Discovery**: Eureka integration for dynamic service registration
- **Rate Limiting**: Redis-based request throttling and protection
- **GitHub Actions CI/CD**: Complete pipeline with build, test, security scan, and deployment
- **Cloud Deployment**: Ready-to-deploy configurations for AWS, Azure, and GCP


## 🎯 Roadmap

- **Plugin System**: Extensible architecture for custom generators
- **Template Engine**: Custom project templates
- **Cloud Integration**: AWS, GCP, Azure deployment templates
- **Database Options**: Multiple database support (MySQL, PostgreSQL, MongoDB, H2)
- **Frontend Integration**: React/Vue/Angular project generation
- **Kubernetes**: K8s deployment manifests
- **Monitoring Dashboards**: Grafana dashboards included

## 🙏 Acknowledgments

- **Spring Boot Team** for the excellent framework
- **Spring Modulith** for modular architecture support
- **OWASP** for security best practices
- **Docker Community** for containerization excellence
- **Open Source Community** for amazing tools and libraries

---

## 🎯 Quick Start for Developers

### **One-Command Installation**
```bash
curl -s https://raw.githubusercontent.com/codesapienbe/sboot-gen/main/sbootgen.sh | bash
```

### **Create Your First Project**
```bash
# Interactive mode (recommended for beginners)
sboot

# Or direct command
sboot modulith my-awesome-app

cd my-awesome-app
make build
make run
```

### **Available Everywhere**
Once installed, `sboot` is available in all your terminal sessions - no need to reinstall or source anything!

### **AI Assistant Configuration**
Configure which AI assistant rules to include:

```bash
# Set environment variable (defaults to 'cursor')
export AI_ASSISTANT=copilot  # cursor, copilot, gemini, claude

# Generate project with specific AI assistant rules
sboot modulith my-app

# The docs/ai-coding-rules.md will contain guidelines for your configured assistant
```

## 📦 Project Backups

Every successfully generated project automatically creates a timestamped ZIP backup:

### **Backup Features**
- **Automatic Creation**: Generated after successful project creation
- **Timestamped Archives**: `project_architecture_backup_YYYYMMDD_HHMMSS.zip`
- **Complete State**: Contains the entire initial generated project
- **Safe Storage**: Placed in the project directory for easy access

### **Backup Contents**
- All source code and configuration files
- Docker and Docker Compose configurations
- Documentation and build scripts
- Initial Git repository state
- Database migrations and schemas

### **Usage**
```bash
# After project creation
ls -la my-app/
# my-app_modulith_backup_20241022_143052.zip

# Extract backup if needed
unzip my-app_modulith_backup_20241022_143052.zip -d backup/
```

### **Why Backups Matter**
- **Recovery**: Restore to initial clean state anytime
- **Comparison**: Compare changes against original generation
- **Distribution**: Share pristine project state with teams
- **Audit**: Maintain records of generated configurations

## 🎯 Event-Driven Architecture (EDA-Kafka)

The `eda-kafka` architecture creates Kafka-based event-driven applications with comprehensive event streaming capabilities:

### **Kafka Integration**
- **Spring Kafka**: Full Kafka integration with Spring Boot
- **Event Producers**: JSON serialization with configurable producers
- **Event Consumers**: Batch processing with configurable consumers
- **Topic Management**: Auto-creation and management
- **Health Checks**: Kafka connectivity monitoring

### **Docker Environment**
- **Kafka Broker**: Confluent Platform Kafka 7.4.0
- **Zookeeper**: Cluster coordination service
- **Multi-Container**: PostgreSQL + Kafka + Zookeeper + App
- **Health Checks**: Service readiness validation

### **Comprehensive Configuration Profiles**

#### **Local Development**
```yaml
kafka:
  bootstrap-servers: localhost:9092
  producer:
    acks: all
    retries: 3
    enable-idempotence: true
  consumer:
    auto-offset-reset: earliest
    max-poll-records: 500
  listener:
    concurrency: 3
    ack-mode: batch

spring:
  kafka:
    producer:
      transaction-id-prefix: ${spring.application.name}-
    consumer:
      group-id: ${spring.application.name}
    streams:
      application-id: ${spring.application.name}-streams
```

#### **Docker Environment**
```yaml
kafka:
  bootstrap-servers: kafka:9092

# Same comprehensive Spring Kafka config as local
# with Docker-specific bootstrap servers
```

#### **Production Environment (Enterprise)**
```yaml
kafka:
  bootstrap-servers: ${KAFKA_BOOTSTRAP_SERVERS}
  producer:
    acks: all
    retries: 10
    compression-type: lz4
    delivery-timeout-ms: 120000
  consumer:
    enable-auto-commit: false
    isolation-level: read_committed
    max-poll-records: 1000

spring:
  kafka:
    security:
      protocol: ${KAFKA_SECURITY_PROTOCOL:SASL_SSL}
    properties:
      sasl.mechanism: ${KAFKA_SASL_MECHANISM:PLAIN}
      ssl.truststore.location: ${KAFKA_TRUSTSTORE_LOCATION}
    streams:
      properties:
        replication.factor: 3
        min.insync.replicas: 2
        processing.guarantee: exactly_once_v2

# Custom event processing config
app:
  kafka:
    topics:
      events: ${spring.application.name}-events
      dead-letter: ${spring.application.name}-events.DLT
    monitoring:
      enabled: true
    error-handling:
      dead-letter-enabled: true
      retry-enabled: true
```

### **Complete Usage Example**
```bash
# Create enterprise-grade microservices system
sboot eda-kafka enterprise-system

# Build and start all services
cd enterprise-system

# Build shared module first
cd shared && mvn clean install && cd ..

# Build and run all services with Docker
docker-compose up --build

# Services will be available at:
# API Gateway:                http://localhost:8083
# User Service (OAuth2/JWT):  http://localhost:8080
# Producer Service:           http://localhost:8081
# Consumer Service:           http://localhost:8082
# Zipkin (Tracing UI):        http://localhost:9411
# Redis (Rate Limiting):      localhost:6379
# Kafka:                      localhost:9092
```

### **Message Flow Demonstration**

#### **1. Get JWT Token**
```bash
# Login to get JWT token
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"producer","password":"producer123"}'

# Response: {"token":"eyJ...","type":"Bearer","expiresIn":"86400000"}
```

#### **2. Send Message via Producer Service**
```bash
# Send a message using the JWT token
curl -X POST http://localhost:8081/api/v1/producer/send \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer eyJ..." \
  -d '{
    "id": "msg-001",
    "content": "Hello from Producer Service!",
    "sender": "producer-service",
    "topic": "message-events",
    "timestamp": "2024-01-01T10:00:00",
    "type": "INFO"
  }'

# Response: {"status":"success","messageId":"msg-001"}
```

#### **3. Consumer Service Automatically Processes**
```bash
# Check consumer service logs - message is automatically processed
docker-compose logs consumer-srv

# Expected log: "Received message from topic message-events: key=msg-001, message=..."
# Expected log: "Message processed successfully: msg-001"
```

#### **4. Send Test Message**
```bash
# Use the built-in test endpoint
curl -X POST http://localhost:8081/api/v1/producer/test \
  -H "Authorization: Bearer eyJ..."

# This creates and sends a test message automatically
```

### **Service Endpoints**

#### **API Gateway (Port 8083) - Single Entry Point**
```bash
# Authentication endpoints (routed to user-service)
POST /api/v1/auth/login      # OAuth2 login
POST /api/v1/auth/validate   # JWT token validation
GET  /api/v1/auth/me         # Get current user

# Producer endpoints (routed to producer-service)
POST /api/v1/producer/send   # Send custom message (rate limited)
POST /api/v1/producer/test   # Send test message

# Consumer endpoints (routed to consumer-service)
GET  /api/v1/consumer/status # Consumer status

# Health and monitoring
GET  /actuator/health        # Gateway health
GET  /actuator/gateway       # Gateway routes
```

#### **Direct Service Access (For Development)**
- **User Service**: `http://localhost:8080` (OAuth2 Authorization Server)
- **Producer Service**: `http://localhost:8081` (Message Producer)
- **Consumer Service**: `http://localhost:8082` (Message Consumer)

#### **Observability Endpoints**
- **Zipkin UI**: `http://localhost:9411` (Distributed Tracing)
- **Health Checks**: `/actuator/health` on all services
- **Metrics**: `/actuator/metrics` on all services
- **Circuit Breakers**: `/actuator/health` (circuit breaker status)

### **Default Users**
- **admin/admin123**: ADMIN role (all services)
- **producer/producer123**: PRODUCER role (message sending)
- **consumer/consumer123**: CONSUMER role (message receiving)

## 🔄 **Circuit Breaker Protection**

### **Microservice Architecture**
The `--microservice` architecture includes Resilience4j Circuit Breaker for resilient communication with other services:

```yaml
resilience4j:
  circuitbreaker:
    instances:
      externalServiceCircuitBreaker:
        baseConfig: default
  retry:
    instances:
      externalServiceRetry:
        baseConfig: default
```

### **Circuit Breaker Features**
- **Failure Threshold**: Opens after 50% failure rate
- **Recovery Time**: 10-second wait before retrying
- **Monitoring**: Health endpoint shows circuit breaker status
- **Fallback Methods**: Graceful degradation when services fail

### **Why Not in EDA-Kafka?**
Kafka doesn't need circuit breakers because:
- **Built-in Retry**: Kafka producers have automatic retry mechanisms
- **Acknowledgment**: Consumers can handle message redelivery
- **Async Communication**: Event-driven architecture is naturally resilient
- **Circuit Breakers**: Are for synchronous HTTP calls between services

### **Usage in Microservice Architecture**
```java
@CircuitBreaker(name = "externalServiceCircuitBreaker", fallbackMethod = "fallback")
@Retry(name = "externalServiceRetry")
public String callExternalService() {
    // HTTP call to another microservice
    return restTemplate.getForObject("http://other-service/api", String.class);
}

public String fallback(Exception e) {
    return "Service temporarily unavailable";
}
```

## 🏗️ **Enterprise Architecture Features**

### **4-Tier Enterprise Architecture**
```
Internet → API Gateway (Security, Routing, Rate Limiting)
    ↓
Service Mesh → Microservices (Authentication, Business Logic)
    ↓
Event Streaming → Kafka + Zookeeper (Async Communication)
    ↓
Infrastructure → PostgreSQL + Redis + Zipkin (Data + Caching + Observability)
```

### **🔗 Distributed Tracing with Zipkin**
- **Spring Cloud Sleuth**: Automatic trace ID injection
- **Zipkin UI**: Visual trace analysis at `http://localhost:9411`
- **Cross-Service Tracing**: Follow requests across all services
- **Performance Monitoring**: Identify bottlenecks and slow calls

### **🚪 API Gateway (Spring Cloud Gateway)**
- **Single Entry Point**: All client requests through gateway
- **JWT Authentication**: Token validation at gateway level
- **Rate Limiting**: Redis-based request throttling
- **Load Balancing**: Service discovery integration
- **Request/Response Filtering**: Custom filters for security

### **🔐 OAuth2/OpenID Connect Security**
- **Authorization Server**: User service as OAuth2 provider
- **JWT Tokens**: Industry-standard token format
- **OpenID Connect**: Identity layer on OAuth2
- **Multi-Client Support**: Different apps with different scopes
- **Token Introspection**: Real-time token validation

### **🔍 Service Discovery & Registration**
- **Eureka Server**: Dynamic service registration
- **Load Balancing**: Client-side load distribution
- **Service Health**: Automatic health checking
- **Failover**: Automatic service switching

### **⚡ Rate Limiting & Protection**
- **Redis Backend**: Distributed rate limiting
- **User-Based Limits**: Per-user request throttling
- **Burst Capacity**: Allow traffic spikes
- **Graduated Limits**: Different limits per endpoint

### **📊 Observability & Monitoring**
- **Centralized Logging**: Structured logging across services
- **Metrics Collection**: Prometheus-compatible metrics
- **Health Checks**: Comprehensive service health monitoring
- **Dashboard Integration**: Grafana/Kibana ready

### **🏭 Production Operations**
- **Configuration Management**: Externalized config with profiles
- **Graceful Shutdown**: Proper service termination
- **Container Optimization**: Multi-stage Docker builds
- **Security Hardening**: Non-root containers, minimal images

## 🚀 **CI/CD Pipeline**

### **GitHub Actions Workflow**
The generated project includes a comprehensive CI/CD pipeline:

```yaml
# .github/workflows/ci-cd.yml
- Build & Test: Multi-service Maven builds
- Integration Tests: Kafka-based testing
- Security Scan: OWASP & Trivy vulnerability scanning
- Docker Build: Multi-stage container builds
- Cloud Deployment: AWS/Azure/GCP deployment options
```

### **Pipeline Stages**
1. **Build Shared Module** - Common entities and DTOs
2. **Build Services** - Parallel service builds
3. **Integration Tests** - Full-stack testing with Kafka
4. **Security Scan** - Dependency and container scanning
5. **Deploy** - Cloud-specific deployment (main branch only)

### **Deployment Triggers**
```bash
# Deploy to AWS
git commit -m "Deploy to AWS" --allow-empty
git push origin main

# Deploy to Azure
git commit -m "Deploy to Azure" --allow-empty
git push origin main

# Deploy to GCP
git commit -m "Deploy to GCP" --allow-empty
git push origin main
```

## ☁️ **Cloud Deployment Options**

### **Command Line Usage**
```bash
# Create project with cloud provider configuration
sboot --aws eda-kafka my-project
sboot --azure eda-kafka my-project
sboot --gcp eda-kafka my-project
```

### **AWS Configuration**
```yaml
spring:
  profiles: aws
  cloud:
    aws:
      region: us-east-1
  datasource:
    url: jdbc:postgresql://${DB_HOST}:5432/service_db
kafka:
  bootstrap-servers: ${KAFKA_BOOTSTRAP_SERVERS}
management:
  metrics:
    export:
      cloudwatch:
        enabled: true
```

### **Azure Configuration**
```yaml
spring:
  profiles: azure
  cloud:
    azure:
      credential:
        managed-identity-enabled: true
      keyvault:
        enabled: true
```

### **GCP Configuration**
```yaml
spring:
  profiles: gcp
  cloud:
    gcp:
      project-id: ${GCP_PROJECT_ID}
      credentials:
        location: classpath:gcp-credentials.json
```

### **Environment Variables**
Set these environment variables for cloud deployments:

#### **AWS**
```bash
export DB_HOST=your-rds-endpoint
export DB_USERNAME=your-db-user
export DB_PASSWORD=your-db-password
export KAFKA_BOOTSTRAP_SERVERS=your-msk-endpoint
```

#### **Azure**
```bash
export DB_HOST=your-postgres-server
export DB_USERNAME=your-db-user
export DB_PASSWORD=your-db-password
export KAFKA_BOOTSTRAP_SERVERS=your-event-hubs-connection
```

#### **GCP**
```bash
export GCP_PROJECT_ID=your-project-id
export DB_HOST=your-cloud-sql-instance
export DB_USERNAME=your-db-user
export DB_PASSWORD=your-db-password
export KAFKA_BOOTSTRAP_SERVERS=your-pubsub-connection
```

### **Docker Deployment**
All services include Docker support with multi-stage builds:
```dockerfile
# Build stage
FROM maven:3.9-eclipse-temurin-17 AS build
# ... build JAR

# Runtime stage
FROM eclipse-temurin:17-jre-alpine AS runtime
# ... run application
```

### **Cloud-Native Features**
- **Externalized Configuration**: Environment-based config
- **Cloud Databases**: PostgreSQL on cloud providers
- **Managed Kafka**: AWS MSK, Azure Event Hubs, GCP Pub/Sub
- **Monitoring**: Cloud-specific metrics export
- **Security**: Cloud IAM integration

### **Key Components**

#### **Microservices Architecture**
- **user-srv**: JWT authentication service (port 8080)
- **producer-srv**: Message publishing service (port 8081)
- **consumer-srv**: Message consumption service (port 8082)
- **shared**: Common entities and DTOs module

#### **Event Processing**
- **JSON Serialization**: String keys, JSON values
- **Event Producers**: RESTful message publishing
- **Event Consumers**: Kafka listeners with acknowledgment
- **Event Handlers**: Business logic for different message types

#### **Authentication & Security**
- **JWT Tokens**: Bearer token authentication across services
- **Role-based Access**: PRODUCER, CONSUMER, ADMIN roles
- **Token Validation**: Cross-service authentication
- **Secure Endpoints**: Protected APIs with method-level security

#### **Resilience & Reliability**
- **Circuit Breaker**: Resilience4j Circuit Breaker for inter-service calls
- **Retry Logic**: Automatic retry with exponential backoff
- **Fallback Methods**: Graceful degradation when services are down
- **Health Monitoring**: Circuit breaker status in actuator endpoints

#### **Infrastructure**
- **Apache Kafka**: Message broker with Zookeeper
- **Docker Compose**: Multi-service orchestration
- **Health Checks**: Service readiness validation
- **Load Balancing**: Service discovery ready

## 🧠 Smart & Safe Features

### **Intelligent System Validation**
- ✅ **Shell Compatibility**: Automatically detects and validates Bash/Zsh compatibility
- ✅ **Version Checking**: Validates Java, Maven, and other tool versions
- ✅ **Network Connectivity**: Verifies internet access for downloads and updates
- ✅ **Resource Monitoring**: Checks disk space (500MB+), memory (512MB+), and system health
- ✅ **Process Safety**: Prevents multiple simultaneous script executions
- ✅ **Dependency Validation**: Ensures all required tools are installed and functional

### **Self-Healing Capabilities**
- 🔧 **Automatic Issue Detection**: Identifies common configuration problems
- 🔧 **JAVA_HOME Setup**: Suggests and helps configure JAVA_HOME
- 🔧 **Permission Fixes**: Automatically fixes executable permissions on Maven wrappers
- 🔧 **Package Manager Detection**: Provides installation commands for missing tools
- 🔧 **Environment Optimization**: Applies performance optimizations automatically

### **Advanced Security**
- 🔒 **Permission Auditing**: Checks file permissions and warns about security risks
- 🔒 **Root User Detection**: Warns when running as root (not recommended)
- 🔒 **Environment Sanitization**: Audits suspicious environment variables
- 🔒 **Safe Downloads**: Downloads to `/tmp` first, validates, then installs
- 🔒 **Backup Recovery**: Creates backups before making system changes

### **Performance Optimizations**
- ⚡ **Download Caching**: Caches downloads for 24 hours to reduce network calls
- ⚡ **File Descriptor Limits**: Automatically increases ulimit for better performance
- ⚡ **Locale Optimization**: Sets consistent locale for predictable behavior
- ⚡ **Concurrent Safety**: Uses lock files to prevent resource conflicts

### **Enhanced Error Recovery**
- 🛟 **Comprehensive Error Messages**: Detailed error messages with actionable solutions
- 🛟 **Automatic Backups**: Creates timestamped backups before risky operations
- 🛟 **Graceful Degradation**: Continues with reduced functionality when possible
- 🛟 **Context-Aware Logging**: Logs include function context for better debugging

### **Enterprise-Ready Reliability**
- 🏢 **System Health Checks**: Comprehensive pre-flight validation
- 🏢 **Atomic Operations**: File operations are atomic to prevent corruption
- 🏢 **Resource Cleanup**: Automatic cleanup of temporary files and locks
- 🏢 **Cross-Platform Support**: Works across different Linux distributions and macOS
- 🏢 **Project Backups**: Automatic ZIP archives of generated projects
- 🏢 **Version Control**: Integrated Git repository initialization

---

**Created with ❤️ for enterprise Spring Boot development**

*Built by [CodeSapien](https://github.com/codesapienbe) | Version 2.0.0 | [GitHub](https://github.com/codesapienbe/sboot-gen)*
