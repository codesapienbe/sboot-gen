#!/bin/bash
set -euo pipefail

################################################################################
# ☕️ sboot – enterprise Spring Boot generator with Spring CLI
#
# Installation methods:
#   1. Download and source: source <(curl -s https://raw.githubusercontent.com/codesapienbe/sboot-gen/main/sbootgen.sh)
#   2. Direct execution: curl -s https://raw.githubusercontent.com/codesapienbe/sboot-gen/main/sbootgen.sh | bash
#   3. Manual install: curl -s https://raw.githubusercontent.com/codesapienbe/sboot-gen/main/sbootgen.sh -o sbootgen.sh && source sbootgen.sh
#
# Usage: sboot <modulith|microservice|monolith> <project-dir>
################################################################################

# Configuration Constants
readonly SCRIPT_VERSION="2.0.0"
readonly SCRIPT_REPO="codesapienbe/sboot-gen"
readonly SCRIPT_URL="https://raw.githubusercontent.com/${SCRIPT_REPO}/main/sbootgen.sh"
readonly SPRING_BOOT_VERSION="3.2.0"
readonly JAVA_VERSION="17"
readonly MAVEN_VERSION="3.8.0"
readonly MODULITH_VERSION="1.3.1"
readonly GROUP_ID="com.battmobility"

# System Requirements
readonly MIN_DISK_SPACE_MB=500
readonly MIN_MEMORY_MB=512
readonly REQUIRED_COMMANDS=("curl" "mvn" "java")
readonly RECOMMENDED_COMMANDS=("git" "docker")

# Dependency versions
readonly LOGSTASH_ENCODER_VERSION="8.0"
readonly PROBLEM_SPRING_WEB_VERSION="0.29.1"
readonly SPOTLESS_VERSION="2.44.5"
readonly GOOGLE_JAVA_FORMAT_VERSION="1.19.2"
readonly CHECKSTYLE_VERSION="3.3.1"
readonly ENFORCER_VERSION="3.4.1"
readonly OWASP_DEP_CHECK_VERSION="9.0.7"
readonly SPOTBUGS_VERSION="4.8.3.0"
readonly JACOCO_VERSION="0.8.11"

# Supported architectures
readonly SUPPORTED_ARCHITECTURES=("modulith" "microservice" "monolith")

# Color constants
readonly RED="\033[0;31m" GRN="\033[0;32m" YLW="\033[1;33m"
readonly BLU="\033[0;34m" MAG="\033[0;35m" CYN="\033[0;36m" CLR="\033[0m"

# Logging functions
log_debug() { [[ "${LOG_LEVEL:-INFO}" == "DEBUG" ]] && echo -e "${CYN}[DEBUG]${CLR} $*" >&2; }
log_info() { echo -e "${BLU}[INFO]${CLR} $*" >&2; }
log_warn() { echo -e "${YLW}[WARN]${CLR} $*" >&2; }
log_error() { echo -e "${RED}[ERROR]${CLR} $*" >&2; }
log_success() { echo -e "${GRN}[SUCCESS]${CLR} $*" >&2; }

# Environment validation functions
check_shell_compatibility() {
  log_debug "Checking shell compatibility..."

  # Check if running in a supported shell
  local current_shell
  current_shell="$(basename "${SHELL:-$0}")"

  case "$current_shell" in
    bash|zsh)
      log_debug "Compatible shell detected: $current_shell"
      ;;
    *)
      log_warn "Shell '$current_shell' detected. Best compatibility with bash or zsh."
      ;;
  esac

  # Check bash version for associative arrays and other features
  if [[ -n "${BASH_VERSION:-}" ]]; then
    local bash_major="${BASH_VERSION%%.*}"
    if (( bash_major < 4 )); then
      log_error "Bash version $BASH_VERSION detected. Requires Bash 4.0+ for full functionality."
      return 1
    fi
  fi

  log_debug "Shell compatibility check passed"
}

check_network_connectivity() {
  log_debug "Checking network connectivity..."

  # Try to connect to GitHub (where script is hosted)
  if command -v curl >/dev/null 2>&1; then
    if curl -s --connect-timeout 5 --max-time 10 "https://api.github.com" >/dev/null 2>&1; then
      log_debug "Network connectivity to GitHub confirmed"
      return 0
    fi
  fi

  # Try alternative connectivity check
  if command -v ping >/dev/null 2>&1; then
    if ping -c 1 -W 2 8.8.8.8 >/dev/null 2>&1; then
      log_debug "Basic network connectivity confirmed"
      return 0
    fi
  fi

  log_error "No network connectivity detected. Internet connection required for downloads."
  return 1
}

check_disk_space() {
  local required_mb="${1:-$MIN_DISK_SPACE_MB}"

  log_debug "Checking available disk space (requiring ${required_mb}MB)..."

  if ! command -v df >/dev/null 2>&1; then
    log_warn "Cannot check disk space - df command not available"
    return 0
  fi

  local available_mb
  available_mb="$(df -m . | tail -1 | awk '{print $4}')"

  if [[ -z "$available_mb" ]] || ! [[ "$available_mb" =~ ^[0-9]+$ ]]; then
    log_warn "Cannot determine available disk space"
    return 0
  fi

  if (( available_mb < required_mb )); then
    log_error "Insufficient disk space: ${available_mb}MB available, ${required_mb}MB required"
    log_info "Please free up disk space and try again"
    return 1
  fi

  log_debug "Disk space check passed: ${available_mb}MB available"
}

check_memory() {
  local required_mb="${1:-$MIN_MEMORY_MB}"

  log_debug "Checking available memory (requiring ${required_mb}MB)..."

  if ! command -v free >/dev/null 2>&1; then
    log_warn "Cannot check memory - free command not available"
    return 0
  fi

  local available_mb
  available_mb="$(free -m | grep '^Mem:' | awk '{print $7}')"  # Available memory

  if [[ -z "$available_mb" ]] || ! [[ "$available_mb" =~ ^[0-9]+$ ]]; then
    log_warn "Cannot determine available memory"
    return 0
  fi

  if (( available_mb < required_mb )); then
    log_error "Insufficient memory: ${available_mb}MB available, ${required_mb}MB required"
    log_info "Please close other applications or add more RAM"
    return 1
  fi

  log_debug "Memory check passed: ${available_mb}MB available"
}

check_command_versions() {
  log_debug "Checking command versions..."

  # Check Java version
  if command -v java >/dev/null 2>&1; then
    local java_version
    java_version="$(java -version 2>&1 | head -1 | sed -E 's/.*version "([^"]+)".*/\1/' | cut -d'.' -f1)"
    if [[ -n "$java_version" ]] && [[ "$java_version" =~ ^[0-9]+$ ]]; then
      if (( java_version < JAVA_VERSION )); then
        log_warn "Java $java_version detected. Java $JAVA_VERSION+ recommended for Spring Boot $SPRING_BOOT_VERSION"
      else
        log_debug "Java version check passed: $java_version"
      fi
    fi
  fi

  # Check Maven version
  if command -v mvn >/dev/null 2>&1; then
    local maven_version
    maven_version="$(mvn -version 2>/dev/null | head -1 | sed -E 's/.* ([0-9]+\.[0-9]+\.[0-9]+).*/\1/' | cut -d'.' -f1-2)"
    if [[ -n "$maven_version" ]]; then
      local maven_major="${maven_version%%.*}"
      if [[ "$maven_major" =~ ^[0-9]+$ ]] && (( maven_major < 3 )); then
        log_warn "Maven $maven_version detected. Maven $MAVEN_VERSION+ recommended"
      else
        log_debug "Maven version check passed: $maven_version"
      fi
    fi
  fi
}

check_required_commands() {
  local missing_critical=()
  local missing_optional=()

  log_debug "Checking required commands..."

  for cmd in "${REQUIRED_COMMANDS[@]}"; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      missing_critical+=("$cmd")
    fi
  done

  for cmd in "${RECOMMENDED_COMMANDS[@]}"; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      missing_optional+=("$cmd")
    fi
  done

  if [[ ${#missing_critical[@]} -gt 0 ]]; then
    log_error "Missing required commands: ${missing_critical[*]}"
    log_info "Please install missing commands and try again"
    return 1
  fi

  if [[ ${#missing_optional[@]} -gt 0 ]]; then
    log_warn "Optional commands not found: ${missing_optional[*]}"
    log_info "Some features may be limited without these commands"
  fi

  log_debug "Command availability check passed"
}

check_process_safety() {
  local script_name="sbootgen"

  # Check for other instances of this script
  local pid_count
  pid_count="$(pgrep -f "$script_name" | wc -l)"

  # Subtract 1 for current process
  if (( pid_count > 1 )); then
    log_warn "Multiple instances of $script_name detected ($pid_count running)"
    log_info "Consider waiting for other instances to complete"
  fi

  # Check for lock file (if this script creates one)
  local lock_file="/tmp/${script_name}.lock"
  if [[ -f "$lock_file" ]]; then
    local lock_pid
    lock_pid="$(cat "$lock_file" 2>/dev/null)"
    if [[ -n "$lock_pid" ]] && kill -0 "$lock_pid" 2>/dev/null; then
      log_error "Another instance is running (PID: $lock_pid)"
      log_info "Please wait for it to complete or kill it manually"
      return 1
    else
      # Stale lock file
      rm -f "$lock_file"
      log_debug "Removed stale lock file"
    fi
  fi

  # Create lock file
  echo "$$" > "$lock_file"
  log_debug "Created lock file: $lock_file"

  # Ensure lock file is cleaned up on exit
  trap "rm -f '$lock_file'" EXIT
}

perform_system_health_check() {
  log_info "Performing system health check..."

  local checks_passed=true

  # Run all checks
  check_shell_compatibility || checks_passed=false
  check_required_commands || checks_passed=false
  check_disk_space || checks_passed=false
  check_memory || checks_passed=false
  check_command_versions
  check_process_safety || checks_passed=false

  if [[ "$checks_passed" == "true" ]]; then
    log_success "System health check completed successfully"
    return 0
  else
    log_error "System health check failed"
    return 1
  fi
}

# Self-healing functions
attempt_command_installation() {
  local cmd="$1"

  log_debug "Attempting to install missing command: $cmd"

  # Detect package manager
  if command -v apt-get >/dev/null 2>&1; then
    log_info "Detected apt package manager"
    log_info "Run: sudo apt-get update && sudo apt-get install $cmd"
  elif command -v yum >/dev/null 2>&1; then
    log_info "Detected yum package manager"
    log_info "Run: sudo yum install $cmd"
  elif command -v dnf >/dev/null 2>&1; then
    log_info "Detected dnf package manager"
    log_info "Run: sudo dnf install $cmd"
  elif command -v brew >/dev/null 2>&1; then
    log_info "Detected Homebrew"
    log_info "Run: brew install $cmd"
  else
    log_warn "Unknown package manager. Please install $cmd manually"
  fi
}

fix_common_issues() {
  log_debug "Checking for common fixable issues..."

  # Check if JAVA_HOME is set
  if ! [[ -n "${JAVA_HOME:-}" ]]; then
    log_warn "JAVA_HOME environment variable not set"
    if command -v java >/dev/null 2>&1; then
      local java_home_candidate
      java_home_candidate="$(readlink -f "$(which java)" | sed 's:/bin/java::')"
      if [[ -d "$java_home_candidate" ]]; then
        log_info "Suggested JAVA_HOME: $java_home_candidate"
        log_info "Add to your shell profile: export JAVA_HOME=\"$java_home_candidate\""
      fi
    fi
  fi

  # Check Maven wrapper permissions
  if [[ -f "mvnw" ]] && ! [[ -x "mvnw" ]]; then
    log_warn "mvnw is not executable"
    if chmod +x "mvnw" 2>/dev/null; then
      log_info "Fixed mvnw permissions"
    fi
  fi

  # Check for common Maven issues
  if command -v mvn >/dev/null 2>&1; then
    local maven_home
    maven_home="$(mvn -v 2>/dev/null | grep 'Maven home:' | cut -d' ' -f3-)"
    if [[ -z "$maven_home" ]]; then
      log_warn "Maven installation may be incomplete"
    fi
  fi

  log_debug "Common issues check completed"
}

# Performance optimization functions
setup_cache_directory() {
  local cache_dir="${HOME}/.cache/sbootgen"

  if ! [[ -d "$cache_dir" ]]; then
    if mkdir -p "$cache_dir" 2>/dev/null; then
      log_debug "Created cache directory: $cache_dir"
    else
      log_warn "Could not create cache directory"
      return 1
    fi
  fi

  echo "$cache_dir"
}

download_with_cache() {
  local url="$1"
  local cache_file="$2"
  local cache_dir
  cache_dir="$(setup_cache_directory)" || return 1

  local cached_path="${cache_dir}/${cache_file}"

  # Check if cached version exists and is recent (24 hours)
  if [[ -f "$cached_path" ]] && [[ $(find "$cached_path" -mtime -1 2>/dev/null) ]]; then
    log_debug "Using cached version: $cached_path"
    cat "$cached_path"
    return 0
  fi

  # Download and cache
  if command -v curl >/dev/null 2>&1; then
    log_debug "Downloading and caching: $url"
    if curl -s "$url" | tee "$cached_path" 2>/dev/null; then
      log_debug "Download cached successfully"
      return 0
    fi
  fi

  log_error "Failed to download: $url"
  return 1
}

optimize_performance() {
  log_debug "Applying performance optimizations..."

  # Increase file descriptor limits if possible
  if command -v ulimit >/dev/null 2>&1; then
    ulimit -n 1024 2>/dev/null && log_debug "Increased file descriptor limit"
  fi

  # Set locale for consistent behavior
  export LC_ALL=C 2>/dev/null || true

  log_debug "Performance optimizations applied"
}

# Enhanced error recovery
create_backup_recovery() {
  local operation="$1"
  local backup_path="${HOME}/.sbootgen/${operation}.backup.$(date +%Y%m%d_%H%M%S)"

  log_debug "Creating recovery backup for: $operation"

  case "$operation" in
    "shell_profile")
      local profile_file="$HOME/.bashrc"
      if [[ -n "${ZSH_VERSION:-}" ]]; then
        profile_file="$HOME/.zshrc"
      elif [[ -f "$HOME/.bash_profile" ]]; then
        profile_file="$HOME/.bash_profile"
      fi

      if [[ -f "$profile_file" ]]; then
        cp "$profile_file" "$backup_path" 2>/dev/null && log_debug "Shell profile backed up: $backup_path"
      fi
      ;;
    "script_install")
      if [[ -f "$HOME/.sbootgen.sh" ]]; then
        cp "$HOME/.sbootgen.sh" "$backup_path" 2>/dev/null && log_debug "Script backed up: $backup_path"
      fi
      ;;
  esac
}

# Advanced security checks
perform_security_audit() {
  log_debug "Performing security audit..."

  # Check if running as root (not recommended)
  if [[ $EUID -eq 0 ]]; then
    log_warn "Running as root - not recommended for development"
  fi

  # Check file permissions
  local script_file="${BASH_SOURCE[0]}"
  if [[ -f "$script_file" ]]; then
    local permissions
    permissions="$(stat -c '%a' "$script_file" 2>/dev/null || stat -f '%Lp' "$script_file" 2>/dev/null)"
    if [[ "${permissions: -1}" == "7" ]]; then
      log_warn "Script has world-writable permissions - consider: chmod 755 $script_file"
    fi
  fi

  # Check for suspicious environment variables
  local suspicious_vars=("LD_PRELOAD" "LD_LIBRARY_PATH")
  for var in "${suspicious_vars[@]}"; do
    if [[ -n "${!var:-}" ]]; then
      log_debug "Environment variable set: $var"
    fi
  done

  log_debug "Security audit completed"
}

# Enhanced logging with context
log_with_context() {
  local level="$1"
  local message="$2"
  local context=""

  # Add context information
  if [[ -n "${FUNCNAME[1]:-}" ]]; then
    context="[${FUNCNAME[1]}] "
  fi

  case "$level" in
    "debug") log_debug "${context}${message}" ;;
    "info") log_info "${context}${message}" ;;
    "warn") log_warn "${context}${message}" ;;
    "error") log_error "${context}${message}" ;;
    "success") log_success "${context}${message}" ;;
  esac
}

# Comprehensive initialization
smart_initialize() {
  log_with_context "info" "Initializing smart shell environment..."

  # Apply performance optimizations
  optimize_performance

  # Perform security audit
  perform_security_audit

  # Attempt to fix common issues
  fix_common_issues

  # Set up error recovery
  trap 'log_error "Unexpected error occurred. Check system requirements and try again."' ERR

  log_with_context "success" "Smart initialization completed"
}

# Cleanup function for trap
cleanup() {
  local exit_code=$?
  if [[ $exit_code -ne 0 ]]; then
    log_error "Script failed with exit code $exit_code"
    if [[ -n "${TEMP_DIR:-}" ]] && [[ -d "$TEMP_DIR" ]]; then
      log_debug "Cleaning up temporary directory: $TEMP_DIR"
      rm -rf "$TEMP_DIR"
    fi
    if [[ -n "${PROJECT_DIR:-}" ]] && [[ -d "$PROJECT_DIR" ]]; then
      log_warn "Cleaning up partially created project directory: $PROJECT_DIR"
      rm -rf "$PROJECT_DIR"
    fi
  fi
  trap - EXIT
  exit $exit_code
}

# Safe file operations
safe_create_dir() {
  local dir="$1"
  if [[ -e "$dir" ]] && [[ ! -d "$dir" ]]; then
    log_error "Path exists but is not a directory: $dir"
    return 1
  fi
  mkdir -p "$dir" || {
    log_error "Failed to create directory: $dir"
    return 1
  }
  log_debug "Created directory: $dir"
}

safe_write_file() {
  local file="$1" content="$2"
  local dir
  dir="$(dirname "$file")"

  safe_create_dir "$dir" || return 1

  printf '%s\n' "$content" > "$file" || {
    log_error "Failed to write file: $file"
    return 1
  }
  log_debug "Wrote file: $file"
}

# Validation functions
validate_dependencies() {
  local missing_deps=()

  command -v spring >/dev/null || missing_deps+=("Spring Boot CLI")
  command -v mvn >/dev/null || missing_deps+=("Maven")
  command -v docker >/dev/null || missing_deps+=("Docker")
  command -v curl >/dev/null || missing_deps+=("curl")

  if [[ ${#missing_deps[@]} -gt 0 ]]; then
    log_error "Missing required dependencies: ${missing_deps[*]}"
    log_info "Please install missing dependencies and try again."
    return 1
  fi

  log_debug "All dependencies validated successfully"
}

validate_architecture() {
  local arch="$1"
  for supported in "${SUPPORTED_ARCHITECTURES[@]}"; do
    [[ "$arch" == "$supported" ]] && return 0
  done
  log_error "Unsupported architecture: $arch"
  log_info "Supported architectures: ${SUPPORTED_ARCHITECTURES[*]}"
  return 1
}

validate_project_name() {
  local name="$1"
  if [[ -z "$name" ]]; then
    log_error "Project name cannot be empty"
    return 1
  fi

  if [[ ! "$name" =~ ^[a-zA-Z][a-zA-Z0-9_-]*$ ]]; then
    log_error "Invalid project name: $name"
    log_info "Project name must start with a letter and contain only letters, numbers, hyphens, and underscores"
    return 1
  fi

  if [[ -d "$name" ]]; then
    log_error "Directory already exists: $name"
    return 1
  fi

  log_debug "Project name validated: $name"
}

print_usage() {
  cat << EOF
${BLU}╔════════════════════════════════════════════════════════╗${CLR}
${BLU}║${CLR}  ☕️  ${GRN}Spring Boot Enterprise Generator${CLR}           ${BLU}║${CLR}
${BLU}║${CLR}  ${CYN}Version ${SCRIPT_VERSION}${CLR}                                 ${BLU}║${CLR}
${BLU}╠════════════════════════════════════════════════════════╣${CLR}
${BLU}║${CLR}  Usage: ${GRN}sboot${CLR} ${MAG}<architecture>${CLR} ${CYN}<directory>${CLR}      ${BLU}║${CLR}
${BLU}║${CLR}                                                     ${BLU}║${CLR}
${BLU}║${CLR}  Architectures:                                    ${BLU}║${CLR}
${BLU}║${CLR}    ${MAG}modulith${CLR}      - Domain-driven modular monolith  ${BLU}║${CLR}
${BLU}║${CLR}    ${MAG}microservice${CLR}  - Standalone microservice         ${BLU}║${CLR}
${BLU}║${CLR}    ${MAG}monolith${CLR}      - Traditional layered monolith    ${BLU}║${CLR}
${BLU}╚════════════════════════════════════════════════════════╝${CLR}
EOF
}

print_success_message() {
  local arch="$1" dir="$2"
  cat << EOF

${GRN}╔════════════════════════════════════════════════════════╗${CLR}
${GRN}║${CLR}  ✅ ${GRN}Project ${MAG}$dir${GRN} created successfully!${CLR}         ${GRN}║${CLR}
${GRN}╠════════════════════════════════════════════════════════╣${CLR}
${GRN}║${CLR}  📦 Architecture: ${MAG}$arch${CLR}                             ${GRN}║${CLR}
${GRN}║${CLR}  🐳 Docker: ${YLW}Multi-stage build ready${CLR}                ${GRN}║${CLR}
${GRN}║${CLR}  📊 Monitoring: ${YLW}Prometheus + Grafana ready${CLR}         ${GRN}║${CLR}
${GRN}║${CLR}  🔧 Quality: ${YLW}Spotless, Checkstyle, OWASP${CLR}          ${GRN}║${CLR}
${GRN}╠════════════════════════════════════════════════════════╣${CLR}
${GRN}║${CLR}  ${BLU}Next Steps:${CLR}                                       ${GRN}║${CLR}
${GRN}║${CLR}    ${CYN}cd $dir${CLR}                                     ${GRN}║${CLR}
${GRN}║${CLR}    ${CYN}make help${CLR}        # See all commands            ${GRN}║${CLR}
${GRN}║${CLR}    ${CYN}make build${CLR}       # Build project               ${GRN}║${CLR}
${GRN}║${CLR}    ${CYN}make run${CLR}         # Run locally                 ${GRN}║${CLR}
${GRN}║${CLR}    ${CYN}make docker-up${CLR}   # Run with PostgreSQL         ${GRN}║${CLR}
${GRN}╠════════════════════════════════════════════════════════╣${CLR}
${GRN}║${CLR}  🌐 Endpoints:                                      ${GRN}║${CLR}
${GRN}║${CLR}    ${YLW}http://localhost:8080/actuator/health${CLR}       ${GRN}║${CLR}
${GRN}║${CLR}    ${YLW}http://localhost:8080/actuator/prometheus${CLR}   ${GRN}║${CLR}
${GRN}╚════════════════════════════════════════════════════════╝${CLR}

${MAG}🎉 Happy coding! Good luck at BattMobility! 🚀${CLR}
EOF
}

# Architecture-specific configurations
get_base_dependencies() {
  echo "web,data-jpa,validation,lombok,actuator,devtools,postgresql,h2"
}

get_extra_dependencies() {
  local arch="$1"
  case "$arch" in
    modulith) echo "security,cache,flyway,prometheus,testcontainers" ;;
    microservice) echo "security,cache,flyway,prometheus,cloud-config,testcontainers" ;;
    monolith) echo "security,cache,flyway,prometheus,testcontainers" ;;
    *) log_error "Unknown architecture: $arch"; return 1 ;;
  esac
}

get_artifact_id() {
  local arch="$1"
  case "$arch" in
    modulith) echo "modulith-project" ;;
    microservice) echo "microservice-project" ;;
    monolith) echo "monolith-project" ;;
    *) log_error "Unknown architecture: $arch"; return 1 ;;
  esac
}

# Core functionality functions
init_spring_project() {
  local arch="$1" dir="$2" artifact_id="$3"
  local base_deps extra_deps package_name

  log_info "Initializing Spring Boot project with Spring CLI..."

  base_deps="$(get_base_dependencies)"
  extra_deps="$(get_extra_dependencies "$arch")"
  package_name="${GROUP_ID//.//}.${artifact_id//-/.}"

  spring init \
    --build=maven \
    --java-version="$JAVA_VERSION" \
    --language=java \
    --packaging=jar \
    --boot-version="$SPRING_BOOT_VERSION" \
    --groupId="$GROUP_ID" \
    --artifactId="$artifact_id" \
    --name="${dir}-app" \
    --description="Enterprise $arch application" \
    --package-name="$package_name" \
    --dependencies="${base_deps},${extra_deps}" \
    "$dir" || {
      log_error "Spring CLI initialization failed"
      return 1
    }

  log_success "Spring Boot project initialized successfully"
}

add_enterprise_dependencies() {
  local arch="$1" pom_file="$2"
  local temp_file

  log_info "Adding enterprise dependencies..."

  # Create temporary file for safe editing
  temp_file="$(mktemp)" || {
    log_error "Failed to create temporary file"
    return 1
  }

  # Add logstash encoder
  sed '/<dependencies>/a\
    <!-- Structured JSON logging -->\
    <dependency>\
      <groupId>net.logstash.logback</groupId>\
      <artifactId>logstash-logback-encoder</artifactId>\
      <version>'"$LOGSTASH_ENCODER_VERSION"'</version>\
    </dependency>' "$pom_file" > "$temp_file" || {
      rm -f "$temp_file"
      log_error "Failed to add logstash dependency"
      return 1
    }
  mv "$temp_file" "$pom_file"

  # Add problem-spring-web
  sed '/<\/dependencies>/i\
    <!-- RFC 7807 Problem Details -->\
    <dependency>\
      <groupId>org.zalando</groupId>\
      <artifactId>problem-spring-web-starter</artifactId>\
      <version>'"$PROBLEM_SPRING_WEB_VERSION"'</version>\
    </dependency>' "$pom_file" > "$temp_file" || {
      rm -f "$temp_file"
      log_error "Failed to add problem-spring-web dependency"
      return 1
    }
  mv "$temp_file" "$pom_file"

  # Add Modulith dependencies if needed
  if [[ "$arch" == "modulith" ]]; then
    sed '/<dependencies>/i\
  <dependencyManagement>\
    <dependencies>\
      <dependency>\
        <groupId>org.springframework.modulith</groupId>\
        <artifactId>spring-modulith-bom</artifactId>\
        <version>'"$MODULITH_VERSION"'</version>\
        <type>pom</type>\
        <scope>import</scope>\
      </dependency>\
    </dependencies>\
  </dependencyManagement>' "$pom_file" > "$temp_file" || {
      rm -f "$temp_file"
      log_error "Failed to add Modulith BOM"
      return 1
    }
    mv "$temp_file" "$pom_file"

    sed '/<dependencies>/a\
    <!-- Spring Modulith -->\
    <dependency>\
      <groupId>org.springframework.modulith</groupId>\
      <artifactId>spring-modulith-starter-core</artifactId>\
    </dependency>\
    <dependency>\
      <groupId>org.springframework.modulith</groupId>\
      <artifactId>spring-modulith-starter-jpa</artifactId>\
    </dependency>\
    <dependency>\
      <groupId>org.springframework.modulith</groupId>\
      <artifactId>spring-modulith-actuator</artifactId>\
      <scope>runtime</scope>\
    </dependency>\
    <dependency>\
      <groupId>org.springframework.modulith</groupId>\
      <artifactId>spring-modulith-observability</artifactId>\
      <scope>runtime</scope>\
    </dependency>\
    <dependency>\
      <groupId>org.springframework.modulith</groupId>\
      <artifactId>spring-modulith-starter-test</artifactId>\
      <scope>test</scope>\
    </dependency>' "$pom_file" > "$temp_file" || {
      rm -f "$temp_file"
      log_error "Failed to add Modulith dependencies"
      return 1
    }
    mv "$temp_file" "$pom_file"
  fi

  rm -f "$temp_file"
  log_success "Enterprise dependencies added successfully"
}

add_code_quality_plugins() {
  local pom_file="$1"
  local temp_file

  log_info "Adding code quality plugins..."

  temp_file="$(mktemp)" || {
    log_error "Failed to create temporary file"
    return 1
  }

  sed '/<plugins>/a\
      <!-- Spotless code formatter -->\
      <plugin>\
        <groupId>com.diffplug.spotless</groupId>\
        <artifactId>spotless-maven-plugin</artifactId>\
        <version>'"$SPOTLESS_VERSION"'</version>\
        <configuration>\
          <java>\
            <googleJavaFormat>\
              <version>'"$GOOGLE_JAVA_FORMAT_VERSION"'</version>\
              <style>GOOGLE</style>\
            </googleJavaFormat>\
            <removeUnusedImports/>\
            <formatAnnotations/>\
          </java>\
        </configuration>\
        <executions>\
          <execution>\
            <goals><goal>check</goal></goals>\
            <phase>compile</phase>\
          </execution>\
        </executions>\
      </plugin>\
      <!-- Checkstyle -->\
      <plugin>\
        <groupId>org.apache.maven.plugins</groupId>\
        <artifactId>maven-checkstyle-plugin</artifactId>\
        <version>'"$CHECKSTYLE_VERSION"'</version>\
        <configuration>\
          <configLocation>google_checks.xml</configLocation>\
          <consoleOutput>true</consoleOutput>\
          <failsOnError>false</failsOnError>\
        </configuration>\
      </plugin>\
      <!-- Maven Enforcer -->\
      <plugin>\
        <groupId>org.apache.maven.plugins</groupId>\
        <artifactId>maven-enforcer-plugin</artifactId>\
        <version>'"$ENFORCER_VERSION"'</version>\
        <executions>\
          <execution>\
            <id>enforce-maven</id>\
            <goals><goal>enforce</goal></goals>\
            <configuration>\
              <rules>\
                <requireMavenVersion><version>'"$MAVEN_VERSION"'</version></requireMavenVersion>\
                <requireJavaVersion><version>'"$JAVA_VERSION"'</version></requireJavaVersion>\
              </rules>\
            </configuration>\
          </execution>\
        </executions>\
      </plugin>\
      <!-- OWASP Dependency Check -->\
      <plugin>\
        <groupId>org.owasp</groupId>\
        <artifactId>dependency-check-maven</artifactId>\
        <version>'"$OWASP_DEP_CHECK_VERSION"'</version>\
        <configuration>\
          <failBuildOnCVSS>8</failBuildOnCVSS>\
        </configuration>\
      </plugin>\
      <!-- SpotBugs -->\
      <plugin>\
        <groupId>com.github.spotbugs</groupId>\
        <artifactId>spotbugs-maven-plugin</artifactId>\
        <version>'"$SPOTBUGS_VERSION"'</version>\
      </plugin>\
      <!-- JaCoCo Coverage -->\
      <plugin>\
        <groupId>org.jacoco</groupId>\
        <artifactId>jacoco-maven-plugin</artifactId>\
        <version>'"$JACOCO_VERSION"'</version>\
        <executions>\
          <execution>\
            <goals>\
              <goal>prepare-agent</goal>\
              <goal>report</goal>\
            </goals>\
          </execution>\
        </executions>\
      </plugin>' "$pom_file" > "$temp_file" || {
    rm -f "$temp_file"
    log_error "Failed to add code quality plugins"
    return 1
  }

  mv "$temp_file" "$pom_file"
  rm -f "$temp_file"
  log_success "Code quality plugins added successfully"
}

create_application_config() {
  local project_dir="$1"

  log_info "Creating application configuration..."

  local config_dir="$project_dir/src/main/resources"
  safe_create_dir "$config_dir" || return 1

  local application_yml="$config_dir/application.yml"
  safe_write_file "$application_yml" "spring:
  application:
    name: \${project.artifactId}
  profiles:
    active: local
  jpa:
    open-in-view: false
    show-sql: false
    properties:
      hibernate:
        format_sql: true
        use_sql_comments: true
        jdbc:
          batch_size: 20
        order_inserts: true
        order_updates: true
  flyway:
    enabled: true
    baseline-on-migrate: true
    locations: classpath:db/migration
  cache:
    type: caffeine
    caffeine:
      spec: maximumSize=500,expireAfterAccess=600s

server:
  port: 8080
  compression:
    enabled: true
  http2:
    enabled: true
  error:
    include-message: always
    include-binding-errors: always
    include-stacktrace: never
    include-exception: false

management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics,prometheus,loggers
      base-path: /actuator
  endpoint:
    health:
      show-details: when-authorized
      probes:
        enabled: true
  metrics:
    export:
      prometheus:
        enabled: true
    distribution:
      percentiles-histogram:
        http.server.requests: true
  tracing:
    sampling:
      probability: 1.0

logging:
  level:
    root: INFO
    ${GROUP_ID}: DEBUG
    org.springframework.web: DEBUG
    org.hibernate.SQL: DEBUG
    org.hibernate.type.descriptor.sql.BasicBinder: TRACE
  pattern:
    console: \"%d{yyyy-MM-dd HH:mm:ss} - %msg%n\"
    file: \"%d{yyyy-MM-dd HH:mm:ss} [%thread] %-5level %logger{36} - %msg%n\"

---
spring:
  config:
    activate:
      on-profile: local
  datasource:
    url: jdbc:h2:mem:testdb;MODE=PostgreSQL
    driver-class-name: org.h2.Driver
    username: sa
    password:
  jpa:
    database-platform: org.hibernate.dialect.H2Dialect
    hibernate:
      ddl-auto: create-drop
  h2:
    console:
      enabled: true
      path: /h2-console

---
spring:
  config:
    activate:
      on-profile: docker
  datasource:
    url: jdbc:postgresql://\${DB_HOST:postgres}:5432/\${DB_NAME:appdb}
    username: \${DB_USER:appuser}
    password: \${DB_PASS:apppass}
    driver-class-name: org.postgresql.Driver
  jpa:
    database-platform: org.hibernate.dialect.PostgreSQLDialect
    hibernate:
      ddl-auto: validate
    show-sql: false

---
spring:
  config:
    activate:
      on-profile: prod
  datasource:
    url: jdbc:postgresql://\${DB_HOST}:5432/\${DB_NAME}
    username: \${DB_USER}
    password: \${DB_PASS}
    hikari:
      maximum-pool-size: 20
      minimum-idle: 5
      connection-timeout: 30000
      idle-timeout: 600000
      max-lifetime: 1800000
  jpa:
    hibernate:
      ddl-auto: validate
    show-sql: false" || return 1

  log_success "Application configuration created successfully"
}

create_docker_assets() {
  local project_dir="$1" project_name="$2"

  log_info "Creating Docker assets..."

  local dockerfile="$project_dir/Dockerfile"
  safe_write_file "$dockerfile" "# ====== Builder Stage ======
FROM maven:3.9.5-eclipse-temurin-${JAVA_VERSION}-alpine AS builder
LABEL stage=builder
WORKDIR /build
COPY pom.xml .
RUN mvn dependency:go-offline -B -q
COPY src ./src
RUN mvn clean package -DskipTests -B -q

# ====== Runtime Stage ======
FROM eclipse-temurin:${JAVA_VERSION}-jre-alpine
LABEL maintainer=\"BattMobility Engineering\"
RUN apk add --no-cache curl tini && \\
    addgroup -S appgroup && adduser -S appuser -G appgroup
WORKDIR /app
COPY --from=builder /build/target/*.jar app.jar
RUN chown -R appuser:appgroup /app
USER appuser
EXPOSE 8080
ENV JAVA_OPTS=\"-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0 -XX:+UseG1GC -Djava.security.egd=file:/dev/./urandom\"
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \\
  CMD curl -f http://localhost:8080/actuator/health/liveness || exit 1
ENTRYPOINT [\"/sbin/tini\", \"--\"]
CMD [\"sh\", \"-c\", \"java \$JAVA_OPTS -jar app.jar\"]" || return 1

  local docker_compose="$project_dir/docker-compose.yml"
  safe_write_file "$docker_compose" "version: '3.9'

services:
  postgres:
    image: postgres:16-alpine
    container_name: ${project_name}-postgres
    environment:
      POSTGRES_DB: appdb
      POSTGRES_USER: appuser
      POSTGRES_PASSWORD: apppass
    ports:
      - \"5432:5432\"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: [\"CMD-SHELL\", \"pg_isready -U appuser -d appdb\"]
      interval: 10s
      timeout: 5s
      retries: 5
    networks:
      - app-network

  app:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: ${project_name}-app
    environment:
      SPRING_PROFILES_ACTIVE: docker
      DB_HOST: postgres
      DB_NAME: appdb
      DB_USER: appuser
      DB_PASS: apppass
    ports:
      - \"8080:8080\"
    depends_on:
      postgres:
        condition: service_healthy
    networks:
      - app-network
    restart: unless-stopped

volumes:
  postgres_data:
    driver: local

networks:
  app-network:
    driver: bridge" || return 1

  local dockerignore="$project_dir/.dockerignore"
  safe_write_file "$dockerignore" "target/
.mvn/
.git/
.idea/
*.iml
*.log" || return 1

  log_success "Docker assets created successfully"
}

create_makefile() {
  local project_dir="$1"

  log_info "Creating Makefile..."

  local makefile="$project_dir/Makefile"
  safe_write_file "$makefile" ".PHONY: help build run test verify format clean docker-build docker-up docker-down security-check coverage

APP_VERSION := \$(shell mvn help:evaluate -Dexpression=project.version -q -DforceStdout)
APP_NAME := \$(shell mvn help:evaluate -Dexpression=project.artifactId -q -DforceStdout)

help:
	@echo \"════════════════════════════════════════════════════════\"
	@echo \"  ☕️  Spring Boot Enterprise Makefile\"
	@echo \"════════════════════════════════════════════════════════\"
	@echo \"  build             - Build project with Maven\"
	@echo \"  run               - Run application locally\"
	@echo \"  test              - Run all tests\"
	@echo \"  verify            - Run Spotless + Checkstyle checks\"
	@echo \"  format            - Format code with Spotless\"
	@echo \"  security-check    - Run OWASP dependency check\"
	@echo \"  coverage          - Generate test coverage report\"
	@echo \"  docker-build      - Build Docker image\"
	@echo \"  docker-up         - Start with Docker Compose\"
	@echo \"  docker-down       - Stop Docker Compose\"
	@echo \"  clean             - Clean build artifacts\"
	@echo \"════════════════════════════════════════════════════════\"

build:
	@echo \"🔨 Building \$(APP_NAME) v\$(APP_VERSION)..\"
	mvn clean install -DskipTests -q || (echo \"❌ Build failed!\" && exit 1)
	@echo \"✅ Build complete!\"

run:
	@echo \"🚀 Running \$(APP_NAME) locally..\"
	mvn spring-boot:run

test:
	@echo \"🧪 Running tests..\"
	mvn test || (echo \"❌ Tests failed!\" && exit 1)
	@echo \"✅ Tests passed!\"

verify:
	@echo \"🔍 Verifying code quality..\"
	mvn spotless:check checkstyle:check -q || (echo \"❌ Verification failed!\" && exit 1)
	@echo \"✅ Verification complete!\"

format:
	@echo \"✨ Formatting code..\"
	mvn spotless:apply -q || (echo \"❌ Formatting failed!\" && exit 1)
	@echo \"✅ Code formatted!\"

security-check:
	@echo \"🔒 Running OWASP dependency check..\"
	mvn dependency-check:check || (echo \"⚠️  Security vulnerabilities found!\" && exit 1)
	@echo \"✅ Security check complete!\"

coverage:
	@echo \"📊 Generating coverage report..\"
	mvn clean test jacoco:report
	@echo \"✅ Coverage report: target/site/jacoco/index.html\"

docker-build:
	@echo \"🐳 Building Docker image..\"
	docker build -t \$(APP_NAME):\$(APP_VERSION) -t \$(APP_NAME):latest .
	@echo \"✅ Docker image built!\"

docker-up:
	@echo \"🐳 Starting services with Docker Compose..\"
	docker-compose up --build
	@echo \"✅ Services started!\"

docker-down:
	@echo \"🛑 Stopping Docker Compose..\"
	docker-compose down
	@echo \"✅ Services stopped!\"

docker-down-volumes:
	@echo \"🛑 Stopping Docker Compose and removing volumes..\"
	docker-compose down -v
	@echo \"✅ Services and volumes removed!\"

clean:
	@echo \"🧹 Cleaning build artifacts..\"
	mvn clean -q
	@echo \"✅ Clean complete!\"" || return 1

  log_success "Makefile created successfully"
}

create_database_migration() {
  local project_dir="$1"

  log_info "Creating database migration..."

  local migration_dir="$project_dir/src/main/resources/db/migration"
  safe_create_dir "$migration_dir" || return 1

  local migration_file="$migration_dir/V1__init.sql"
  safe_write_file "$migration_file" "-- Initial schema
CREATE TABLE IF NOT EXISTS app_metadata (
    id SERIAL PRIMARY KEY,
    version VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO app_metadata (version) VALUES ('1.0.0');" || return 1

  log_success "Database migration created successfully"
}

create_documentation() {
  local project_dir="$1" arch="$2"

  log_info "Creating documentation..."

  local readme="$project_dir/README.md"
  safe_write_file "$readme" "# ${project_dir} - Enterprise ${arch^} Application

🚀 Production-ready Spring Boot 3.x application with enterprise features

## 🎯 Architecture: ${arch^}

## 🛠 Tech Stack

- **Java ${JAVA_VERSION}** with Spring Boot ${SPRING_BOOT_VERSION}
- **PostgreSQL** (production) / **H2** (development)
- **Micrometer + Prometheus** for metrics
- **Structured JSON logging** with Logstash encoder
- **Flyway** for database migrations
- **Testcontainers** for integration tests
- **Docker** with multi-stage builds (~200MB image)

## 🏗 Code Quality Tools

- **Spotless** - Code formatting
- **Checkstyle** - Style enforcement
- **Maven Enforcer** - Dependency rules
- **OWASP Dependency Check** - Security scanning
- **SpotBugs** - Static analysis
- **JaCoCo** - Test coverage

## 🚀 Quick Start

\`\`\`bash
# Build
make build

# Run locally (H2)
make run

# Run with Docker (PostgreSQL)
make docker-up

# Access
open http://localhost:8080/actuator/health
\`\`\`

## 📋 Available Commands

\`\`\`bash
make help              # Show all commands
make build             # Build project
make run               # Run locally
make test              # Run tests
make verify            # Check code quality
make format            # Format code
make security-check    # OWASP scan
make coverage          # Test coverage
make docker-up         # Start with Docker
make docker-down       # Stop Docker
\`\`\`

## 🔍 Monitoring & Observability

- **Health**: http://localhost:8080/actuator/health
- **Metrics**: http://localhost:8080/actuator/metrics
- **Prometheus**: http://localhost:8080/actuator/prometheus
- **Info**: http://localhost:8080/actuator/info

## 🐳 Docker

Multi-stage build for optimal image size:
- Build stage: Maven + JDK (880MB, discarded)
- Runtime stage: JRE only (~200MB final)

## 📊 Profiles

- \`local\` - H2 in-memory database (default)
- \`docker\` - PostgreSQL via Docker Compose
- \`prod\` - Production settings with connection pooling

## 🧪 Testing

\`\`\`bash
# Unit tests
mvn test

# Integration tests with Testcontainers
mvn verify

# Coverage report
make coverage
\`\`\`

## 🔐 Security

- Non-root user in Docker
- OWASP dependency scanning
- Spring Security enabled
- Environment-based secrets

## 📝 License

Created for BattMobility - $(date +%Y)" || return 1

  local gitignore="$project_dir/.gitignore"
  safe_write_file "$gitignore" "target/
!.mvn/wrapper/maven-wrapper.jar
!**/src/main/**/target/
!**/src/test/**/target/

.mvn/timing.properties
.mvn/wrapper/maven-wrapper.jar

*.iml
.idea/
*.ipr
*.iws

.vscode/

.DS_Store

*.log
logs/

*.jar
*.war
*.nar
*.ear
*.zip
*.tar.gz
*.rar

application-local.yml
application-secrets.yml" || return 1

  log_success "Documentation created successfully"
}

initialize_git_repository() {
  local project_dir="$1"

  log_info "Initializing Git repository..."

  # Check if git is available
  if ! command -v git >/dev/null 2>&1; then
    log_warn "Git not found - skipping Git initialization"
    return 0
  fi

  cd "$project_dir" || {
    log_error "Failed to change to project directory for Git initialization"
    return 1
  }

  # Initialize repository
  if ! git init --quiet; then
    log_error "Failed to initialize Git repository"
    cd .. || log_warn "Failed to return to parent directory"
    return 1
  fi

  # Configure Git (optional, with fallbacks)
  git config user.name "Spring Boot Generator" 2>/dev/null || true
  git config user.email "generator@battmobility.com" 2>/dev/null || true

  # Add all files
  git add . || {
    log_error "Failed to add files to Git"
    cd .. || log_warn "Failed to return to parent directory"
    return 1
  }

  # Create initial commit
  git commit -m "Initial commit: Enterprise Spring Boot application

- Architecture: $2
- Spring Boot $SPRING_BOOT_VERSION with Java $JAVA_VERSION
- Enterprise tooling: Docker, monitoring, security
- Code quality: Spotless, Checkstyle, OWASP, JaCoCo
- Generated by sboot v$SCRIPT_VERSION" --quiet || {
    log_error "Failed to create initial commit"
    cd .. || log_warn "Failed to return to parent directory"
    return 1
  }

  cd .. || log_warn "Failed to return to parent directory"
  log_success "Git repository initialized with initial commit"
}

check_for_updates() {
  log_debug "Checking for script updates..."

  # Only check if curl is available and we're not in CI
  if ! command -v curl >/dev/null 2>&1 || [[ -n "${CI:-}" ]]; then
    return 0
  fi

  local latest_version
  latest_version="$(curl -s "https://api.github.com/repos/${SCRIPT_REPO}/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/' 2>/dev/null)" || {
    log_debug "Failed to check for updates"
    return 0
  }

  if [[ -z "$latest_version" ]]; then
    return 0
  fi

  # Remove 'v' prefix if present
  latest_version="${latest_version#v}"

  if [[ "$latest_version" != "$SCRIPT_VERSION" ]]; then
    log_warn "New version available: $latest_version (current: $SCRIPT_VERSION)"
    log_info "Run 'sboot --update' to update to the latest version"
  else
    log_debug "Script is up to date"
  fi
}

update_script() {
  log_info "Updating sboot script to latest version..."

  if ! command -v curl >/dev/null 2>&1; then
    log_error "curl is required for updates"
    return 1
  fi

  local temp_file
  temp_file="$(mktemp)" || {
    log_error "Failed to create temporary file for update"
    return 1
  }

  if ! curl -s "$SCRIPT_URL" -o "$temp_file"; then
    rm -f "$temp_file"
    log_error "Failed to download latest version"
    return 1
  fi

  # Basic validation of downloaded file
  if ! head -n 5 "$temp_file" | grep -q "sboot.*enterprise Spring Boot generator"; then
    rm -f "$temp_file"
    log_error "Downloaded file appears to be invalid"
    return 1
  fi

  # Get current script path
  local script_path
  script_path="$(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null || echo "${BASH_SOURCE[0]}")"

  if [[ -w "$script_path" ]]; then
    mv "$temp_file" "$script_path" || {
      rm -f "$temp_file"
      log_error "Failed to update script file"
      return 1
    }
    chmod +x "$script_path" || log_warn "Failed to set execute permissions"
    log_success "Script updated successfully! Please restart your shell or run 'source $script_path'"
  else
    log_error "Cannot write to script file: $script_path"
    log_info "Please run with sudo or update manually:"
    log_info "curl -s $SCRIPT_URL -o $script_path"
    rm -f "$temp_file"
    return 1
  fi
}

validate_generated_project() {
  local project_dir="$1" arch="$2"

  log_info "Validating generated project structure..."

  local required_files=(
    "pom.xml"
    "src/main/resources/application.yml"
    "src/main/resources/db/migration/V1__init.sql"
    "Dockerfile"
    "docker-compose.yml"
    "Makefile"
    "README.md"
    ".gitignore"
  )

  local missing_files=()

  for file in "${required_files[@]}"; do
    if [[ ! -f "$project_dir/$file" ]]; then
      missing_files+=("$file")
    fi
  done

  if [[ ${#missing_files[@]} -gt 0 ]]; then
    log_error "Missing required files: ${missing_files[*]}"
    return 1
  fi

  # Validate pom.xml structure
  if ! grep -q "<groupId>$GROUP_ID</groupId>" "$project_dir/pom.xml"; then
    log_error "Invalid pom.xml: missing correct groupId"
    return 1
  fi

  if ! grep -q "<artifactId>.*-project</artifactId>" "$project_dir/pom.xml"; then
    log_error "Invalid pom.xml: missing correct artifactId"
    return 1
  fi

  # Validate application.yml profiles
  local app_yml="$project_dir/src/main/resources/application.yml"
  for profile in "local" "docker" "prod"; do
    if ! grep -q "on-profile: $profile" "$app_yml"; then
      log_error "Invalid application.yml: missing $profile profile"
      return 1
    fi
  done

  # Validate Dockerfile
  if ! grep -q "FROM maven.*-eclipse-temurin-$JAVA_VERSION" "$project_dir/Dockerfile"; then
    log_error "Invalid Dockerfile: wrong Java version"
    return 1
  fi

  # Validate Makefile targets
  local makefile="$project_dir/Makefile"
  for target in "build" "run" "test" "clean"; do
    if ! grep -q "^$target:" "$makefile"; then
      log_error "Invalid Makefile: missing $target target"
      return 1
    fi
  done

  # Validate architecture-specific dependencies
  case "$arch" in
    modulith)
      if ! grep -q "spring-modulith" "$project_dir/pom.xml"; then
        log_error "Invalid pom.xml: missing Modulith dependencies for $arch architecture"
        return 1
      fi
      ;;
    microservice)
      if ! grep -q "cloud-config" "$project_dir/pom.xml"; then
        log_error "Invalid pom.xml: missing cloud-config for $arch architecture"
        return 1
      fi
      ;;
  esac

  # Check file permissions
  if [[ ! -x "$project_dir/mvnw" ]] 2>/dev/null; then
    log_debug "mvnw not found or not executable (expected for Spring Boot CLI projects)"
  fi

  log_success "Project structure validation completed successfully"
}

validate_system_resources() {
  log_debug "Validating system resources..."

  # Check available disk space (need at least 500MB)
  local available_space
  available_space="$(df -m . | tail -1 | awk '{print $4}')" || available_space=""

  if [[ -n "$available_space" ]] && [[ "$available_space" -lt 500 ]]; then
    log_warn "Low disk space: ${available_space}MB available (recommended: 500MB+)"
  fi

  # Check available memory
  if command -v free >/dev/null 2>&1; then
    local available_mem
    available_mem="$(free -m | grep '^Mem:' | awk '{print $7}')" || available_mem=""

    if [[ -n "$available_mem" ]] && [[ "$available_mem" -lt 1024 ]]; then
      log_warn "Low memory: ${available_mem}MB available (recommended: 1024MB+)"
    fi
  fi

  # Check Java version if available
  if command -v java >/dev/null 2>&1; then
    local java_version
    java_version="$(java -version 2>&1 | head -1 | cut -d'"' -f2 | cut -d'.' -f1)" || java_version=""

    if [[ -n "$java_version" ]] && [[ "$java_version" -lt "$JAVA_VERSION" ]]; then
      log_warn "Java version $java_version detected (recommended: $JAVA_VERSION+)"
    fi
  fi

  log_debug "System resource validation completed"
}

backup_existing_project() {
  local project_dir="$1"

  if [[ -d "$project_dir" ]]; then
    local backup_dir="${project_dir}.backup.$(date +%Y%m%d_%H%M%S)"

    log_warn "Directory $project_dir exists, creating backup: $backup_dir"

    if ! cp -r "$project_dir" "$backup_dir" 2>/dev/null; then
      log_error "Failed to create backup of existing directory"
      return 1
    fi

    log_info "Backup created: $backup_dir"
  fi
}

# Main function
sboot() {
  # Smart initialization
  smart_initialize

  # Set up error handling
  trap cleanup EXIT
  trap 'log_error "Script interrupted by user"; exit 130' INT TERM

  # Handle special commands
  case "${1:-}" in
    --version|-v)
      echo "sboot v$SCRIPT_VERSION"
      return 0
      ;;
    --update)
      update_script
      return $?
      ;;
    --help|-h)
      print_usage
      return 0
      ;;
  esac

  # Parse arguments or prompt interactively
  local ARCH DIR
  if [[ $# -lt 2 ]]; then
    echo
    echo -e "${YLW}╔════════════════════════════════════════════════════════╗${CLR}"
    echo -e "${YLW}║${CLR}  ☕️  ${GRN}Interactive Project Setup${CLR}                   ${YLW}║${CLR}"
    echo -e "${YLW}╚════════════════════════════════════════════════════════╝${CLR}"
    echo

    # Prompt for architecture
    echo -e "${CYN}Available architectures:${CLR}"
    echo -e "  ${MAG}modulith${CLR}      - Domain-driven modular monolith"
    echo -e "  ${MAG}microservice${CLR}  - Standalone microservice"
    echo -e "  ${MAG}monolith${CLR}      - Traditional layered monolith"
    echo

    while true; do
      read -p "Choose architecture (modulith/microservice/monolith): " ARCH
      if [[ " ${SUPPORTED_ARCHITECTURES[*]} " =~ " ${ARCH} " ]]; then
        break
      else
        echo -e "${RED}Invalid architecture. Please choose from: ${SUPPORTED_ARCHITECTURES[*]}${CLR}"
      fi
    done

    # Prompt for project directory
    while true; do
      read -p "Enter project directory name: " DIR
      if [[ -z "$DIR" ]]; then
        echo -e "${RED}Project name cannot be empty.${CLR}"
        continue
      fi
      if [[ ! "$DIR" =~ ^[a-zA-Z][a-zA-Z0-9_-]*$ ]]; then
        echo -e "${RED}Invalid project name. Use only letters, numbers, hyphens, and underscores. Must start with a letter.${CLR}"
        continue
      fi
      if [[ -d "$DIR" ]]; then
        echo -e "${RED}Directory '$DIR' already exists. Choose a different name.${CLR}"
        continue
      fi
      break
    done

    echo
    echo -e "${GRN}Creating ${MAG}$ARCH${GRN} project in directory: ${MAG}$DIR${CLR}"
    echo
  else
    ARCH="$1"
    DIR="$2"
  fi
  local PROJECT_DIR=""
  local TEMP_DIR=""

  # Check for updates (non-blocking)
  check_for_updates &

  # Perform comprehensive system health check
  perform_system_health_check || return 1

  # Validate dependencies (legacy check, now part of health check)
  validate_dependencies || return 1

  # For interactive mode, validation is already done in prompts
  if [[ $# -ge 2 ]]; then
    validate_architecture "$ARCH" || return 1
    validate_project_name "$DIR" || return 1
  fi

  # Validate system resources
  validate_system_resources

  # Backup existing project if it exists
  backup_existing_project "$DIR" || return 1

  # Set up temporary directory for safe operations
  TEMP_DIR="$(mktemp -d)" || {
    log_error "Failed to create temporary directory"
    return 1
  }
  log_debug "Created temporary directory: $TEMP_DIR"

  # Get project configuration
  local ARTIFACT_ID
  ARTIFACT_ID="$(get_artifact_id "$ARCH")" || return 1

  log_info "🚀 Generating $ARCH project in directory: $DIR"

  # Initialize Spring project
  init_spring_project "$ARCH" "$DIR" "$ARTIFACT_ID" || return 1

  # Change to project directory
  PROJECT_DIR="$(pwd)/$DIR"
  cd "$DIR" || {
    log_error "Failed to change to project directory: $DIR"
    return 1
  }

  # Add enterprise features
  add_enterprise_dependencies "$ARCH" "pom.xml" || return 1
  add_code_quality_plugins "pom.xml" || return 1

  # Create project assets
  create_application_config "$PROJECT_DIR" || return 1
  create_docker_assets "$PROJECT_DIR" "$DIR" || return 1
  create_makefile "$PROJECT_DIR" || return 1
  create_database_migration "$PROJECT_DIR" || return 1
  create_documentation "$PROJECT_DIR" "$ARCH" || return 1
  initialize_git_repository "$PROJECT_DIR" "$ARCH" || return 1

  # Validate generated project
  validate_generated_project "$PROJECT_DIR" "$ARCH" || {
    log_error "Generated project validation failed"
    return 1
  }

  # Return to original directory
  cd .. || log_warn "Failed to return to parent directory"

  # Clean up temporary directory
  if [[ -n "$TEMP_DIR" ]] && [[ -d "$TEMP_DIR" ]]; then
    rm -rf "$TEMP_DIR"
    TEMP_DIR=""
  fi

  # Print success message
  print_success_message "$ARCH" "$DIR"

  # Clear trap
  trap - EXIT
}

################################################################################
# Installation and Execution Logic
################################################################################

# Function to install sboot into shell profile
install_sboot() {
  local profile_file="$HOME/.bashrc"

  # Detect shell profile
  if [[ -n "${ZSH_VERSION:-}" ]]; then
    profile_file="$HOME/.zshrc"
  elif [[ -f "$HOME/.bash_profile" ]]; then
    profile_file="$HOME/.bash_profile"
  fi

  log_info "Installing sboot into $profile_file..."

  # Check if already installed
  if grep -q "source.*sbootgen\.sh" "$profile_file" 2>/dev/null; then
    log_warn "sboot already appears to be installed in $profile_file"
    return 0
  fi

  # Add to profile
  cat >> "$profile_file" << 'EOF'

# sboot - Enterprise Spring Boot Generator
# Installed via curl | bash
if [[ -f "$HOME/.sbootgen.sh" ]]; then
  source "$HOME/.sbootgen.sh"
elif command -v curl >/dev/null 2>&1; then
  source <(curl -s https://raw.githubusercontent.com/codesapienbe/sboot-gen/main/sbootgen.sh) 2>/dev/null || true
fi
EOF

  log_success "sboot installed successfully!"
  log_info "Please restart your shell or run: source $profile_file"
}

# Function to setup local installation
setup_local_installation() {
  local temp_script="/tmp/sbootgen.$$.sh"
  local final_script="$HOME/.sbootgen.sh"

  log_info "Setting up local installation..."

  # Download to temporary location first
  if command -v curl >/dev/null 2>&1; then
    log_debug "Downloading script to temporary location: $temp_script"
    curl -s "$SCRIPT_URL" -o "$temp_script" || {
      log_error "Failed to download script to temporary location"
      return 1
    }
    chmod +x "$temp_script" || {
      log_error "Failed to make temporary script executable"
      rm -f "$temp_script"
      return 1
    }
  else
    log_error "curl is required for installation"
    return 1
  fi

  # Move from temp to final location
  if [[ -w "$(dirname "$final_script")" ]]; then
    mv "$temp_script" "$final_script" || {
      log_error "Failed to move script to final location: $final_script"
      rm -f "$temp_script"
      return 1
    }
    log_debug "Script moved to: $final_script"
  else
    log_error "Cannot write to home directory. Please check permissions."
    rm -f "$temp_script"
    return 1
  fi

  # Install into profile
  install_sboot

  log_success "Local installation complete!"
}

# Interactive installation menu
interactive_install() {
  echo
  echo -e "${BLU}╔════════════════════════════════════════════════════════╗${CLR}"
  echo -e "${BLU}║${CLR}  ☕️  ${GRN}sboot Installation Options${CLR}                 ${BLU}║${CLR}"
  echo -e "${BLU}╠════════════════════════════════════════════════════════╣${CLR}"
  echo -e "${BLU}║${CLR}  ${CYN}1.${CLR} Install to shell profile (recommended)       ${BLU}║${CLR}"
  echo -e "${BLU}║${CLR}  ${CYN}2.${CLR} Download locally (~/.sbootgen.sh)          ${BLU}║${CLR}"
  echo -e "${BLU}║${CLR}  ${CYN}3.${CLR} Just source for this session               ${BLU}║${CLR}"
  echo -e "${BLU}║${CLR}  ${CYN}4.${CLR} Show manual installation commands          ${BLU}║${CLR}"
  echo -e "${BLU}║${CLR}  ${CYN}q.${CLR} Quit                                         ${BLU}║${CLR}"
  echo -e "${BLU}╚════════════════════════════════════════════════════════╝${CLR}"
  echo

  local choice
  read -p "Choose installation method (1-4, q to quit): " -n 1 choice
  echo

  case "$choice" in
    1)
      install_sboot
      ;;
    2)
      setup_local_installation
      ;;
    3)
      log_info "sboot is now available in this session"
      log_info "To make it permanent, run: sboot --install"
      ;;
    4)
      echo
      echo -e "${YLW}Manual Installation Commands:${CLR}"
      echo
      echo -e "${CYN}# Option 1 - Source directly (recommended):${CLR}"
      echo -e "source <(curl -s https://raw.githubusercontent.com/codesapienbe/sboot-gen/main/sbootgen.sh)"
      echo
      echo -e "${CYN}# Option 2 - Download and source:${CLR}"
      echo -e "curl -s https://raw.githubusercontent.com/codesapienbe/sboot-gen/main/sbootgen.sh -o ~/.sbootgen.sh"
      echo -e "echo 'source ~/.sbootgen.sh' >> ~/.bashrc && source ~/.bashrc"
      echo
      echo -e "${CYN}# Option 3 - Add to profile manually:${CLR}"
      echo -e "echo '# sboot - Spring Boot Generator' >> ~/.bashrc"
      echo -e "echo 'source <(curl -s https://raw.githubusercontent.com/codesapienbe/sboot-gen/main/sbootgen.sh)' >> ~/.bashrc"
      echo
      ;;
    q|Q)
      log_info "Installation cancelled"
      exit 0
      ;;
    *)
      log_error "Invalid choice. Please run again."
      exit 1
      ;;
  esac
}

# Show installation banner
show_install_banner() {
  echo -e "${BLU}╔════════════════════════════════════════════════════════╗${CLR}"
  echo -e "${BLU}║${CLR}  ☕️  ${GRN}Welcome to sboot v${SCRIPT_VERSION}${CLR}                    ${BLU}║${CLR}"
  echo -e "${BLU}║${CLR}  ${CYN}Enterprise Spring Boot Generator${CLR}               ${BLU}║${CLR}"
  echo -e "${BLU}╠════════════════════════════════════════════════════════╣${CLR}"
  echo -e "${BLU}║${CLR}  ${YLW}Installation required for first use${CLR}             ${BLU}║${CLR}"
  echo -e "${BLU}╚════════════════════════════════════════════════════════╝${CLR}"
  echo
}

# Main execution logic
main() {
  # If script is being sourced, just define the function
  if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
    # Being sourced - define the sboot function
    return 0
  fi

  # Check if script is running from temp directory (downloaded via curl)
  local script_path="${BASH_SOURCE[0]}"
  if [[ "$script_path" =~ ^/tmp/ ]]; then
    log_debug "Script running from temp directory: $script_path"

    # For temp execution, always do auto-install
    if [[ -t 0 ]]; then
      # Interactive terminal - show installation menu
      show_install_banner
      interactive_install
    else
      # Non-interactive (likely curl | bash) - auto-install
      log_info "Auto-installing sboot..."
      setup_local_installation
    fi
    exit $?
  fi

  # Script is being executed directly from permanent location
  show_install_banner

  # Check if this is an installation request
  if [[ "${1:-}" == "--install" ]]; then
    interactive_install
    exit 0
  fi

  # If running from permanent location, show interactive menu
  interactive_install
}

# Run main logic
main "$@"
