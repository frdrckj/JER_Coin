# Contributing to JER Cryptocurrency

Thank you for your interest in contributing to JER! This document provides guidelines and instructions for contributing.

---

## 🎯 Ways to Contribute

### 1. Testing
- Test on regtest/testnet and report bugs
- Verify builds on different platforms
- Test wallet functionality
- Stress test the network

### 2. Documentation
- Improve existing documentation
- Add tutorials and guides
- Translate documentation
- Fix typos and clarify instructions

### 3. Code
- Fix bugs
- Implement new features
- Optimize performance
- Improve security

### 4. Community
- Answer questions on Discord/Telegram
- Help new users get started
- Create content (videos, articles)
- Spread the word

---

## 🚀 Getting Started

### Prerequisites

Before contributing, make sure you have:
- Git installed
- Development environment set up
- Familiarity with C++ (for code contributions)
- Read the project documentation

### Setting Up Development Environment

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/JER_Coin.git
cd JER_Coin

# Add upstream remote
git remote add upstream https://github.com/frdrckj/JER_Coin.git

# Build the project
./scripts/build-jer.sh

# Run tests
./scripts/start-regtest.sh
./scripts/test-mining.sh
```

---

## 📝 Contribution Workflow

### 1. Find or Create an Issue

Before starting work:
- Check existing issues
- Create a new issue if needed
- Discuss your approach in the issue
- Get feedback before writing code

### 2. Fork and Branch

```bash
# Fork the repository on GitHub
# Clone your fork
git clone https://github.com/YOUR_USERNAME/JER_Coin.git

# Create a feature branch
git checkout -b feature/your-feature-name

# Or for bug fixes
git checkout -b fix/bug-description
```

### 3. Make Your Changes

- Write clean, readable code
- Follow existing code style
- Comment complex logic
- Keep commits focused and atomic
- Write descriptive commit messages

### 4. Test Your Changes

```bash
# Build and test locally
./scripts/build-jer.sh

# Start regtest
./scripts/start-regtest.sh

# Test your changes thoroughly
./scripts/test-mining.sh

# Stop when done
./scripts/stop-node.sh
```

### 5. Commit Your Changes

```bash
# Stage your changes
git add .

# Commit with descriptive message
git commit -m "Add feature: description of what you did

- Detailed point 1
- Detailed point 2
- Fixes #123 (if applicable)"
```

### 6. Push and Create Pull Request

```bash
# Push to your fork
git push origin feature/your-feature-name

# Go to GitHub and create a Pull Request
# Fill in the PR template
# Link related issues
```

---

## 📋 Commit Message Guidelines

### Format

```
<type>: <short summary>

<detailed description>

<footer with issue references>
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks
- `perf`: Performance improvements
- `security`: Security fixes

### Examples

```
feat: Add support for custom DNS seeds

- Allow configuration of custom DNS seed nodes
- Update chainparams.cpp with seed management
- Add documentation for seed node setup

Closes #45
```

```
fix: Resolve port conflict on testnet startup

The testnet was using the same port as mainnet causing
conflicts when both networks were running simultaneously.

Changed testnet port from 8732 to 18732.

Fixes #67
```

---

## 🎨 Code Style Guidelines

### C++ Code

- Follow Bitcoin Core's coding style
- Use 4 spaces for indentation (no tabs)
- Maximum line length: 100 characters
- Use meaningful variable names
- Comment non-obvious code

### Example

```cpp
// Good
int CalculateBlockReward(int height) {
    // Initial reward is 50 JER
    int64_t reward = 50 * COIN;

    // Halving occurs every 210,000 blocks
    int halvings = height / 210000;

    // Stop if we've gone through all halvings
    if (halvings >= 64) return 0;

    return reward >> halvings;
}

// Bad
int calc(int h) {
    int64_t r = 50 * COIN;
    return r >> (h / 210000);
}
```

### Shell Scripts

- Use `#!/bin/bash` shebang
- Add comments for complex logic
- Use meaningful variable names
- Check for errors (`set -e`)

### Markdown

- Use proper headers (# ## ###)
- Add blank lines between sections
- Use code blocks with language hints
- Keep lines reasonably short

---

## 🔍 Code Review Process

### What We Look For

1. **Correctness**: Does it work as intended?
2. **Security**: Are there any security implications?
3. **Performance**: Is it efficient?
4. **Readability**: Is the code clear and well-documented?
5. **Testing**: Has it been tested?
6. **Compatibility**: Does it work across platforms?

### Review Timeline

- Initial review: 2-7 days
- Follow-up reviews: 1-3 days
- Merge: After approval from maintainers

### Addressing Review Comments

```bash
# Make requested changes
git add .
git commit -m "Address review comments: description"

# Push updates
git push origin feature/your-feature-name

# The PR will update automatically
```

---

## 🐛 Bug Reports

### Before Reporting

1. Check if it's already reported
2. Test on the latest version
3. Verify it's reproducible

### Bug Report Template

```markdown
**Description**
Clear description of the bug

**Steps to Reproduce**
1. Step 1
2. Step 2
3. Step 3

**Expected Behavior**
What should happen

**Actual Behavior**
What actually happens

**Environment**
- OS: [e.g., macOS 14.0]
- JER Version: [e.g., v1.0.0]
- Network: [mainnet/testnet/regtest]

**Logs**
Relevant log output or error messages

**Additional Context**
Any other relevant information
```

---

## 💡 Feature Requests

### Before Requesting

1. Check if it's already requested
2. Consider if it aligns with project goals
3. Think about implementation complexity

### Feature Request Template

```markdown
**Problem Statement**
What problem does this solve?

**Proposed Solution**
How would you solve it?

**Alternatives Considered**
What other approaches did you consider?

**Additional Context**
Why is this important?

**Implementation Notes**
Any technical considerations
```

---

## 🔒 Security

### Reporting Security Issues

**DO NOT create public issues for security vulnerabilities!**

Instead:
1. Email security concerns privately to [your-email]
2. Include detailed information
3. Allow time for fix before disclosure

### Security Review Checklist

When contributing code that affects security:
- [ ] No hardcoded credentials
- [ ] Input validation implemented
- [ ] No SQL injection vulnerabilities
- [ ] Cryptographic operations are secure
- [ ] Private keys are never logged
- [ ] Error messages don't leak sensitive info

---

## 📚 Documentation

### Types of Documentation

1. **Code Comments**: Explain complex logic
2. **README**: Project overview and quick start
3. **Guides**: Step-by-step tutorials
4. **API Docs**: RPC/API documentation
5. **Configuration**: Setup and configuration guides

### Documentation Standards

- Use clear, simple language
- Include code examples
- Add screenshots where helpful
- Keep it up-to-date
- Link to related docs

---

## ✅ Pull Request Checklist

Before submitting your PR:

- [ ] Code builds successfully
- [ ] All tests pass
- [ ] New features have tests
- [ ] Documentation is updated
- [ ] Commit messages follow guidelines
- [ ] Code follows style guidelines
- [ ] No merge conflicts
- [ ] PR description is complete
- [ ] Related issues are linked

---

## 🌟 Recognition

Contributors will be recognized in:
- CONTRIBUTORS.md file
- Release notes
- Project documentation
- Community announcements

---

## 📞 Getting Help

### Questions?

- **Discord**: [Coming Soon]
- **Telegram**: [Coming Soon]
- **GitHub Discussions**: https://github.com/frdrckj/JER_Coin/discussions
- **Issues**: For bug reports and feature requests

### Resources

- [CLAUDE.md](CLAUDE.md) - Project context
- [NETWORK-CONFIGURATION.md](NETWORK-CONFIGURATION.md) - Technical details
- [BUILD-SUCCESS-SUMMARY.md](BUILD-SUCCESS-SUMMARY.md) - Build instructions

---

## 🎓 Learning Resources

### Bitcoin Core

- [Bitcoin Core Developer Docs](https://github.com/bitcoin/bitcoin/tree/master/doc)
- [Bitcoin Developer Guide](https://developer.bitcoin.org/)
- [Bitcoin Stack Exchange](https://bitcoin.stackexchange.com/)

### Cryptocurrency Development

- [Mastering Bitcoin](https://github.com/bitcoinbook/bitcoinbook)
- [Programming Bitcoin](https://github.com/jimmysong/programmingbitcoin)

---

## 📜 Code of Conduct

### Our Standards

- Be respectful and inclusive
- Welcome newcomers
- Focus on what's best for the community
- Show empathy toward others
- Accept constructive criticism

### Unacceptable Behavior

- Harassment or discrimination
- Trolling or insulting comments
- Personal or political attacks
- Publishing others' private information
- Other unprofessional conduct

### Enforcement

Violations may result in:
1. Warning
2. Temporary ban
3. Permanent ban

Report violations to project maintainers.

---

## 🙏 Thank You!

Every contribution, no matter how small, helps make JER better.

Thank you for contributing to JER Cryptocurrency! 🎉

---

**Last Updated**: October 28, 2025
