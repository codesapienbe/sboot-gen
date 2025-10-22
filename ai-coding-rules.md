# AI Code Assistant Rules and Conventions for Java + Spring Boot Projects

## Core Development Principles

### Language and Framework Standards
- **Java Version**: Use Java 17 or 21 LTS versions
- **Spring Boot Version**: Use the latest stable version (3.x+)
- **Build Tool**: Prefer Maven 3.6.3+ over Gradle, unless project specifically requires Gradle
- **Dependency Management**: Use Spring Boot Starters for consistent dependency management
- **Code Style**: Follow Google Java Style Guide or similar established conventions

### Project Structure and Architecture
```
src/
├── main/
│   ├── java/
│   │   └── com/yourcompany/yourapp/
│   │       ├── Application.java (Main class)
│   │       ├── config/           (Configuration classes)
│   │       ├── controller/       (REST controllers)
│   │       ├── service/          (Business logic)
│   │       ├── repository/       (Data access layer)
│   │       ├── model/           (JPA entities)
│   │       ├── dto/             (Data Transfer Objects)
│   │       ├── exception/       (Custom exceptions)
│   │       └── util/            (Utility classes)
│   └── resources/
│       ├── application.yml       (Main configuration)
│       ├── application-{env}.yml (Environment configs)
│       └── logback-spring.xml   (Logging configuration)
└── test/
    └── java/                    (Test classes mirror main structure)
```

## Spring Boot Best Practices

### Configuration Management
- **Externalize Configuration**: Use `application.yml` over `application.properties`
- **Environment Profiles**: Create separate profiles for dev, staging, and production
- **Property Binding**: Use `@ConfigurationProperties` for complex configurations
- **Sensitive Data**: Never hardcode secrets; use environment variables or Spring Cloud Config
- **Config Structure**:
```yaml
# application.yml
spring:
  application:
    name: your-application
  profiles:
    active: ${SPRING_PROFILES_ACTIVE:dev}
  datasource:
    url: ${DATABASE_URL:jdbc:h2:mem:testdb}
    username: ${DATABASE_USERNAME:sa}
    password: ${DATABASE_PASSWORD:password}

server:
  port: ${SERVER_PORT:8080}
  
management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics,prometheus
```

### Dependency Injection
- **Constructor Injection**: Always prefer constructor injection over field injection
- **Final Fields**: Mark injected dependencies as `final`
- **Avoid @Autowired**: Use constructor injection instead of `@Autowired` annotation
```java
@Service
public class UserService {
    private final UserRepository userRepository;
    private final EmailService emailService;
    
    public UserService(UserRepository userRepository, EmailService emailService) {
        this.userRepository = userRepository;
        this.emailService = emailService;
    }
}
```

### REST API Design
- **HTTP Methods**: Use correct HTTP verbs (GET, POST, PUT, DELETE, PATCH)
- **HTTP Status Codes**: Return appropriate status codes (200, 201, 400, 404, 500, etc.)
- **Resource Naming**: Use plural nouns for collections (`/users`, not `/user`)
- **URL Structure**: Follow RESTful conventions
  - `GET /api/v1/users` - Get all users
  - `GET /api/v1/users/{id}` - Get specific user
  - `POST /api/v1/users` - Create user
  - `PUT /api/v1/users/{id}` - Update user
  - `DELETE /api/v1/users/{id}` - Delete user
- **Content Type**: Default to JSON (`application/json`)
- **API Versioning**: Use URL path versioning (`/api/v1/`)

### Data Transfer Objects (DTOs)
- **Always Use DTOs**: Never expose JPA entities directly in REST APIs
- **Separate Request/Response**: Create separate DTOs for requests and responses
- **Validation**: Apply Bean Validation annotations on DTOs
```java
public class CreateUserRequest {
    @NotBlank(message = "Username is required")
    @Size(min = 3, max = 50, message = "Username must be between 3 and 50 characters")
    private String username;
    
    @Email(message = "Email should be valid")
    @NotBlank(message = "Email is required")
    private String email;
    
    // constructors, getters, setters
}
```

### Exception Handling
- **Global Exception Handling**: Use `@ControllerAdvice` for centralized exception handling
- **Custom Exceptions**: Create meaningful custom exceptions
- **Error Responses**: Return consistent error response structure
- **Logging**: Log exceptions appropriately
```java
@RestControllerAdvice
public class GlobalExceptionHandler {
    
    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleResourceNotFound(ResourceNotFoundException ex) {
        ErrorResponse error = ErrorResponse.builder()
            .status(HttpStatus.NOT_FOUND.value())
            .message(ex.getMessage())
            .timestamp(LocalDateTime.now())
            .build();
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(error);
    }
}
```

### Database and JPA
- **Repository Pattern**: Use Spring Data JPA repositories
- **Entity Relationships**: Be careful with bidirectional relationships and lazy loading
- **Database Migrations**: Use Flyway or Liquibase for database versioning
- **Connection Pooling**: Configure HikariCP properly
- **Query Optimization**: Use `@Query` for complex queries, avoid N+1 problems
```java
@Entity
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, unique = true)
    private String username;
    
    @Column(nullable = false)
    private String email;
    
    // Use proper fetch types
    @OneToMany(mappedBy = "user", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private List<Order> orders = new ArrayList<>();
}
```

## Security Best Practices

### Spring Security Configuration
- **HTTPS Only**: Force HTTPS in production environments
- **Authentication**: Implement proper authentication (JWT, OAuth2, etc.)
- **Authorization**: Use method-level security with `@PreAuthorize`
- **CSRF Protection**: Enable CSRF for web applications, disable for stateless APIs
- **CORS Configuration**: Configure CORS properly for frontend integration
```java
@Configuration
@EnableWebSecurity
@EnableMethodSecurity
public class SecurityConfig {
    
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable()) // For stateless APIs
            .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/v1/auth/**").permitAll()
                .requestMatchers("/actuator/health").permitAll()
                .anyRequest().authenticated()
            );
        return http.build();
    }
}
```

## Testing Best Practices

### Test Structure
- **Test Pyramid**: Write more unit tests, fewer integration tests
- **Naming Convention**: Use descriptive test method names (`shouldReturnUserWhenValidIdProvided`)
- **AAA Pattern**: Arrange, Act, Assert structure
- **Test Data**: Use test data builders or factories

### JUnit 5 and Mockito
- **Annotations**: Use `@ExtendWith(MockitoExtension.class)` for JUnit 5
- **Mock Creation**: Use `@Mock` and `@InjectMocks` annotations
- **Verification**: Verify interactions with `verify()`
- **Stubbing**: Use `when().thenReturn()` for method stubbing
```java
@ExtendWith(MockitoExtension.class)
class UserServiceTest {
    
    @Mock
    private UserRepository userRepository;
    
    @InjectMocks
    private UserService userService;
    
    @Test
    void shouldReturnUserWhenValidIdProvided() {
        // Arrange
        Long userId = 1L;
        User expectedUser = new User(userId, "testuser", "test@example.com");
        when(userRepository.findById(userId)).thenReturn(Optional.of(expectedUser));
        
        // Act
        User actualUser = userService.findById(userId);
        
        // Assert
        assertThat(actualUser).isEqualTo(expectedUser);
        verify(userRepository, times(1)).findById(userId);
    }
}
```

### Spring Boot Test Annotations
- **@SpringBootTest**: For integration tests
- **@WebMvcTest**: For testing web layer only
- **@DataJpaTest**: For testing JPA repositories
- **@TestConfiguration**: For test-specific configurations

## Code Quality and Clean Code

### Naming Conventions
- **Classes**: PascalCase (`UserService`, `OrderController`)
- **Methods**: camelCase (`findUserById`, `calculateTotalAmount`)
- **Variables**: camelCase (`userId`, `totalAmount`)
- **Constants**: UPPER_SNAKE_CASE (`MAX_RETRY_ATTEMPTS`)
- **Packages**: lowercase (`com.company.service`)

### Method Design
- **Single Responsibility**: Each method should do one thing
- **Method Length**: Keep methods under 20-30 lines
- **Parameter Count**: Limit parameters to 3-4, use objects for more
- **Return Early**: Use guard clauses to reduce nesting
```java
public User findUserById(Long id) {
    if (id == null) {
        throw new IllegalArgumentException("User ID cannot be null");
    }
    
    return userRepository.findById(id)
        .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + id));
}
```

### Error Handling
- **Fail Fast**: Validate inputs early
- **Meaningful Messages**: Provide clear error messages
- **Exception Types**: Use appropriate exception types
- **Resource Cleanup**: Use try-with-resources for resource management

### Comments and Documentation
- **Javadoc**: Document public APIs
- **Inline Comments**: Explain complex business logic, not obvious code
- **TODO Comments**: Use sparingly and track them
- **Self-Documenting Code**: Prefer clear code over comments

## Logging Best Practices

### Logging Configuration
- **Framework**: Use SLF4J with Logback (Spring Boot default)
- **Log Levels**: DEBUG for development, INFO for production
- **Structured Logging**: Use JSON format for production
- **Log Rotation**: Configure log file rotation and archiving
```xml
<!-- logback-spring.xml -->
<configuration>
    <springProfile name="!prod">
        <appender name="CONSOLE" class="ch.qos.logback.core.ConsoleAppender">
            <encoder>
                <pattern>%d{yyyy-MM-dd HH:mm:ss} [%thread] %-5level %logger{36} - %msg%n</pattern>
            </encoder>
        </appender>
        <root level="INFO">
            <appender-ref ref="CONSOLE"/>
        </root>
    </springProfile>
    
    <springProfile name="prod">
        <appender name="FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
            <file>logs/application.log</file>
            <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
                <fileNamePattern>logs/application-%d{yyyy-MM-dd}.%i.log</fileNamePattern>
                <maxHistory>30</maxHistory>
            </rollingPolicy>
            <encoder class="net.logstash.logback.encoder.LoggingEventCompositeJsonEncoder">
                <providers>
                    <timestamp/>
                    <logLevel/>
                    <loggerName/>
                    <message/>
                    <mdc/>
                </providers>
            </encoder>
        </appender>
        <root level="INFO">
            <appender-ref ref="FILE"/>
        </root>
    </springProfile>
</configuration>
```

### Logging Practices
- **Log Levels**: Use appropriate log levels (ERROR, WARN, INFO, DEBUG, TRACE)
- **Sensitive Data**: Never log passwords, API keys, or personal data
- **Performance**: Use parameterized logging to avoid string concatenation
- **Contextual Information**: Include relevant context (user ID, request ID, etc.)
```java
@Service
public class UserService {
    private static final Logger log = LoggerFactory.getLogger(UserService.class);
    
    public User createUser(CreateUserRequest request) {
        log.info("Creating user with username: {}", request.getUsername());
        
        try {
            User user = userMapper.toEntity(request);
            User savedUser = userRepository.save(user);
            log.info("Successfully created user with ID: {}", savedUser.getId());
            return savedUser;
        } catch (Exception e) {
            log.error("Failed to create user with username: {}", request.getUsername(), e);
            throw new UserCreationException("Failed to create user", e);
        }
    }
}
```

## Docker Best Practices

### Multi-Stage Dockerfile
- **Build Stage**: Use full JDK for building
- **Runtime Stage**: Use slim JRE for running
- **Layer Optimization**: Copy dependencies before source code
- **Security**: Run as non-root user
```dockerfile
# Build stage
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn clean package -DskipTests

# Runtime stage
FROM eclipse-temurin:17-jre-alpine AS runtime
WORKDIR /app

# Create non-root user
RUN addgroup -g 1001 appgroup && \
    adduser -u 1001 -G appgroup -s /bin/sh -D appuser

# Copy built application
COPY --from=build /app/target/*.jar app.jar

# Change ownership and switch to non-root user
RUN chown appuser:appgroup app.jar
USER appuser

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8080/actuator/health || exit 1

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

### Docker Compose
- **Environment Variables**: Use .env files for configuration
- **Volumes**: Persist data and logs
- **Networks**: Create custom networks for service isolation
- **Health Checks**: Include health checks for all services
```yaml
version: '3.8'
services:
  app:
    build: .
    ports:
      - "8080:8080"
    environment:
      - SPRING_PROFILES_ACTIVE=docker
      - DATABASE_URL=jdbc:postgresql://db:5432/myapp
      - DATABASE_USERNAME=myapp
      - DATABASE_PASSWORD=secret
    depends_on:
      db:
        condition: service_healthy
    volumes:
      - ./logs:/app/logs
    networks:
      - myapp-network

  db:
    image: postgres:15-alpine
    environment:
      - POSTGRES_DB=myapp
      - POSTGRES_USER=myapp
      - POSTGRES_PASSWORD=secret
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U myapp -d myapp"]
      interval: 10s
      timeout: 5s
      retries: 5
    networks:
      - myapp-network

volumes:
  postgres_data:

networks:
  myapp-network:
    driver: bridge
```

## Kubernetes Best Practices

### Deployment Configuration
- **Resource Limits**: Always set CPU and memory limits
- **Health Checks**: Configure readiness and liveness probes
- **Environment Variables**: Use ConfigMaps and Secrets
- **Replicas**: Set appropriate replica count for availability
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp-deployment
  labels:
    app: myapp
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: myapp
        image: myapp:latest
        ports:
        - containerPort: 8080
        env:
        - name: SPRING_PROFILES_ACTIVE
          value: "kubernetes"
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: myapp-secrets
              key: database-url
        resources:
          requests:
            memory: "512Mi"
            cpu: "250m"
          limits:
            memory: "1Gi"
            cpu: "500m"
        readinessProbe:
          httpGet:
            path: /actuator/health/readiness
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 10
        livenessProbe:
          httpGet:
            path: /actuator/health/liveness
            port: 8080
          initialDelaySeconds: 60
          periodSeconds: 30
```

### Service and Ingress
- **Service Types**: Use ClusterIP for internal services, LoadBalancer for external
- **Ingress**: Configure proper SSL/TLS and routing rules
- **Labels**: Use consistent labeling strategy
```yaml
apiVersion: v1
kind: Service
metadata:
  name: myapp-service
spec:
  selector:
    app: myapp
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
  type: ClusterIP

---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: myapp-ingress
  annotations:
    kubernetes.io/ingress.class: nginx
    cert-manager.io/cluster-issuer: letsencrypt-prod
spec:
  tls:
  - hosts:
    - api.myapp.com
    secretName: myapp-tls
  rules:
  - host: api.myapp.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: myapp-service
            port:
              number: 80
```

## Cloud Platform Best Practices

### AWS Specific
- **IAM Roles**: Use IAM roles instead of access keys
- **Parameter Store**: Use AWS Systems Manager Parameter Store for configuration
- **CloudWatch**: Set up proper logging and monitoring
- **RDS**: Use RDS for managed databases
- **Load Balancer**: Use Application Load Balancer for HTTP/HTTPS traffic

### Configuration for Cloud
```yaml
# application-aws.yml
spring:
  cloud:
    aws:
      region:
        static: ${AWS_REGION:us-east-1}
      credentials:
        instance-profile: true
  datasource:
    url: ${RDS_ENDPOINT}
    username: ${RDS_USERNAME}
    password: ${RDS_PASSWORD}

management:
  metrics:
    export:
      cloudwatch:
        enabled: true
        namespace: MyApp
        step: 1m

logging:
  config: classpath:logback-aws.xml
```

## Performance Optimization

### JVM Tuning
- **Heap Size**: Set appropriate heap size (`-Xms` and `-Xmx`)
- **Garbage Collection**: Use G1GC for most applications
- **JVM Flags**: Add performance monitoring flags
```bash
java -Xms512m -Xmx1g \
     -XX:+UseG1GC \
     -XX:MaxGCPauseMillis=200 \
     -XX:+HeapDumpOnOutOfMemoryError \
     -XX:HeapDumpPath=/app/heapdumps \
     -jar app.jar
```

### Application Performance
- **Connection Pooling**: Configure HikariCP properly
- **Caching**: Use Spring Cache with Redis or Hazelcast
- **Async Processing**: Use `@Async` for non-blocking operations
- **Database Indexing**: Ensure proper database indexes

## Monitoring and Observability

### Spring Boot Actuator
- **Endpoints**: Enable necessary actuator endpoints
- **Metrics**: Export metrics to monitoring systems
- **Health Checks**: Implement custom health indicators
```yaml
management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics,prometheus
  endpoint:
    health:
      show-details: when-authorized
  metrics:
    export:
      prometheus:
        enabled: true
```

### Distributed Tracing
- **Spring Cloud Sleuth**: Add distributed tracing
- **Zipkin/Jaeger**: Configure trace collection
- **Correlation IDs**: Include correlation IDs in logs

## API Documentation

### OpenAPI/Swagger
- **springdoc-openapi**: Use for API documentation
- **Annotations**: Document APIs with OpenAPI annotations
- **Examples**: Provide request/response examples
```java
@RestController
@RequestMapping("/api/v1/users")
@Tag(name = "User Management", description = "APIs for managing users")
public class UserController {
    
    @GetMapping("/{id}")
    @Operation(summary = "Get user by ID", description = "Retrieves a user by their unique identifier")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "User found"),
        @ApiResponse(responseCode = "404", description = "User not found")
    })
    public ResponseEntity<UserResponse> getUser(
            @Parameter(description = "User ID", required = true)
            @PathVariable Long id) {
        // implementation
    }
}
```

## Security Scanning and Dependencies

### Dependency Management
- **OWASP Dependency Check**: Scan for vulnerable dependencies
- **Snyk**: Use for continuous security monitoring
- **Dependabot**: Enable automatic dependency updates
- **Maven/Gradle**: Keep build tools updated

### Static Code Analysis
- **SonarQube**: Set up code quality gates
- **SpotBugs**: Find potential bugs
- **Checkstyle**: Enforce coding standards
- **PMD**: Detect code smells

## DevOps and CI/CD

### Build Pipeline
- **Multi-stage**: Build, test, security scan, deploy
- **Parallel Execution**: Run tests in parallel
- **Caching**: Cache dependencies and build artifacts
- **Failure Handling**: Fail fast on critical issues

### Deployment Strategy
- **Blue-Green**: For zero-downtime deployments
- **Rolling Updates**: For Kubernetes deployments
- **Feature Flags**: For controlled feature rollouts
- **Database Migrations**: Automate schema changes

---

## General Guidelines for AI Code Assistants

1. **Always follow Spring Boot conventions and best practices**
2. **Prefer established patterns over custom solutions**
3. **Include proper error handling and logging**
4. **Write testable code with dependency injection**
5. **Use meaningful names for classes, methods, and variables**
6. **Keep methods small and focused on single responsibility**
7. **Include proper validation and security measures**
8. **Follow clean code principles**
9. **Add necessary comments for complex business logic**
10. **Consider performance implications of code changes**

When generating code, always consider the broader context of a production-ready Spring Boot application and include appropriate error handling, logging, and testing strategies.