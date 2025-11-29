# Copilot Instructions

## Programming Languages & Technologies

### Primary Languages
- **F#** - Use F# as the primary programming language for application development
- **Bicep** - Use Bicep for all Infrastructure as Code (IaC) definitions
- **PowerShell** - Use PowerShell for scripting and automation tasks
- **Markdown** - Use Markdown for documentation and scripting explanations

### CI/CD
- **GitHub Actions** - Use GitHub Actions for all CI/CD pipelines
- Use Azure Deployment Stacks over normal deployments

## Git Workflow

### Branch Strategy
- **Always create a new branch** for any new work, feature, or fix
- Use descriptive branch names following the pattern: `feature/`, `fix/`, `chore/`, or `docs/` prefix
- Examples: `feature/add-apim-bicep`, `fix/function-binding-error`, `chore/update-dependencies`
- Never commit directly to `main` branch

### Commit Messages
- Use clear, descriptive commit messages
- Follow conventional commit format when possible: `type(scope): description`
- Examples: `feat(bicep): add APIM module`, `fix(functions): correct binding configuration`

## Azure Development Guidelines

### CLI Preference
- **Prefer Azure CLI (`az`) over Azure PowerShell modules** when working with Azure resources
- Use `az` commands in scripts for Azure operations
- Only use Azure PowerShell modules when Azure CLI doesn't support the required functionality

### Infrastructure as Code
- Write all infrastructure definitions in **Bicep**
- Use Azure Verified Modules when available
- Follow Bicep best practices for modularity and reusability
- Use parameter files for environment-specific configurations
- Organize Bicep files in a logical folder structure

## Code Style & Conventions

### F# Guidelines
- Follow F# coding conventions and idioms
- Prefer immutable data structures
- Use pattern matching where appropriate
- Leverage F#'s type system for domain modeling
- Use `Result` and `Option` types for error handling

### PowerShell Guidelines
- Use approved verbs for function names
- Include proper documentation comments
- Use `[CmdletBinding()]` for advanced functions
- Prefer splatting for commands with many parameters

### Bicep Guidelines
- Use meaningful resource names with consistent naming conventions
- Add descriptions to parameters
- Use variables for computed values
- Organize resources logically
- Use modules for reusable components

## Developer Experience

### Be Developer Friendly
- Provide clear, concise explanations
- Include examples when introducing new concepts
- Suggest improvements and best practices
- Explain the "why" behind recommendations
- Keep code readable and maintainable

### Documentation
- Use Markdown for all documentation
- Include code examples with proper syntax highlighting
- Document parameters, inputs, and outputs
- Provide usage examples for scripts and modules

## File Organization

```
/
├── .github/
│   └── workflows/          # GitHub Actions pipelines
├── Deployment/
│   └── bicep/              # Bicep IaC files
├── src/                    # F# source code
├── scripts/                # PowerShell scripts
└── docs/                   # Markdown documentation
```

## Testing

- Write unit tests for F# code
- Test Bicep templates with `az deployment what-if`
- Validate PowerShell scripts with PSScriptAnalyzer
