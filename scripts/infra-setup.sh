#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "========================================="
echo "Able Infrastructure Setup"
echo "========================================="
echo ""

ERRORS=0
WARNINGS=0

check_command() {
  if command -v "$1" &> /dev/null; then
    echo -e "${GREEN}✓${NC} $1 installed"
    return 0
  else
    echo -e "${RED}✗${NC} $1 not found"
    return 1
  fi
}

check_secret() {
  local name=$1
  local result=$(gh secret list 2>/dev/null | grep -c "^$name" || true)
  if [ "$result" -gt 0 ]; then
    echo -e "${GREEN}✓${NC} Secret $name is set"
    return 0
  else
    echo -e "${RED}✗${NC} Secret $name is not set"
    return 1
  fi
}

check_variable() {
  local name=$1
  local result=$(gh variable list 2>/dev/null | grep -c "^$name" || true)
  if [ "$result" -gt 0 ]; then
    echo -e "${GREEN}✓${NC} Variable $name is set"
    return 0
  else
    echo -e "${YELLOW}○${NC} Variable $name is not set (optional)"
    return 1
  fi
}

# Check required CLI tools
echo "Checking CLI tools..."
check_command "gh" || ERRORS=$((ERRORS + 1))
check_command "aws" || ERRORS=$((ERRORS + 1))
check_command "terraform" || ERRORS=$((ERRORS + 1))
check_command "bun" || ERRORS=$((ERRORS + 1))
echo ""

# Check GitHub CLI authentication
echo "Checking GitHub authentication..."
if gh auth status &> /dev/null; then
  echo -e "${GREEN}✓${NC} GitHub CLI authenticated"
else
  echo -e "${RED}✗${NC} GitHub CLI not authenticated. Run: gh auth login"
  ERRORS=$((ERRORS + 1))
fi
echo ""

# Check AWS authentication
echo "Checking AWS authentication..."
if aws sts get-caller-identity --profile able &> /dev/null; then
  ACCOUNT_ID=$(aws sts get-caller-identity --profile able --query Account --output text)
  echo -e "${GREEN}✓${NC} AWS authenticated (account: $ACCOUNT_ID)"
else
  echo -e "${RED}✗${NC} AWS not authenticated. Configure 'able' profile"
  ERRORS=$((ERRORS + 1))
fi
echo ""

# Check GitHub secrets
echo "Checking GitHub secrets..."
check_secret "AWS_ROLE_ARN" || ERRORS=$((ERRORS + 1))
check_secret "TF_VAR_ANTHROPIC_API_KEY" || ERRORS=$((ERRORS + 1))
check_secret "GH_APP_ID" || ERRORS=$((ERRORS + 1))
check_secret "GH_APP_PRIVATE_KEY" || ERRORS=$((ERRORS + 1))
echo ""

# Check GitHub variables (optional)
echo "Checking GitHub variables..."
check_variable "ALARM_EMAIL" || WARNINGS=$((WARNINGS + 1))
echo ""

# Summary
echo "========================================="
if [ $ERRORS -gt 0 ]; then
  echo -e "${RED}Setup incomplete: $ERRORS error(s), $WARNINGS warning(s)${NC}"
  echo ""
  # Check if GitHub App secrets are the issue
  if ! check_secret "GH_APP_ID" 2>/dev/null || ! check_secret "GH_APP_PRIVATE_KEY" 2>/dev/null; then
    echo ""
    echo "GitHub App not configured. Creating it now..."
    echo ""

    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    bun "$SCRIPT_DIR/create-github-app.ts"

    echo ""
    echo "After installing the app and setting secrets, re-run this script to verify."
  fi
  exit 1
else
  echo -e "${GREEN}Setup complete!${NC}"
  if [ $WARNINGS -gt 0 ]; then
    echo -e "${YELLOW}$WARNINGS optional item(s) not configured${NC}"
  fi
  exit 0
fi
