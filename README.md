# Databricks Deploy GitHub Action

Composite GitHub Action that updates a Databricks Repo/Git Folder to a target branch using the Databricks Repos API.

## Usage

```yaml
name: SFK Test Deploy to Databricks Test Workspace

on:
  push:
    branches:
      - test
  workflow_dispatch:

jobs:
  test_test_branch_deployment:
    runs-on: ubuntu-latest

    steps:
      - name: Deploy to Test Databricks ENV Repository (test branch)
        uses: cflynn-suffolk/databricks-deploy@main
        with:
          databricks-repo-branch: 'test'
          databricks-token: "${{ secrets.DBX_TEST__ACCESS_TOKEN }}"
          databricks-host: "${{ secrets.DBX_TEST__HOST }}"
          databricks-repo-id: "2717834014525072"
