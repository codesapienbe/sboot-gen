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

### 🏛️ **Generated Project Structure**
```
your-app/
├── src/main/java/com/example/yourapp/
│   ├── Application.java              # Main Spring Boot class
│   ├── config/
│   │   └── SecurityConfig.java       # Security configuration
│   ├── controller/
│   │   └── UserController.java       # REST controllers
│   ├── service/
│   │   └── UserService.java          # Business logic
│   ├── repository/
│   │   └── UserRepository.java       # Data access layer
│   ├── model/
│   │   └── User.java                 # JPA entities
│   ├── dto/
│   │   ├── UserResponse.java         # Response DTOs
│   │   ├── CreateUserRequest.java    # Request DTOs
│   │   └── UpdateUserRequest.java
│   ├── exception/
│   │   ├── GlobalExceptionHandler.java # Exception handling
│   │   ├── ResourceNotFoundException.java
│   │   └── ErrorResponse.java
│   └── util/                         # Utility classes
├── src/main/resources/
│   ├── application.yml               # Main configuration
│   ├── application-local.yml         # Local profile
│   ├── application-docker.yml        # Docker profile
│   ├── application-prod.yml          # Production profile
│   └── logback-spring.xml            # Logging configuration
├── src/test/java/                    # Test structure mirrors main
├── docs/
│   └── ai-coding-rules.md            # AI assistant guidelines
├── Dockerfile                        # Multi-stage Docker build
├── docker-compose.yml                # Local development stack
├── Makefile                          # Build and run commands
└── pom.xml                           # Maven configuration
```

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
sudo apt-get install spring-boot-cli maven docker.io curl git  # Ubuntu

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
```bash
# Create a modular monolith
sboot modulith my-awesome-app

# Create a microservice
sboot microservice user-service

# Create a traditional monolith
sboot monolith legacy-app

# Create an event-driven app
sboot eda-kafka event-processor
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
# Direct usage with arguments
sboot <architecture> <project-directory>

# Interactive mode (prompts for input)
sboot

# Examples
sboot modulith ecommerce-platform
sboot microservice payment-service
sboot monolith admin-portal
sboot eda-kafka event-processor
```

### Interactive Mode

When you run `sboot` without arguments, it enters interactive mode:

```bash
sboot
```

This will prompt you to:
1. **Choose an architecture** from the available options
2. **Enter a project directory name** (with validation)

The interactive mode provides:
- ✅ **Clear architecture descriptions**
- ✅ **Real-time input validation**
- ✅ **User-friendly error messages**
- ✅ **Guided setup process**

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

### **Usage Example**
```bash
# Create event-driven app
sboot eda-kafka event-processor

# Start with Docker (includes Kafka)
cd event-processor
make docker-up

# App will be available at localhost:8080
# Kafka broker at localhost:9092
# Kafka UI at localhost:9094
```

### **Key Components**

#### **Event Processing**
- **Event Producers**: Idempotent, transactional JSON event publishing
- **Event Consumers**: Batch processing with configurable concurrency
- **Event Handlers**: Business logic for event processing
- **Event Streams**: Kafka Streams for real-time event processing

#### **Reliability & Resilience**
- **Dead Letter Topics**: Automatic error event routing
- **Retry Mechanisms**: Configurable exponential backoff
- **Circuit Breakers**: Fault tolerance for downstream services
- **Health Monitoring**: Kafka connectivity and consumer lag monitoring

#### **Enterprise Features**
- **Security**: SASL/SSL authentication and encryption
- **Monitoring**: Metrics and observability integration
- **Performance**: Optimized batch sizes and compression
- **Exactly-Once Processing**: Transactional guarantees

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
